const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.getItems = functions.https.onRequest(async (req, res) => {
	const items = await getCollection().get();
	return res.status(200).json({'data': items.docs.map(documentToJson)});
});

exports.changeQuantity = functions.https.onRequest(async (req, res) => {
	let item = await getCollection().doc(req.body.data.id);
	if (!item.exists)
		return res.status(404);
	const quantity = (await item.get()).data.quantity;
	await item.update({'quantity': quantity + req.body.data.change});
	return getResponse(res);
});
exports.editItem = functions.https.onRequest(async (req, res) => {
	let item = await getCollection().doc(req.body.data.id);
	if (!item.exists)
		return res.status(404);
	delete req.body.data.id;
	await item.update(req.body.data);
	return getResponse(res);
});

exports.createItem = functions.https.onRequest(async (req, res) => {
	await getCollection().doc().create(req.body.data);
	return getResponse(res);
});
exports.removeItem = functions.https.onRequest(async (req, res) => {
	let item = await getCollection().doc(req.body.data.id);
	if (!item.exists)
		return res.status(404);
	await item.delete();
	return getResponse(res);
});

function getCollection() {
	return admin.firestore().collection('items');
}
function getResponse(res) {
	return res.status(200).json({'data': {}});
}

function documentToJson(doc) {
	let json = doc.data();
	json['id'] = doc.id;
	return json;
}
