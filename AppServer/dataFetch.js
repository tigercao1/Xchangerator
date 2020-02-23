const request = require('superagent');
const constants = require('./constants/query');
const errorConsts = require('./constants/error');
const emojiConsts = require('./constants/emoji');
const currencyConsts = require('./constants/currency');
const customLogger = require('./logger');
const logger = customLogger('appserver:dataFetch');
const debug = require('debug')('appserver:dataFetch');
const { setexRawLatest } = require('./cacheUtil');

const API_KEY = process.env.API_KEY || void 0;

const getRawLatest = async () => {
  if (!API_KEY) {
    throw new ReferenceError(errorConsts.EMPTY_API_KEY);
  }
  try {
    const res = await request
      .get(constants.RATES_URL_LATEST)
      .query({ app_id: API_KEY })
      .retry(3, (err, res) => {
        if (err) {
          logger.error(
            `[getRawLatest] retry error: ${err} ${JSON.stringify(
              res,
              null,
              2,
            )}`,
          );
        }
      });
    debug(JSON.stringify(res, null, 2));
    return res;
  } catch (e) {
    throw e;
  }
};

/**
 * Fetch latest raw data, store to redis
 * then compute and return hydrated data
 *
 * @returns Object hydrated data
 */
const getHydratedLatest = async () => {
  const res = await getRawLatest();

  await setexRawLatest(res.body);

  const { timestamp, base, rates } = res.body;
  const countries = [];

  for (const code in rates) {
    if (rates.hasOwnProperty(code)) {
      const country = {
        unit: code,
        rate: rates[code],
        flag: emojiConsts[code],
        name: currencyConsts[code],
      };
      countries.push(country);
    }
  }

  return {
    timestamp,
    base,
    countries,
  };
};

module.exports = { getRawLatest, getHydratedLatest };
