import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_app/logic/item_list/item_list_cubit.dart';
import 'package:warehouse_app/page/login_page.dart';
import 'package:warehouse_app/page/panel_page.dart';
import 'package:warehouse_app/services/service_injection.dart';

import 'logic/authentication/authentication_bloc.dart';
import 'model/app_page.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp();
	registerServices();
  runApp(BlocProvider<AuthenticationBloc>(
	  create: (context) => AuthenticationBloc(),
	  child: WarehouseApp(),
  ));
}

class WarehouseApp extends StatelessWidget {
	var _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warehouse App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppPage.login.name,
      routes: {
	      AppPage.login.name: (context) => _createPage(LoginPage(), context),
	      AppPage.panel.name: (context) => _createPage(PanelPage(), context, ItemListCubit()),
      },
	    builder: _authenticationGateBuilder,
	    navigatorKey: _navigatorKey,
    );
  }

	Widget _createPage<CubitType extends Cubit>(Widget page, BuildContext context, [CubitType pageCubit]) {
		if (pageCubit != null)
			page = BlocProvider(
				create: (context) => pageCubit,
				child: page,
			);
		return page;
	}

  Widget _authenticationGateBuilder(BuildContext context, Widget child) {
	  return BlocListener<AuthenticationBloc, AuthenticationState>(
		  listenWhen: (oldState, newState) => oldState.status != newState.status,
		  listener: (context, state) {
			  var redirectPage = state.status == AuthenticationStatus.authenticated ? AppPage.panel : AppPage.login;
			  _navigatorKey.currentState.pushNamedAndRemoveUntil(redirectPage.name, (route) => false);
		  },
		  child: child
	  );
  }
}
