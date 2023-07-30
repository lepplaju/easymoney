import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

import './dialog_components/dialog_titlebar.dart';

/// Dialog for viewing pdf files
///
/// Takes a [title] for the dialog and [pdf] to be shown.
class ShowPdfDialog extends StatelessWidget {
  const ShowPdfDialog({
    super.key,
    required this.title,
    required this.pdf,
  });
  final String title;
  final PdfDocument pdf;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitleBar(title: title),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PdfDocumentLoader(
                  doc: pdf,
                  documentBuilder: (context, pdfDocument, pageCount) =>
                      LayoutBuilder(
                    builder: (context, constraints) => SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                        itemCount: pageCount,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.all(15),
                          child: PdfPageView(
                            pdfDocument: pdfDocument,
                            pageNumber: index + 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
