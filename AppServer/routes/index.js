var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
  res.send('Dev only! This path should be handled by Nginx in production.');
});

module.exports = router;
