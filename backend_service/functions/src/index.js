const admin = require("firebase-admin");

admin.initializeApp();

exports.items = require('./items');
exports.users = require('./users');
