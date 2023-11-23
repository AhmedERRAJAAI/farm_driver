import 'package:flutter/material.dart';
import '../../mywidgets/side_drawer.dart';
import '../charts/dashboard_chart.dart';
import './eggAddDayPrice.dart';
import './egg_calendar_screen.dart';
import 'egg_mouvement_form_screen.dart';
import './egg_clients_screen.dart';
import './egg_all_operations_screen.dart';
import './egg_stock_screen.dart';
// WIDGETS
import '../widgets/operation_list_item.dart';

class EggsDashboard extends StatefulWidget {
  static const routeName = "egg-dashboard/";
  const EggsDashboard({super.key});

  @override
  State<EggsDashboard> createState() => _EggsDashboardState();
}

class _EggsDashboardState extends State<EggsDashboard> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EggCalendarScreen.routeName);
            },
            icon: const Icon(
              Icons.calendar_month_outlined,
              size: 24,
            ),
            color: const Color(0xFF145da0),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EggDayPrice.routeName);
            },
            icon: const Icon(
              Icons.control_point_duplicate,
              size: 24,
            ),
            color: const Color(0xFF145da0),
          ),
        ],
      ),
      drawer: const SideDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "évolution du cours des oeufs (gros calibre)(DH)",
                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w400),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text("voir plus +", style: TextStyle(decoration: TextDecoration.underline), textAlign: TextAlign.right),
                              style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 320, child: EggsDashCharts()),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(EggStockScreen.routeName);
                      },
                      child: DashBtn(
                        title: "Stock",
                        btnIcon: Icons.warehouse,
                        width: deviceSize.width * 0.3,
                        btnColor: Colors.indigo,
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(EggOperationForm.routeName);
                      },
                      child: DashBtn(
                        title: "Mouvement",
                        btnIcon: Icons.add,
                        width: deviceSize.width * 0.3,
                        btnColor: Colors.amber.shade700,
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(EggClientScreen.routeName);
                      },
                      child: DashBtn(
                        title: "Clients",
                        btnIcon: Icons.group,
                        width: deviceSize.width * 0.3,
                        btnColor: Colors.blue.shade800,
                      )),
                ],
              ),
              // GestureDetector(
              //     onTap: () {
              //       Navigator.of(context).pushNamed(EggOperationForm.routeName);
              //     },
              //     child: DashBtn(
              //       title: "Mouvement",
              //       btnIcon: Icons.add,
              //       width: deviceSize.width * 0.92,
              //       btnColor: Colors.lightGreen.shade600,
              //     )),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.blue.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "les opérations d'aujourd'hui",
                              style: TextStyle(color: Colors.blue),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(EggAllOperations.routeName);
                              },
                              child: Text("voir plus +", style: TextStyle(), textAlign: TextAlign.right),
                              style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            OperationListOneItem(batiment: "T1", name: "AZIZ", date: "09/11/2023", id: 0, operType: 0, pu: "0.95", qty: 90000),
                            OperationListOneItem(batiment: "T1", name: "T1", date: "09/11/2023", id: 0, operType: 1, pu: null, qty: 90000),
                            OperationListOneItem(batiment: "T1", name: "JOHN DOE", date: "09/11/2023", id: 0, operType: 2, pu: "0.95", qty: 90000),
                            OperationListOneItem(batiment: "T1", name: "EXPLICATION ...", date: "09/11/2023", id: 0, operType: 3, pu: null, qty: 1000),
                            OperationListOneItem(batiment: "T1", name: "T2", date: "09/11/2023", id: 0, operType: 1, pu: null, qty: 100000),
                            OperationListOneItem(batiment: "T1", name: "JOHN DOE", date: "09/11/2023", id: 0, operType: 4, pu: "0.95", qty: 90000),
                            OperationListOneItem(batiment: "T1", name: "JOHN DOE", date: "09/11/2023", id: 0, operType: 0, pu: "0.95", qty: 90000),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashBtn extends StatelessWidget {
  final double width;
  final String title;
  final IconData btnIcon;
  final Color btnColor;
  const DashBtn({super.key, required this.width, required this.title, required this.btnIcon, required this.btnColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: width,
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(width: 4),
          Icon(
            btnIcon,
            color: Colors.white,
            size: 22,
          ),
        ],
      ),
    );
  }
}
