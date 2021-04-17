var express = require('express');
var db = require('../database/db');
var router = express.Router();

/* GET home page. */
router.get('/', async function(req, res) {
  const rows = await db.query(`SELECT * FROM ddcharacter;`);

  var characterlist = new Array();

  for (c of rows) {
    // validate that no attributes go above 20
    // Don't add attributes to characters if they would go above 20

    var statrows = await db.query(`CALL calc_character_stats(?);`, [c.character_id]);
    statrows = statrows[0][0];
    console.log(statrows);

    var str_new = statrows.str;
    var dex_new = statrows.dex;
    var con_new = statrows.con;
    var wis_new = statrows.wis;
    var int_new = statrows.int;
    var cha_new = statrows.cha;

    var options1 = new Array();
    var options2 = new Array();

    str_new++;
    if (str_new <= 20) {
      options1.push("Strength");
    }
    dex_new++;
    if (dex_new <= 20) {
      options1.push("Dexterity");
    }
    con_new++;
    if (con_new <= 20) {
      options1.push("Constitution");
    }
    wis_new++;
    if (wis_new <= 20) {
      options1.push("Wisdom");
    }
    int_new++;
    if (int_new <= 20) {
      options1.push("Intelligence");
    }
    cha_new++;
    if (cha_new <= 20) {
      options1.push("Charisma");
    }

    str_new++;
    if (str_new <= 20) {
      options2.push("Strength");
    }
    dex_new++;
    if (dex_new <= 20) {
      options2.push("Dexterity");
    }
    con_new++;
    if (con_new <= 20) {
      options2.push("Constitution");
    }
    wis_new++;
    if (wis_new <= 20) {
      options2.push("Wisdom");
    }
    int_new++;
    if (int_new <= 20) {
      options2.push("Intelligence");
    }
    cha_new++;
    if (cha_new <= 20) {
      options2.push("Charisma");
    }

    c.options1 = options1;
    c.options2 = options2;
    characterlist.push(c);
  }

  console.log(characterlist);

  res.render('home', 
  { 
    "characterlist": characterlist,
    title: 'D&D Character Leveling Tool' 
  });
});

/* GET character page. */
router.get('/character/:cid', async function(req, res) {
  const cid = req.params.cid;
  const rows = await db.query(`SELECT * FROM ddcharacter dd JOIN race rr ON dd.race_name = rr.race_name JOIN class cc ON dd.class_name = cc.class_name JOIN background bb ON dd.bg_name = bb.bg_name WHERE character_id = ?;`, [cid]);
  console.log(rows[0]);
  const statrows = await db.query(`CALL calc_character_stats(?);`, [cid]);
  console.log(statrows[0][0]);
  const sthrowrows = await db.query(`SELECT stat from ddcharacter dd JOIN classSavingThrow st ON dd.class_name = st.class_name WHERE dd.character_id = ?;`, [cid]);
  console.log(sthrowrows);
  const hprows = await db.query(`CALL calc_hp(?);`, [cid]);
  console.log(hprows[0][0]);
  const allskills = await db.query(`SELECT skill_name, stat FROM skill`);
  console.log(allskills);
  const skillrows = await db.query(`SELECT skill_name, stat FROM characterToSkill JOIN skill USING(skill_name) WHERE character_id = ?;`, [cid]);
  console.log(skillrows);
  console.log(skillrows[0]);
  res.render('characterinfo', 
  { 
    "character": rows[0],
    "stats": statrows[0][0],
    "savingthrows": sthrowrows,
    "hp_stats": hprows[0][0],
    "allskills": allskills,
    "skills": skillrows,
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
