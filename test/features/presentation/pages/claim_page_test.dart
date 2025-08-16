import 'package:claims_app/features/claims/data/models/claim_model.dart';
import 'package:claims_app/features/claims/domain/entities/claim.dart';
import 'package:claims_app/features/claims/presentation/cubit/claim_cubit.dart';
import 'package:claims_app/features/claims/presentation/cubit/claim_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';
import '../../test_module.dart';

void main() {
  late MockIModularNavigator mockNavigator;
  late MockClaimCubit mockClaimCubit;

  setUp(() {
    mockNavigator = MockIModularNavigator();
    mockClaimCubit = MockClaimCubit();

    // inject mock navigator ke Modular
    Modular.navigatorDelegate = mockNavigator;
  });


  Widget createWidgetUnderTest() {
    return ModularApp(
      module: TestModule(mockClaimCubit),
      child: MaterialApp.router(
        routerDelegate: Modular.routerDelegate,
        routeInformationParser: Modular.routeInformationParser,
      ),
    );
  }

  testWidgets('Show CircularProgressIndicator when loading',
          (WidgetTester tester) async {
        when(mockClaimCubit.state).thenReturn(ClaimLoading());
        when(mockClaimCubit.stream).thenAnswer((_) => Stream.value(ClaimLoading()));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });


  testWidgets('Show claim list when ClaimLoaded',
          (WidgetTester tester) async {
        final claims = [
          ClaimModel(id: 1, userId: 101, title: 'Claim A', body: 'Body A'),
          ClaimModel(id: 2, userId: 202, title: 'Claim B', body: 'Body B'),
        ];

        when(mockClaimCubit.state).thenReturn(ClaimLoaded(claims));
        when(mockClaimCubit.stream).thenAnswer((_) => Stream.value(ClaimLoaded(claims)));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Claim A'), findsOneWidget);
        expect(find.text('Claim B'), findsOneWidget);
      });

  testWidgets('Show search result based on query', (tester) async {
    final claims = [
      Claim(userId: 1, id: 1, title: 'Claim One', body: 'Description One'),
      Claim(userId: 2, id: 2, title: 'Claim Two', body: 'Description Two'),
    ];

    when(mockClaimCubit.state).thenReturn(ClaimLoaded(claims));
    when(mockClaimCubit.stream).thenAnswer((_) => Stream.value(ClaimLoaded(claims)));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Claim One'), findsOneWidget);
    expect(find.text('Claim Two'), findsOneWidget);

    // input query "one"
    await tester.enterText(find.byType(TextField), 'one');
    await tester.pumpAndSettle();

    // hanya Claim One yang muncul
    expect(find.text('Claim One'), findsOneWidget);
    expect(find.text('Claim Two'), findsNothing);
  });


  testWidgets('Show snackbar when ClaimError', (WidgetTester tester) async {
    // Stub state awal
    // Stub state awal cubit
    when(mockClaimCubit.state).thenReturn(ClaimError('Something went wrong'));

    // Stub stream cubit (simulasikan event error)
    when(mockClaimCubit.stream).thenAnswer(
          (_) => Stream.value(ClaimError('Something went wrong')),
    );

    // Render widget dengan BlocProvider
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ClaimCubit>.value(
          value: mockClaimCubit,
          child: createWidgetUnderTest(),
        ),
      ),
    );

    // Jalankan frame awal + beri waktu untuk snackbar muncul
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verifikasi snackbar tampil
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Something went wrong'), findsOneWidget);
  });


  testWidgets('Navigate to /detail when the item is clicked',
          (WidgetTester tester) async {
        final claims = [
          ClaimModel(id: 1, userId: 999, title: 'Claim A', body: 'Body A'),
        ];

        // Stub cubit state & stream
        when(mockClaimCubit.state).thenReturn(ClaimLoaded(claims));
        when(mockClaimCubit.stream)
            .thenAnswer((_) => Stream.value(ClaimLoaded(claims)));

        // Stub navigator
        when(mockNavigator.pushNamed(
          any,
          arguments: anyNamed('arguments'),
          forRoot: anyNamed('forRoot'),
        )).thenAnswer((_) async => null);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Pastikan list muncul
        expect(find.text('Claim A'), findsOneWidget);

        // Klik item
        await tester.tap(find.text('Claim A'));
        await tester.pumpAndSettle();

        // Verify navigasi
        verify(mockNavigator.pushNamed(
          '/detail',
          arguments: claims.first,
          forRoot: anyNamed('forRoot'),
        )).called(1);
      });
}