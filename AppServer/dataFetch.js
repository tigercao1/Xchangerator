const request = require('superagent');
const constants = require('./constants/query');
const errorConsts = require('./constants/error');
const emojiConsts = require('./constants/emoji');
const currencyConsts = require('./constants/currencies');
const customLogger = require('./logger');
const logger = customLogger('appserver:dataFetch');
const debug = require('debug')('appserver:dataFetch');

const API_KEY = process.env.API_KEY || void 0;

const getLatest = async () => {
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
            `[getLatest] retry error: ${err} ${JSON.stringify(res, null, 2)}`,
          );
        }
      });
    debug(JSON.stringify(res, null, 2));
    return res;
  } catch (e) {
    throw Error(e);
  }
};

const getHybridLatest = async () => {
  const res = await getLatest();

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

module.exports = { getLatest, getHybridLatest };
