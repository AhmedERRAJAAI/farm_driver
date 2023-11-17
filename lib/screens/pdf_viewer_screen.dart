import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/table_charts_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  static const routeName = "pdf-viewer";
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    final String pdfPath = Provider.of<TableAndChartsProvider>(context).getPdfPath.path;
    print(pdfPath);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: SfPdfViewer.file(File(pdfPath))),
      // body: SafeArea(child: SfPdfViewer.network("https://www.africau.edu/images/default/sample.pdf")),
    );
  }
}
