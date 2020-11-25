import 'dart:convert';

import 'package:warehouse_app/model/json_convertible.dart';

import 'file_storage_service.dart';
import 'storage_service.dart';

class JsonStorage<Model extends JsonConvertible> {
	final StorageService _storageService;
	final Model _model;

	Model get model => _model;

	JsonStorage(String identifier, this._model) : _storageService = FileStorageService(identifier) {
		_initialize();
	}

	Future<dynamic> execute(dynamic Function(Model) query) async {
		var result = query(_model);
		await _write();
		return result;
	}

  Future _initialize() async {
		await _storageService.initialize();
		if ((await _storageService.read()) == null)
			_storageService.write('[]');
		else
			_read();
  }

  Future<String> _read() async {
		_model.fromJson(json.decode(await _storageService.read()));
  }

  Future _write() => _storageService.write(json.encode(_model.toJson()));
}
