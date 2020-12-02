import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:warehouse_app/services/auth/auth_provider.dart';
import 'package:warehouse_app/services/auth/firebase_auth_provider.dart';
import 'package:warehouse_app/services/data/aggregate_data_service.dart';

import 'connectivity_service.dart';
import 'data/data_service.dart';

void registerServices(RouteObserver<PageRoute> routeObserver) {
	GetIt.I.registerSingleton<ConnectivityService>(ConnectivityService());
	GetIt.I.registerSingleton<DataService>(AggregateDataService());
	GetIt.I.registerSingleton<AuthenticationProvider>(FirebaseAuthProvider());
	GetIt.I.registerSingleton<RouteObserver<PageRoute>>(routeObserver);
}
