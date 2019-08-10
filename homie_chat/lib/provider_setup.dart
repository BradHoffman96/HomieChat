
import 'package:homie_chat/core/services/group_service.dart';
import 'package:homie_chat/core/services/message_service.dart';
import 'package:provider/provider.dart';

import 'core/models/group.dart';
import 'core/models/message.dart';
import 'core/models/user.dart';
import 'core/services/api.dart';
import 'core/services/authentication_service.dart';
import 'core/services/storage_service.dart';

Future<Iterable<SingleChildCloneableWidget>> getProviders() async {
  var storage = await StorageService.getInstance();

  List<SingleChildCloneableWidget> independentServices = [
    Provider<StorageService>.value(value: storage),
  ];

  List<SingleChildCloneableWidget> dependentServices = [
    ProxyProvider<StorageService, Api>(
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
    ),
    ProxyProvider<Api, MessageService>(
      builder: (context, api, messageService) =>
        MessageService(api: api),
    )
  ];

  List<SingleChildCloneableWidget> uiConsumableProviders = [
    StreamProvider<User>(
      builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
    ),
    StreamProvider<Group>(
      builder: (context) => Provider.of<GroupService>(context, listen: false).group,
    ),
    StreamProvider<List<Message>>(
      builder: (context) => Provider.of<MessageService>(context, listen: false).messages,
    )
  ];

  return [
    ...independentServices,
    ...dependentServices,
    ...uiConsumableProviders
  ];
}

