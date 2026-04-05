import 'package:flutter/material.dart';
import 'package:learningdart/utilties/show_generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: "Delete note",
    content: "An Error occurred",
    optionsBuilder: () => {"OK": null},
  );
}
