class Api {
  static const String searchUsers = '$baseUrl/users/search';
  static const String leaderboard = '$baseUrl/users/leaderboard';
  static String viewProfile(int id) => '$baseUrl/users/$id/profile';
  static const String baseUrl = 'https://soalix-backend.onrender.com';
  static const String imageUrl = '$baseUrl/public/';
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String activate = '$baseUrl/auth/activate';
  static const String requestResetPassword =
      '$baseUrl/auth/request-reset-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String addCard = '$baseUrl/cards';
  static const String uploadImage = '$baseUrl/media/image';
  static const String uploadDocument = '$baseUrl/media/document';
  static const String getDecks = '$baseUrl/decks/hierarchy';
  static const String getMyDecks = '$baseUrl/decks/me';
  static const String enterCode = '$baseUrl/codes/link-by-code';
  static const String createDeck = '$baseUrl/decks';
  static  String editDeck(int id) => '$baseUrl/decks/$id';
  static  String deleteDeck(int id) => '$baseUrl/decks/$id';
  static  String deleteCard(int deckID,int id) => '$baseUrl/cards/$deckID/$id';
  static String getCards(int id) => '$baseUrl/cards/$id';
  static const String getDocument = '$baseUrl/media/documents';
  static  String answerCard(int id) => '$baseUrl/cards/answer/$id';
  static String getProfile(int id) => '$baseUrl/users/$id/profile';
  static String followUser(int id) => '$baseUrl/users/$id/follow';
  static String unfollowUser(int id) => '$baseUrl/users/$id/follow';
  static const String updateProfile = '$baseUrl/users/me/profile';
}
