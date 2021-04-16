var express = require('express');
var db = require('../database/db');
var router = express.Router();

/* GET home page. */
router.get('/', async function(req, res) {
  const rows = await db.query(`SELECT * FROM ddcharacter;`);
  console.log(rows);
  res.render('home', 
  { 
    "characterlist": rows,
    title: 'D&D Character Leveling Tool' 
  });
});

/* GET character page. */
router.get('/character/:cid', async function(req, res) {
  const cid = req.params.cid;
  const rows = await db.query(`SELECT * FROM ddcharacter dd JOIN race rr ON dd.race_name = rr.race_name JOIN class cc ON dd.class_name = cc.class_name JOIN background bb ON dd.bg_name = bb.bg_name WHERE character_id = ?;`, [cid]);
  console.log(rows[0]);
  const statrows = await db.query(`CALL calc_character_stats(?)`, [cid]);
  console.log(statrows[0][0]);
  const sthrowrows = await db.query(`SELECT stat from ddcharacter dd JOIN classSavingThrow st ON dd.class_name = st.class_name WHERE dd.character_id = ?;`, [cid]);
  console.log(sthrowrows);
  res.render('characterinfo', 
  { 
    "character": rows[0],
    "stats": statrows[0][0],
    "savingthrows": sthrowrows,
    title: rows[0].character_name 
  });
});

/* GET character edit page. */
router.get('/character/:cid/edit', async function(req, res) {
  const cid = req.params.cid;
  const rows = await db.query(`SELECT * FROM ddcharacter dd JOIN race rr ON dd.race_name = rr.race_name JOIN class cc ON dd.class_name = cc.class_name JOIN background bb ON dd.bg_name = bb.bg_name WHERE character_id = ?;`, [cid]);
  console.log(rows[0]);
  const statrows = await db.query(`CALL calc_character_stats(?)`, [cid]);
  console.log(statrows[0][0]);
  res.render('characteredit', 
  { 
    "character": rows[0],
    "stats": statrows[0][0],
    title: rows[0].character_name 
  });
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

router.post('/testform', async function(req, res) {
  console.log("Processing POST /testform");
  console.log(req.body.field1);
  res.redirect('/');
});


// TODO: make it so that you can't increase an attribute beyond 20.
router.post('/levelup', async function(req, res) {
  console.log("Processing POST /levelup");
  console.log("leveling up character with cid: " + req.body.cid);
  console.log("increasing attributes: " + req.body.attribute1 + " and " + req.body.attribute2);
  var attribute1 = (typeof req.body.attribute1 === 'undefined') ? null : req.body.attribute1;
  var attribute2 = (typeof req.body.attribute2 === 'undefined') ? null : req.body.attribute2;
  const levelup_response = await db.query("CALL level_up(?, ?, ?);", [req.body.cid, attribute1, attribute2]);
  console.log(levelup_response);
  res.redirect('/');
});

module.exports = router;
