import 'package:get_it/get_it.dart';
import 'package:homies/scoped_models/home_model.dart';
import 'package:homies/scoped_models/login_view_model.dart';
import 'package:homies/services/user_service.dart';
import 'package:homies/services/web_service.dart';

GetIt locator = new GetIt();

void setupLocator() {
  locator.registerLazySingleton<WebService>(() => WebService());
  locator.registerLazySingleton<UserService>(() => UserService());

  locator.registerFactory<LoginModel>(() => LoginModel());
  locator.registerFactory<HomeModel>(() => HomeModel());
}