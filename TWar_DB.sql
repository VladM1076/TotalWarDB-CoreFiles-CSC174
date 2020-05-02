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
	recruited_By_Faction_Name VARCHAR(50) NOT NULL,
	garrisoned_At_Settlement_Name VARCHAR(50),
	faction_Army_Cavalry_Count INT,
	navy_Ship_Count INT,
	military_Force_Type CHAR NOT NULL,
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

CREATE TABLE FACTION_ARMY_MAT_VIEW
(
	faction_Army_Military_Force_Name VARCHAR(50) NOT NULL,
	unit_Count INT,
	morale SET ('eager', 'fair', 'poor'),
	recruited_By_Faction_Name VARCHAR(50) NOT NULL,
	garrisoned_At_Settlement_Name VARCHAR(50),
	cavalry_Count INT,
	CONSTRAINT faction_Army_Garrisoned_At_Settlement_Name_fk
        FOREIGN KEY (garrisoned_At_Settlement_Name)
            REFERENCES SETTLEMENT (settlement_Name)
                ON UPDATE CASCADE,
    CONSTRAINT faction_Army_Recruited_By_Faction_Name_fk
        FOREIGN KEY (recruited_By_Faction_Name)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE,
	CONSTRAINT faction_Army_Military_Force_Name_pk
        PRIMARY KEY (faction_Army_Military_Force_Name),
    CONSTRAINT military_Force_Name_Of_Faction_Army_fk
	    FOREIGN KEY (faction_Army_Military_Force_Name)
	        REFERENCES MILITARY_FORCE (military_Force_Name)
                ON UPDATE CASCADE
);

CREATE TABLE NAVY_MAT_VIEW
(
	navy_Military_Force_Name INT NOT NULL,
	unit_Count INT,
	morale SET ('eager', 'fair', 'poor'),
	recruited_By_Faction_Name VARCHAR(50) NOT NULL,
	docked_At_Settlement_Name VARCHAR(50),
	ship_Count INT,
	CONSTRAINT navy_Docked_At_Settlement_Name_fk
        FOREIGN KEY (docked_At_Settlement_Name)
            REFERENCES SETTLEMENT (settlement_Name)
                ON UPDATE CASCADE,
	CONSTRAINT navy_Recruited_By_Faction_Name_fk
        FOREIGN KEY (recruited_By_Faction_Name)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE,
	CONSTRAINT navy_Military_Force_Name_pk
        PRIMARY KEY (navy_Military_Force_Name),
    CONSTRAINT military_Force_Name_Of_Navy_fk
	    FOREIGN KEY (navy_Military_Force_Name)
	        REFERENCES MILITARY_FORCE (military_Force_Name)
                ON UPDATE CASCADE
);

DELIMITER $$
CREATE FUNCTION military_force_check_type (military_Force_Type CHAR,
                                           faction_Army_Cavalry_Count INT,
                                           navy_Ship_Count INT) RETURNS BOOLEAN
    BEGIN
        DECLARE isGood BOOLEAN default FALSE;

        CASE (military_Force_Type)
            WHEN 'A' THEN SET isGood = (navy_Ship_Count IS NULL);
            WHEN 'N' THEN SET isGood = (faction_Army_Cavalry_Count IS NULL);
        END CASE;

        RETURN isGood;
    END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER military_force_before_insert_trigger
    BEFORE INSERT ON MILITARY_FORCE
    FOR EACH ROW
    BEGIN
        DECLARE isGood BOOLEAN;

        SET isGood = military_force_check_type (new.military_Force_Type,
                                                new.faction_Army_Cavalry_Count,
                                                new.navy_Ship_Count);
        IF (!isGood) THEN
            signal SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Incorrect attribute values for military force type';
        END IF;
    END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER military_force_before_update_trigger
    BEFORE UPDATE ON MILITARY_FORCE
    FOR EACH ROW
    BEGIN
        DECLARE isGood BOOLEAN;

        SET isGood = military_force_check_type (new.military_Force_Type,
                                                new.faction_Army_Cavalry_Count,
                                                new.navy_Ship_Count);
        IF (!isGood) THEN
            signal SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Incorrect attribute values for military force type';
        END IF;
    END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER military_force_faction_army_insert_after_trigger
    AFTER INSERT ON MILITARY_FORCE
    FOR EACH ROW
    BEGIN
        IF new.military_Force_Type = 'A' THEN
            INSERT INTO FACTION_ARMY_MAT_VIEW
                value (new.military_Force_Name, new.faction_Army_Cavalry_Count,
                        new.unit_Count, new.morale,
                        new.recruited_By_Faction_Name,
                        new.garrisoned_At_Settlement_Name);
        END IF;
    END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER military_force_navy_insert_after_trigger
    AFTER INSERT ON MILITARY_FORCE
    FOR EACH ROW
    BEGIN
        IF new.military_Force_Type = 'N' THEN
            INSERT INTO NAVY_MAT_VIEW
                VALUE (new.military_Force_Name,
                        new.unit_Count, new.morale,
                        new.recruited_By_Faction_Name,
                        new.garrisoned_At_Settlement_Name,
                      new.navy_Ship_Count);
        END IF;
    END $$
DELIMITER ;

DELIMITER $$
 CREATE TRIGGER faction_army_military_force_update_after_trigger
     AFTER UPDATE ON MILITARY_FORCE
     FOR EACH ROW
     BEGIN  -- delete old row from faction_army_mat_view, then insert new row

        IF old.military_Force_Type = 'A' THEN
            DELETE FROM FACTION_ARMY_MAT_VIEW
                WHERE FACTION_ARMY_MAT_VIEW.faction_Army_Military_Force_Name = old.military_Force_Name;
        END IF;

        IF new.military_Force_Type = 'A' THEN
            INSERT INTO FACTION_ARMY_MAT_VIEW
                VALUE (new.military_Force_Name,
                        new.unit_Count, new.morale,
                        new.recruited_By_Faction_Name,
                        new.garrisoned_At_Settlement_Name,
                       new.faction_Army_Cavalry_Count);
            END IF;
     END $$
DELIMITER ;

DELIMITER $$
 CREATE TRIGGER navy_military_force_update_after_trigger
     AFTER UPDATE ON MILITARY_FORCE
     FOR EACH ROW
     BEGIN  -- delete old row from navy_mat_view, then insert new row

        IF old.military_Force_Type = 'N' THEN
            DELETE FROM NAVY_MAT_VIEW
                WHERE NAVY_MAT_VIEW.navy_Military_Force_Name = old.military_Force_Name;
        END IF;

        IF new.military_Force_Type = 'N' THEN
            INSERT INTO NAVY_MAT_VIEW
                VALUE (new.military_Force_Name,
                        new.unit_Count, new.morale,
                        new.recruited_By_Faction_Name,
                        new.garrisoned_At_Settlement_Name,
                       new.navy_Ship_Count);
            END IF;
     END $$
DELIMITER ;

DELIMITER $$
 CREATE TRIGGER faction_army_military_force_before_delete_trigger
     BEFORE DELETE ON MILITARY_FORCE
     FOR EACH ROW
     BEGIN  -- delete old row from faction_army_mat_view
         IF old.military_Force_Name
                IN (SELECT faction_Army_Military_Force_Name FROM FACTION_ARMY_MAT_VIEW)
             THEN
             DELETE FROM FACTION_ARMY_MAT_VIEW
             WHERE FACTION_ARMY_MAT_VIEW.faction_Army_Military_Force_Name = old.military_Force_Name;
         END IF;
     END $$
DELIMITER ;

DELIMITER $$
 CREATE TRIGGER navy_military_force_before_delete_trigger
     BEFORE DELETE ON MILITARY_FORCE
     FOR EACH ROW
     BEGIN  -- delete old row from navy_mat_view
         IF old.military_Force_Name
                IN (SELECT navy_Military_Force_Name FROM NAVY_MAT_VIEW)
             THEN
             DELETE FROM NAVY_MAT_VIEW
             WHERE NAVY_MAT_VIEW.navy_Military_Force_Name = old.military_Force_Name;
         END IF;
     END $$
DELIMITER ;




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
