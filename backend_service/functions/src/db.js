const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.getItems = functions.https.onRequest(async (req, res) => {
	const items = await getCollection().get();
	return res.status(200).json({'data': items.docs.map(documentToJson)});
});

exports.changeQuantity = functions.https.onRequest(async (req, res) => {
	let itemRef = await getCollection().doc(req.body.data.id);
	if (!(await itemRef.get()).exists)
		return getResponse(res, 404);
	await itemRef.update({'quantity': admin.firestore.FieldValue.increment(req.body.data.change)});
	return getResponse(res);
});
exports.editItem = functions.https.onRequest(async (req, res) => {
	var arg = req.body.data.item;
	let itemRef = await getCollection().doc(arg.id);
	if (!(await itemRef.get()).exists)
		return getResponse(res, 404);
	delete arg.id;
	await itemRef.update(arg);
	return getResponse(res);
});

exports.createItem = functions.https.onRequest(async (req, res) => {
	await getCollection().add(req.body.data.item);
	return getResponse(res);
});
exports.removeItem = functions.https.onRequest(async (req, res) => {
	let itemRef = getCollection().doc(req.body.data.id);
	if (!(await itemRef.get()).exists)
		return getResponse(res, 404);
	await itemRef.delete();
	return getResponse(res);
});

function getCollection() {
	return admin.firestore().collection('items');
}
function getResponse(res, status=200) {
	return res.status(status).json({'data': {}});
}

function documentToJson(doc) {
	let json = doc.data();
	json['id'] = doc.id;
	return json;
}
