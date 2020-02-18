const path = require('path');
const debug = require('debug')('appserver:firebase');
const customLogger = require('./logger');
const logger = customLogger('appserver:firebase');

const initDB=()=> {
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
  let db = admin.firestore();
  return db
}

//firestore node api: https://firebase.google.com/docs/firestore/quickstart

/**
 * Middlewares
 */
const getByIdFactory = (collRef) => {
  return async (db, docKey) => {
    let docRef = db.collection(collRef).doc(docKey);
    let getDoc = docRef.get()
        .then(doc => {
          if (!doc.exists) {
            debug('No such document!');
            console.log('No such document!');
          } else {
            debug(`Document data:', ${doc.data()}`);
            console.log('Document data:', doc.data());
          }
        })
        .catch(err => {
          logger.error(err.stack);
          console.log('Error getting document', err);
        });
  };
};

const getAllFactory = (collRef) => {
  return async (db) => {
    let docs = db.collection(collRef);
    let allDocs = docs.get()
        .then(snapshot => {
          snapshot.forEach(doc => {
            console.log(doc.id, '=>', doc.data());
          });
        })
        .catch(err => {
          console.log('Error getting documents', err);
        });
  }
}
const getUserById = getByIdFactory('users'); //M7H4N2GByVIQbEkP6AvZ
const getUsers = getAllFactory('users');

//
// /**
//  * Set data
//  */
//https://firebase.google.com/docs/firestore/manage-data/add-data#set_a_document
// let initialData = {
//   name: 'Frank',
//   age: 12,
//   favorites: {
//     food: 'Pizza',
//     color: 'Blue',
//     subject: 'recess'
//   }
// };
// // ...
// let updateNested = db.collection('users').doc('Frank').update({
//   age: 13,
//   'favorites.color': 'Red'
// });

//
// /**
//  * update data
//  */
// https://firebase.google.com/docs/firestore/manage-data/add-data#update-data
//let cityRef = db.collection('cities').doc('DC');
//let updateSingle = cityRef.update({capital: true});



// /**
//  * Del doc
//  */
//https://firebase.google.com/docs/firestore/manage-data/delete-data#fields

 // let deleteDoc = db.collection('cities').doc('DC').delete();

// /**
//  * Del collections
//  */
// https://firebase.google.com/docs/firestore/manage-data/delete-data#collections

// /**
//  * Del fields
//  */
// https://firebase.google.com/docs/firestore/manage-data/delete-data#fields

module.exports = { getUserById,getUsers,initDB };
