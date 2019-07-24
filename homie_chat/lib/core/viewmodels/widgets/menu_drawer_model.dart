
import 'package:homie_chat/core/services/group_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class MenuDrawerModel extends BaseModel {
  final GroupService _groupService;
  
  MenuDrawerModel({GroupService groupService}) : _groupService = groupService;
}