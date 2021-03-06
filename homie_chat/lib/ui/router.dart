
import 'package:flutter/material.dart';
import 'package:homie_chat/core/constants/app_constants.dart';
import 'package:homie_chat/ui/views/gallery_view.dart';
import 'package:homie_chat/ui/views/group_settings_view.dart';
import 'package:homie_chat/ui/views/home_view.dart';
import 'package:homie_chat/ui/views/login_view.dart';
import 'package:homie_chat/ui/views/members_view.dart';
import 'package:homie_chat/ui/views/profile_view.dart';
import 'package:homie_chat/ui/views/register_view.dart';
import 'package:homie_chat/ui/views/root_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Root:
        return MaterialPageRoute(builder: (_) => RootView());
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => HomeView());
      case RoutePaths.Login:
        return MaterialPageRoute(builder: (_) => LoginView());
      case RoutePaths.Register:
        return MaterialPageRoute(builder: (_) => RegisterView());
      case RoutePaths.Profile:
        return MaterialPageRoute(builder: (_) => ProfileView());
      case RoutePaths.GroupSettings:
        return MaterialPageRoute(builder: (_) => GroupSettingsView());
      case RoutePaths.Gallery:
        return MaterialPageRoute(builder: (_) => GalleryView());
      case RoutePaths.Members:
        return MaterialPageRoute(builder: (_) => MembersView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route deifned for ${settings.name}'),
            )
          )
        );
    }
  }
}