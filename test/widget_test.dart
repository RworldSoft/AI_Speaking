import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_speak/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Since privacyAccepted is false by default in main.dart if not set,
    // we build the app with privacyAccepted: false to check for PrivacyScreen.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(privacyAccepted: false),
      ),
    );

    // Verify that our PrivacyScreen is shown.
    // We look for common text in PrivacyScreen like "Privacy" or "Accept".
    expect(find.textContaining('Privacy'), findsAtLeast(1));
  });
}
