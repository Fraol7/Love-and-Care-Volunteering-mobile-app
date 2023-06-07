import 'package:flutter_test/flutter_test.dart';
import 'package:love_and_care/application/comment/comment_bloc.dart';
import 'package:love_and_care/application/comment/comment_bloc_event.dart';
import 'package:love_and_care/application/comment/comment_bloc_state.dart';
import 'package:love_and_care/domain/comment/comment_model.dart';
import 'package:love_and_care/repository/comment/comment_repository.dart';
import 'package:love_and_care/repository/response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'comment_bloc_test.mocks.dart';

@GenerateMocks([
  CommentRepository,
])
void main() {
  late CommentBloc commentBloc;
  late MockCommentRepository mockCommentRepository;
  final testCommentGlobalState = CommentGlobalState(comments: []);

  setUp(() {
    mockCommentRepository = MockCommentRepository();
    commentBloc = CommentBloc(mockCommentRepository, testCommentGlobalState);
  });

  tearDown(() {
    commentBloc.close();
  });

  group('CommentBloc', () {
    // ...

    final comment = 'comment';
    final opportunityId = '1';
    final date = DateTime.now();
    final username = 'username';
    final id = '1';

    var testComment = Comment(
        id: id,
        opportunityId: opportunityId,
        username: username,
        comment: comment,
        date: date);

    group('GetComments', () {
      final testOpportunityId = 'opportunity_id';

      test(
        'emits [CommentLoading, CommentSuccess] when GetComments event is added and fetching comments succeeds',
        () async {
          // Arrange
          final getCommentsEvent = GetComments(id: id);
          final successResponse =
              Response<List<Comment>>.success([testComment, testComment]);

          when(mockCommentRepository.getOpportunityComments(id))
              .thenAnswer((_) async => successResponse);

          // Act
          commentBloc.add(getCommentsEvent);

          // Assert
          await expectLater(
            commentBloc.stream,
            emitsInOrder([
              CommentLoading(),
              CommentSuccess(testCommentGlobalState),
            ]),
          );
          expect(commentBloc.state, isA<CommentSuccess>());
          // expect(commentBloc.state.testCommentGlobalState.comments, hasLength(2));
        },
      );

      test(
        'emits [CommentLoading, CommentFailure] when GetComments event is added and fetching comments fails',
        () async {
          // Arrange
          final getCommentsEvent = GetComments(id: id);
          final errorResponse =
              Response<List<Comment>>.error('Failed to fetch comments');

          when(mockCommentRepository.getOpportunityComments(id))
              .thenAnswer((_) async => errorResponse);

          // Act
          commentBloc.add(getCommentsEvent);

          // Assert
          await expectLater(
            commentBloc.stream,
            emitsInOrder([
              CommentLoading(),
              CommentFailure(errorResponse.error!),
            ]),
          );
          expect(commentBloc.state, isA<CommentFailure>());
          // expect(commentBloc.state.errorMessage,
          //     equals('Failed to fetch comments'));
        },
      );
    });
  });
}
