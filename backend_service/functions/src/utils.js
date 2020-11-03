const admin = require("firebase-admin");

exports.getCollection = function getCollection(name) {
	return admin.firestore().collection(name);
}

exports.getResponse = function getResponse(res, status=200) {
	return res.status(status).json({'data': {}});
}

exports.documentToJson = function documentToJson(doc) {
	let json = doc.data();
	json['id'] = doc.id;
	return json;
}
