const redis = require('redis');
const client = redis.createClient();
const { promisify } = require('util');
const getAsync = promisify(client.get).bind(client);
const setexAsync = promisify(client.setex).bind(client);

const customLogger = require('./logger');
const logger = customLogger('appserver:cacheUtil');

const debug = require('debug')('appserver:cacheUtil');

const cacheControlConst = require('./constants/cacheControl');

/**
 * Middlewares
 */
const getFactory = (key, cacheResponseDirective) => {
  return async (req, res, next) => {
    try {
      const data = await getAsync(key);
      if (data !== null) {
        debug(`Cache exists, responding immediately ${JSON.stringify(data)}`);
        res.set('Cache-Control', cacheResponseDirective);
        res.json(JSON.parse(data));
      } else {
        next();
      }
    } catch (e) {
      logger.error(e.stack);
      res.status(502).json({ errorCode: 502 });
    }
  };
};

const checkLatest = getFactory('latest', cacheControlConst.LATEST);

/**
 * Util functions
 */
const setexFactory = key => {
  return async data => {
    try {
      await setexAsync(key, 3600, JSON.stringify(data));
    } catch (e) {
      logger.error(e.stack);
    }
  };
};

const setexLatest = setexFactory('latest');

module.exports = { checkLatest, setexLatest };
