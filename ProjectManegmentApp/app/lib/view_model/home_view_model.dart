import 'package:app/view_model/auth_view_model.dart';
import 'package:app/views/auth_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';



class HomeViewModel with ChangeNotifier{

  int pageIndex = 0;
  set setPageIndex(int newValue){
    pageIndex = newValue;
    notifyListeners();
  }

  Future logOut(BuildContext context)async{
    await Provider.of<AuthViewModel>(context,listen: false).logout();
    Navigator.of(context).pushReplacementNamed(AuthView.routeName);
  }
}