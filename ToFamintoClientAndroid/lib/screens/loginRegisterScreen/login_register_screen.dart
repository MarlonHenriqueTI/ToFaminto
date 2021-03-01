import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/models/user.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/bottom_screen_large_button.dart';
import 'package:to_faminto_client/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_faminto_client/services/custom_text_formatter.dart';

class LoginRegisterScreen extends StatefulWidget {
  final RoutesState routesState;
  const LoginRegisterScreen({this.routesState});

  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _apiService = ApiService();
  Future<bool> _isUserLoggedIn;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isFetchingData = false;
  bool _isLoginScreen = true;

  void sendAlert(BuildContext context,
      {String message = "Ops... algo nao esta certo", bool clear = false}) {
    setState(() {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppStyle.yellowMediumText16Style(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          duration: Duration(seconds: 5),
        ),
      );
      if (clear) {
        _emailController.clear();
        _passwordController.clear();
        _isFetchingData = false;
      }
    });
  }

  void logIn(context) async {
    if (!validateEmail(isLogin: true)) {
      sendAlert(context, message: "Nome inválido");
      return;
    }
    if (!validatePassword(isLogin: true)) {
      sendAlert(context, message: "Senha inválida");
      return;
    }

    setState(() {
      _isFetchingData = true;
    });

    final dynamic response = await _apiService.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (response is ApiError) {
      setState(() {
        sendAlert(context, message: "Ooops, problema com a conexão");
        _isFetchingData = false;
      });
    } else if (response is User) {
      final dynamic userWasGuest =
          await Provider.of<UserState>(context, listen: false)
              .saveUser(response);
      if (userWasGuest is ApiError) {
        setState(() {
          sendAlert(context, message: "Ooops, problema com a conexão");
          _isFetchingData = false;
        });
      } else if (userWasGuest) {
        changeToHomeScreen(context, resetState: false);
      } else {
        changeToHomeScreen(context);
      }
    } else {
      sendAlert(context, clear: true);
    }
  }

  void register(context) async {
    if (!validateUsername()) {
      sendAlert(context, message: "Nome inválido");
      return;
    }
    if (!validateEmail()) {
      sendAlert(context, message: "Email inválido");
      return;
    }
    if (!validatePhoneNumber()) {
      sendAlert(context, message: "Celular inválido");
      return;
    }
    if (!validatePassword()) {
      sendAlert(context, message: "Senha inválida");
      return;
    }

    setState(() {
      _isFetchingData = true;
    });

    final response = await _apiService.register(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
    );

    if (response is ApiError) {
      _isFetchingData = false;
      sendAlert(context, message: "Ooops, problema com a conexão");
    } else if (response is User) {
      final dynamic userWasGuest =
          await Provider.of<UserState>(context, listen: false)
              .saveUser(response);
      if (userWasGuest is ApiError) {
        setState(() {
          _isFetchingData = false;
          sendAlert(context, message: "Ooops, problema com a conexão");
        });
      }
      if (userWasGuest) {
        changeToHomeScreen(context, resetState: false);
      } else {
        changeToHomeScreen(context);
      }
    } else if (response is String) {
      sendAlert(context, clear: true, message: response);
    } else {
      sendAlert(context, clear: true);
    }
  }

  void changeToHomeScreen(context, {resetState = true}) {
    Provider.of<RoutesState>(context, listen: false)
        .changeToHomeScreen(shouldResetState: resetState);
  }

  Future<bool> checkIfUserIsLoggedIn() async {
    final _prefs = await SharedPreferences.getInstance();

    final authToken = _prefs.get('authToken');
    final id = _prefs.get('id');

    if (authToken != null && id != null) {
      User loggedInUser =
          User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));
      if (loggedInUser.isGuess == null) {
        loggedInUser.isGuess = false;
        _prefs.setString('currentUser', jsonEncode(loggedInUser.toJson()));
      }
      return true;
    } else {
      return false;
    }
  }

  bool validateEmail({isLogin = false}) {
    final String email = _emailController.text;
    if (isLogin) {
      return email.length > 0;
    } else {
      final regex = RegExp(
          r"^((([!#$%&'*+\-/=?^_`{|}~\w])|([!#$%&'*+\-/=?^_`{|}~\w][!#$%&'*+\-/=?^_`{|}~\.\w]{0,}[!#$%&'*+\-/=?^_`{|}~\w]))[@]\w+([-.]\w+)*\.\w+([-.]\w+)*)$");
      return regex.hasMatch(email);
    }
  }

  bool validatePassword({isLogin = false}) {
    final String password = _passwordController.text;
    if (isLogin) {
      return password.length > 0;
    } else {
      return password.length > 6;
    }
  }

  bool validateUsername() {
    final String username = _nameController.text;
    final String trimmedUsername = username.trim();
    final regex = RegExp(r" ");
    if (!regex.hasMatch(trimmedUsername)) return false;
    return username.length > 6;
  }

  bool validatePhoneNumber() {
    String phoneNumber = _phoneController.text;
    RegExp re = new RegExp(r'(\D)');
    phoneNumber = phoneNumber.replaceAll(re, "");
    return phoneNumber.length >= 10;
  }

  void initiate(BuildContext context) async {
    _isUserLoggedIn = checkIfUserIsLoggedIn();
    if (await _isUserLoggedIn) changeToHomeScreen(context);
  }

  void changeScreen() {
    setState(() {
      _isLoginScreen = !_isLoginScreen;
    });
  }

  void enterAsGuess() {
    Provider.of<UserState>(context, listen: false).saveUser(User.guest());
    _emailController.dispose();
    _passwordController.dispose();
    changeToHomeScreen(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initiate(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (!snapshot.data) {
            return Scaffold(
              body: Builder(
                builder: (ctx) => SafeArea(
                  child: _isFetchingData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _isLoginScreen
                          ? loginColumn(ctx)
                          : registerColumn(ctx),
                ),
              ),
            );
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Column loginColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            alignment: Alignment.center,
            child: Image.asset("assets/images/tofaminto_letters_logo.png"),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                LoginRegisterFormField(
                  controller: _emailController,
                  fieldName: "Email",
                  keyboardType: TextInputType.emailAddress,
                  icon: Icon(
                    Icons.mail_outline,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                LoginRegisterFormField(
                  controller: _passwordController,
                  fieldName: "Senha",
                  icon: Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <TextButton>[
                    TextButton(
                      onPressed: enterAsGuess,
                      child: Text(
                        "Entrar como convidado",
                        style: AppStyle.greyMediumText14Style(),
                      ),
                    ),
                    TextButton(
                      onPressed: changeScreen,
                      child: Text(
                        "Cadastrar",
                        style: AppStyle.greyMediumText14Style(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        BottomScreenLargeButton(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 10),
          canExpand: false,
          onPressed: (_) => logIn(context),
          child: Text(
            "ENTRAR",
            style: AppStyle.whiteSemiBoldText16Style(),
          ),
        ),
      ],
    );
  }

  Column registerColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            alignment: Alignment.center,
            child: Image.asset("assets/images/tofaminto_letters_logo.png"),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Text(
                          "Nome Completo",
                          style: AppStyle.greyRegularText14Style(),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    LoginRegisterFormField(
                      controller: _nameController,
                      fieldName: "Nome",
                      keyboardType: TextInputType.name,
                      icon: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Text(
                          "Email",
                          style: AppStyle.greyRegularText14Style(),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    LoginRegisterFormField(
                      controller: _emailController,
                      fieldName: "Email",
                      keyboardType: TextInputType.emailAddress,
                      icon: Icon(
                        Icons.mail_outline,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Text(
                          "Celular",
                          style: AppStyle.greyRegularText14Style(),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    LoginRegisterFormField(
                      controller: _phoneController,
                      fieldName: "Celular",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CustomTextFormatter(
                          mask: "(xx)x xxxx-xxxx",
                          separators: [" ", "-", "(", ")"],
                        ),
                      ],
                      icon: Icon(
                        Icons.phone_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Text(
                          "Senha",
                          style: AppStyle.greyRegularText14Style(),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    LoginRegisterFormField(
                      controller: _passwordController,
                      fieldName: "Senha",
                      icon: Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
                TextButton(
                    onPressed: changeScreen,
                    child: Text(
                      "Ja estou cadastrado",
                      style: AppStyle.greyMediumText14Style(),
                    )),
              ],
            ),
          ),
        ),
        BottomScreenLargeButton(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 10),
          canExpand: false,
          onPressed: (_) => register(context),
          child: Text(
            "CADASTRAR",
            style: AppStyle.whiteSemiBoldText16Style(),
          ),
        ),
      ],
    );
  }
}

class LoginRegisterFormField extends StatefulWidget {
  final String fieldName;
  final TextEditingController controller;
  final Icon icon;
  final bool obscureText;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  const LoginRegisterFormField({
    @required this.fieldName,
    @required this.controller,
    this.icon,
    this.obscureText = false,
    this.inputFormatters,
    this.keyboardType,
  });

  @override
  _LoginRegisterFormFieldState createState() => _LoginRegisterFormFieldState();
}

class _LoginRegisterFormFieldState extends State<LoginRegisterFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.topRight,
          colors: [
            AppStyle.yellowGradientStart,
            AppStyle.yellowGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(36)),
      ),
      child: TextFormField(
        inputFormatters: widget.inputFormatters ?? [],
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        controller: widget.controller,
        style: AppStyle.whiteMediumTextStyle(),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: widget.icon,
        ),
      ),
    );
  }
}
