var express = require('express');
var db = require('../database/db');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

/* GET Hello World page. */
router.get('/helloworld', function(req, res, next) {
  res.render('helloworld', { title: 'Hello World!' });
});

/* GET race list page */
router.get('/racelist', async function(req, res) {
    const rows = await db.query(`SELECT * FROM race;`, []);
    console.log(rows);
    res.render('racelist', {
      "racelist" : rows,
      "title" : "Races"
    });
});

module.exports = router;
