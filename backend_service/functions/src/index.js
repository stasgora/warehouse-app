const admin = require("firebase-admin");

admin.initializeApp();

exports.db = require('./db');
