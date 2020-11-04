const functions = require("firebase-functions");
const admin = require("firebase-admin");
const utils = require("./utils");


exports.getAll = functions.https.onCall(async (data, context) => {
	utils.checkAuth(context);
	const items = await utils.getCollection('items').get();
	return items.docs.map(utils.documentToJson);
});

exports.changeQuantity = functions.https.onCall(async (data, context) => {
	utils.checkAuth(context);
	let itemRef = await utils.getCollection('items').doc(data.id);
	if (!(await itemRef.get()).exists)
		throw new functions.https.HttpsError('not-found', 'No matching item found');
	let newQuantity;
	await admin.firestore().runTransaction(async (t) => {
		const item = await t.get(itemRef);
		newQuantity = Math.max(0, item.data().quantity + data.change);
		t.update(itemRef, {'quantity': newQuantity});
	});
	return newQuantity;
});
exports.edit = functions.https.onCall(async (data, context) => {
	utils.checkAuth(context);
	var arg = data.item;
	let itemRef = await utils.getCollection('items').doc(arg.id);
	if (!(await itemRef.get()).exists)
		throw new functions.https.HttpsError('not-found', 'No matching item found');
	delete arg.id;
	await itemRef.update(arg);
	return {};
});

exports.create = functions.https.onCall(async (data, context) => {
	utils.checkAuth(context);
	await utils.getCollection('items').add(data.item);
	return {};
});
exports.remove = functions.https.onCall(async (data, context) => {
	utils.checkAuth(context);
	let itemRef = utils.getCollection('items').doc(data.id);
	if (!(await itemRef.get()).exists)
		throw new functions.https.HttpsError('not-found', 'No matching item found');
	await itemRef.delete();
	return {};
});

