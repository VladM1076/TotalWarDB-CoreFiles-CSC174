CREATE TABLE FACTION
(
	faction_Name VARCHAR(50) NOT NULL,
	total_Faction_Population INTEGER,
	religion VARCHAR(50),
	CONSTRAINT faction_Name_pk
        PRIMARY KEY (faction_Name)
);

CREATE TABLE AT_WAR
(
    warring_Faction_Name_1 VARCHAR(50) NOT NULL,
    warring_Faction_Name_2 VARCHAR(50) NOT NULL,
    CONSTRAINT warring_Factions_pk
        PRIMARY KEY (warring_Faction_Name_1,
                        warring_Faction_Name_2),
    CONSTRAINT warring_Faction_Name_1_fk
        FOREIGN KEY (warring_Faction_Name_1)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE,
    CONSTRAINT warring_Faction_Name_2_fk
        FOREIGN KEY (warring_Faction_Name_2)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE
);

CREATE TABLE ALLIED
(
    allied_Faction_Name_1 VARCHAR(50) NOT NULL,
    allied_Faction_Name_2 VARCHAR(50) NOT NULL,
    CONSTRAINT allied_Factions_pk
        PRIMARY KEY (allied_Faction_Name_1,
                        allied_Faction_Name_2),
    CONSTRAINT allied_Faction_Name_1_fk
        FOREIGN KEY (allied_Faction_Name_1)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE,
    CONSTRAINT allied_Faction_Name_2_fk
        FOREIGN KEY (allied_Faction_Name_2)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE
);

CREATE TABLE MILITARY_FORCE
(
	military_Force_Name VARCHAR(100) NOT NULL,
	unit_Count INT,
	morale SET ('eager', 'fair', 'poor'),
	faction_Army_Cavalry_Count INT,
	navy_Ship_Count INT,
	military_Force_Type CHAR NOT NULL,
	recruited_By_Faction_Name VARCHAR(50) NOT NULL,
	garrisoned_At_Settlement_Name VARCHAR(50),
	CONSTRAINT military_Force_Recruited_By_Faction_Name_fk
        FOREIGN KEY (recruited_By_Faction_Name)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE,
    CONSTRAINT military_Force_Garrisoned_At_Settlement_Name_fk
        FOREIGN KEY (garrisoned_At_Settlement_Name)
            REFERENCES SETTLEMENT (settlement_Name)
                ON UPDATE CASCADE,
	CONSTRAINT military_Force_Name_pk
        PRIMARY KEY (military_Force_Name)
);

CREATE TABLE FACTION_ARMY
(
	faction_Army_Military_Force_Name INT NOT NULL,
	cavalry_Count INT,
	CONSTRAINT faction_Army_Military_Force_Name_pk
        PRIMARY KEY (faction_Army_Military_Force_Name),
    CONSTRAINT military_Force_Name_Of_Faction_Army_fk
	    FOREIGN KEY (faction_Army_Military_Force_Name)
	        REFERENCES MILITARY_FORCE (military_Force_Name)
                ON UPDATE CASCADE
);

CREATE TABLE NAVY
(
	navy_Military_Force_Name INT NOT NULL,
	ship_Count INT,
	CONSTRAINT navy_Military_Force_Name_pk
        PRIMARY KEY (navy_Military_Force_Name),
    CONSTRAINT military_Force_Name_Of_Navy_fk
	    FOREIGN KEY (navy_Military_Force_Name)
	        REFERENCES MILITARY_FORCE (military_Force_Name)
                ON UPDATE CASCADE
);

CREATE TABLE BATTLED
(
    battling_Military_Force_Name_1 INT NOT NULL,
    battling_Military_Force_Name_2 INT NOT NULL,
    victor_Faction_Name VARCHAR(50) NOT NULL,
    attacker_Faction_Name VARCHAR(50) NOT NULL,
    defender_Faction_Name VARCHAR(50) NOT NULL,
    attacking_Military_Force_Name_Losses INT,
    defending_Military_Force_Name_Losses INT,
    CONSTRAINT battling_Military_Force_Names_pk
        PRIMARY KEY (battling_Military_Force_Name_1,
                        battling_Military_Force_Name_2),
    CONSTRAINT battling_Military_Force_Name_1_fk
        FOREIGN KEY (battling_Military_Force_Name_1)
            REFERENCES MILITARY_FORCE (military_Force_Name)
                ON UPDATE CASCADE,
    CONSTRAINT battling_Military_Force_Name_2_fk
        FOREIGN KEY (battling_Military_Force_Name_2)
            REFERENCES MILITARY_FORCE (military_Force_Name)
                ON UPDATE CASCADE,
    CONSTRAINT victor_Faction_Name_fk
        FOREIGN KEY (victor_Faction_Name)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE,
    CONSTRAINT F_B_att_fk
        FOREIGN KEY (attacker_Faction_Name)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE,
    CONSTRAINT F_B_def_fk
        FOREIGN KEY (defender_Faction_Name)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE
);

CREATE TABLE SETTLEMENT
(
	settlement_Name VARCHAR(50) NOT NULL,
	settlement_Population INT NOT NULL,
	city_Taxes_Collected INTEGER,
	stronghold_Garrison_Unit_Count INTEGER,
	settlement_Type CHAR NOT NULL,
	controlled_By_Faction_Name VARCHAR(50) NOT NULL,
	faction_Date_Settlement_Occupied DATE,
	CONSTRAINT faction_Name_Controlling_Settlement_fk
        FOREIGN KEY (controlled_By_Faction_Name)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE,
	CONSTRAINT settlement_Name_pk
	    PRIMARY KEY (settlement_Name)
);

CREATE TABLE CITY
(
	settlement_Name_Of_City VARCHAR(50) NOT NULL,
	taxes_Collected INTEGER,
	CONSTRAINT settlement_Name_Of_City_pk
	    PRIMARY KEY (settlement_Name_Of_City),
	CONSTRAINT settlement_Name_Of_City_fk
	    FOREIGN KEY (settlement_Name_Of_City)
	        REFERENCES SETTLEMENT (settlement_Name)
                ON UPDATE CASCADE
);

CREATE TABLE STRONGHOLD
(
	settlement_Name_Of_Stronghold VARCHAR(50) NOT NULL,
	Garrison_Unit_Count_In_Stronghold INTEGER,
    CONSTRAINT Garrison_Unit_Count_In_Stronghold_positive
        CHECK (Garrison_Unit_Count_In_Stronghold > 0),
	CONSTRAINT settlement_Name_Of_Stronghold_pk
	    PRIMARY KEY (settlement_Name_Of_Stronghold),
	CONSTRAINT settlement_Name_Of_Stronghold_fk
	    FOREIGN KEY (settlement_Name_Of_Stronghold)
	        REFERENCES SETTLEMENT (settlement_Name)
                ON UPDATE CASCADE
);

CREATE TABLE SETTLEMENT_ROAD
(
    road_Between_Settlement_Name_1 VARCHAR(50) NOT NULL,
    road_Between_Settlement_Name_2 VARCHAR(50) NOT NULL,
    road_Length_Between_Settlements INT NOT NULL,
    road_Quality SET ('none', 'dirt', 'paved', 'brick'),
    CONSTRAINT road_Between_Settlements_Name_pk
        PRIMARY KEY (road_Between_Settlement_Name_1,
                        road_Between_Settlement_Name_2),
    CONSTRAINT road_Between_Settlement_Name_1_fk
        FOREIGN KEY (road_Between_Settlement_Name_2)
            REFERENCES SETTLEMENT (settlement_Name)
                ON UPDATE CASCADE,
    CONSTRAINT road_Between_Settlement_Name_2_fk
        FOREIGN KEY (road_Between_Settlement_Name_2)
            REFERENCES SETTLEMENT (settlement_Name)
                ON UPDATE CASCADE
);

/*
CREATE TABLE CONTROLS
(
    fName VARCHAR(50) NOT NULL,
    sName VARCHAR(50) NOT NULL,
    date_Occupied DATE,
    CONSTRAINT Cont_fName_sName_pk
        PRIMARY KEY (fName, sName),
    CONSTRAINT F_Cont_fName_fk
        FOREIGN KEY (fName)
            REFERENCES FACTION (fName)
                ON UPDATE CASCADE,
    CONSTRAINT S_Cont_sName_fk
        FOREIGN KEY (sName)
            REFERENCES SETTLEMENT (sName)
                ON UPDATE CASCADE
);
*/

/*
CREATE TABLE GARRISON
(
    sName VARCHAR(50) NOT NULL,
    mID INT NOT NULL,
    CONSTRAINT Gar_sName_mID_pk
        PRIMARY KEY (sName, mID),
    CONSTRAINT S_Gar_sName_fk
        FOREIGN KEY (sName)
            REFERENCES SETTLEMENT (sName)
                ON UPDATE CASCADE,
    CONSTRAINT MF_Gar_mID_fk
        FOREIGN KEY (mID)
            REFERENCES MILITARY_FORCE (mID)
                ON UPDATE CASCADE
);
 */

CREATE TABLE STRATEGIC_BUILDING
(
	built_By_Settlement_Name VARCHAR(50) NOT NULL,
    strategic_Building_Name VARCHAR(50) NOT NULL,
	structural_Integrity SET ('good', 'damaged', 'destroyed'),
	smith_Type VARCHAR(50),
	food_Type VARCHAR(50),
	resource_Type VARCHAR(50),
	strategic_Building_Type CHAR NOT NULL,
	CONSTRAINT strategic_Building_Settlement_Name_pk
        PRIMARY KEY (built_By_Settlement_Name,
                        strategic_Building_Name),
    CONSTRAINT strategic_Building_Built_By_Settlement_Name_fk
        FOREIGN KEY (built_By_Settlement_Name)
            REFERENCES SETTLEMENT (settlement_Name)
                ON UPDATE CASCADE
);

CREATE TABLE BLACKSMITH
(
	blacksmith_Built_By_Settlement_Name VARCHAR(50) NOT NULL,
	blacksmith_Strategic_Building_Name VARCHAR(50) NOT NULL,
    smith_Type VARCHAR(50),
	CONSTRAINT strategic_Building_Blacksmith_Built_By_Settlement_Name_pk
        PRIMARY KEY (blacksmith_Built_By_Settlement_Name,
                        blacksmith_Strategic_Building_Name),
    CONSTRAINT strategic_Building_Blacksmith_Built_By_Settlement_Name_fk
        FOREIGN KEY (blacksmith_Built_By_Settlement_Name,
                        blacksmith_Strategic_Building_Name)
            REFERENCES STRATEGIC_BUILDING (built_By_Settlement_Name,
                                            strategic_Building_Name)
                ON UPDATE CASCADE
);

CREATE TABLE FARM
(
	farm_Built_By_Settlement_Name VARCHAR(50) NOT NULL,
	farm_Strategic_Building_Name VARCHAR(50) NOT NULL,
    food_Type VARCHAR(50),
	CONSTRAINT farm_Strategic_Building_Built_By_Settlement_Name_pk
        PRIMARY KEY (farm_Built_By_Settlement_Name,
                        farm_Strategic_Building_Name),
    CONSTRAINT farm_Strategic_Building_Built_By_Settlement_Name_fk
        FOREIGN KEY (farm_Built_By_Settlement_Name,
                        farm_Strategic_Building_Name)
            REFERENCES STRATEGIC_BUILDING (built_By_Settlement_Name,
                                            strategic_Building_Name)
                ON UPDATE CASCADE
);

CREATE TABLE MINE
(
	mine_Built_By_Settlement_Name VARCHAR(50) NOT NULL,
	mine_Strategic_Building_Name VARCHAR(50) NOT NULL,
    resource_Type VARCHAR(50),
	CONSTRAINT mine_Strategic_Building_Built_By_Settlement_Name_pk
        PRIMARY KEY (mine_Built_By_Settlement_Name,
                        mine_Strategic_Building_Name),
    CONSTRAINT mine_Strategic_Building_Built_By_Settlement_Name_fk
        FOREIGN KEY (mine_Built_By_Settlement_Name,
                        mine_Strategic_Building_Name)
            REFERENCES STRATEGIC_BUILDING (built_By_Settlement_Name,
                                            strategic_Building_Name)
                ON UPDATE CASCADE
);
















/* triggers(before-inserts to be implemented)

DELIMITER ;
CREATE TRIGGER enforce_disjoint_militaryForce
BEFORE INSERT ON military_force
FOR EACH ROW
BEGIN
	IF new. IS NULL
	THEN SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Subclass must exist(Total Participation)';
	END IF;
END;
//
DELIMITER

DELIMITER ;
CREATE TRIGGER enforce_disjoint_settlement
BEFORE INSERT ON settlement
FOR EACH ROW
BEGIN
	IF new. IS NULL
	THEN SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Subclass must exist(Total Participation)';
	END IF;
END;
//
DELIMITER

DELIMITER ;
CREATE TRIGGER enforce_disjoint_strategicBuilding
BEFORE INSERT ON strategic_building
FOR EACH ROW
BEGIN
	IF new. IS NULL
	THEN SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Subclass must exist(Total Participation)';
	END IF;
END;
//
DELIMITER


/*
