import 'package:flutter_test/flutter_test.dart';
import 'package:love_and_care/application/opportunity/opportunity_bloc.dart';
import 'package:love_and_care/application/opportunity/opportunity_bloc_event.dart';
import 'package:love_and_care/application/opportunity/opportunity_bloc_state.dart';
import 'package:love_and_care/domain/opportunity/opportunity_%20model.dart';
import 'package:love_and_care/repository/opportunity/opportunity_repository.dart';
import 'package:love_and_care/repository/response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opportunity_bloc_test.mocks.dart';

@GenerateMocks([
  OpportunityRepository,
])
void main() {
  late OpportunityBloc opportunityBloc;
  late MockOpportunityRepository mockOpportunityRepository;

  final opportunityId = '1';
  final title = 'Test Opportunity';
  final description = 'This is a test opportunity';
  final date = DateTime.now();
  final location = 'Test Location';
  final volunteerSeeker = "volunteerSeeker";
  final totalLikes = 0;
  final totalParticipants = 0;

  final testOpportunity = Opportunity(
      opportunityId: opportunityId,
      volunteerSeeker: volunteerSeeker,
      title: title,
      description: description,
      date: date,
      location: location,
      totalLikes: totalLikes,
      totalParticipants: totalParticipants,
      likes: [],
      participants: []);
  final testOpportunityGlobalState = OpportunityGlobalState(
    opportunities: [testOpportunity],
  );

  setUp(() {
    mockOpportunityRepository = MockOpportunityRepository();
    opportunityBloc =
        OpportunityBloc(mockOpportunityRepository, testOpportunityGlobalState);
  });

  tearDown(() {
    opportunityBloc.close();
  });

  group('OpportunityBloc', () {
    test('initial state is OpportunityInitial', () {
      // Arrange
      opportunityBloc = OpportunityBloc(
          mockOpportunityRepository, testOpportunityGlobalState);

      // Assert
      expect(opportunityBloc.state, equals(OpportunityInitial()));
    });

    test(
      'emits [OpportunityLoading, OpportunitySuccess] when FetchOpportunities is added and fetching succeeds',
      () async {
        // Arrange
        final fetchOpportunitiesEvent = FetchOpportunities();
        final successResponse = Response<List<Opportunity>>.success(
          [testOpportunity],
        );

        when(mockOpportunityRepository.getAllOpportunities())
            .thenAnswer((_) async => successResponse);

        // Act
        opportunityBloc.add(fetchOpportunitiesEvent);

        // Assert
        await expectLater(
          opportunityBloc.stream,
          emitsInOrder([
            OpportunityLoading(),
            OpportunitySuccess(testOpportunityGlobalState),
          ]),
        );
      },
    );

    test(
      'emits [OpportunityLoading, OpportunitySuccess] when FetchOpportunities is added and fetching succeeds',
      () async {
        // Arrange
        final fetchOpportunitiesEvent = FetchOpportunities();
        final successResponse = Response<List<Opportunity>>.success(
          [testOpportunity],
        );

        when(mockOpportunityRepository.getAllOpportunities()).thenAnswer(
          (_) async => successResponse,
        );

        // Act
        opportunityBloc.add(fetchOpportunitiesEvent);

        // Assert
        await expectLater(
          opportunityBloc.stream,
          emitsInOrder([
            OpportunityLoading(),
            OpportunitySuccess(testOpportunityGlobalState),
          ]),
        );
      },
    );

    test(
      'emits [OpportunityLoading, OpportunityFailure] when FetchOpportunities is added and fetching fails',
      () async {
        // Arrange
        final fetchOpportunitiesEvent = FetchOpportunities();
        final failureResponse = Response<List<Opportunity>>.error(
          'Fetching opportunities failed',
        );

        when(mockOpportunityRepository.getAllOpportunities()).thenAnswer(
          (_) async => failureResponse,
        );

        // Act
        opportunityBloc.add(fetchOpportunitiesEvent);

        // Assert
        await expectLater(
          opportunityBloc.stream,
          emitsInOrder([
            OpportunityLoading(),
            OpportunityFailure('Fetching opportunities failed'),
          ]),
        );
      },
    );
    
  });
}
