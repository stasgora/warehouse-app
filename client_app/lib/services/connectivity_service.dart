import 'package:connectivity/connectivity.dart';

class ConnectivityService {
	bool _override;
	set override(bool val) => _override = val;

	Future<bool> hasConnectivity() async => _override ?? (await (Connectivity().checkConnectivity())) != ConnectivityResult.none;
}