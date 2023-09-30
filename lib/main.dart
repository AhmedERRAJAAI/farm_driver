import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import './providers/dashboard_provider.dart';
import './providers/sites_bats_provider.dart';
import './providers/settings_apps_provider.dart';
import './providers/table_charts_provider.dart';
import './providers/init_account_provider.dart';
import './providers/forms_provider.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/calendar_screen.dart';
import 'screens/apps_screen.dart';
import './screens/table_data_view.dart';
import 'screens/table_charts_screen.dart';
import './screens/lots_screen.dart';
import './screens/display_data_screen.dart';
import './screens/before_add_screen.dart';
import './screens/age_details_screen.dart';
import './screens/manage_lots_screen.dart';
import 'forms/create_master_user.dart';
import './forms/production_form.dart';
import './forms/lotForm.dart';
import './forms/poussForm.dart';
import './forms/create_eleveur.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  initializeDateFormatting().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => DashboardProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => InitUserProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => FormsProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => SitesBatsProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => TableAndChartsProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => SettingsAppsProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
        ],
        //when ever u create a new class instance (object use create) (like this case: instantiating the provider)
        //whenever u reuse an exsting object use .value approach (products_grid.dart case:grid)
        child: Consumer<Auth>(
          builder: (ctx, auth, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.blue.shade800,
              appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF0F0F3)),
              colorScheme: ThemeData().colorScheme.copyWith(secondary: const Color.fromARGB(255, 255, 110, 7)),
              canvasColor: const Color(0xFFF0F0F3),
              fontFamily: 'Raleway',
              textTheme: const TextTheme(
                displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
                titleLarge: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
                bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Hind'),
              ),
            ),

            home: auth.isAuth
                ? const DashboardScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
                  ),
            routes: {
              // '/': (ctx) => auth.isAuth ? ProductsScreen() :AuthScreen(),
              AgeDetailsScreen.routeName: (ctx) => const AgeDetailsScreen(),
              LotForm.routeName: (ctx) => const LotForm(),
              TableDataView.routeName: (ctx) => const TableDataView(),
              ProductionFrom.routeName: (ctx) => const ProductionFrom(),
              BeforeAddingScreen.routeName: (ctx) => const BeforeAddingScreen(),
              DisplayDataScreen.routeName: (ctx) => const DisplayDataScreen(),
              PoussForm.routeName: (ctx) => const PoussForm(),
              LotsScreen.routeName: (ctx) => const LotsScreen(),
              ChartsScreen.routeName: (ctx) => ChartsScreen(),
              AppsScreen.routeName: (ctx) => const AppsScreen(),
              CalendarScreen.routeName: (ctx) => const CalendarScreen(),
              ManageLotsScreen.routeName: (ctx) => const ManageLotsScreen(),
              CreateMasterUser.routeName: (ctx) => const CreateMasterUser(),
              CreateEleveurForm.routeName: (ctx) => const CreateEleveurForm(),
            },
            // onUnknownRoute: (settings) {
            // // displays when flutter failed to find a the given route (404)
            // return MaterialPageRoute(builder: (ctx) => MyHomePage());
            // },
          ),
        ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
