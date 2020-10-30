import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_app/logic/item_list_cubit.dart';
import 'package:warehouse_app/page/item_page.dart';
import 'package:warehouse_app/page/login_page.dart';
import 'package:warehouse_app/page/panel_page.dart';
import 'package:warehouse_app/services/service_injection.dart';
import 'logic/authentication/bloc/authentication_bloc.dart';
import 'logic/authentication/sign_in/sign_in_cubit.dart';
import 'model/app_page.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp();
	var routeObserver = RouteObserver<PageRoute>();
	registerServices(routeObserver);
  runApp(BlocProvider<AuthenticationBloc>(
	  create: (context) => AuthenticationBloc(),
	  child: WarehouseApp(routeObserver),
  ));
}

class WarehouseApp extends StatelessWidget {
	final _navigatorKey = GlobalKey<NavigatorState>();
	final _routeObserver;

  WarehouseApp(this._routeObserver);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warehouse App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppPage.loginPage.name,
      routes: _createRoutes(),
	    builder: _authenticationGateBuilder,
	    navigatorKey: _navigatorKey,
	    navigatorObservers: [_routeObserver],
    );
  }

	Map<String, WidgetBuilder> _createRoutes() {
		var getRoute = (BuildContext context) => ModalRoute.of(context);
		var getParams = (BuildContext context) => getRoute(context).settings.arguments;
  	return {
		  AppPage.loginPage.name: (context) => _createPage(LoginPage(), context, SignInCubit()),
		  AppPage.panelPage.name: (context) => _createPage(PanelPage(), context, ItemListCubit(getRoute(context))),
		  AppPage.itemPage.name: (context) => _createPage(ItemPage(getParams(context)), context),
	  };
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
			  var redirectPage = state.status == AuthenticationStatus.authenticated ? AppPage.panelPage : AppPage.loginPage;
			  _navigatorKey.currentState.pushNamedAndRemoveUntil(redirectPage.name, (route) => false);
		  },
		  child: child
	  );
  }
}
