import 'package:fluent_ui/fluent_ui.dart';

class Components {
  static void showErrorSnackBar(BuildContext context, {required String text}) {
    showSnackbar(
      context,
      margin: const EdgeInsets.symmetric(horizontal: 50,vertical: 20),
      Snackbar(
        content: Text(text),
      ),
    );
  }
}
