const functions = require("firebase-functions");
const admin = require("firebase-admin");
const utils = require("./utils");

exports.synchronize = functions.https.onCall(async (data, context) => {
	utils.checkAuth(context);
	let operations = data.ops;
});
