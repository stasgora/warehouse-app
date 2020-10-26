import 'package:get_it/get_it.dart';
import 'package:warehouse_app/model/backend_connector.dart';

void registerServices() {
	GetIt.I.registerSingleton<BackendConnector>(BackendConnector());
}
