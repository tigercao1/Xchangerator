const express = require('express');
const router = express.Router();
const { getLatest } = require('../dataFetch');
const customLogger = require('../logger');
const logger = customLogger('appserver');
const { checkLatest, setexLatest } = require('../cacheUtil');

router.get('/', function(req, res, next) {
  res.status(405).send('Method Not Allowed');
});

/**
 * Read data from redis if it exists, otherwise, make a getLatest request
 * and update redis key store
 */
router.get('/latest', checkLatest, async function(req, res, next) {
  try {
    // fetch latest rates
    logger.info('no redis cache found, start fetching latest rates');
    const rates = await getLatest();

    // write to redis
    await setexLatest(rates.body);

    res.json(rates.body);
  } catch (e) {
    logger.error(e.stack);
    res.status(502).json({ errorCode: 502 });
  }
});

module.exports = router;
