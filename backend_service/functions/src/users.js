const functions = require("firebase-functions");
const utils = require("./utils");


exports.get = functions.https.onRequest(async (req, res) => {
	let query = await utils.getCollection('users').where('authId', '==', req.body.data.authId).get();
	if (query.size === 0)
		return utils.getResponse(res);
	return res.status(200).json({'data': utils.documentToJson(query.docs[0])});
});

exports.create = functions.https.onRequest(async (req, res) => {
	await utils.getCollection('users').add(req.body.data.user);
	return utils.getResponse(res);
});
