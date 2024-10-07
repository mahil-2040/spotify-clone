import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/Themes/app_color.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/presentation/auth/pages/signin.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signinText(context),
      appBar: BasicAppBar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _registerText(),
            const SizedBox(
              height: 50,
            ),
            _fullNameField(context),
            const SizedBox(
              height: 20,
            ),
            _emailField(context),
            const SizedBox(
              height: 20,
            ),
            _passwordField(context),
            const SizedBox(
              height: 40,
            ),
            BasicAppButton(onPressed: () {}, title: 'Create Account'),
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Register',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
        decoration: const InputDecoration(
            hintText: 'Full Name',
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontSize: 18,
            )).applyDefaults(
      Theme.of(context).inputDecorationTheme,
    ));
  }

  Widget _emailField(BuildContext context) {
    return TextField(
        decoration: const InputDecoration(
            hintText: 'Enter Email',
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontSize: 18,
            )).applyDefaults(
      Theme.of(context).inputDecorationTheme,
    ));
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
        decoration: const InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontSize: 18,
            )).applyDefaults(
      Theme.of(context).inputDecorationTheme,
    ));
  }

  Widget _signinText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do you have an account?',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const Signin()));
            },
            child: const Text('Sign In', style: TextStyle(fontSize: 17),),
          ),
        ],
      ),
    );
  }
}
