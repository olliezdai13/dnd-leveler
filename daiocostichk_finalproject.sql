/* Logical Design of D&D Character Manager
 * Draft 1
 * Oliver Dai and Kenneth Costich
 * CS3200 Final Project
 */
 
 /* COMMENTS WHILE DERIVING LOGICAL DESIGN FROM CONCEPTUAL DESIGN
  * - check comment above background table
  * - check comment above backgroundToSkill table
  * - LD has been made with these comments in mind, rather than according to CD (CD needs editing):
  * 	- CD says 1 character has 1 background...should be 0..* characters have 1 background?
  * 	- similarly, CD says 1 character has 1 class
  *
  * -have yet to add all relationships or the StatChange entity
  */
 
 DROP DATABASE IF EXISTS ddCharacterManager;
 
 CREATE DATABASE ddCharacterManager;
 
 USE ddCharacterManager;
 
 CREATE TABLE skill 
 (
	skill_name VARCHAR(255) PRIMARY KEY,
    stat ENUM('Strength', 'Dexterity', 'Constitution', 'Intelligence', 'Wisdom', 'Charisma') NOT NULL,
    description TEXT NOT NULL
 );
 
 CREATE TABLE race 
 (
	race_name VARCHAR(255) PRIMARY KEY,
    speed INT NOT NULL,
    size INT NOT NULL,
    description TEXT NOT NULL
 );
 
 CREATE TABLE racialStatChange 
 (
	rsc_id INT PRIMARY KEY AUTO_INCREMENT,
    stat ENUM('Strength', 'Dexterity', 'Constitution', 'Intelligence', 'Wisdom', 'Charisma') NOT NULL,
    amount INT NOT NULL,
    race_name VARCHAR(255) NOT NULL,
    FOREIGN KEY (race_name) REFERENCES race(race_name) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 CREATE TABLE class 
 (
	class_name VARCHAR(255) PRIMARY KEY,
    hit_dice INT NOT NULL,
    hp_base INT NOT NULL,
    hp_increment INT NOT NULL,
    num_skills INT NOT NULL,
    description TEXT NOT NULL
 );
 
 CREATE TABLE classSavingThrow 
 (
	id INT PRIMARY KEY AUTO_INCREMENT,
    stat ENUM('Strength', 'Dexterity', 'Constitution', 'Intelligence', 'Wisdom', 'Charisma') NOT NULL,
    class_name VARCHAR(255) NOT NULL,
    FOREIGN KEY (class_name) REFERENCES class(class_name) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 -- is there any reason to have the PK as an INT? class and race has PK as VARCHAR representing their names
 CREATE TABLE background 
 (
	bg_id INT PRIMARY KEY,
    bg_name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL
 );
 
 CREATE TABLE ddCharacter 
 (
	character_id INT PRIMARY KEY,
    character_name VARCHAR(255) NOT NULL,
    level INT NOT NULL,
    str_score INT NOT NULL,
    dex_score INT NOT NULL,
    con_score INT NOT NULL,
    int_score INT NOT NULL,
    wis_score INT NOT NULL,
    cha_score INT NOT NULL,
    alignment ENUM('Lawful good', 'Neutral good', 'Chaotic good',
				   'Lawful neutral', 'Neutral', 'Chaotic neutral',
                   'Lawful evil', 'Neutral evil', 'Chaotic evil') NOT NULL,
	proficiency_bonus INT NOT NULL,
    deity ENUM('Auril, Goddess of Winter',
			   'Azuth, God of Wizards',
               'Bane, God of Tyranny',
               'Beshaba, Goddess of Misfortune',
               'Bhaal, God of Murder',
               'Chauntea, Goddess of Agriculture',
               'Cyric, God of Lies',
               'Deneir, God of Writing',
               'Eldath, Goddess of Peace',
               'Gond, God of Craft',
               'Helm, God of Protection',
               'Ilmater, God of Endurance',
               'Kelemvor, God of the Dead',
               'Lathander, God of Birth and Renewal',
               'Leira, Goddess of Illusion',
               'Lliira, Goddess of Joy',
               'Loviatar, Goddess of Pain',
               'Malar, God of the Hunt',
               'Mask, God of Thieves',
               'Mielikki, Goddess of Forests',
               'Milil, God of Poetry and Song',
               'Myrkul, God of Death',
               'Mystra, Goddess of Magic',
               'Oghma, God of Knowledge',
               'Savras, God of Divination and Fate',
               'Selûne, Goddess of the Moon',
               'Shar, Goddess of Darkness and Loss',
               'Silvanus, God of Wild Nature',
               'Sune, Goddess of Love and Beauty',
               'Talona, Goddess of Disease and Poison',
               'Talos, God of Storms',
               'Tempus, God of War',
               'Torm, God of Courage and Self-Sacrifice',
               'Tymora, Goddess of Good Fortune',
               'Tyr, God of Justice',
               'Umberlee, Goddess of the Sea',
               'Waukeen, Goddess of Trade',
               'Bahamut, Dragon God of Good',
               'Blibdoolpoolp, Kuo-toa Goddess',
               'Corellon Larenthian, Elf Deity of Art and Magic',
               'Deep Sashelas, Elf God of the Sea',
               'Eadro, Merfolk Deity of the Sea',
               'Garl Glittergold, Gnome God of Trickery and Wiles',
               'Grolantor, Hill Giant God of War',
               'Gruumsh, Orc God of Storms and War',
               'Hruggek, Bugbear God of Violence',
               'Kurtulmak, Kobold God of War and Mining',
               'Laogzed, Troglodyte God of Hunger',
               'Lolth, Drow Goddess of Spiders',
               'Maglubiyet, Goblinoid God of War',
               'Moradin, Dwarf God of Creation',
               'Rillifane Rallathil, Wood Elf God of Nature',
               'Sehanine Moonbow, Elf Goddess of the Moon',
               'Sekolah, Sahuagin God of the Hunt',
               'Semuanya, Lizardfolk Deity of Survival',
               'Skerrit, Centaur and Satyr God of Nature',
               'Skoraeus Stonebones, God of Stone Giants and Art',
               'Surtur, God of Fire Giants and Craft',
               'Thrym, God of Frost Giants and Strength',
               'Tiamat, Dragon Goddess of Evil',
               'Yondalla, Halfling Goddess of Fertility and Protection') NOT NULL,
	sex ENUM('Male', 'Female','None', 'Other') NOT NULL,
    height INT NOT NULL,
    weight INT NOT NULL,
    eyes ENUM('Blue', 'Brown', 'Green', 'Yellow', 'Red', 'Black'),
    skin ENUM('Caucasian', 'Blue', 'Brown', 'Green', 'Yellow', 'Red', 'Black'),
    portraitPath VARCHAR(255) NOT NULL
 );
 
 CREATE TABLE raceToSkill 
 (
	race_name VARCHAR(255) NOT NULL,
    skill_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (race_name, skill_name),
    FOREIGN KEY (race_name) REFERENCES race(race_name) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (skill_name) REFERENCES skill(skill_name) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 CREATE TABLE classToSkill 
 (
	class_name VARCHAR(255) NOT NULL,
    skill_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (class_name, skill_name),
    FOREIGN KEY (class_name) REFERENCES class(class_name) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (skill_name) REFERENCES skill(skill_name) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 -- way to enfore only 6 entries per bg_id?
 CREATE TABLE backgroundToSkill 
 (
	bg_id INT NOT NULL,
    skill_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (bg_id, skill_name),
    FOREIGN KEY (bg_id) REFERENCES background(bg_id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (skill_name) REFERENCES skill(skill_name) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 