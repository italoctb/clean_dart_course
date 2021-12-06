import 'dart:js';

import 'package:clean_dart_course/ui/pages/login/login_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordFormField extends StatelessWidget {
  const PasswordFormField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<String>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
                labelText: "Password",
                icon: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColor,
                ),
                errorText:
                    snapshot.data?.isEmpty == true ? null : snapshot.data),
            obscureText: true,
            onChanged: presenter.validatePassword,
          );
        });
  }
}
