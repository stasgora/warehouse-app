import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:warehouse_app/services/backend_service.dart';

void registerServices(RouteObserver<PageRoute> routeObserver) {
	GetIt.I.registerSingleton<BackendService>(BackendService());
	GetIt.I.registerSingleton<RouteObserver<PageRoute>>(routeObserver);
}
