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

/* GET character create page. */
router.get('/charactercreate', async function(req, res) {
  const racestatrows = await db.query("SELECT rr.race_name AS race_name, stat, amount FROM race rr JOIN racialstatchange sc ON rr.race_name = sc.race_name;");
  console.log(racestatrows);
  const racesrows = await db.query("SELECT * FROM race;");
  console.log(racesrows);
  const classrows = await db.query("SELECT * FROM class;");
  //console.log(classrows);
  const backgroundrows = await db.query("SELECT * FROM background;");
  //console.log(backgroundrows);
  const deityrows = await db.query("SELECT * FROM deity;");
  //console.log(deityrows);
  res.render('charactercreate', 
  { 
    "races": racesrows,
    "racestats": racestatrows,
    "classes": classrows,
    "backgrounds": backgroundrows,
    "deities": deityrows,
    title: 'Create New Character'
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


router.post('/charactercreate', async function(req, res) {
  console.log("Processing POST /charactercreate");
  console.log(req.body);
  var formcharacter = req.body;

  // validate form input
  if (typeof formcharacter.height === 'undefined' || formcharacter.height === '') {
    formcharacter.height= null;
  }
  if (typeof formcharacter.weight === 'undefined' || formcharacter.weight === '') {
    formcharacter.weight = null;
  }
  if (typeof formcharacter.eyes === 'undefined' || formcharacter.eyes === '') {
    formcharacter.eyes = null;
  }
  if (typeof formcharacter.skin === 'undefined' || formcharacter.skin === '') {
    formcharacter.skin = null;
  }
  if (typeof formcharacter.deity_id === 'undefined' || formcharacter.deity_id === '') {
    formcharacter.deity_id = null;
  }


  var racestatsarray = JSON.parse(formcharacter.race_stats);
  console.log("PARSED ARRAY");
  console.log(racestatsarray);

  // handle racial stat increases
  if (typeof formcharacter.race_option_1 != 'undefined') {
    racestatsarray.push({race_name: formcharacter.race_name, stat: formcharacter.race_option_1, amount: 1});
  }
  if (typeof formcharacter.race_option_2 != 'undefined') {
    racestatsarray.push({race_name: formcharacter.race_name, stat: formcharacter.race_option_2, amount: 1});
  }
  console.log(racestatsarray);

  const result = await db.query("INSERT INTO ddcharacter (character_name, race_name, class_name, bg_name, level, str_score, dex_score, con_score, int_score, wis_score, cha_score, alignment, proficiency_bonus, deity_id, sex, height, weight, eyes, skin, portraitPath) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
  [formcharacter.character_name, formcharacter.race_name, formcharacter.class_name, formcharacter.bg_name, 1, formcharacter.base_str, formcharacter.base_dex, formcharacter.base_con, formcharacter.base_int, formcharacter.base_wis, formcharacter.base_cha, formcharacter.alignment, 2, formcharacter.deity_id, formcharacter.sex, formcharacter.height, formcharacter.weight, formcharacter.eyes, formcharacter.skin, null]);
  
  console.log(result);

  var statchanges = '';
  for (statchange of racestatsarray) {
    statchanges += `(${result.insertId}, "${statchange.stat}", ${statchange.amount}, "Race"),`;
  }
  if (statchanges.slice(-1) === ",") {
    statchanges = statchanges.substring(0, statchanges.length - 1);
  }

  console.log(statchanges);
  const stat_result = await db.query(`INSERT INTO statchange (character_id, stat, amount, origin) VALUES ${statchanges}`);
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
