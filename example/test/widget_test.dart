import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ccid_example/main.dart';

void main() {
  const channel = MethodChannel('ccid');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'listReaders') {
        return <String>['Test reader'];
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('shows the smart card controls and available readers',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Smart Card Transceiver'), findsOneWidget);
    expect(find.text('Test reader'), findsOneWidget);
    expect(find.text('Refresh'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
    expect(find.text('Send APDU'), findsOneWidget);
    expect(find.text('History:'), findsOneWidget);
  });
}
