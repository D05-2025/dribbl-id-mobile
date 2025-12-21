import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dribbl_id/events/models/event.dart';
import 'package:dribbl_id/events/widgets/event_card.dart';
import 'package:dribbl_id/events/screens/event_details.dart';
import 'package:dribbl_id/events/screens/event_list.dart';
import 'package:dribbl_id/events/screens/event_form.dart';

void main() {
  final testEvent = Event(
    id: 1,
    title: "Gathering Fasilkom",
    description: "Acara seru bareng anak-anak",
    date: DateTime(2023, 12, 12),
    time: "10:00 WIB",
    location: "Gedung C",
    imageUrl: "",
    isPublic: true,
  );

  final testEventWithImage = Event(
    id: 2,
    title: "Event dengan Gambar",
    description: "Event testing dengan URL gambar",
    date: DateTime(2024, 1, 15),
    time: "14:00 WIB",
    location: "Aula Besar",
    imageUrl: "https://via.placeholder.com/300",
    isPublic: false,
  );

  Widget createTestableWidget(Widget child, {String role = "admin"}) {
    final request = CookieRequest();
    request.jsonData["role"] = role;

    return Provider<CookieRequest>.value(
      value: request,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, widget) {
          return MediaQuery(
            data: const MediaQueryData(size: Size(2400, 2400)),
            child: widget!,
          );
        },
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  group('Event Module Final Coverage', () {

    test('Model Event Parsing', () {
      final json = {
        "id": 1, "title": "A", "description": "B", "date": "2023-01-01",
        "time": "12:00", "location": "C", "image_url": "", "is_public": true
      };
      expect(Event.fromJson(json).title, "A");
    });

    // Test tambahan untuk Event model dengan berbagai kondisi
    test('Model Event Parsing - Private Event', () {
      final json = {
        "id": 2, "title": "Private Event", "description": "Secret",
        "date": "2024-06-15", "time": "18:00", "location": "VIP Room",
        "image_url": "test.jpg", "is_public": false
      };
      final event = Event.fromJson(json);
      expect(event.isPublic, isFalse);
      expect(event.imageUrl, "test.jpg");
    });

    testWidgets('EventCard Actions', (tester) async {
      bool editCalled = false;
      await tester.pumpWidget(createTestableWidget(EventCard(
        event: testEvent,
        onTap: () {},
        onEdit: () => editCalled = true,
      )));

      final editIcon = find.byIcon(Icons.edit_rounded);
      if (tester.any(editIcon)) {
        await tester.tap(editIcon);
        await tester.pump();
        expect(editCalled, isTrue);
      }
    });

    // Test tambahan untuk EventCard dengan delete action
    testWidgets('EventCard Delete Action', (tester) async {
      bool deleteCalled = false;
      await tester.pumpWidget(createTestableWidget(EventCard(
        event: testEvent,
        onTap: () {},
        onDelete: () => deleteCalled = true,
      )));

      final deleteIcon = find.byIcon(Icons.delete_rounded);
      if (tester.any(deleteIcon)) {
        await tester.tap(deleteIcon);
        await tester.pump();
        expect(deleteCalled, isTrue);
      }
    });

    // Test untuk EventCard dengan gambar
    testWidgets('EventCard with Image URL', (tester) async {
      await tester.pumpWidget(createTestableWidget(EventCard(
        event: testEventWithImage,
        onTap: () {},
      )));

      await tester.pump();
      expect(find.text("Event dengan Gambar"), findsOneWidget);
      expect(find.text("Private"), findsOneWidget);
    });

    // Test untuk EventCard mobile layout
    testWidgets('EventCard Mobile Layout', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestableWidget(EventCard(
        event: testEvent,
        onTap: () {},
      )));

      await tester.pump();
      expect(find.text("Gathering Fasilkom"), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('EventDetails Content', (tester) async {
      await tester.pumpWidget(createTestableWidget(EventDetailsPage(event: testEvent)));
      expect(find.text("Detail Event"), findsOneWidget);
    });

    // Test tambahan untuk EventDetails dengan layout berbeda
    testWidgets('EventDetails Desktop Layout', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestableWidget(EventDetailsPage(event: testEvent)));
      await tester.pump();

      expect(find.text("Gathering Fasilkom"), findsOneWidget);
      expect(find.text("Gedung C"), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });

    // Test untuk action buttons di EventDetails
    testWidgets('EventDetails Action Buttons', (tester) async {
      await tester.pumpWidget(createTestableWidget(EventDetailsPage(event: testEvent)));
      await tester.pump();

      expect(find.text("Buka di Peta"), findsOneWidget);
      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    });

    testWidgets('EventForm Interaction', (tester) async {
      await tester.pumpWidget(createTestableWidget(const EventFormPage()));

      // Isi fields
      await tester.enterText(find.byType(TextFormField).at(0), "Judul");
      await tester.enterText(find.byType(TextFormField).at(1), "Desc");
      await tester.enterText(find.byType(TextFormField).at(2), "Loc");

      final btnSimpan = find.text("Simpan Event");
      if (tester.any(btnSimpan)) {
        await tester.ensureVisible(btnSimpan);
        await tester.tap(btnSimpan);
        await tester.pump();
      }
    });

    // Test tambahan untuk EventForm - Edit Mode
    testWidgets('EventForm Edit Mode', (tester) async {
      await tester.pumpWidget(createTestableWidget(EventFormPage(event: testEvent)));
      await tester.pump();

      expect(find.text("Edit Event"), findsOneWidget);
      expect(find.text("Gathering Fasilkom"), findsOneWidget);
    });

    // Test untuk DatePicker di EventForm
    testWidgets('EventForm Date Picker', (tester) async {
      await tester.pumpWidget(createTestableWidget(const EventFormPage()));
      await tester.pump();

      final dateButton = find.text("Pilih Tanggal");
      if (tester.any(dateButton)) {
        await tester.tap(dateButton);
        await tester.pumpAndSettle();

        // Cari tombol OK di date picker
        final okButton = find.text('OK');
        if (tester.any(okButton)) {
          await tester.tap(okButton);
          await tester.pump();
        }
      }
    });

    // Test untuk Public Switch di EventForm
    testWidgets('EventForm Public Switch', (tester) async {
      await tester.pumpWidget(createTestableWidget(const EventFormPage()));
      await tester.pump();

      final switchWidget = find.byType(SwitchListTile);
      if (tester.any(switchWidget)) {
        await tester.tap(switchWidget);
        await tester.pump();
      }
    });

    testWidgets('EventList Search & Role Check', (tester) async {
      tester.view.physicalSize = const Size(2400, 2400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestableWidget(const EventListPage(), role: "admin"));
      await tester.pump();

      final searchField = find.byType(TextField);
      if (tester.any(searchField)) {
        await tester.enterText(searchField, "Cari");
        await tester.pump();
        expect(find.text("Cari"), findsOneWidget);
      }

      addTearDown(tester.view.resetPhysicalSize);
    });

    // Test tambahan untuk EventList - Filter Options
    testWidgets('EventList Filter Dropdown', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestableWidget(const EventListPage()));
      await tester.pump();

      final dropdown = find.byType(DropdownButton<String>);
      if (tester.any(dropdown)) {
        await tester.tap(dropdown.first);
        await tester.pumpAndSettle();
      }

      addTearDown(tester.view.resetPhysicalSize);
    });

    // Test untuk Sort Button
    testWidgets('EventList Sort Toggle', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestableWidget(const EventListPage()));
      await tester.pump();

      final sortButton = find.byIcon(Icons.arrow_downward);
      if (tester.any(sortButton)) {
        await tester.tap(sortButton);
        await tester.pump();
        expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      }

      addTearDown(tester.view.resetPhysicalSize);
    });

    // Test untuk Regular User (bukan admin)
    testWidgets('EventList Regular User View', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestableWidget(const EventListPage(), role: "user"));
      await tester.pump();

      expect(find.text("REGULAR USER"), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
    });

    // Test untuk Compact Mode (Mobile)
    testWidgets('EventList Compact Mode', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestableWidget(const EventListPage()));
      await tester.pump();

      // Di compact mode, filter hanya menampilkan icon
      expect(find.byIcon(Icons.filter_list), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });

    // Test validasi form
    testWidgets('EventForm Validation', (tester) async {
      await tester.pumpWidget(createTestableWidget(const EventFormPage()));
      await tester.pump();

      // Coba submit tanpa mengisi field
      final btnSimpan = find.text("Simpan Event");
      if (tester.any(btnSimpan)) {
        await tester.ensureVisible(btnSimpan);
        await tester.tap(btnSimpan);
        await tester.pump();

        // Harus muncul error message
        expect(find.text("Judul tidak boleh kosong!"), findsOneWidget);
      }
    });
  });
}