class AnswersEntity {
  int userId;
  int cardId;
  String answer;

  AnswersEntity({
    required this.answer,
    required this.cardId,
    required this.userId,
  });
}