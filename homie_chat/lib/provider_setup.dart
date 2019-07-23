
import 'package:provider/provider.dart';

import 'core/models/user.dart';
import 'core/services/api.dart';
import 'core/services/authentication_service.dart';
import 'core/services/storage.dart';

List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildCloneableWidget> independentServices = [
  FutureProvider.value(value: Storage.getInstance())
];

List<SingleChildCloneableWidget> dependentServices = [
  ProxyProvider<Storage, Api>(
    builder: (context, storage, api) =>
      Api(storage: storage),
  ),
  ProxyProvider<Api, AuthenticationService>(
    builder: (context, api, authenticationService) =>
        AuthenticationService(api: api),
  )
];

List<SingleChildCloneableWidget> uiConsumableProviders = [
  StreamProvider<User>(
    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
  )
];