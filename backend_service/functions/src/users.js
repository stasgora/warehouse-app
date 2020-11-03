const functions = require("firebase-functions");
const utils = require("./utils");


exports.get = functions.https.onCall(async (data, context) => {
	utils.checkAuth(context);
	let query = await utils.getCollection('users').where('authId', '==', data.authId).get();
	if (query.size === 0)
		return {};
	return utils.documentToJson(query.docs[0]);
});

exports.create = functions.https.onCall(async (data, context) => {
	utils.checkAuth(context);
	await utils.getCollection('users').add(data.user);
	return {};
});
