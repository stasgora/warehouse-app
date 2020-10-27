import 'package:get_it/get_it.dart';
import 'package:warehouse_app/services/backend_service.dart';

void registerServices() {
	GetIt.I.registerSingleton<BackendService>(BackendService());
}
