 /* Logical Design of D&D Character Manager
 * Draft 2
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
    stat ENUM('Strength', 'Dexterity', 'Constitution', 'Intelligence', 'Wisdom', 'Charisma', 'AnyOther1', 'AnyOther2') NOT NULL,
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
	bg_name VARCHAR(255) PRIMARY KEY,
    description TEXT NOT NULL
 );
 
 CREATE TABLE deity 
 (
	deity_id INT PRIMARY KEY AUTO_INCREMENT,
    deity_name VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    alignment ENUM('Lawful good', 'Neutral good', 'Chaotic good',
				   'Lawful neutral', 'Neutral', 'Chaotic neutral',
                   'Lawful evil', 'Neutral evil', 'Chaotic evil') NOT NULL
 );
 
 CREATE TABLE ddCharacter 
 (
	character_id INT PRIMARY KEY,
    character_name VARCHAR(255) NOT NULL,
    race_name VARCHAR(255) NOT NULL,
    class_name VARCHAR(255) NOT NULL,
    bg_name VARCHAR(255) NOT NULL,
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
    deity_id INT,
	sex ENUM('Male', 'Female', 'None', 'Other') NOT NULL,
    height INT NOT NULL,
    weight INT NOT NULL,
    eyes ENUM('Blue', 'Brown', 'Green', 'Yellow', 'Red', 'Black'),
    skin ENUM('Light', 'Blue', 'Brown', 'Green', 'Yellow', 'Red', 'Black'),
    portraitPath VARCHAR(255) NOT NULL,
    FOREIGN KEY (race_name) REFERENCES race(race_name) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (class_name) REFERENCES class(class_name) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (bg_name) REFERENCES background(bg_name) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (deity_id) REFERENCES deity(deity_id) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 CREATE TABLE statChange 
 (
	id INT PRIMARY KEY AUTO_INCREMENT,
    character_id INT NOT NULL,
    stat ENUM('Strength', 'Dexterity', 'Constitution', 'Intelligence', 'Wisdom', 'Charisma') NOT NULL,
    origin VARCHAR(255) NOT NULL,
    FOREIGN KEY (character_id) REFERENCES ddCharacter(character_id) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 CREATE TABLE characterToSkill 
 (
	character_id INT NOT NULL,
    skill_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (character_id, skill_name),
    FOREIGN KEY (character_id) REFERENCES ddCharacter(character_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (skill_name) REFERENCES skill(skill_name) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 CREATE TABLE raceToSkill 
 (
	race_name VARCHAR(255) NOT NULL,
    skill_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (race_name, skill_name),
    FOREIGN KEY (race_name) REFERENCES race(race_name) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 CREATE TABLE classToSkill 
 (
	class_name VARCHAR(255) NOT NULL,
    skill_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (class_name, skill_name),
    FOREIGN KEY (class_name) REFERENCES class(class_name) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (skill_name) REFERENCES skill(skill_name) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 CREATE TABLE characterToStatChange 
 (
	character_id INT NOT NULL,
    statChange_id INT NOT NULL,
    PRIMARY KEY (character_id, statChange_id),
    FOREIGN KEY (character_id) REFERENCES ddCharacter(character_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (statChange_id) REFERENCES statChange(id) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 CREATE TABLE backgroundToSkill 
 (
	bg_name VARCHAR(255) NOT NULL,
    skill_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (bg_name, skill_name),
    FOREIGN KEY (bg_name) REFERENCES background(bg_name) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (skill_name) REFERENCES skill(skill_name) ON UPDATE RESTRICT ON DELETE RESTRICT
 );
 
 -- INSERT DATA
 
INSERT INTO deity VALUES (1, 'Auril', 'Goddess of Winter', 'Neutral evil'),
						 (2, 'Azuth', 'God of Wizards', 'Lawful neutral'),
						 (3, 'Bane', 'God of Tyranny', 'Lawful evil'),
						 (4, 'Beshaba', 'Goddess of Misfortune', 'Chaotic evil'),
						 (5, 'Bhaal', 'God of Murder', 'Neutral evil'),
						 (6, 'Chauntea', 'Goddess of Agriculture', 'Neutral good'),
						 (7, 'Cyric', 'God of Lies', 'Chaotic evil'),
						 (8, 'Deneir', 'God of Writing', 'Neutral good'),
						 (9, 'Eldath', 'Goddess of Peace', 'Neutral good'),
						 (10, 'Gond', 'God of Craft', 'Neutral'),
						 (11, 'Helm', 'God of Protection', 'Lawful neutral'),
						 (12, 'Ilmater', 'God of Endurance', 'Lawful good'),
						 (13, 'Kelemvor', 'God of the Dead', 'Lawful neutral'),
						 (14, 'Lathander', 'God of Birth and Renewal', 'Neutral good'),
						 (15, 'Leira', 'Goddess of Illusion', 'Chaotic neutral'),
						 (16, 'Lliira', 'Goddess of Joy', 'Chaotic good'),
						 (17, 'Loviatar', 'Goddess of Pain', 'Lawful evil'),
						 (18, 'Malar', 'God of the Hunt', 'Chaotic evil'),
						 (19, 'Mask', 'God of Thieves', 'Chaotic neutral'),
						 (20, 'Mielikki', 'Goddess of Forests', 'Neutral good'),
						 (21, 'Milil', 'God of Poetry and Song', 'Neutral good'),
						 (22, 'Myrkul', 'God of Death', 'Neutral evil'),
						 (23, 'Mystra', 'Goddess of Magic', 'Neutral good'),
						 (24, 'Oghma', 'God of Knowledge', 'Neutral'),
						 (25, 'Savras', 'God of Divination and Fate', 'Lawful neutral'),
						 (26, 'Selûne', 'Goddess of the Moon', 'Chaotic good'),
						 (27, 'Shar', 'Goddess of Darkness and Loss', 'Neutral evil'),
						 (28, 'Silvanus', 'God of Wild Nature', 'Neutral'),
						 (29, 'Sune', 'Goddess of Love and Beauty', 'Chaotic good'),
						 (30, 'Talona', 'Goddess of Disease and Poison', 'Chaotic evil'),
						 (31, 'Talos', 'God of Storms', 'Chaotic evil'),
						 (32, 'Tempus', 'God of War', 'Neutral'),
						 (33, 'Torm', 'God of Courage and Self-Sacrifice', 'Lawful good'),
						 (34, 'Tymora', 'Goddess of Good Fortune', 'Chaotic good'),
						 (35, 'Tyr', 'God of Justice', 'Lawful good'),
						 (36, 'Umberlee', 'Goddess of the Sea', 'Chaotic evil'),
						 (37, 'Waukeen', 'Goddess of Trade', 'Neutral'),
						 (38, 'Bahamut', 'Dragon God of Good', 'Lawful good'),
						 (39, 'Blibdoolpoolp', 'Kuo-toa Goddess', 'Neutral evil'),
						 (40, 'Corellon Larenthian', 'Elf Deity of Art and Magic', 'Chaotic good'),
						 (41, 'Deep Sashelas', 'Elf God of the Sea', 'Chaotic good'),
						 (42, 'Eadro', 'Merfolk Deity of the Sea', 'Neutral'),
						 (43, 'Garl Glittergold', 'Gnome God of Trickery and Wiles', 'Lawful good'),
						 (44, 'Grolantor', 'Hill Giant God of War', 'Chaotic evil'),
						 (45, 'Gruumsh', 'Orc God of Storms and War', 'Chaotic evil'),
						 (46, 'Hruggek', 'Bugbear God of Violence', 'Chaotic evil'),
						 (47, 'Kurtulmak', 'Kobold God of War and Mining', 'Lawful evil'),
						 (48, 'Laogzed', 'Troglodyte God of Hunger', 'Chaotic evil'),
						 (49, 'Lolth', 'Drow Goddess of Spiders', 'Chaotic evil'),
						 (50, 'Maglubiyet', 'Goblinoid God of War', 'Lawful evil'),
						 (51, 'Moradin', 'Dwarf God of Creation', 'Lawful good'),
						 (52, 'Rillifane Rallathil', 'Wood Elf God of Nature', 'Chaotic good'),
						 (53, 'Sehanine Moonbow', 'Elf Goddess of the Moon', 'Chaotic good'),
						 (54, 'Sekolah', 'Sahuagin God of the Hunt', 'Lawful evil'),
						 (55, 'Semuanya', 'Lizardfolk Deity of Survival', 'Neutral'),
						 (56, 'Skerrit', 'Centaur and Satyr God of Nature', 'Neutral'),
						 (57, 'Skoraeus Stonebones', 'God of Stone Giants and Art', 'Neutral'),
						 (58, 'Surtur', 'God of Fire Giants and Craft', 'Lawful evil'),
						 (59, 'Thrym', 'God of Frost Giants and Strength', 'Chaotic evil'),
						 (60, 'Tiamat', 'Dragon Goddess of Evil', 'Lawful evil'),
						 (61, 'Yondalla', 'Halfling Goddess of Fertility and Protection', 'Lawful good');
                         
INSERT INTO skill VALUES ('Acrobatics', 'Dexterity', 'Acrobatics covers your attempt to stay on your feet in a tricky situation, such as when you’re trying to run across a sheet of ice, balance on a tightrope, or stay upright on a rocking ship’s deck. The GM might also call for a Acrobatics check to see if you can perform acrobatic stunts, including dives, rolls, somersaults, and flips.'),
						 ('Animal Handling', 'Wisdom', 'When there is any question whether you can calm down a domesticated animal, keep a mount from getting spooked, or intuit an animal’s intentions, the GM might call for an Animal Handling check. You also make an Animal Handling check to control your mount when you attempt a risky maneuver.'),
                         ('Arcana', 'Intelligence', 'Arcana measures your ability to recall lore about spells, magic items, eldritch symbols, magical traditions, the planes of existence, and the inhabitants of those planes.'),
                         ('Athletics', 'Strength', 'Athletics covers difficult situations you encounter while climbing, jumping, or swimming.'),
                         ('Deception', 'Charisma', 'Deception lets you convincingly hide the truth, either verbally or through your actions. This deception can encompass everything from misleading others through ambiguity to telling outright lies. Typical situations include trying to fasttalk a guard, con a merchant, earn money through gambling, pass yourself off in a disguise, dull someone’s suspicions with false assurances, or maintain a straight face while telling a blatant lie.'),
                         ('History', 'Intelligence', 'History is your ability to recall lore about historical events, legendary people, ancient kingdoms, past disputes, recent wars, and lost civilizations.'),
                         ('Insight', 'Wisdom', 'Insight is the ability to determine the true intentions of a creature, such as when searching out a lie or predicting someone’s next move. Doing so involves gleaning clues from body language, speech habits, and changes in mannerisms.'),
                         ('Intimidation', 'Charisma', 'When you attempt to influence someone through overt threats, hostile actions, and physical violence, the GM might ask you to make an Intimidation check. Examples include trying to pry information out of a prisoner, convincing street thugs to back down from a confrontation, or using the edge of a broken bottle to convince a sneering vizier to reconsider a decision.'),
                         ('Investigation', 'Intelligence', 'When you look around for clues and make deductions based on those clues, you make an Investigation check. You might deduce the location of a hidden object, discern from the appearance of a wound what kind of weapon dealt it, or determine the weakest point in a tunnel that could cause it to collapse. Poring through ancient scrolls in search of a hidden fragment of knowledge might also call for an Intelligence Investigation check.'),
                         ('Medicine', 'Wisdom', 'Medicine lets you try to stabilize a dying companion or diagnose an illness.'),
                         ('Nature', 'Intelligence', 'Nature measures your ability to recall lore about terrain, plants and animals, the weather, and natural cycles.'),
                         ('Perception', 'Wisdom', 'Your Perception lets you spot, hear, or otherwise detect the presence of something. It measures your general awareness of your surroundings and the keenness of your senses. For example, you might try to hear a conversation through a closed door, eavesdrop under an open window, or hear monsters moving stealthily in the forest. Or you might try to spot things that are obscured or easy to miss, whether they are orcs lying in ambush on a road, thugs hiding in the shadows of an alley, or candlelight under a closed secret door.'),
                         ('Performance', 'Charisma', 'Performance determines how well you can delight an audience with music, dance, acting, storytelling, or some other form of entertainment.'),
                         ('Persuasion', 'Charisma', 'When you attempt to influence someone or a group of people with tact, social graces, or good nature, the GM might ask you to make a Persuasion check. Typically, you use persuasion when acting in good faith, to foster friendships, make cordial requests, or exhibit proper etiquette. Examples of persuading others include convincing a chamberlain to let your party see the king, negotiating peace between warring tribes, or inspiring a crowd of townsfolk.'),
                         ('Religion', 'Intelligence', 'Religion measures your ability to recall lore about deities, rites and prayers, religious hierarchies, holy symbols, and the practices of secret cults.'),
                         ('Sleight of Hand', 'Dexterity', 'Whenever you attempt an act of legerdemain or manual trickery, such as planting something on someone else or concealing an object on your person, make a Sleight of Hand check. The GM might also call for a Sleight of Hand check to determine whether you can lift a coin purse off another person or slip something out of another person’s pocket.'),
                         ('Stealth', 'Dexterity', 'Make a Stealth check when you attempt to conceal yourself from enemies, slink past guards, slip away without being noticed, or sneak up on someone without being seen or heard.'),
                         ('Survival', 'Wisdom', 'The GM might ask you to make a Survival check to follow tracks, hunt wild game, guide your group through frozen wastelands, identify signs that owlbears live nearby, predict the weather, or avoid quicksand and other natural hazards.');
 
 
INSERT INTO race (race_name, description, size, speed) VALUES
	('Dragonborn', 'Dragonborn are bipedal, dragon-like creatures that originally hatched from dragon eggs. These creatures have scales, taloned claws, and long, reptilian faces that resemble their elder kin. The color of the scales resembles the dragon that they descended from, usually the ones with more vibrant scales and a particularly potent blood lineage. Dragonborn are notoriously proud beings and their clan is more important than life itself.', 3, 30),
    ('Human', 'In the reckonings of most worlds, humans are the youngest of the common races, late to arrive on the world scene and short-lived in comparison to dwarves, elves, and dragons. Perhaps it is because of their shorter lives that they strive to achieve as much as they can in the years they are given. Or maybe they feel they have something to prove to the elder races, and that\'s why they build their mighty empires on the foundation of conquest and trade. Whatever drives them, humans are the innovators, the achievers, and the pioneers of the worlds.', 3, 30),
    ('Hill Dwarf', 'As a hill dwarf, you have keen senses, deep intuition, and remarkable resilience. The gold dwarves of Faerûn in their mighty southern kingdom are hill dwarves, as are the exiled Neidar and the debased Klar of Krynn in the Dragonlance setting.', 3, 25),
	('Mountain Dwarf', 'As a mountain dwarf, you’re strong and hardy, accustomed to a difficult life in rugged terrain. You’re probably on the tall side (for a dwarf), and tend toward lighter coloration. The shield dwarves of northern Faerûn, as well as the ruling Hylar clan and the noble Daewar clan of Dragonlance, are mountain dwarves.', 3, 25),
    ('High Elf', 'High elves, also sometimes known as eladrin, were graceful warriors and wizards who originated from the realm of Faerie, also known as the Feywild. They lived in the forests of the world. They were magical in nature and shared an interest in the arcane arts. From an early age they also learned to defend themselves, particularly with swords.', 3, 30),
    ('Wood Elf', 'As a wood elf, you have keen senses and intuition, and your fleet feet carry you quickly and stealthily through your native forests. This category includes the wild elves (grugach) of Greyhawk and the Kagonesti of Dragonlance, as well as the races called wood elves in Greyhawk and the Forgotten Realms. In Faerûn, wood elves (also called wild elves, green elves, or forest elves) are reclusive and distrusting of non-elves.', 3, 35),
    ('Deep Gnome', 'Forest gnomes and rock gnomes are the gnomes most commonly encountered in the lands of the surface world. There is another subrace of gnomes rarely seen by any surface-dweller: deep gnomes, also known as svirfneblin. Guarded, and suspicious of outsiders, svirfneblin are cunning and taciturn, but can be just as kind-hearted, loyal, and compassionate as their surface cousins.', 2, 25),
    ('Rock Gnome', 'As a rock gnome, you have a natural inventiveness and hardiness beyond that of other gnomes. Most gnomes in the worlds of D&D are rock gnomes, including the tinker gnomes of the Dragonlance setting.', 2, 25),
    ('Half-Elf', 'Walking in two worlds but truly belonging to neither, half-elves combine what some say are the best qualities of their elf and human parents: human curiosity, inventiveness, and ambition tempered by the refined senses, love of nature, and artistic tastes of the elves.', 3, 30),
    ('Lightfoot Halfling', 'As a lightfoot halfling, you can easily hide from notice, even using other people as cover. You’re inclined to be affable and get along well with others. In the Forgotten Realms, lightfoot halflings have spread the farthest and thus are the most common variety.', 2, 25),
    ('Stout Halfling', 'As a stout halfling, you’re hardier than average and have some resistance to poison. Some say that stouts have dwarven blood. In the Forgotten Realms, these halflings are called stronghearts, and they’re most common in the south.', 2, 25),
    ('Half-Orc', 'Half-orcs are creatures that, like Half-elves, are caught between two worlds. They are constantly at war with the two halves of their nature and have trouble belonging anywhere.', 3, 30),
    ('Tiefling', 'Tieflings are derived from human bloodlines, and in the broadest possible sense, they still look human. However, their infernal heritage has left a clear imprint on their appearance.', 3, 30);

INSERT INTO racialstatchange (race_name, stat, amount) VALUES
	('Dragonborn', 'Strength', 2),
    ('Dragonborn', 'Charisma', 1),
    ('Human', 'Strength', 1),
    ('Human', 'Dexterity', 1),
    ('Human', 'Constitution', 1),
    ('Human', 'Wisdom', 1),
    ('Human', 'Intelligence', 1),
    ('Human', 'Charisma', 1),
    ('Hill Dwarf', 'Constitution', 2),
    ('Hill Dwarf', 'Wisdom', 1),
    ('Mountain Dwarf', 'Constitution', 2),
    ('Mountain Dwarf', 'Strength', 2),
    ('High Elf', 'Dexterity', 2),
    ('High Elf', 'Intelligence', 1),
    ('Wood Elf', 'Dexterity', 2),
    ('Wood Elf', 'Wisdom', 1),
    ('Deep Gnome', 'Intelligence', 2),
    ('Deep Gnome', 'Dexterity', 1),
    ('Rock Gnome', 'Intelligence', 2),
    ('Rock Gnome', 'Constitution', 1),
    ('Half-Elf', 'Charisma', 2),
    ('Half-Elf', 'AnyOther2', 1), -- Increase any 2 stats other than the default Half-Elf stat increase (CHA) by 1
    ('Lightfoot Halfling', 'Dexterity', 2),
    ('Lightfoot Halfling', 'Charisma', 1),
    ('Stout Halfling', 'Dexterity', 2),
    ('Stout Halfling', 'Constitution', 1),
    ('Half-Orc', 'Strength', 2),
    ('Half-Orc', 'Constitution', 1),
    ('Tiefling', 'Intelligence', 1),
    ('Tiefling', 'Charisma', 2);
    
INSERT INTO racetoskill (race_name, skill_name) VALUES
	('Mountain Dwarf', 'History'),
	('Hill Dwarf', 'History'),
    ('High Elf', 'Perception'),
    ('Wood Elf', 'Perception'),
    ('Half-Elf', 'Any2'),
    ('Half-Orc', 'Intimidation');