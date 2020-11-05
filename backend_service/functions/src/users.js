const functions = require("firebase-functions");
const utils = require("./utils");


exports.get = functions.https.onCall(async (data, context) => {
	utils.checkAuth(context);
	return utils.documentToJson(await utils.getUser(data.authId));
});

exports.create = functions.https.onCall(async (data, context) => {
	utils.checkAuth(context);
	await utils.getCollection('users').add(data.user);
	return {};
});
