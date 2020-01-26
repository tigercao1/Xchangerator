const createError = require('http-errors');
const express = require('express');
const helmet = require('helmet');
const morgan = require('morgan');

const customLogger = require('./logger');
const logger = customLogger('appserver');

const indexRouter = require('./routes/index');
const apiRouter = require('./routes/api');

const app = express();

app.use(
  helmet({
    frameguard: false,
    hsts: false,
    noSniff: false,
    xssFilter: false,
  }),
);

if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
}

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use('/', indexRouter);
app.use('/api', apiRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  logger.log('error', `Error code ${err.status}`);
  res.status(err.status || 500);
  res.end('Error');
});

module.exports = app;
