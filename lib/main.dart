import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';

import './providers/auth.dart';

import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

// EGGS SELLING PART
import './eggs_selling/screens/dashboard_eggs_screen.dart';
import 'eggs_selling/screens/sortie_details.dart';
import './eggs_selling/screens/egg_calendar_screen.dart';
import 'eggs_selling/screens/egg_mouvement_form_screen.dart';
import './eggs_selling/screens/egg_clients_screen.dart';
import './eggs_selling/screens/egg_single_client_screen.dart';
import './eggs_selling/screens/egg_all_operations_screen.dart';
import 'eggs_selling/screens/egg_add_day_price.dart';
import './eggs_selling/screens/egg_stock_screen.dart';
import './eggs_selling/screens/egg_gestion_clients.dart';
import './eggs_selling/screens/eggs_records_screen.dart';

// // PROVIDERS -----
import 'eggs_selling/providers/daily_price_provider.dart';
import 'eggs_selling/providers/clients_provider.dart';
import 'eggs_selling/providers/mouvements_provider.dart';
import 'eggs_selling/providers/payment_provider.dart';
import 'eggs_selling/providers/stock_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => EggPrice(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => MouvementProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ClientProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => PaymentProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => StockProvider(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) => MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'), // English
              Locale('fr'), // Spanish
            ],
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.blue.shade800,
              appBarTheme: const AppBarTheme(backgroundColor: Color.fromARGB(255, 248, 247, 247)),
              colorScheme: ThemeData().colorScheme.copyWith(secondary: const Color.fromARGB(255, 255, 110, 7)),
              canvasColor: const Color.fromARGB(255, 251, 251, 251),
              fontFamily: 'Raleway',
              textTheme: const TextTheme(
                displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
                titleLarge: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
                bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Hind'),
              ),
            ),
            home: auth.isAuth
                ? const EggsDashboard()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? const SplashScreen() : const AuthScreen(),
                  ),
            routes: {
              // EGGS SELLING
              EggsDashboard.routeName: (ctx) => const EggsDashboard(),
              SortieDetailsScreen.routeName: (ctx) => const SortieDetailsScreen(),
              EggCalendarScreen.routeName: (ctx) => const EggCalendarScreen(),
              EggOperationForm.routeName: (ctx) => const EggOperationForm(),
              EggClientScreen.routeName: (ctx) => const EggClientScreen(),
              EggClientDetailScreen.routeName: (ctx) => const EggClientDetailScreen(),
              EggAllOperations.routeName: (ctx) => const EggAllOperations(),
              EggDayPrice.routeName: (ctx) => const EggDayPrice(),
              EggStockScreen.routeName: (ctx) => const EggStockScreen(),
              EggGestionClients.routeName: (ctx) => const EggGestionClients(),
              EggMouvementRecords.routeName: (ctx) => const EggMouvementRecords(),
            },
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
