import 'package:claims_app/features/claims/presentation/cubit/claim_cubit.dart';
import 'package:claims_app/features/claims/presentation/cubit/claim_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock ClaimCubit
class MockClaimCubit extends MockCubit<ClaimState> implements ClaimCubit {}

// Mock ModularNavigator
class MockModularNavigator extends Mock implements IModularNavigator {}

// Mock Modular for dependency injection
class MockModular extends Mock {
  static MockClaimCubit mockClaimCubit = MockClaimCubit();
  static MockModularNavigator mockNavigator = MockModularNavigator();

  static T get<T extends Object>() {
    if (T == ClaimCubit) {
      return mockClaimCubit as T;
    }
    throw Exception('Type $T not mocked');
  }

  static IModularNavigator get to => mockNavigator;
}

void main() {
  late MockClaimCubit mockClaimCubit;
  late MockModularNavigator mockNavigator;

  setUp(() {
// Initialize mocks
    mockClaimCubit = MockClaimCubit();
    mockNavigator = MockModularNavigator();
    MockModular.mockClaimCubit = mockClaimCubit;
    MockModular.mockNavigator = mockNavigator;

// Mock Modular.get and Modular.to
    when(() => Modular.get<ClaimCubit>()).thenReturn(mockClaimCubit);
    when(() => Modular.to).thenReturn(mockNavigator);
  });

  tearDown(() {
// Reset mocks
    reset(mockClaimCubit);
    reset(mockNavigator);
  });

// Helper function to create a ClaimModel
  ClaimModel createClaimModel(int id) {
    return ClaimModel(
      id: id,
      title: 'Test Claim $id',
      body: 'This is a test claim body for claim $id',
      userId: id,
    );
  }

// Wrap widget with necessary providers
  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(
      home: BlocProvider<ClaimCubit>.value(
        value: mockClaimCubit,
        child: widget,
      ),
    );
  }

  group('ClaimPage', () {
    testWidgets('displays AppBar with title "Claims"', (WidgetTester tester) async {
      // Arrange
      when(() => mockClaimCubit.state).thenReturn(ClaimInitial());
      when(() => mockClaimCubit.fetchClaims()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(buildTestableWidget(const ClaimPage()));
      await tester.pump();

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Claims'), findsOneWidget);
    });

    testWidgets('displays CircularProgressIndicator when state is ClaimInitial', (WidgetTester tester) async {
      // Arrange
      when(() => mockClaimCubit.state).thenReturn(ClaimInitial());
      when(() => mockClaimCubit.fetchClaims()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(buildTestableWidget(const ClaimPage()));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays CircularProgressIndicator when state is ClaimLoading', (WidgetTester tester) async {
      // Arrange
      when(() => mockClaimCubit.state).thenReturn(ClaimLoading());
      when(() => mockClaimCubit.fetchClaims()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(buildTestableWidget(const ClaimPage()));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays ListView with claims when state is ClaimLoaded', (WidgetTester tester) async {
      // Arrange
      final claims = [createClaimModel(1), createClaimModel(2)];
      when(() => mockClaimCubit.state).thenReturn(ClaimLoaded(claims));
      when(() => mockClaimCubit.fetchClaims()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(buildTestableWidget(const ClaimPage()));
      await tester.pump();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.text('Test Claim 1'), findsOneWidget);
      expect(find.text('Test Claim 2'), findsOneWidget);
      expect(find.text('This is a test claim body for claim 1',), findsOneWidget);
    });

    testWidgets('displays error message when state is ClaimError', (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Failed to load claims: DioException [bad response]: status code 403';
      when(() => mockClaimCubit.state).thenReturn(ClaimError(errorMessage));
      when(() => mockClaimCubit.fetchClaims()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(buildTestableWidget(const ClaimPage()));
      await tester.pump();

      // Assert
      expect(find.text('Error: $errorMessage'), findsOneWidget);
    });

    testWidgets('shows SnackBar when ClaimError state is emitted', (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Failed to load claims: DioException [bad response]: status code 403';
      whenListen(
        mockClaimCubit,
        Stream.fromIterable([ClaimInitial(), ClaimError(errorMessage)]),
        initialState: ClaimInitial(),
      );
      when(() => mockClaimCubit.fetchClaims()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(buildTestableWidget(const ClaimPage()));
      await tester.pumpAndSettle(); // Wait for SnackBar animation

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is SnackBar && (widget.backgroundColor == Colors.red)), findsOneWidget);
    });

    testWidgets('navigates to detail page when ListTile is tapped', (WidgetTester tester) async {
      // Arrange
      final claim = createClaimModel(1);
      when(() => mockClaimCubit.state).thenReturn(ClaimLoaded([claim]));
      when(() => mockClaimCubit.fetchClaims()).thenAnswer((_) async {});
      when(() => mockNavigator.pushNamed('/detail', arguments: claim)).thenAnswer((_) async => null);

      // Act
      await tester.pumpWidget(buildTestableWidget(const ClaimPage()));
      await tester.pump();
      await tester.tap(find.byType(ListTile).first);
      await tester.pump();

      // Assert
      verify(() => mockNavigator.pushNamed('/detail', arguments: claim)).called(1);
    });
  });
}