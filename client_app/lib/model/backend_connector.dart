import 'package:cloud_functions/cloud_functions.dart';
import 'package:warehouse_app/model/item.dart';

class BackendConnector {
	var _api = CloudFunctions.instance.useFunctionsEmulator(origin: 'http://10.0.2.2:5521');

	Future<List<Item>> fetchItems() async {
		List<dynamic> data = await _call('getItems');
		return data.map((element) {
		  return Item.fromJson(Map.from(element));
		}).toList();
	}
	
	Future<dynamic> _call(String function, [dynamic args]) async => (await _api.getHttpsCallable(functionName: function).call(args)).data;
}
