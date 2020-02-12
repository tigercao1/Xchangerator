const path = require('path');
const debug = require('debug')('appserver:firebase');

/**
 * Firebase: Initialize Cloud Firestore
 */
const admin = require('firebase-admin');

let serviceAccount = require(path.join(
  __dirname,
  process.env.SERVICE_ACCOUNT_KEY_PATH,
));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://xchangerator.firebaseio.com',
});

//firestore node api: https://firebase.google.com/docs/firestore/quickstart
let db = admin.firestore(); // Todo: maybe needed to exported ;
