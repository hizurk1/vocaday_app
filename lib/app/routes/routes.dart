part of 'route_manager.dart';

class AppRoutes {
  AppRoutes._();
  static const init = '/'; // Entry page
  static const authentication = '/authentication';
  static const setting = '/setting';
  static const favourite = '/favourite';
  static const knownWord = '/knownWord';
  static const changePassword = '/changePassword';
  static const listWord = '/listWord';
  static const flashCard = '/flashCard';
  static const cart = '/cart';

  static const quiz = '/quiz';
  static const quizSummery = '/quizSummery';
  static const slidingPuzzle = '/slidingPuzzle';

  static const main = '/main';
  static const home = '$main/home';
  static const search = '$main/search';
  static const activity = '$main/activity';
  static const profile = '$main/profile';
  static const profileEdit = '$profile/edit';
}
