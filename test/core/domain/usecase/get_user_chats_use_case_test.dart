import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';
import 'package:novatech_chat/core/domain/models/models.dart';
import 'package:novatech_chat/core/domain/usecase/get_user_chats_use_case.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late GetUserChatsUseCase useCase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    useCase = GetUserChatsUseCase(
      chatRepository: mockChatRepository,
    );
  });

  group('constructor', () {
    test('instantiates use case with required repository', () {
      expect(
        () => GetUserChatsUseCase(
          chatRepository: mockChatRepository,
        ),
        isNot(throwsException),
      );
    });
  });

  group('call', () {
    const userId = 'test-user-id';

    test('returns stream of chat previews from repository', () {
      final chatPreviews = [
        const ChatPreview(
          id: 'chat1',
          participants: ['test-user-id', 'other-user-id'],
          lastMessage: 'Hello',
          lastSenderId: 'other-user-id',
        ),
        const ChatPreview(
          id: 'chat2',
          participants: ['test-user-id', 'user3'],
          lastMessage: 'Hi there',
          lastSenderId: 'test-user-id',
        ),
      ];

      when(() => mockChatRepository.getChats(userId))
          .thenAnswer((_) => Stream.value(chatPreviews));

      final stream = useCase(userId);

      expect(stream, emits(chatPreviews));
      verify(() => mockChatRepository.getChats(userId)).called(1);
    });

    test('emits empty list when user has no chats', () {
      when(() => mockChatRepository.getChats(userId))
          .thenAnswer((_) => Stream.value([]));

      final stream = useCase(userId);

      expect(stream, emits(isEmpty));
      verify(() => mockChatRepository.getChats(userId)).called(1);
    });

    test('propagates error from repository', () {
      final error = Exception('Failed to fetch chats');
      when(() => mockChatRepository.getChats(userId))
          .thenAnswer((_) => Stream.error(error));

      final stream = useCase(userId);

      expect(stream, emitsError(isA<Exception>()));
      verify(() => mockChatRepository.getChats(userId)).called(1);
    });

    test('delegates to repository with correct user id', () {
      const differentUserId = 'different-user-id';
      when(() => mockChatRepository.getChats(differentUserId))
          .thenAnswer((_) => Stream.value([]));

      useCase(differentUserId);

      verify(() => mockChatRepository.getChats(differentUserId)).called(1);
    });
  });
}
