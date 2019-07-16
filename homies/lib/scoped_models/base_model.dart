
import 'package:homies/enums/view_state.dart';
import 'package:scoped_model/scoped_model.dart';

export 'package:homies/enums/view_state.dart';

class BaseModel extends Model {
  ViewState _state;
  ViewState get state => _state;

  void setState(ViewState newState) {
    _state = newState;

    notifyListeners();
  }
}