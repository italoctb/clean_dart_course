// ignore_for_file: use_key_in_widget_constructors

import 'package:clean_dart_course/ui/components/components.dart';
import 'package:clean_dart_course/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/components.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPresenter presenter;
  LoginPage(this.presenter);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        widget.presenter.mainErrorStream.listen((error) {
          if (error != null) {
            showErrorMessage(context, error);
          } else {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          }
        });
        return SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 240,
              margin: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.topRight,
                      colors: [Colors.cyan, Colors.white24])),
              child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "IMAGEM",
                    style: TextStyle(fontSize: 50),
                  )),
            ),
            Provider(
              create: (_) => widget.presenter,
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login Page",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const EmailFormField(),
                    const SizedBox(
                      height: 40,
                    ),
                    const PasswordFormField(),
                    const SizedBox(
                      height: 30,
                    ),
                    // ignore: deprecated_member_use
                    const LoginButtonSubmit(),
                    const SizedBox(
                      height: 15,
                    ),
                    // ignore: deprecated_member_use
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Criar conta".toUpperCase()),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
      }),
    );
  }
}
