import 'package:flutter/material.dart';
import 'package:grocery_plus/provider/authentication_provider.dart';
import 'package:grocery_plus/util/shared_pref.dart';
import 'package:grocery_plus/view/forgot_password_screen.dart';
import 'package:grocery_plus/util/helper.dart';
import 'package:grocery_plus/util/page_view_label_indicator.dart';
import 'package:provider/provider.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthenticationProvider>(
      create: (context) => AuthenticationProvider(),
      child: const MainScreen()
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{

  late PageController pageController;
  List<String>  page = ['Signup','Signin'];
  final currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, provider, child){
        return Scaffold(
          appBar: PreferredSize(preferredSize: const Size.fromHeight(0),child: AppBar(backgroundColor: Colors.green)),
          body: Stack(
            children: [
              Container(color: const Color.fromARGB(255, 246, 246, 246),width: double.infinity,height: double.infinity,child: Align(alignment: Alignment.bottomRight,child: Image.asset('asset/grocery_background.jpg'))),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: const Align(alignment: Alignment.center,child: Text('Grocery Plus',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)))
                    ),
                    PageViewLabelIndicator(
                      height: MediaQuery.of(context).size.height * 0.08,
                      label: page,
                      backgroundColor: Colors.transparent,
                      currentPageNotifier: currentPageNotifier,
                      selectedColor: Colors.green,
                      onPageSelect: provider.loading
                       ? null
                       : (index) => {
                          pageController.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.linear),
                          currentPageNotifier.value = index
                      }
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.72,
                      padding: const EdgeInsets.all(15),
                      child: PageView(
                        controller: pageController,
                        physics: provider.loading ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                        children: [Signup(provider: provider),Signin(provider: provider)],
                        onPageChanged: (value) => currentPageNotifier.value = value,
                      )
                    )
                  ]
                )
              )
            ]
          )
        );
      }
    );
  }
}

class Signin extends StatefulWidget {
  final AuthenticationProvider provider;
  const Signin({ Key? key,required this.provider}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> with Helper{
  var emailCont = TextEditingController();
  var passwordCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: emailCont,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'abc@xyz.com*',
            hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
            prefixIcon: Icon(Icons.email)
          )
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordCont,
          obscureText: true,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            hintText: '********',
            hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
            prefixIcon: Icon(Icons.password)
          )
        ),
        widget.provider.loading
        ? const Padding(padding: EdgeInsets.only(top: 30),child: Center(child: SizedBox(height: 25,width: 25,child: CircularProgressIndicator(strokeWidth: 2.0,color: Colors.green))))
        : GestureDetector(
          onTap: () async{
            await widget.provider.userAuthenticate(true, context, '', emailCont.text, passwordCont.text);
            if(SharedPref.getLogin){
              Navigator.pop(context,true);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 30,left: 15,right: 15,bottom: 10),
            height: 40,
            decoration: const BoxDecoration(color: Colors.green,borderRadius: BorderRadius.all(Radius.circular(5))),
            child: const Center(child: Text('Signin',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white)))
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword())),
          child: const Align(alignment: Alignment.center,child: Text('Forgot your password?',style: TextStyle(fontSize: 14,color: Colors.grey)))
        )
      ]
    );
  }
}

class Signup extends StatefulWidget {
  final AuthenticationProvider provider;
  const Signup({ Key? key, required this.provider}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with Helper{

  var nameCont = TextEditingController();
  var emailCont = TextEditingController();
  var passwordCont = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nameCont,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            hintText: 'Ali Hasan*',
            hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
            prefixIcon: Icon(Icons.person)
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: emailCont,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'abc@xyz.com*',
            hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
            prefixIcon: Icon(Icons.email)
          )
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordCont,
          obscureText: true,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            hintText: '********',
            hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
            prefixIcon: Icon(Icons.password)
          )
        ),
        widget.provider.loading
        ? const Padding(padding: EdgeInsets.only(top: 30),child: Center(child: SizedBox(height: 25,width: 25,child: CircularProgressIndicator(strokeWidth: 2.0,color: Colors.green))))
        : GestureDetector(
          onTap: () async{
            await widget.provider.userAuthenticate(false, context, nameCont.text, emailCont.text, passwordCont.text);
            if(SharedPref.getLogin){
              Navigator.pop(context,true);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 30,left: 15,right: 15,bottom: 10),
            height: 40,
            decoration: const BoxDecoration(color: Colors.green,borderRadius: BorderRadius.all(Radius.circular(5))),
            child: const Center(child: Text('Signup',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white)))
          )
        ) 
      ]
    );
  }
}