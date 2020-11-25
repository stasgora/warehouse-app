abstract class StorageService {
	final String identifier;

	StorageService(this.identifier);
	Future initialize();
	Future write(String content);
	Future<String> read();
}