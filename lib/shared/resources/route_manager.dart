import 'package:smart_recommendation_system_for_mental_health_patients/authentication/login_auth.dart';
import '../../screens/journal/components/create.dart';

class RouteManager {
  static const String splashScreen = "/splash";
  static const String welcomeScreen = "/welcome";
  static const String authScreen = "/auth";
  static const String forgotPasswordScreen = "/forgotPasswordScreen";
  static const String signupAcknowledgeScreen = "/signupAcknowledge";
  static const String homeScreen = '/homeScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String createNoteScreen = '/createNote';
  static const String pinSetup = '/pinSetup';
  static const String pinConfirmScreen = '/pinConfirm';
  static const String pinSuccessScreen = '/pinSuccess';

}

final routes = {
  RouteManager.homeScreen: (context) => LoginAuthPage(),
  RouteManager.createNoteScreen: (context) => const CreateNoteScreen(),

};