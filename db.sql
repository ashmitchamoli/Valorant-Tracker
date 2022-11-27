DROP DATABASE IF EXISTS `ValorantTracker`;
CREATE SCHEMA `ValorantTracker`;
USE `ValorantTracker`;

CREATE TABLE `Agent`(
    `Agent_Name`          VARCHAR(255),
    `Gender`              VARCHAR(255),
    `Agent_Type`          VARCHAR(255),
    `Origin`              VARCHAR(255),
    `Primary_Ability`     VARCHAR(255),
    `Secondary_Ability`   VARCHAR(255),
    `Ternary_Ability`     VARCHAR(255),
    `Ultimate`            VARCHAR(255),

    PRIMARY KEY (`Agent_Name`) 
);

CREATE TABLE `Weapon`(
    `Weapon_Name`         VARCHAR(255),
    `Type`                VARCHAR(255),
    `Damage`              INT,
    `Wall_Penetration`    VARCHAR(255),
    `Fire_Rate`           INT,
    `Run_Speed`           FLOAT,
    `Reload_Speed`        FLOAT,
    `Magazine`            INT,

    PRIMARY KEY (`Weapon_Name`)
);

CREATE TABLE `Map`(
    `Map_Name`                VARCHAR(255),
    `Total_Sites`             INT,
    `Attacker_Win_Percent`    FLOAT,
    `Defender_Win_Percent`    FLOAT,
    `Most_Popular_Agent`      VARCHAR(255),
    `Location`                VARCHAR(255),

    PRIMARY KEY (`Map_Name`),
    FOREIGN KEY (`Most_Popular_Agent`) REFERENCES `Agent` (`Agent_Name`)
);

CREATE TABLE `Player`(
    `Player_Tag`        INT,
    `Player_Name`       VARCHAR(255),
    `Current_Rating`    VARCHAR(255),
    `Peak_Rating`       VARCHAR(255),
    `Top_Agent`         VARCHAR(255),
    `Top_Weapon`        VARCHAR(255),
    `Top_Map`           VARCHAR(255),
    `Win_Percent`       VARCHAR(255),

    PRIMARY KEY (Player_Tag)
);