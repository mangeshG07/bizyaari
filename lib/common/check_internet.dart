import '../utils/exported_path.dart';

Future<void> checkInternetAndShowPopup() async {
  final List<ConnectivityResult> connectivityResult = await (Connectivity()
      .checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.none)) {
    AllDialogs().noInternetDialog();
  }
}
