import 'package:flutter/cupertino.dart';
import 'package:grocery_plus/util/helper.dart';

class AuthenticationProvider extends ChangeNotifier with Helper {
  bool _isLoading = false;
  bool get loading => _isLoading;


  Future<void> userAuthenticate(bool isLogin,BuildContext _context,String name, String email, String password) async {
    if (await validation(_context,name, email, password)) {
      _isLoading = true;
      notifyListeners();
      try {
        isLogin
        ? userCredential = await firebaseAuthInstance.signInWithEmailAndPassword(email: email, password: password)
        : userCredential = await firebaseAuthInstance.createUserWithEmailAndPassword(email: email, password: password);
        Preferences.setUserEmail(email);
        Preferences.setUserLogin(true);
        Preferences.setUserID(userCredential!.user!.uid);
        Preferences.setSyncEnabled(true);
        Preferences.setSyncExplicitly(true);
        if(!isLogin) databaseReference.child(userCredential!.user!.uid).update({'name' : name });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showSnackbar(_context,'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showSnackbar(_context,'The account already exists for that email.');
        } else if (e.code == 'user-not-found') {
          showSnackbar(_context,'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showSnackbar(_context,'Wrong password provided for that user.');
        }
      } catch (e) {
        showSnackbar(_context, e.toString());
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void deleteUserData(BuildContext _context) async{
    if(await checkInternetConnection()){
      _syncDataDelete = true;
      notifyListeners();
      await databaseReference.child(Preferences.getUserID()).child('task').remove();
      await databaseReference.child(Preferences.getUserID()).child('completeTask').remove();
      showSnackbar(_context, 'All Sync data has been deleted successfully');
      _syncDataDelete = false;
      notifyListeners();
    }else{
      showSnackbar(_context, 'No Internet Connection');
    }
  }

  void fillEmailPassword(String name,String email,String password){
    if(_isLogin){
      if(email.isNotEmpty && password.isNotEmpty){
        _emailPaswordAvail = true;
      }else{
        _emailPaswordAvail = false;
      } 
    }else{
      if(email.isNotEmpty && password.isNotEmpty && name.isNotEmpty){
        _emailPaswordAvail = true;
      }else{
        _emailPaswordAvail = false;
      }
    }
    notifyListeners();
  }

  void passwordVisibility(){
    _showPassword = _showPassword ? false : true;
    notifyListeners();
  }



  Future<bool> validation(BuildContext _context,String name, String email, String password) async{
    if(!_isLogin && name.isEmpty){
      showSnackbar(_context, 'Please provider name');
      return false;
    }
    if (email.isEmpty) {
      showSnackbar(_context, 'Please provide email');
      return false;
    } else if(!validateEmail(email)){
      showSnackbar(_context, 'Invalid Email');
      return false;
    } else if (password.isEmpty) {
      showSnackbar(_context, 'Please provide password');
      return false;
    }else if(password.length < 6){
      showSnackbar(_context, 'Weak Password!!! Length of Password Should be atleast 6');
      return false;
    }else if(!await checkInternetConnection()){
      showSnackbar(_context, 'No Internet Connection');
      return false;
    }
    return true;
  }


}
