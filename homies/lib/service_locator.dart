import 'package:get_it/get_it.dart';
import 'package:homies/scoped_models/home_model.dart';
import 'package:homies/scoped_models/login_view_model.dart';
import 'package:homies/services/persistence_service.dart';
import 'package:homies/services/user_service.dart';
import 'package:homies/services/web_service.dart';

GetIt locator = new GetIt();

Future setupLocator() async {
  locator.registerLazySingleton<WebService>(() => WebService());
  locator.registerLazySingleton<UserService>(() => UserService());
  //locator.registerLazySingleton<PersistenceService>(() => PersistenceService());
  
  var instance = await PersistenceService.getInstance();
  locator.registerSingleton<PersistenceService>(instance);

  locator.registerFactory<LoginModel>(() => LoginModel());
  locator.registerFactory<HomeModel>(() => HomeModel());
}