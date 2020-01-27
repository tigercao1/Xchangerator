const express = require('express');
const router = express.Router();
const {getLatest} = require('../dataFetch');
const customLogger = require('../logger');
const logger = customLogger('appserver');

router.get('/', function(req, res, next) {
  res.status(405).send('Method Not Allowed');
});

/* GET latest exchange rates */
// todo: using redis
router.get('/latest', async function(req, res, next) {
  try {
    const rates = await getLatest();
    res.json(rates.body);
  } catch (e) {
    logger.error(e.stack);
    res.status(502).json({errorCode: 502});
  }
});

module.exports = router;
