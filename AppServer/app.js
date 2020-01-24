const createError = require('http-errors');
const express = require('express');
const path = require('path');
const fs = require('fs');
const helmet = require('helmet');
const logger = require('morgan');

const indexRouter = require('./routes/index');
const apiRouter = require('./routes/api');

const app = express();

app.use(helmet());

const LOGGER_FORMAT = `:remote-addr - :remote-user [:date[iso]] ":method\
 :url HTTP/:http-version" :status :res[content-length] - :response-time ms`;

if (process.env.NODE_ENV !== 'development') {
  // create a write stream
  const accessLogStream = fs.createWriteStream(
    path.join(__dirname, 'access.log'),
    {
      flags: 'a', // append mode
    },
  );
  app.use(logger(LOGGER_FORMAT, { stream: accessLogStream }));
} else {
  app.use(logger('dev'));
}

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));

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
  res.status(err.status || 500);
  res.send('Internal Server Error');
});

module.exports = app;
