import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:warehouse_app/logic/authentication/sign_in/sign_in_cubit.dart';
import 'package:warehouse_app/model/app_page.dart';
import 'package:warehouse_app/model/ui_button.dart';
import 'package:warehouse_app/widgets/auth/auth_button.dart';
import 'package:warehouse_app/services/auth/auth_exceptions.dart';
import 'package:warehouse_app/model/auth/email.dart';
import 'package:warehouse_app/model/auth/password.dart';
import 'package:warehouse_app/widgets/auth/auth_input_field.dart';
import 'package:warehouse_app/widgets/auth/auth_widgets.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
	  return Scaffold(
		  backgroundColor: Theme.of(context).accentColor,
		  body: SafeArea(
		    child: BlocListener<SignInCubit, SignInState>(
			    listener: (context, state) {
				    if (state.status.isSubmissionFailure && state.signInError != null)
					    Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(
						    SnackBar(content: Text(state.signInError.key)),
					    );
			    },
		      child: ListView(
		        children: [
		          AuthGroup(
		          	title: "Zaloguj się",
			        hint: 'Uzyskaj dostęp do swojego konta',
		          	content: _buildSignInForm(context),
		          ),
	          _buildSignUpButtons(context)
		        ],
		      ),
		    ),
		  ),
	  );
  }

  Column _buildSignInForm(BuildContext context) {
    return Column(
			children: [
				AuthenticationInputField<SignInCubit, SignInState>(
					getField: (state) => state.email,
					changedAction: (cubit, value) => cubit.emailChanged(value),
					label: 'Adres e-mail',
					icon: Icons.email,
					getError: (state) => state.email.error.key,
					inputType: TextInputType.emailAddress
				),
				AuthenticationInputField<SignInCubit, SignInState>(
					getField: (state) => state.password,
					changedAction: (cubit, value) => cubit.passwordChanged(value),
					label: 'Hasło',
					icon: Icons.lock,
					getError: (state) => state.password.error.key,
					hideInput: true
				),
				AuthButton(
					button: UIButton.ofType(
						ButtonType.signIn,
						() => context.bloc<SignInCubit>().logInWithCredentials(),
						Colors.teal
					)
				),
				AuthDivider(),
				AuthButton.google(
					UIButton('Zaloguj się z Google', () => context.bloc<SignInCubit>().logInWithGoogle())
				)
			],
		);
  }

  Widget _buildSignUpButtons(BuildContext context) {
	  return AuthGroup(
		  title: 'Zarejestruj się',
		  hint: 'Załóż konto',
		  content: Column(
			  children: <Widget>[
				  AuthButton(
					  button: UIButton.ofType(
						  ButtonType.signUp,
						  () => Navigator.of(context).pushNamed(AppPage.signUpPage.name),
						  Colors.teal
					  )
				  )
			  ]
		  )
	  );
  }
}
