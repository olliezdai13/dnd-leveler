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
	character_id INT PRIMARY KEY AUTO_INCREMENT,
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
    portraitPath VARCHAR(255),
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
    amount INT NOT NULL,
    origin ENUM ('Other', 'Race', 'ASI4', 'ASI8', 'ASI12', 'ASI16', 'ASI19') NOT NULL,
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
    
INSERT INTO background (bg_name, description) VALUES
	("Acolyte", "You have spent your life in the service of a temple to a specific god or pantheon of gods. You act as an intermediary between the realm of the holy and the mortal world, performing sacred rites and offering sacrifices in order to conduct worshipers into the presence of the divine. You are not necessarily a cleric—performing sacred rites is not the same thing as channeling divine power."),
    ("Criminal", "You are an experienced criminal with a history of breaking the law. You have spent a lot of time among other criminals and still have contacts within the criminal underworld. You’re far closer than most people to the world of murder, theft, and violence that pervades the underbelly of civilization, and you have survived up to this point by flouting the rules and regulations of society."),
    ("Folk Hero", "You come from a humble social rank, but you are destined for so much more. Already the people of your home village regard you as their champion, and your destiny calls you to stand against the tyrants and monsters that threaten the common folk everywhere."),
    ("Noble", "You understand wealth, power, and privilege. You carry a noble title, and your family owns land, collects taxes, and wields significant political influence. You might be a pampered aristocrat unfamiliar with work or discomfort, a former merchant just elevated to the nobility, or a disinherited scoundrel with a disproportionate sense of entitlement. Or you could be an honest, hard-working landowner who cares deeply about the people who live and work on your land, keenly aware of your responsibility to them."),
    ("Sage", "You spent years learning the lore of the multiverse. You scoured manuscripts, studied scrolls, and listened to the greatest experts on the subjects that interest you. Your efforts have made you a master in your fields of study."),
    ("Soldier", "War has been your life for as long as you care to remember. You trained as a youth, studied the use of weapons and armor, learned basic survival techniques, including how to stay alive on the battlefield. You might have been part of a standing national army or a mercenary company, or perhaps a member of a local militia who rose to prominence during a recent war."),
    ("Charlatan", "You have always had a way with people. You know what makes them tick, you can tease out their hearts' desires after a few minutes of conversation, and with a few leading questions you can read them like they were children's books. It's a useful talent, and one that you're perfectly willing to use for your advantage."),
    ("Entertainer", "You thrive in front of an audience. You know how to entrance them, entertain them, and even inspire them. Your poetics can stir the hearts of those who hear you, awakening grief or joy, laughter or anger. Your music raises their spirits or captures their sorrow. Your dance steps captivate, your humor cuts to the quick. Whatever techniques you use, your art is your life."),
    ("Gladiator", "Gladiators battle for the entertainment of raucous crowds. Some gladiators are brutal pit fighters who treat each match as a life-or-death struggle, while others are professional duelists who Command huge fees but rarely fight to the death."),
    ("Guild Artisan", "You are a member of an artisan's guild, skilled in a particular field and closely associated with other artisans. You are a well-established part of the mercantile world, freed by talent and wealth from the constraints of a feudal social order. You learned your skills as an apprentice to a master artisan, under the sponsorship of your guild, until you became a master in your own right."),
    ("Hermit", "You lived in seclusion – either in a sheltered community such as a monastery, or entirely alone – for a formative part of your life. In your time apart from the clamor of society, you found quiet, solitude, and perhaps some of the answers you were looking for."),
    ("Knight", "Knights are warriors who pledge service to rulers, religious orders, and noble causes. A knight’s Alignment determines the extent to which a pledge is honored. Whether undertaking a quest or patrolling a realm, a knight often travels with an entourage that includes squires and Hirelings who are commoners."),
    ("Outlander", "You grew up in the wilds, far from civilization and the comforts of town and technology. You've witnessed the migration of herds larger than forests, survived weather more extreme than any city-dweller could comprehend, and enjoyed the solitude of being the only thinking creature for miles in any direction. The wilds are in your blood, whether you were a nomad, an explorer, a recluse, a hunter-gatherer, or even a marauder. Even in places where you don't know the specific features of the terrain, you know the ways of the wild."),
    ("Sailor", "You sailed on a seagoing vessel for years. In that time, you faced down mighty storms, monsters of the deep, and those who wanted to sink your craft to the bottomless depths. Your first love is the distant line of the horizon, but the time has come to try your hand at something new."),
    ("Pirate", "You spent your youth under the sway of a dread pirate, a ruthless cutthroat who taught you how to survive in a world of sharks and savages. You've indulged in larceny on the high seas and sent more than one deserving soul to a briny grave. Fear and bloodshed are no strangers to you, and you've garnered a somewhat unsavory reputation in many a port town."),
    ("Urchin", "You grew up on the streets alone, orphaned, and poor, You had no one to watch over you or to provide for you, so you learned to provide for yourself. You fought fiercely over food and kept a constant watch out for other desperate souls who might steal from you. You slept on rooftops and in alleyways, exposed to the elements, and endured sickness without the advantage of medicine or a place to recuperate. You've survived despite all odds, and did so through cunning, strength, speed, or some combination of each.");
    
    
INSERT INTO backgroundtoskill (bg_name, skill_name) VALUES
	("Acolyte", "Insight"),
	("Acolyte", "Religion"),
    ("Criminal", "Deception"), 
    ("Criminal", "Stealth"), 
    ("Folk Hero", "Animal Handling"),
    ("Folk Hero", "Survival"),
    ("Noble", "History"),
    ("Noble", "Persuasion"),
    ("Sage", "Arcana"),
    ("Sage", "History"),
    ("Soldier", "Athletics"),
    ("Soldier", "Intimidation"),
    ("Charlatan", "Deception"),
    ("Charlatan", "Sleight of Hand"),
    ("Entertainer", "Acrobatics"),
    ("Entertainer", "Performance"),
    ("Gladiator", "Athletics"),
    ("Gladiator", "Performance"),
    ("Guild Artisan", "Insight"),
    ("Guild Artisan", "Persuasion"),
	("Hermit", "Medicine"),
	("Hermit", "Religion"),
    ("Knight", "Athletics"),
    ("Knight", "Religion"),
    ("Outlander", "Athletics"),
    ("Outlander", "Survival"),
    ("Sailor", "Athletics"),
    ("Sailor", "Perception"),
    ("Pirate", "Athletics"),
    ("Pirate", "Perception"),
    ("Urchin", "Sleight of Hand"),
    ("Urchin", "Stealth");
    
INSERT INTO class (class_name, hit_dice, hp_base, hp_increment, num_skills, description) VALUES
	-- Barbarian, 1d12, 12hp + CON, +7hp + CON, choose 2 skills, <description>
	("Barbarian", 12, 12, 7, 2, "Barbarians, different as they might be, are defined by their rage: unbridled, unquenchable, and unthinking fury. More than a mere emotion, their anger is the ferocity of a cornered predator, the unrelenting assault of a storm, the churning turmoil of the sea."),
    ("Bard", 8, 8, 5, 3, "Whether scholar, skald, or scoundrel, a bard weaves magic through words and music to inspire allies, demoralize foes, manipulate minds, create illusions, and even heal wounds."),
    ("Cleric", 8, 8, 5, 3, "Clerics are intermediaries between the mortal world and the distant planes of the gods. As varied as the gods they serve, clerics strive to embody the handiwork of their deities. No ordinary priest, a cleric is imbued with divine magic."),
    ("Druid", 8, 8, 5, 2, "Whether calling on the elemental forces of nature or emulating the creatures of the animal world, druids are an embodiment of nature’s resilience, cunning, and fury. They claim no mastery over nature. Instead, they see themselves as extensions of nature’s indomitable will."),
    ("Fighter", 10, 10, 6, 2, "Questing knights, conquering overlords, royal champions, elite foot soldiers, hardened mercenaries, and bandit kings—as fighters, they all share an unparalleled mastery with weapons and armor, and a thorough knowledge of the skills of combat. And they are well acquainted with death, both meting it out and staring it defiantly in the face."),
    ("Monk", 8, 8, 5, 2, "Whatever their discipline, monks are united in their ability to magically harness the energy that flows in their bodies. Whether channeled as a striking display of combat prowess or a subtler focus of defensive ability and speed, this energy infuses all that a monk does."),
    ("Paladin", 10, 10, 6, 2, "Whatever their origin and their mission, paladins are united by their oaths to stand against the forces of evil. Whether sworn before a god’s altar and the witness of a priest, in a sacred glade before nature spirits and fey beings, or in a moment of desperation and grief with the dead as the only witness, a paladin’s oath is a powerful bond. It is a source of power that turns a devout warrior into a blessed champion."),
    ("Ranger", 10, 10, 6, 3, "Far from the bustle of cities and towns, past the hedges that shelter the most distant farms from the terrors of the wild, amid the dense-packed trees of trackless forests and across wide and empty plains, rangers keep their unending watch."),
    ("Rogue", 8, 8, 5, 4, "Rogues rely on skill, stealth, and their foes’ vulnerabilities to get the upper hand in any situation. They have a knack for finding the solution to just about any problem, demonstrating a resourcefulness and versatility that is the cornerstone of any successful adventuring party."),
    ("Sorcerer", 6, 6, 4, 2, "Sorcerers carry a magical birthright conferred upon them by an exotic bloodline, some otherworldly influence, or exposure to unknown cosmic forces. One can’t study sorcery as one learns a language, any more than one can learn to live a legendary life. No one chooses sorcery; the power chooses the sorcerer."),
    ("Warlock", 8, 8, 5, 2, "Warlocks are seekers of the knowledge that lies hidden in the fabric of the multiverse. Through pacts made with mysterious beings of supernatural power, warlocks unlock magical effects both subtle and spectacular. Drawing on the ancient knowledge of beings such as fey nobles, demons, devils, hags, and alien entities of the Far Realm, warlocks piece together arcane secrets to bolster their own power."),
    ("Wizard", 6, 6, 4, 2, "Wizards are supreme magic-users, defined and united as a class by the spells they cast. Drawing on the subtle weave of magic that permeates the cosmos, wizards cast spells of explosive fire, arcing lightning, subtle deception, and brute-force mind control.");
    
INSERT INTO classtoskill (class_name, skill_name) VALUES
	("Barbarian", "Animal Handling"),
	("Barbarian", "Athletics"),
	("Barbarian", "Intimidation"),
	("Barbarian", "Nature"),
	("Barbarian", "Perception"),
	("Barbarian", "Survival"),
	("Bard", "Athletics"),
	("Bard", "Acrobatics"),
	("Bard", "Sleight of Hand"),
	("Bard", "Stealth"),
	("Bard", "Arcana"),
	("Bard", "History"),
	("Bard", "Investigation"),
	("Bard", "Nature"),
	("Bard", "Religion"),
	("Bard", "Animal Handling"),
	("Bard", "Insight"),
	("Bard", "Medicine"),
	("Bard", "Perception"),
	("Bard", "Survival"),
	("Bard", "Deception"),
	("Bard", "Intimidation"),
	("Bard", "Performance"),
	("Bard", "Persuasion"),
	("Cleric", "History"),
	("Cleric", "Religion"),
	("Cleric", "Insight"),
	("Cleric", "Medicine"),
	("Cleric", "Persuasion"),
	("Druid", "Arcana"),
	("Druid", "Animal Handling"),
	("Druid", "Insight"),
	("Druid", "Medicine"),
	("Druid", "Nature"),
	("Druid", "Perception"),
	("Druid", "Religion"),
	("Druid", "Survival"),
    ("Fighter", "Acrobatics"),
    ("Fighter", "Animal Handling"),
    ("Fighter", "Athletics"),
    ("Fighter", "History"),
    ("Fighter", "Insight"),
    ("Fighter", "Intimidation"),
    ("Fighter", "Perception"),
    ("Fighter", "Survival"),
    ("Monk", "Acrobatics"),
    ("Monk", "Athletics"),
    ("Monk", "History"),
    ("Monk", "Insight"),
    ("Monk", "Religion"),
    ("Monk", "Stealth"),
    ("Paladin", "Athletics"),
    ("Paladin", "Insight"),
    ("Paladin", "Intimidation"),
    ("Paladin", "Medicine"),
    ("Paladin", "Persuasion"),
    ("Paladin", "Religion"),
    ("Ranger", "Animal Handling"),
    ("Ranger", "Athletics"),
    ("Ranger", "Insight"),
    ("Ranger", "Investigation"),
    ("Ranger", "Nature"),
    ("Ranger", "Perception"),
    ("Ranger", "Stealth"),
    ("Ranger", "Survival"),
    ("Rogue", "Acrobatics"),
    ("Rogue", "Investigation"),
    ("Rogue", "Stealth"),
    ("Rogue", "Sleight of Hand"),
    ("Rogue", "Persuasion"),
    ("Rogue", "Performance"),
    ("Rogue", "Perception"),
    ("Rogue", "Intimidation"),
    ("Rogue", "Insight"),
    ("Rogue", "Deception"),
    ("Rogue", "Athletics"),
    ("Sorcerer", "Religion"),
    ("Sorcerer", "Persuasion"),
    ("Sorcerer", "Intimidation"),
    ("Sorcerer", "Insight"),
    ("Sorcerer", "Deception"),
    ("Sorcerer", "Arcana"),
    ("Warlock", "Religion"),
    ("Warlock", "Nature"),
    ("Warlock", "Investigation"),
    ("Warlock", "Intimidation"),
    ("Warlock", "History"),
    ("Warlock", "Deception"),
    ("Warlock", "Arcana"),
    ("Wizard", "Religion"),
    ("Wizard", "Medicine"),
    ("Wizard", "Investigation"),
    ("Wizard", "Insight"),
    ("Wizard", "History"),
    ("Wizard", "Arcana");
    
INSERT INTO classsavingthrow (class_name, stat) VALUES
	("Wizard", "Wisdom"),
	("Wizard", "Intelligence"),
	("Warlock", "Wisdom"),
	("Warlock", "Charisma"),
	("Sorcerer", "Charisma"),
	("Sorcerer", "Constitution"),
	("Rogue", "Intelligence"),
	("Rogue", "Dexterity"),
	("Ranger", "Wisdom"),
	("Ranger", "Dexterity"),
	("Fighter", "Constitution"),
	("Fighter", "Strength"),
	("Druid", "Wisdom"),
	("Druid", "Intelligence"),
	("Cleric", "Charisma"),
	("Cleric", "Wisdom"),
	("Bard", "Charisma"),
	("Bard", "Dexterity"),
	("Barbarian", "Constitution"),
	("Barbarian", "Strength");
    
    
-- Sample character (assuming height in CM and weight in KG)
INSERT INTO ddcharacter (character_id, character_name, race_name, class_name, bg_name, level, str_score, dex_score, con_score, int_score, wis_score, cha_score, alignment, proficiency_bonus, deity_id, sex, height, weight, eyes, skin, portraitPath) VALUES
						(1, "Leglass", "Half-Elf", "Ranger", "Folk Hero", 1, 10, 15, 10, 11, 15, 10, "Neutral good", 2, NULL, "Female", 160, 54, "Blue", "Light", NULL);
                        
INSERT INTO statchange (character_id, stat, amount, origin) VALUES
	(1, "Charisma", 2, "Race"),
    (1, "Dexterity", 1, "Race"),
    (1, "Wisdom", 1, "Race");
    
INSERT INTO charactertoskill (character_id, skill_name) VALUES
	(1, "Animal Handling"),
	(1, "Survival"),
	(1, "Athletics"),
	(1, "Insight"),
	(1, "Investigation"),
	(1, "Arcana"),
	(1, "Medicine");
                        
-- Procedures:
 -- Fetches a race's stat change options
DROP PROCEDURE IF EXISTS get_race_stats;

 -- Outputs a character's final stat block, accounting for stat changes
DROP PROCEDURE IF EXISTS calc_character_stats;

 -- Levels up the given character
 -- Takes two stats for the ability score increase (only applies at the relevant levels). Input can be NULL but will error if the level-up expects an ability score increase
DROP PROCEDURE IF EXISTS level_up;

DELIMITER $$
CREATE PROCEDURE get_race_stats(character_id INT)
BEGIN
    SELECT stat, amount, r.race_name, character_name FROM racialstatchange r JOIN ddcharacter d ON r.race_name = d.race_name WHERE d.character_id = character_id;
END $$

DELIMITER $$
CREATE PROCEDURE calc_character_stats(character_id INT)
BEGIN
    DECLARE str_change INT;
    DECLARE dex_change INT;
    DECLARE con_change INT;
    DECLARE wis_change INT;
    DECLARE int_change INT;
    DECLARE cha_change INT;
    
    SET str_change = (SELECT COALESCE(SUM(amount), 0) AS val FROM statchange sc WHERE sc.character_id = character_id AND sc.stat = "Strength");
    SET dex_change = (SELECT COALESCE(SUM(amount), 0) AS val FROM statchange sc WHERE sc.character_id = character_id AND sc.stat = "Dexterity");
    SET con_change = (SELECT COALESCE(SUM(amount), 0) AS val FROM statchange sc WHERE sc.character_id = character_id AND sc.stat = "Constitution");
    SET wis_change = (SELECT COALESCE(SUM(amount), 0) AS val FROM statchange sc WHERE sc.character_id = character_id AND sc.stat = "Wisdom");
    SET int_change = (SELECT COALESCE(SUM(amount), 0) AS val FROM statchange sc WHERE sc.character_id = character_id AND sc.stat = "Intelligence");
    SET cha_change = (SELECT COALESCE(SUM(amount), 0) AS val FROM statchange sc WHERE sc.character_id = character_id AND sc.stat = "Charisma");
    
    SELECT str_score + str_change AS str, dex_score + dex_change AS dex, con_score + con_change AS con, wis_score + wis_change AS wis, int_score + int_change AS `int`, cha_score + cha_change AS cha,
		str_score AS str_base, dex_score AS dex_base, con_score AS con_base, wis_score AS wis_base, int_score AS int_base, cha_score AS cha_base, level, proficiency_bonus
		FROM ddcharacter dd WHERE dd.character_id = character_id;
END $$

DELIMITER $$
CREATE PROCEDURE level_up(	character_id INT, 
							score_increase_stat_1 ENUM('Strength', 'Dexterity', 'Constitution', 'Intelligence', 'Wisdom', 'Charisma'), 
                            score_increase_stat_2 ENUM('Strength', 'Dexterity', 'Constitution', 'Intelligence', 'Wisdom', 'Charisma'))
BEGIN 
	DECLARE lvl INT;
    DECLARE prof INT;
    DECLARE new_lvl INT;
    SET lvl = (SELECT level FROM ddcharacter dd WHERE dd.character_id = character_id);
    SET new_lvl = lvl + 1;
    
    IF (lvl <= 20) THEN SET prof = 6; END IF;
    IF (lvl <= 16) THEN SET prof = 5; END IF;
    IF (lvl <= 12) THEN SET prof = 4; END IF;
    IF (lvl <= 8) THEN SET prof = 3; END IF;
    IF (lvl <= 4) THEN SET prof = 2; END IF;
    
    -- if level 4, 8, 12, 16, or 19, do an ability score increase
    IF ((new_lvl = 4 OR new_lvl = 8 OR new_lvl = 12 OR new_lvl = 16 OR new_lvl = 19)
		AND (score_increase_stat_1 IS NULL AND score_increase_stat_2 IS NULL)) THEN
			SELECT "ERROR: To level up, must specify one or two ability scores to increase." AS message;
	ELSE
		IF (new_lvl = 4 OR new_lvl = 8 OR new_lvl = 12 OR new_lvl = 16 OR new_lvl = 19) THEN
			IF (score_increase_stat_1 IS NOT NULL AND score_increase_stat_2 IS NULL) THEN
				-- if only 1 stat specified, increase it by 2
				INSERT INTO statchange (character_id, stat, amount, origin) VALUES
					(character_id, score_increase_stat_1, 2, CONCAT("ASI", new_lvl));
			ELSEIF (score_increase_stat_1 IS NOT NULL AND score_increase_stat_2 IS NOT NULL) THEN
				-- if 2 stats specified, increase them by 1
				INSERT INTO statchange (character_id, stat, amount, origin) VALUES
					(character_id, score_increase_stat_1, 1, CONCAT("ASI", new_lvl)),
					(character_id, score_increase_stat_2, 1, CONCAT("ASI", new_lvl));
			END IF;
		END IF;
		UPDATE ddcharacter dd SET level = new_lvl, proficiency_bonus = prof WHERE dd.character_id = character_id;
	END IF;
END $$


CALL level_up(1, "Charisma", NULL);
CALL calc_character_stats(1);

SELECT skill_name, stat from ddcharacter dd JOIN charactertoskill chts USING(character_id) JOIN skill USING(skill_name) WHERE dd.character_id = 1;