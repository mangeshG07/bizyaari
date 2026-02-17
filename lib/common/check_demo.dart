import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class DemoService {
  bool isDemo = false;

  Future<void> init() async {
    String authKey = await LocalStorage.getString('auth_key') ?? '';
    isDemo = authKey != 'demo';
  }

  Future<void> updateDemoStatus(String newAuthKey) async {
    // print('newAuthKey');
    // print(newAuthKey);
    await LocalStorage.setString('auth_key', newAuthKey);
    isDemo = newAuthKey != 'demo';
  }
}
