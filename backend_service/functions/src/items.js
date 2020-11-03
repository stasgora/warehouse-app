const functions = require("firebase-functions");
const admin = require("firebase-admin");
const utils = require("./utils");


exports.getAll = functions.https.onRequest(async (req, res) => {
	const items = await utils.getCollection('items').get();
	return res.status(200).json({'data': items.docs.map(utils.documentToJson)});
});

exports.changeQuantity = functions.https.onRequest(async (req, res) => {
	let itemRef = await utils.getCollection('items').doc(req.body.data.id);
	if (!(await itemRef.get()).exists)
		return utils.getResponse(res, 404);
	await itemRef.update({'quantity': admin.firestore.FieldValue.increment(req.body.data.change)});
	return utils.getResponse(res);
});
exports.edit = functions.https.onRequest(async (req, res) => {
	var arg = req.body.data.item;
	let itemRef = await utils.getCollection('items').doc(arg.id);
	if (!(await itemRef.get()).exists)
		return utils.getResponse(res, 404);
	delete arg.id;
	await itemRef.update(arg);
	return utils.getResponse(res);
});

exports.create = functions.https.onRequest(async (req, res) => {
	await utils.getCollection('items').add(req.body.data.item);
	return utils.getResponse(res);
});
exports.remove = functions.https.onRequest(async (req, res) => {
	let itemRef = utils.getCollection('items').doc(req.body.data.id);
	if (!(await itemRef.get()).exists)
		return utils.getResponse(res, 404);
	await itemRef.delete();
	return utils.getResponse(res);
});

