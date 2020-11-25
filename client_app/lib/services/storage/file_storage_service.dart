import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'storage_service.dart';

class FileStorageService extends StorageService {
	File _storageFile;
	String _storage;

  FileStorageService(String identifier) : super(identifier);

	@override
	Future<String> read() => Future.value(_storage);

	@override
	Future write(String content) {
		return Future.sync(() {
			_storageFile.writeAsString(content);
			_storage = content;
		});
	}

	@override
  Future initialize() async {
  	var path = await _getLocalPath;
	  _storageFile = File('$path/$identifier');
	  if (await _storageFile.exists())
	  	_storage = await read();
  }

	static Future<String> get _getLocalPath async => (await getApplicationDocumentsDirectory()).path;
}
