const { createLogger, transports, format } = require('winston');
const { combine, timestamp, label, printf } = format;

const myFormat = printf(({ level, message, label, timestamp }) => {
  return `${level} ${timestamp} [${label}]: ${message}`;
});

const logger = logLabel => {
  return createLogger({
    format: combine(
      format.colorize(),
      label({ label: logLabel }),
      timestamp(),
      myFormat,
    ),
    transports: [new transports.Console()],
  });
};

module.exports = logger;
