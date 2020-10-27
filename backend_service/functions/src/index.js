const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
exports.getItems = functions.https.onRequest(async (req, res) => {
	const items = await admin.firestore().collection('items').get();
	const response = items.docs.map(doc => doc.data());
	res.json({'data': items.docs.map(doc => doc.data())});
});