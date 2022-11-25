import 'package:app/model/util/map_marker.dart';
import 'package:app/services/map_services.dart';
import 'package:app/services/order_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:app/services/auth_services.dart';
import 'package:app/services/database_services.dart';
import 'package:app/services/user_services.dart';

GetIt locator = GetIt.instance;

void setupLocators() {
  locator.registerSingleton(DatabaseService());
  locator.registerSingleton(AuthService(FirebaseAuth.instance));
  locator.registerSingleton(
      UserService(firebase: FirebaseAuth.instance.currentUser));
  locator.registerSingleton(MapService());
  locator.registerLazySingleton(() => OrderService());
}

class locators {
  static DatabaseService get databaseService => locator.get<DatabaseService>();
  static AuthService get authService => locator.get<AuthService>();
  static UserService get userService => locator.get<UserService>();
  static MapService get mapService => locator.get<MapService>();
  static OrderService get orderService => locator.get<OrderService>();
}
