import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chat/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String userName,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  final bool isLoading;
  AuthForm(this.submitFn, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  File _userImageFile;
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String _userEmail;
  String _userName;
  String _userPassword;
  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text('pls pick an image'),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
    //check all validation return null
    if (isValid && _userImageFile != null) {
      _formKey.currentState.save();
      print('user details');
      print(_userEmail);
      print(_userName);
      print(_userPassword);
      _formKey.currentState.save(); //saving triggeres onsave
      widget.submitFn(
        _userEmail.trim(),
        _userName,
        _userPassword.trim(),
        _userImageFile,
        _isLogin,
        context,
      );

      //use these values to send our auth
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (!_isLogin)
                  UserImagePicker(
                      _pickedImage), //inline condition to decide wheather to add or remove the widget
                TextFormField(
                  key: ValueKey(
                      'email'), // to uniquely identigy otherwise errors happen as  we dynamically remove form fields
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'please enter valid email adress ';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email Adress'),
                  onSaved: (value) {
                    _userEmail = value;
                  },
                ),
                if (!_isLogin) //special condition that can be applied to check to include this form field
                  TextFormField(
                    key: ValueKey(
                        'username'), // to uniquely identigy otherwise errors happen as  we dynamically remove form fields
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Need minimum 4 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'username'),
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'password must be 7 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userPassword = value;
                  },
                  decoration: InputDecoration(labelText: 'password'),
                  obscureText: true, //hide text
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  RaisedButton(
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? 'login' : 'Signup '),
                  ),
                if (!widget.isLoading)
                  FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'create new account'
                          : 'I already have an account')),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
