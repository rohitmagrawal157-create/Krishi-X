import 'package:flutter_test/flutter_test.dart';
import 'package:krishix/app.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:krishix/features/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('KrishiX opens login screen', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await UserAuthService.resetForTest();

    await tester.pumpWidget(const KrishiXApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
