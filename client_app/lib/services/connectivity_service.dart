import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectivityService {
	SharedPreferences _preferences;
	static const String _PREF_KEY = 'overrideConnect';

	bool _override;

	bool get override => _override;

	set override(bool val) {
		val == null ? _preferences.remove(_PREF_KEY) : _preferences.setBool(_PREF_KEY, val);
	  _override = val;
	}

	ConnectivityService() {
		SharedPreferences.getInstance().then((value) {
		  _preferences = value;
		  _override = _preferences.getBool(_PREF_KEY);
		});
	}

	Future<bool> hasConnectivity() async => _override ?? (await (Connectivity().checkConnectivity())) != ConnectivityResult.none;
}