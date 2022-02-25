import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uphf_edt/data/models/lesson.dart';
import 'package:uphf_edt/screen/widgets/lesson_tile.dart';

void main() {
  testWidgets(
    'Given a Lesson When widget is ran Then informations are correctly show',
    (WidgetTester test) async {
      // Given
      Lesson lesson = Lesson(
        date: DateTime.now(),
        informations: 'Informations',
        room: 'Room',
        teacher: 'Teacher',
        title: 'Title',
        time: 'Time',
        type: 'DS',
      );
      LessonTile lessonTile = LessonTile(lesson);

      // When
      await test.pumpWidget(
        MaterialApp(
          home: ThemeProvider(
            themes: [
              AppTheme.light(),
              AppTheme.dark(),
            ],
            child: Scaffold(
              body: lessonTile,
            ),
          ),
        ),
      );

      // Then
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Room'), findsOneWidget);
      expect(find.text('Teacher'), findsOneWidget);
      expect(find.text('Time'), findsOneWidget);
      expect(find.text('DS'), findsOneWidget);
      expect(find.text('Informations'), findsOneWidget);
    },
  );

  group(
    'DS Color',
    () {
      testWidgets(
        'Given a DS Lesson When widget is ran in light theme Then color is corect',
        (WidgetTester tester) async {
          // Given
          Lesson lesson = Lesson(
            date: DateTime.now(),
            informations: 'Informations',
            room: 'Room',
            teacher: 'Teacher',
            title: 'Title',
            time: 'Time',
            type: 'DS',
          );
          LessonTile lessonTile = LessonTile(lesson);

          // When
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeProvider(
                themes: [
                  AppTheme.light(),
                  AppTheme.dark(),
                ],
                child: Scaffold(
                  body: lessonTile,
                ),
              ),
            ),
          );
          BoxDecoration box = tester
              .firstWidget<Container>(find.byType(Container))
              .decoration as BoxDecoration;

          // Then
          expect(
            box.gradient!.colors,
            [
              Colors.orange[900]!,
              Colors.orange,
              Colors.orange[300]!,
              Colors.orange[200]!
            ],
          );
        },
      );

      testWidgets(
        'Given a DS Lesson When widget is ran in dark theme Then color is corect',
        (WidgetTester tester) async {
          // Given
          Lesson lesson = Lesson(
            date: DateTime.now(),
            informations: 'Informations',
            room: 'Room',
            teacher: 'Teacher',
            title: 'Title',
            time: 'Time',
            type: 'DS',
          );
          LessonTile lessonTile = LessonTile(lesson);

          // When
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeProvider(
                themes: [
                  AppTheme.dark(),
                  AppTheme.light(),
                ],
                child: Scaffold(
                  body: lessonTile,
                ),
              ),
            ),
          );
          BoxDecoration box = tester
              .firstWidget<Container>(find.byType(Container))
              .decoration as BoxDecoration;

          // Then
          expect(
            box.gradient!.colors,
            [
              Colors.deepOrange[900]!,
              Colors.deepOrange,
              Colors.deepOrange[500]!,
              Colors.deepOrange[700]!
            ],
          );
        },
      );
    },
  );
  group(
    'TD Color',
    (() {
      testWidgets(
        'Given a TD Lesson When widget is ran in light theme Then color is corect',
        (WidgetTester tester) async {
          // Given
          Lesson lesson = Lesson(
            date: DateTime.now(),
            informations: 'Informations',
            room: 'Room',
            teacher: 'Teacher',
            title: 'Title',
            time: 'Time',
            type: 'TD',
          );
          LessonTile lessonTile = LessonTile(lesson);

          // When
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeProvider(
                themes: [
                  AppTheme.light(),
                  AppTheme.dark(),
                ],
                child: Scaffold(
                  body: lessonTile,
                ),
              ),
            ),
          );
          BoxDecoration box = tester
              .firstWidget<Container>(find.byType(Container))
              .decoration as BoxDecoration;

          // Then
          expect(
            box.gradient!.colors,
            [
              Colors.blue[900]!,
              Colors.blue,
              Colors.lightBlue,
              Colors.lightBlue[200]!
            ],
          );
        },
      );

      testWidgets(
        'Given a TD Lesson When widget is ran in dark theme Then color is corect',
        (WidgetTester tester) async {
          // Given
          Lesson lesson = Lesson(
            date: DateTime.now(),
            informations: 'Informations',
            room: 'Room',
            teacher: 'Teacher',
            title: 'Title',
            time: 'Time',
            type: 'TD',
          );
          LessonTile lessonTile = LessonTile(lesson);

          // When
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeProvider(
                themes: [
                  AppTheme.dark(),
                  AppTheme.light(),
                ],
                child: Scaffold(
                  body: lessonTile,
                ),
              ),
            ),
          );
          BoxDecoration box = tester
              .firstWidget<Container>(find.byType(Container))
              .decoration as BoxDecoration;

          // Then
          expect(
            box.gradient!.colors,
            [
              Colors.teal[900]!,
              Colors.teal,
              Colors.teal[500]!,
              Colors.teal[700]!,
            ],
          );
        },
      );
    }),
  );
  group(
    'TP Color',
    (() {
      testWidgets(
        'Given a TP Lesson When widget is ran in light theme Then color is corect',
        (WidgetTester tester) async {
          // Given
          Lesson lesson = Lesson(
            date: DateTime.now(),
            informations: 'Informations',
            room: 'Room',
            teacher: 'Teacher',
            title: 'Title',
            time: 'Time',
            type: 'TP',
          );
          LessonTile lessonTile = LessonTile(lesson);

          // When
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeProvider(
                themes: [
                  AppTheme.light(),
                  AppTheme.dark(),
                ],
                child: Scaffold(
                  body: lessonTile,
                ),
              ),
            ),
          );
          BoxDecoration box = tester
              .firstWidget<Container>(find.byType(Container))
              .decoration as BoxDecoration;

          // Then
          expect(
            box.gradient!.colors,
            [
              Colors.green[900]!,
              Colors.green,
              Colors.lightGreen,
              Colors.lightGreen[200]!
            ],
          );
        },
      );

      testWidgets(
        'Given a TP Lesson When widget is ran in dark theme Then color is corect',
        (WidgetTester tester) async {
          // Given
          Lesson lesson = Lesson(
            date: DateTime.now(),
            informations: 'Informations',
            room: 'Room',
            teacher: 'Teacher',
            title: 'Title',
            time: 'Time',
            type: 'TP',
          );
          LessonTile lessonTile = LessonTile(lesson);

          // When
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeProvider(
                themes: [
                  AppTheme.dark(),
                  AppTheme.light(),
                ],
                child: Scaffold(
                  body: lessonTile,
                ),
              ),
            ),
          );
          BoxDecoration box = tester
              .firstWidget<Container>(find.byType(Container))
              .decoration as BoxDecoration;

          // Then
          expect(
            box.gradient!.colors,
            [
              Colors.green[900]!,
              Colors.green,
              Colors.green[500]!,
              Colors.green[700]!,
            ],
          );
        },
      );
    }),
  );
  group(
    'CM Color',
    (() {
      testWidgets(
        'Given a CM Lesson When widget is ran in light theme Then color is corect',
        (WidgetTester tester) async {
          // Given
          Lesson lesson = Lesson(
            date: DateTime.now(),
            informations: 'Informations',
            room: 'Room',
            teacher: 'Teacher',
            title: 'Title',
            time: 'Time',
            type: 'CM',
          );
          LessonTile lessonTile = LessonTile(lesson);

          // When
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeProvider(
                themes: [
                  AppTheme.light(),
                  AppTheme.dark(),
                ],
                child: Scaffold(
                  body: lessonTile,
                ),
              ),
            ),
          );
          BoxDecoration box = tester
              .firstWidget<Container>(find.byType(Container))
              .decoration as BoxDecoration;

          // Then
          expect(
            box.gradient!.colors,
            [
              Colors.purple[900]!,
              Colors.purple,
              Colors.purple[300]!,
              Colors.purple[200]!
            ],
          );
        },
      );

      testWidgets(
        'Given a CM Lesson When widget is ran in dark theme Then color is corect',
        (WidgetTester tester) async {
          // Given
          Lesson lesson = Lesson(
            date: DateTime.now(),
            informations: 'Informations',
            room: 'Room',
            teacher: 'Teacher',
            title: 'Title',
            time: 'Time',
            type: 'CM',
          );
          LessonTile lessonTile = LessonTile(lesson);

          // When
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeProvider(
                themes: [
                  AppTheme.dark(),
                  AppTheme.light(),
                ],
                child: Scaffold(
                  body: lessonTile,
                ),
              ),
            ),
          );
          BoxDecoration box = tester
              .firstWidget<Container>(find.byType(Container))
              .decoration as BoxDecoration;

          // Then
          expect(
            box.gradient!.colors,
            [
              Colors.deepPurple[900]!,
              Colors.deepPurple,
              Colors.deepPurple[500]!,
              Colors.deepPurple[700]!
            ],
          );
        },
      );
    }),
  );

  group(
    'RES Color',
    (() {
      testWidgets(
        'Given a RES Lesson When widget is ran in light theme Then color is corect',
        (WidgetTester tester) async {
          // Given
          Lesson lesson = Lesson(
            date: DateTime.now(),
            informations: 'Informations',
            room: 'Room',
            teacher: 'Teacher',
            title: 'Title',
            time: 'Time',
            type: 'RES',
          );
          LessonTile lessonTile = LessonTile(lesson);

          // When
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeProvider(
                themes: [
                  AppTheme.light(),
                  AppTheme.dark(),
                ],
                child: Scaffold(
                  body: lessonTile,
                ),
              ),
            ),
          );
          BoxDecoration box = tester
              .firstWidget<Container>(find.byType(Container))
              .decoration as BoxDecoration;

          // Then
          expect(
            box.gradient!.colors,
            [
              Colors.grey[900]!,
              Colors.grey,
              Colors.grey[400]!,
              Colors.grey[300]!
            ],
          );
        },
      );

      testWidgets(
        'Given a RES Lesson When widget is ran in dark theme Then color is corect',
        (WidgetTester tester) async {
          // Given
          Lesson lesson = Lesson(
            date: DateTime.now(),
            informations: 'Informations',
            room: 'Room',
            teacher: 'Teacher',
            title: 'Title',
            time: 'Time',
            type: 'RES',
          );
          LessonTile lessonTile = LessonTile(lesson);

          // When
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeProvider(
                themes: [
                  AppTheme.dark(),
                  AppTheme.light(),
                ],
                child: Scaffold(
                  body: lessonTile,
                ),
              ),
            ),
          );
          BoxDecoration box = tester
              .firstWidget<Container>(find.byType(Container))
              .decoration as BoxDecoration;

          // Then
          expect(
            box.gradient!.colors,
            [
              Colors.grey[900]!,
              Colors.grey,
              Colors.grey[500]!,
              Colors.grey[700]!
            ],
          );
        },
      );
    }),
  );
  group('Default color', () {
    testWidgets(
      'Given a Lesson without valid type When widget is ran in light theme Then a default color is show',
      (widgetTester) async {
        // Given
        Lesson lesson = Lesson(
          date: DateTime.now(),
          informations: 'Informations',
          room: 'Room',
          teacher: 'Teacher',
          title: 'Title',
          time: 'Time',
          type: 'Type',
        );
        LessonTile lessonTile = LessonTile(lesson);

        // When
        await widgetTester.pumpWidget(
          MaterialApp(
            home: ThemeProvider(
              themes: [
                AppTheme.light(),
                AppTheme.dark(),
              ],
              child: Scaffold(
                body: lessonTile,
              ),
            ),
          ),
        );
        BoxDecoration box = widgetTester
            .firstWidget<Container>(find.byType(Container))
            .decoration as BoxDecoration;

        // Then
        expect(
          box.gradient!.colors,
          [
            Colors.blue[900]!,
            Colors.blue,
            Colors.lightBlue,
            Colors.lightBlue[200]!
          ],
        );
      },
    );
    testWidgets(
      'Given a Lesson without valid type When widget is ran in dark theme Then a default color is show',
      (widgetTester) async {
        // Given
        Lesson lesson = Lesson(
          date: DateTime.now(),
          informations: 'Informations',
          room: 'Room',
          teacher: 'Teacher',
          title: 'Title',
          time: 'Time',
          type: 'Type',
        );
        LessonTile lessonTile = LessonTile(lesson);

        // When
        await widgetTester.pumpWidget(
          MaterialApp(
            home: ThemeProvider(
              themes: [
                AppTheme.dark(),
                AppTheme.light(),
              ],
              child: Scaffold(
                body: lessonTile,
              ),
            ),
          ),
        );
        BoxDecoration box = widgetTester
            .firstWidget<Container>(find.byType(Container))
            .decoration as BoxDecoration;

        // Then
        expect(
          box.gradient!.colors,
          [
            Colors.teal[900]!,
            Colors.teal,
            Colors.teal[500]!,
            Colors.teal[700]!,
          ],
        );
      },
    );
  });
}
