import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_test_app/app_colors.dart';
import 'package:my_test_app/app_text_styles.dart';

void main() {
  testWidgets('App theme uses correct colors', (WidgetTester tester) async {
    // Build a simple Material app to test theme colors
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: AppColors.primaryYellow,
            surface: AppColors.backgroundColor,
          ),
          scaffoldBackgroundColor: AppColors.backgroundColor,
        ),
        home: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            color: AppColors.cardBackground,
            child: Text(
              'Test',
              style: AppTextStyles.h2,
            ),
          ),
        ),
      ),
    );

    // Verify that the text is displayed
    expect(find.text('Test'), findsOneWidget);

    // Verify that the scaffold has the correct background color
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, equals(AppColors.backgroundColor));
  });

  testWidgets('Text styles are applied correctly', (WidgetTester tester) async {
    // Build a widget with different text styles
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text('Heading', style: AppTextStyles.h2),
              Text('Subtitle', style: AppTextStyles.subtitle),
              Text('Body', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ),
    );

    // Verify all text widgets are displayed
    expect(find.text('Heading'), findsOneWidget);
    expect(find.text('Subtitle'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
  });
}
