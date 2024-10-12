import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/Themes/app_color.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/domain/usecases/auth/signup.dart';
import 'package:spotify/presentation/auth/pages/signin.dart';
import 'package:spotify/presentation/home/pages/root.dart';
import 'package:spotify/service_locator.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
      body: SingleChildScrollView(
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
            BasicAppButton(
              onPressed: () async {
                var result = await sl<SignUpUseCase>().call(
                    params: CreateUserReq(
                  fullName: _fullName.text,
                  email: _email.text,
                  password: _password.text,
                ));
        
                result.fold(
                  (l) {
                    var snackbar = SnackBar(content: Text(l));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                  (r) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (ctx) => const RootPage()),
                        (route) => false);
                  },
                );
              },
              title: 'Create Account',
            ),
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
        controller: _fullName,
        style: const TextStyle(
          fontSize: 22, 
        ),
        decoration: const InputDecoration(
            hintText: 'Full Name',
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontSize: 20,
            )).applyDefaults(
          Theme.of(context).inputDecorationTheme,
        ));
  }

  Widget _emailField(BuildContext context) {
    return TextField(
        controller: _email,
        style: const TextStyle(
          fontSize: 22, 
        ),
        decoration: const InputDecoration(
            hintText: 'Enter Email',
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontSize: 20,
            )).applyDefaults(
          Theme.of(context).inputDecorationTheme,
        ));
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
        controller: _password,
        style: const TextStyle(
          fontSize: 22, 
        ),
        decoration: const InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontSize: 20,
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
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => Signin()));
            },
            child: const Text(
              'Sign In',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
