const express = require('express');
const router = express.Router();
const { getHydratedLatest } = require('../dataFetch');
const customLogger = require('../logger');
const logger = customLogger('appserver');
const { checkLatestMid, setexHydratedLatest } = require('../cacheUtil');
const cacheControlConst = require('../constants/cacheControl');

router.get('/', function(req, res, next) {
  res.status(405).send('Method Not Allowed');
});

/**
 * Read data from redis if it exists, otherwise, make a getHydratedLatest request
 * and update redis key store
 */
router.get('/latest', checkLatestMid, async function(req, res, next) {
  try {
    // fetch latest rates
    logger.info('no redis cache found, start fetching latest rates');
    const data = await getHydratedLatest();

    // write to redis
    await setexHydratedLatest(data);

    res.set('Cache-Control', cacheControlConst.LATEST);
    res.json(data);
  } catch (e) {
    logger.error(e.stack);
    res.status(502).json({ errorCode: 502 });
  }
});

module.exports = router;
