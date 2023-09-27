import 'package:flutter/material.dart';
import 'package:my_shop/mywidgets/indice_conv_widget.dart';
import '../providers/sites_bats_provider.dart';
import '../mywidgets/param_item.dart';
import './reportHeader.dart';
import './light_widget.dart';
import './conso_widget.dart';

class ReportItem extends StatelessWidget {
  final double height;
  final double width;
  final TableData oneReport;
  final int lotId;
  const ReportItem({super.key, 
    required this.height,
    required this.width,
    required this.oneReport,
    required this.lotId,
  });

  // final List nbrs = [1, 1, 2];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: Colors.grey),
          ),
        ),
        // height: double.infinity,
        child: Column(
          children: <Widget>[
            ReportHeader(width: width, height: height, oneReport: oneReport),
            Container(
              color: Colors.blue.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    size: 23,
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 23,
                    color: Colors.blue,
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Paramétre',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.settings,
                        color: Colors.blue,
                        size: 16,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Réel | Écart',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.swap_vert,
                        color: Colors.blue,
                        size: 16,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Guide',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.book_outlined,
                        color: Colors.blue,
                        size: 16,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ...oneReport.params.map((param) {
                  return ParamItem(
                    age: oneReport.calendar['age'],
                    lotId: lotId,
                    id: param['id'],
                    color: param['color'] ?? '',
                    paramName: param['name'],
                    reel: param['reel'],
                    ecart: param['ecart'],
                    isUp: param['isUp'],
                    unity: param['unity'],
                    guide: param['guide'],
                  );
                }).toList(),
                const Divider(
                  thickness: 2,
                  height: 0,
                  color: Colors.blue,
                ),
                LightWidget(
                  id: oneReport.lumiere['id'],
                  name: oneReport.lumiere['name'],
                  period: oneReport.lumiere['period'],
                  end_at: oneReport.lumiere['ends_at'],
                  starts_at: oneReport.lumiere['starts_at'],
                ),
                LightWidget(
                  id: oneReport.flash['id'],
                  name: oneReport.flash['name'],
                  period: oneReport.flash['period'],
                  end_at: oneReport.flash['ends_at'],
                  starts_at: oneReport.flash['starts_at'],
                ),
                ConsoWidget(
                  id: oneReport.consumption['id'],
                  aps: oneReport.consumption['aps'],
                  eps: oneReport.consumption['eps'],
                  ratio: oneReport.consumption['ratio'],
                  ratioColor: oneReport.consumption['ratio_color'],
                ),
                IndiceConvers(
                    ic_cuml: oneReport.indiceConver['ic_cuml'],
                    ic_sem: oneReport.indiceConver['ic_sem'],
                    id: oneReport.indiceConver['id'])
              ],
            )
          ],
        ),
      ),
    );
  }
}
