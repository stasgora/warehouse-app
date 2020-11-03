import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:warehouse_app/logic/authentication/sign_up/sign_up_cubit.dart';
import 'package:warehouse_app/model/ui_button.dart';
import 'package:warehouse_app/widgets/auth/auth_button.dart';
import 'package:warehouse_app/widgets/auth/auth_input_field.dart';
import 'package:warehouse_app/widgets/auth/auth_widgets.dart';
import 'package:warehouse_app/model/auth/email.dart';
import 'package:warehouse_app/services/auth/auth_exceptions.dart';
import 'package:warehouse_app/model/auth/name.dart';
import 'package:warehouse_app/model/auth/password.dart';
import 'package:warehouse_app/model/auth/confirmed_password.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
	  return Scaffold(
		  backgroundColor: Theme.of(context).accentColor,
		  body: SafeArea(
			  child: BlocListener<SignUpCubit, SignUpState>(
				  listener: (context, state) {
					  if (state.status.isSubmissionFailure && (state.signInError != null || state.signUpError != null))
						  Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(
							  SnackBar(content: Text(state.signUpError?.key ?? state.signInError.key)),
						  );
				  },
			    child: ListView(
				  children: [
					  AuthGroup(
						  title: "Zarejestruj się",
						  hint: 'Stwórz nowe konto',
						  content: _buildSignUpForm(context),
					  ),
				  ],
			    ),
			  ),
		  ),
	  );
  }

  Widget _buildSignUpForm(BuildContext context) {
  	return Column(
		  children: [
			  AuthenticationInputField<SignUpCubit, SignUpState>(
				  getField: (state) => state.name,
				  changedAction: (cubit, value) => cubit.nameChanged(value),
				  label: 'Imię',
				  icon: Icons.person,
				  getError: (state) => state.name.error.key,
				  inputType: TextInputType.name
			  ),
			  AuthenticationInputField<SignUpCubit, SignUpState>(
				  getField: (state) => state.email,
				  changedAction: (cubit, value) => cubit.emailChanged(value),
				  label: 'Adres e-mail',
				  icon: Icons.email,
				  getError: (state) => state.email.error.key,
				  inputType: TextInputType.emailAddress
			  ),
			  AuthenticationInputField<SignUpCubit, SignUpState>(
				  getField: (state) => state.password,
				  changedAction: (cubit, value) => cubit.passwordChanged(value),
				  label: 'Hasło',
				  icon: Icons.lock,
				  getError: (state) => state.password.error.key,
				  hideInput: true
			  ),
			  AuthenticationInputField<SignUpCubit, SignUpState>(
				  getField: (state) => state.confirmedPassword,
				  changedAction: (cubit, value) => cubit.confirmedPasswordChanged(value),
				  label: 'Powtórz hasło',
				  icon: Icons.lock,
				  getError: (state) => state.confirmedPassword.error.key,
				  hideInput: true
			  ),
			  AuthButton(
				  button: UIButton.ofType(
					  ButtonType.signUp,
					  () => context.bloc<SignUpCubit>().signUpFormSubmitted(),
					  Colors.teal
				  )
			  ),
			  AuthDivider(),
			  AuthButton.google(
				  UIButton('Załóż konto z Google', () => context.bloc<SignUpCubit>().logInWithGoogle())
			  )
		  ],
	  );
  }
}
