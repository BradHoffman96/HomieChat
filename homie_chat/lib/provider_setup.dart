
import 'package:homie_chat/core/services/group_service.dart';
import 'package:provider/provider.dart';

import 'core/models/group.dart';
import 'core/models/user.dart';
import 'core/services/api.dart';
import 'core/services/authentication_service.dart';
import 'core/services/storage.dart';

Future<Iterable<SingleChildCloneableWidget>> getProviders() async {
  var storage = await Storage.getInstance();

  List<SingleChildCloneableWidget> independentServices = [
    Provider<Storage>.value(value: storage)
  ];

  List<SingleChildCloneableWidget> dependentServices = [
    ProxyProvider<Storage, Api>(
      builder: (context, storage, api) =>
        Api(storage: storage),
    ),
    ProxyProvider<Api, AuthenticationService>(
      builder: (context, api, authenticationService) =>
        AuthenticationService(api: api),
    ),
    ProxyProvider<Api, GroupService>(
      builder: (context, api, groupService) =>
        GroupService(api: api),
    )
  ];

  List<SingleChildCloneableWidget> uiConsumableProviders = [
    StreamProvider<User>(
      builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
    ),
    StreamProvider<Group>(
      builder: (context) => Provider.of<GroupService>(context, listen: false).group,
    )
  ];

  return [
    ...independentServices,
    ...dependentServices,
    ...uiConsumableProviders
  ];
}

