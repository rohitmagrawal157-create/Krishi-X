import 'package:flutter_test/flutter_test.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await UserAuthService.resetForTest();
  });

  test('register then login recognizes same phone', () async {
    await UserAuthService.registerUser(
      phone: '98 7654 3210',
      fullName: 'Raju Patil',
    );

    expect(await UserAuthService.isRegistered('9876543210'), isTrue);
    expect(await UserAuthService.isRegistered('98 7654 3210'), isTrue);

    final user = await UserAuthService.findUser('9876543210');
    expect(user?.fullName, 'Raju Patil');
  });

  test('registered user survives sync from preferences', () async {
    await UserAuthService.registerUser(
      phone: '9123456789',
      fullName: 'Test Farmer',
    );

    await UserAuthService.syncUsers();

    expect(await UserAuthService.isRegistered('9123456789'), isTrue);
    expect(await UserAuthService.hasRegisteredUsers(), isTrue);
  });
}
