var express = require('express');
var db = require('../database/db');
var router = express.Router();

/* GET home page. */
router.get('/', async function(req, res) {
  try {
    const rows = await db.query(`SELECT * FROM ddcharacter;`).catch( error => { console.error(error) });

    var characterlist = new Array();
  
    for (c of rows) {
      // validate that no attributes go above 20
      // Don't add attributes to characters if they would go above 20
  
      var statrows = await db.query(`CALL calc_character_stats(?);`, [c.character_id]).catch( error => { console.error(error) });
      statrows = statrows[0][0];
      // console.log(statrows);
  
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
  
    // console.log(characterlist);
  
    res.render('home', 
    { 
      "characterlist": characterlist,
      title: 'D&D Character Leveling Tool' 
    });
  } catch (err) {
    res.status(500).json({message: err.message});
  }
  
});

/* GET character page. */
router.get('/character/:cid', async function(req, res) {
  try {
    const cid = req.params.cid;
    const rows = await db.query(`SELECT * FROM ddcharacter dd JOIN race rr ON dd.race_name = rr.race_name JOIN class cc ON dd.class_name = cc.class_name JOIN background bb ON dd.bg_name = bb.bg_name WHERE character_id = ?;`, [cid]).catch( error => { console.error(error) });
    // console.log(rows[0]);
    const statrows = await db.query(`CALL calc_character_stats(?);`, [cid]);
    // console.log(statrows[0][0]);
    const sthrowrows = await db.query(`SELECT stat from ddcharacter dd JOIN classSavingThrow st ON dd.class_name = st.class_name WHERE dd.character_id = ?;`, [cid]).catch( error => { console.error(error) });
    // console.log(sthrowrows);
    const hprows = await db.query(`CALL calc_hp(?);`, [cid]).catch( error => { console.error(error) });
    // console.log(hprows[0][0]);
    const allskills = await db.query(`SELECT skill_name, stat FROM skill`).catch( error => { console.error(error) });
    // console.log(allskills);
    const skillrows = await db.query(`SELECT skill_name, stat FROM characterToSkill JOIN skill USING(skill_name) WHERE character_id = ?;`, [cid]).catch( error => { console.error(error) });
    // console.log(skillrows);
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
  } catch (err) {
    res.status(500).json({message: err.message});
  }
});

/* GET character edit page. */
router.get('/character/:cid/edit', async function(req, res) {
  try {
    const cid = req.params.cid;
    const rows = await db.query(`SELECT * FROM ddcharacter dd JOIN race rr ON dd.race_name = rr.race_name JOIN class cc ON dd.class_name = cc.class_name JOIN background bb ON dd.bg_name = bb.bg_name WHERE character_id = ?;`, [cid]).catch( error => { console.error(error) });
    // console.log(rows[0]);
    const statrows = await db.query(`CALL calc_character_stats(?)`, [cid]).catch( error => { console.error(error) });
    // console.log(statrows[0][0]);
    res.render('characteredit', 
    { 
      "character": rows[0],
      "stats": statrows[0][0],
      title: rows[0].character_name 
    });
  } catch (err) {
    res.status(500).json({message: err.message});
  }
});

/* GET character create page. */
router.get('/charactercreate', async function(req, res) {
  try {
    const racestatrows = await db.query("SELECT rr.race_name AS race_name, stat, amount FROM race rr JOIN racialstatchange sc ON rr.race_name = sc.race_name;").catch( error => { console.error(error) });
    // console.log(racestatrows);
    const racesrows = await db.query("SELECT * FROM race;").catch( error => { console.error(error) });
    // console.log(racesrows);
    const classrows = await db.query("SELECT * FROM class;").catch( error => { console.error(error) });
    //console.log(classrows);
    const backgroundrows = await db.query("SELECT * FROM background;").catch( error => { console.error(error) });
    //console.log(backgroundrows);
    const backgroundskillrows = await db.query("SELECT bb.bg_name, skill_name FROM background bb JOIN backgroundtoskill bs ON bb.bg_name = bs.bg_name;").catch( error => { console.error(error) });
    // console.log(backgroundskillrows);
    const classskillrows = await db.query("SELECT cc.class_name, skill_name FROM class cc JOIN classtoskill cs ON cc.class_name = cs.class_name;").catch( error => { console.error(error) });
    // console.log(classskillrows);
    const raceskillrows = await db.query("SELECT rr.race_name, skill_name FROM race rr JOIN racetoskill rs ON rr.race_name = rs.race_name;").catch( error => { console.error(error) });
    // console.log(raceskillrows);
    const deityrows = await db.query("SELECT * FROM deity;").catch( error => { console.error(error) });
    //console.log(deityrows);
    res.render('charactercreate', 
    { 
      "races": racesrows,
      "racestats": racestatrows,
      "classes": classrows,
      "backgrounds": backgroundrows,
      "bgskills": backgroundskillrows,
      "classskills": classskillrows,
      "raceskills" : raceskillrows,
      "deities": deityrows,
      title: 'Create New Character'
    });
  } catch (err) {
    res.status(500).json({message: err.message});
  }
});

/* GET race list page */
router.get('/racelist', async function(req, res) {
  try {
    const rows = await db.query(`SELECT * FROM race;`, []).catch( error => { console.error(error) });
    // console.log(rows);
    res.render('racelist', {
      "racelist" : rows,
      "title" : "Races"
    });
  } catch (err) {
    res.status(500).json({message: err.message});
  }
});

router.post('/charactercreate', async function(req, res) {
  try {
  // console.log("Processing POST /charactercreate");
    // console.log(req.body);
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
    // console.log("PARSED ARRAY");
    // console.log(racestatsarray);

    // handle racial stat increases
    if (typeof formcharacter.race_option_1 != 'undefined') {
      racestatsarray.push({race_name: formcharacter.race_name, stat: formcharacter.race_option_1, amount: 1});
    }
    if (typeof formcharacter.race_option_2 != 'undefined') {
      racestatsarray.push({race_name: formcharacter.race_name, stat: formcharacter.race_option_2, amount: 1});
    }
    // console.log(racestatsarray);

    const result = await db.query("CALL insert_char(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
    [formcharacter.character_name, formcharacter.race_name, formcharacter.class_name, formcharacter.bg_name, 1, formcharacter.base_str, formcharacter.base_dex, formcharacter.base_con, formcharacter.base_int, formcharacter.base_wis, formcharacter.base_cha, formcharacter.alignment, 2, formcharacter.deity_id, formcharacter.sex, formcharacter.height, formcharacter.weight, formcharacter.eyes, formcharacter.skin, null]).catch( error => { console.error(error) });
    
    // console.log(result);

    var statchanges = '';
    for (statchange of racestatsarray) {
      statchanges += `(${result.insertId}, "${statchange.stat}", ${statchange.amount}, "Race"),`;
    }
    if (statchanges.slice(-1) === ",") {
      statchanges = statchanges.substring(0, statchanges.length - 1);
    }

    // console.log(statchanges);
    const stat_result = await db.query(`INSERT INTO statchange (character_id, stat, amount, origin) VALUES ${statchanges}`).catch( error => { console.error(error) }).catch( error => { console.error(error) });
    
    var skills = JSON.parse(formcharacter.skills);
    // console.log("Skills");
    // console.log(skills);
    // console.log(skills[0]);
    var skillchanges = '';
    for (ss of skills) {
      skillchanges += `(${result.insertId}, "${ss.skill_name}", "${ss.origin}"),`;
    }
    if (skillchanges.slice(-1) === ",") {
      skillchanges = skillchanges.substring(0, skillchanges.length - 1);
    }
    // console.log(skillchanges);
    const skill_result = await db.query(`INSERT INTO charactertoskill (character_id, skill_name, origin) VALUES ${skillchanges}`).catch( error => { console.error(error) });
    
    res.redirect('/');
  } catch (err) {
    res.status(500).json({message: err.message});
  }
});


router.post('/levelup', async function(req, res) {
  try {
    // console.log("Processing POST /levelup");
    // console.log("leveling up character with cid: " + req.body.cid);
    // console.log("increasing attributes: " + req.body.attribute1 + " and " + req.body.attribute2);
    var attribute1 = (typeof req.body.attribute1 === 'undefined') ? null : req.body.attribute1;
    var attribute2 = (typeof req.body.attribute2 === 'undefined') ? null : req.body.attribute2;

    const levelup_response = await db.query("CALL level_up(?, ?, ?);", [req.body.cid, attribute1, attribute2]).catch( error => { console.error(error) });
    // console.log(levelup_response);
    res.redirect('/');
  } catch (err) {
    res.status(500).json({message: err.message});
  }
});

router.post('/character/:cid/delete', async function(req, res) {
  try {
    const result = await db.query("CALL delete_char(?);", [req.params.cid]).catch( error => { console.error(error) });
    res.redirect('/');
  } catch (err) {
    res.status(500).json({message: err.message});
  }
});

module.exports = router;
