DROP DATABASE IF EXISTS `ValorantTracker`;
CREATE SCHEMA `ValorantTracker`;
USE `ValorantTracker`;

DROP TABLE IF EXISTS `Agent`;
CREATE TABLE `Agent`(
    `Agent_Name`          VARCHAR(255)		NOT NULL,
    `Gender`              BIT(1)			NOT NULL,	-- Only Male(0) or Female(1) huehue
    `Agent_Type`          VARCHAR(255)		NOT NULL,
    `Origin`              VARCHAR(255)		DEFAULT NULL,
    `Primary_Ability`     VARCHAR(255)		NOT NULL,
    `Secondary_Ability`   VARCHAR(255)		NOT NULL,
    `Ternary_Ability`     VARCHAR(255)		NOT NULL,
    `Ultimate`            VARCHAR(255)		NOT NULL,

    PRIMARY KEY (`Agent_Name`) 
);

DROP TABLE IF EXISTS `Weapon`;
CREATE TABLE `Weapon`(
    `Weapon_Name`         VARCHAR(255)		NOT NULL,
    `Type`                VARCHAR(255)		NOT NULL,
    `Damage`              INT				NOT NULL,
    `Wall_Penetration`    INT				NOT NULL,
    `Fire_Rate`           INT				NOT NULL,
    `Run_Speed`           FLOAT				NOT NULL,
    `Reload_Speed`        FLOAT				NOT NULL,
    `Magazine`            INT				NOT NULL,

    PRIMARY KEY (`Weapon_Name`)
);

DROP TABLE IF EXISTS `Map`;
CREATE TABLE `Map`(
    `Map_Name`                VARCHAR(255)	NOT NULL,
    `Total_Sites`             INT			NOT NULL,
    `Attacker_Win_Percent`    FLOAT			DEFAULT NULL,
    `Defender_Win_Percent`    FLOAT			DEFAULT NULL,
    `Most_Popular_Agent`      VARCHAR(255)	DEFAULT NULL,
    `Location`                VARCHAR(255)	NOT NULL,

    PRIMARY KEY (`Map_Name`),
    CONSTRAINT `MPA_fk` FOREIGN KEY (`Most_Popular_Agent`) REFERENCES `Agent` (`Agent_Name`)
);

DROP TABLE IF EXISTS `Player`;
CREATE TABLE `Player`(
    `Player_Tag`        INT					NOT NULL,
    `Player_Name`       VARCHAR(255)		NOT NULL,
    `Current_Rating`    VARCHAR(255)		NOT NULL,
    `Peak_Rating`       VARCHAR(255)		NOT NULL,
    `Top_Agent`         VARCHAR(255)		DEFAULT NULL,
    `Top_Weapon`        VARCHAR(255)		DEFAULT NULL,
    `Top_Map`           VARCHAR(255)		DEFAULT NULL,
    `Win_Percent`       VARCHAR(255)		DEFAULT NULL,

    PRIMARY KEY (`Player_Tag`)
);

DROP TABLE IF EXISTS `Match`;
CREATE TABLE `Match`(
	`Match_ID`			VARCHAR(255)		NOT NULL,
    `Team_A_Score`		INT					NOT NULL,
	`Team_B_Score`		INT					NOT NULL,
    `Winning_Team`		BIT(1)				NOT NULL,	-- Team_A(0) & Team_B(1)
    `MVP`				INT					NOT NULL,
	`Map`				VARCHAR(255)		NOT NULL,
    
    PRIMARY KEY (`Match_ID`),
	CONSTRAINT `MVP_fk` FOREIGN KEY (`MVP`) REFERENCES `Player` (`Player_Tag`),
    CONSTRAINT `Map_fk` FOREIGN KEY (`Map`) REFERENCES `Map` (`Map_Name`)
);

DROP TABLE IF EXISTS `Team`;
CREATE TABLE `Team`(
	`Match_ID`			VARCHAR(255)		NOT NULL,
    `TeamType`			BIT(1)				NOT NULL,	-- Team_A(0) & Team_B(1)
    `Player_1`			INT					NOT NULL,
    `Player_2`			INT					NOT NULL,
    `Player_3`			INT					NOT NULL,
    `Player_4`			INT					NOT NULL,
    `Player_5`			INT					NOT NULL,
    
    PRIMARY KEY (`Match_ID`, `TeamType`),
    CONSTRAINT `Match_id_fk` FOREIGN KEY (`Match_ID`) REFERENCES `Match` (`Match_ID`),
    CONSTRAINT `P1_fk` FOREIGN KEY (`Player_1`) REFERENCES `Player` (`Player_Tag`),
    CONSTRAINT `P2_fk` FOREIGN KEY (`Player_2`) REFERENCES `Player` (`Player_Tag`),
    CONSTRAINT `P3_fk` FOREIGN KEY (`Player_3`) REFERENCES `Player` (`Player_Tag`),
    CONSTRAINT `P4_fk` FOREIGN KEY (`Player_4`) REFERENCES `Player` (`Player_Tag`),
    CONSTRAINT `P5_fk` FOREIGN KEY (`Player_5`) REFERENCES `Player` (`Player_Tag`)
);

-- ALTER TABLE `Match`
-- ADD CONSTRAINT `Winner_fk`
-- FOREIGN KEY (`Winning_Team`) REFERENCES `Team` (`TeamType`);

DROP TABLE IF EXISTS `Round`;
CREATE TABLE `Round`(
	`Match_ID`			VARCHAR(255)		NOT NULL,
    `Round_Number`		INT					NOT NULL,
    `Weapon`			VARCHAR(255)		NOT NULL,
    `Duration`			FLOAT				NOT NULL,
    `Winning_Team`		BIT(1)				NOT NULL,
    
    PRIMARY KEY (`Match_ID`, `Round_Number`),
	CONSTRAINT `Round_Match_fk` FOREIGN KEY (`Match_ID`) REFERENCES `Match` (`Match_ID`),
	CONSTRAINT `Wpn_Name_fk` FOREIGN KEY (`Weapon`) REFERENCES `Weapon` (`Weapon_Name`)
);

DROP TABLE IF EXISTS `Weapon_Skin`;
CREATE TABLE `Weapon_Skin`(
	`Weapon`			VARCHAR(255)		NOT NULL,
    `Name`				VARCHAR(255)		NOT NULL,
    `Price`				INT					NOT NULL,
    `Availability`		BIT(1)				DEFAULT 0,	-- Yes(1) No(0)
    
    PRIMARY KEY (`Weapon`, `Name`)
);

DROP TABLE IF EXISTS `Match_Stats`;
CREATE TABLE `Match_Stats`(
	`Match_ID`			VARCHAR(255)		NOT NULL,
    `Player_Tag`		INT					NOT NULL,
    `Agent`				VARCHAR(255)		NOT NULL,
    `Map`				VARCHAR(255)		NOT NULL,
    `Kills`				INT					NOT NULL,
    `Deaths`			INT					NOT NULL,
    `Assists`			INT					NOT NULL,
    `Avg_Combat_Score`	FLOAT,
    
    PRIMARY KEY (`Match_ID`, `Player_Tag`),
    CONSTRAINT `Match_Stats_fk` FOREIGN KEY (`Match_ID`) REFERENCES `Match` (`Match_ID`),
    CONSTRAINT `Player_Match_Stats_fk` FOREIGN KEY (`Player_Tag`) REFERENCES `Player` (`Player_Tag`),
    CONSTRAINT `Agent_Match_Stats` FOREIGN KEY (`Agent`) REFERENCES `Agent` (`Agent_Name`),
    CONSTRAINT `Map_Match_Stats` FOREIGN KEY (`Map`) REFERENCES `Map` (`Map_Name`)
);





-- Populate Database
INSERT INTO `Agent` VALUES ('Brimstone', 0, 'Controller', 'United States', 'Incendiary', 'Stim Beacon', 'Sky Smoke', 'Orbital Strike');
INSERT INTO `Agent` VALUES ('Viper', 1, 'Controller', 'United States', 'Snake Bite', 'Poison Cloud', 'Toxic Screen', 'Vipers Pit');
INSERT INTO `Agent` VALUES ('Omen', 0, 'Controller', 'Earth', 'Shrouded Step', 'Paranoia', 'Dark Cover', 'From The Shadows');
INSERT INTO `Agent` VALUES ('Sage', 1, 'Sentinel', 'China', 'Barrier Orb', 'Slow Orb', 'Healing Orb', 'Resurrection');
INSERT INTO `Agent` VALUES ('Reyna', 1, 'Duelist', 'Mexico', 'Leer', 'Devour', 'Dismiss', 'Empress');
INSERT INTO `Agent` VALUES ('Raze', 1, 'Duelist', 'Brazil', 'Boom Bot', 'Blast Pack', 'Paint Shells', 'Showstopper');
INSERT INTO `Agent` VALUES ('Breach', 0, 'Initiator', 'Sweden', 'Aftershock', 'Flashpoint', 'Fault Line', 'Rolling Thunder');

INSERT INTO `Map` VALUES ('Ascent', 2, NULL, NULL, 'Reyna', 'Venice');
INSERT INTO `Map` VALUES ('Haven', 3, NULL, NULL, 'Breach', 'Bhutan');
INSERT INTO `Map` VALUES ('Fracture', 2, NULL, NULL, 'Raze', 'Mecico');

INSERT INTO `Player` VALUES ('1111', 'Pyrole', 'Silver 1', 'Silver 1', NULL, NULL, NULL, NULL);
INSERT INTO `Player` VALUES ('2222', 'IITPaanwallah', 'Bronze 2', 'Bronze 3', NULL, NULL, NULL, NULL);
INSERT INTO `Player` VALUES ('3333', 'Paneer', 'Silver 1', 'Silver 2', NULL, NULL, NULL, NULL);
INSERT INTO `Player` VALUES ('4444', 'Devilunraveled', 'Bronze 2', 'Bronze 2', NULL, NULL, NULL, NULL);

INSERT INTO `Weapon_Skin` VALUES ('Spectre', 'Protocol', 1234, 1);
INSERT INTO `Weapon_Skin` VALUES ('Vandal', 'Chronovoid', 4567, 1);

INSERT INTO `Weapon` VALUES('Classic', 'Pistol', 20, 2, 2, 5, 3.5, 12);
INSERT INTO `Weapon` VALUES('Spectre', 'SMG', 50, 0, 5, 3.5, 3, 20);
INSERT INTO `Weapon` VALUES('Marshall', 'Sniper', 101, 4, 1, 4, 10, 6);
INSERT INTO `Weapon` VALUES('Vandal', 'Rifle', 80, 6, 3, 2, 3, 25);
INSERT INTO `Weapon` VALUES('Operator', 'Sniper', 150, 10, 1, 1.4, 2.2, 7);