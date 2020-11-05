const admin = require("firebase-admin");
const functions = require("firebase-functions");

exports.getCollection = function getCollection(name) {
	return admin.firestore().collection(name);
}

exports.documentToJson = function documentToJson(doc) {
	let json = doc.data();
	json['id'] = doc.id;
	return json;
}

exports.checkAuth = function checkAuth(context) {
	if (!context.auth)
		throw new functions.https.HttpsError('unauthenticated', 'Authentication Required');
}

exports.getUser = async function getUser(authId) {
	let query = await (exports.getCollection('users').where('authId', '==', authId).get());
	if (query.size === 0)
		return {};
	return query.docs[0];
}
