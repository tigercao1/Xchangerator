const path = require('path');
const { get } = require('lodash');
const fbCollectionConst = require('./constants/fbCollection');
const fbFieldConst = require('./constants/fbField');
const debug = require('debug')('appserver:firestore');
const customLogger = require('./logger');
const logger = customLogger('appserver:firestore');
const { getRawLatest } = require('./cacheUtil');

const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: 'https://xchangerator.firebaseio.com',
});

const db = admin.firestore();

const getAllDocsFactory = collectionPath => {
  return async db => {
    let docQuery = db.collection(collectionPath);
    try {
      let docQuerySnapshot = await docQuery.get();
      return docQuerySnapshot;
    } catch (e) {
      throw e;
    }
  };
};

const getUsers = getAllDocsFactory(fbCollectionConst.users);

const computeRate = async (from, to) => {
  const dataString = await getRawLatest();
  const { rates } = JSON.parse(dataString);
  const toRate = rates[to];
  const fromRate = rates[from];
  if (toRate && fromRate) {
    return toRate / fromRate;
  }
  return void 0;
};

const isTriggeredNotification = async ({
  from,
  to,
  relation,
  target,
  disabled,
}) => {
  const currentRate = await computeRate(from, to);
  if (currentRate) {
    debug(`currentRate + ${currentRate}`);
    if (!disabled) {
      switch (relation) {
        case 'GT':
          return target < currentRate;
        case 'LT':
          return target > currentRate;
      }
    }
  }
  return false;
};

const getTriggeredData = async (db, getUsers) => {
  try {
    const triggeredDataArr = [];
    let usersDocSnapshot = await getUsers(db);
    for (let userDocSnapshot of usersDocSnapshot.docs) {
      const deviceTokens = get(
        userDocSnapshot.data(),
        fbFieldConst.deviceTokens,
      );

      if (deviceTokens) {
        const notificationsSnapshot = await getSubcollection({
          db,
          docSnapshotPath: userDocSnapshot.ref.path,
          subCollectionName: fbCollectionConst.notifications,
        });

        const notificationDocs = notificationsSnapshot.docs;
        for (let doc of notificationDocs) {
          const { target, condition, disabled } = doc.data();
          const conditionArr = condition.split('-');
          const [from, to, relation] = conditionArr;
          if (
            await isTriggeredNotification({
              from,
              to,
              relation,
              target,
              disabled,
            })
          ) {
            triggeredDataArr.push({ deviceTokens, from, to, relation, target });
          }
        }
      } else {
        logger.error(
          `${userDocSnapshot.ref.path} ${fbFieldConst.deviceTokens} is not undefined`,
        );
      }
    }
    return triggeredDataArr;
  } catch (e) {
    throw e;
  }
};

/**
 * Get the specified subcollection querySnapshot of a document
 * @param db
 * @param docSnapshotPath
 * @param subCollectionName
 * @returns {Promise<QuerySnapshot<T>>} subColQuerySnapshot
 */
const getSubcollection = async ({ db, docSnapshotPath, subCollectionName }) => {
  let subColQuery = db.collection(
    path.join(docSnapshotPath, subCollectionName),
  );
  const subColQuerySnapshot = await subColQuery.get();
  return subColQuerySnapshot;
};

module.exports = { db, getUsers, getTriggeredData };
