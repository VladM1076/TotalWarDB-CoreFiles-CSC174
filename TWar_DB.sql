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

CREATE TABLE SETTLEMENT
(
	settlement_Name VARCHAR(50) NOT NULL,
	settlement_Population INT NOT NULL,
	controlled_By_Faction_Name VARCHAR(50) NOT NULL,
	city_Taxes_Collected INTEGER,
	stronghold_Garrison_Unit_Count INTEGER,
	settlement_Type CHAR NOT NULL,
	CONSTRAINT faction_Name_Controlling_Settlement_fk
        FOREIGN KEY (controlled_By_Faction_Name)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE,
	CONSTRAINT settlement_Name_pk
	    PRIMARY KEY (settlement_Name)
);

CREATE TABLE CITY_MAT_VIEW
(
	settlement_Name_Of_City VARCHAR(50) NOT NULL,
	settlement_Population_Of_City INT NOT NULL,
	controlled_By_Faction_Name VARCHAR(50) NOT NULL,
	taxes_Collected INTEGER NOT NULL,
	CONSTRAINT city_Faction_Name_Controlling_Settlement_fk
        FOREIGN KEY (controlled_By_Faction_Name)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE,
	CONSTRAINT settlement_Name_Of_City_pk
	    PRIMARY KEY (settlement_Name_Of_City),
	CONSTRAINT settlement_Name_Of_City_fk
	    FOREIGN KEY (settlement_Name_Of_City)
	        REFERENCES SETTLEMENT (settlement_Name)
                ON UPDATE CASCADE
);

CREATE TABLE STRONGHOLD_MAT_VIEW
(
	settlement_Name_Of_Stronghold VARCHAR(50) NOT NULL,
	settlement_Population_Of_Stronghold INT NOT NULL,
	controlled_By_Faction_Name VARCHAR(50) NOT NULL,
	Garrison_Unit_Count_In_Stronghold INTEGER NOT NULL,
	CONSTRAINT stronghold_Faction_Name_Controlling_Settlement_fk
        FOREIGN KEY (controlled_By_Faction_Name)
            REFERENCES FACTION (faction_Name)
                ON UPDATE CASCADE,
    CONSTRAINT Garrison_Unit_Count_In_Stronghold_exists
        CHECK (Garrison_Unit_Count_In_Stronghold > 1),
	CONSTRAINT settlement_Name_Of_Stronghold_pk
	    PRIMARY KEY (settlement_Name_Of_Stronghold),
	CONSTRAINT settlement_Name_Of_Stronghold_fk
	    FOREIGN KEY (settlement_Name_Of_Stronghold)
	        REFERENCES SETTLEMENT (settlement_Name)
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
	navy_Military_Force_Name VARCHAR(50) NOT NULL,
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

CREATE TABLE BATTLED
(
    battling_Military_Force_Name_1 VARCHAR(50) NOT NULL,
    battling_Military_Force_Name_2 VARCHAR(50) NOT NULL,
    victor_Faction_Name VARCHAR(50) NOT NULL,
    attacking_Military_Force_Name_Losses INT,
    defending_Military_Force_Name_Losses INT,
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
                ON UPDATE CASCADE
);

--  These triggers and functions update & synchronize the
--  MatView Tables. There are also triggers that
--  enforce the disjoint for the tables.
--  The identifying names and references are fairly descriptive.

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
                value (new.military_Force_Name,
                        new.unit_Count, new.morale,
                        new.recruited_By_Faction_Name,
                        new.garrisoned_At_Settlement_Name,
                        new.faction_Army_Cavalry_Count);
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

DELIMITER $$
CREATE FUNCTION settlement_check_type (settlement_Type CHAR,
                                           city_Taxes_Collected INTEGER,
                                           stronghold_Garrison_Unit_Count INTEGER)
                                           RETURNS BOOLEAN
    BEGIN
        DECLARE isGood BOOLEAN default FALSE;

        CASE (settlement_Type)
            WHEN 'C' THEN SET isGood = (stronghold_Garrison_Unit_Count IS NULL);
            WHEN 'S' THEN SET isGood = (city_Taxes_Collected IS NULL);
        END CASE;

        RETURN isGood;
    END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER settlement_before_insert_trigger
    BEFORE INSERT ON SETTLEMENT
    FOR EACH ROW
    BEGIN
        DECLARE isGood BOOLEAN;

        SET isGood = settlement_check_type (new.settlement_Type,
                                                new.city_Taxes_Collected,
                                                new.stronghold_Garrison_Unit_Count);
        IF (!isGood) THEN
            signal SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Incorrect attribute values for settlement type';
        END IF;
    END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER settlement_before_update_trigger
    BEFORE UPDATE ON SETTLEMENT
    FOR EACH ROW
    BEGIN
        DECLARE isGood BOOLEAN;

        SET isGood = settlement_check_type (new.settlement_Type,
                                                new.city_Taxes_Collected,
                                                new.stronghold_Garrison_Unit_Count);
        IF (!isGood) THEN
            signal SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Incorrect attribute values for settlement type';
        END IF;
    END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER settlement_city_after_insert_trigger
    AFTER INSERT ON SETTLEMENT
    FOR EACH ROW
    BEGIN
        IF new.settlement_Type = 'C' THEN
            INSERT INTO CITY_MAT_VIEW
                VALUE (new.settlement_Name, new.settlement_Population,
                        new.controlled_By_Faction_Name,
                        new.city_Taxes_Collected);
        END IF;
    END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER settlement_stronghold_after_insert_trigger
    AFTER INSERT ON SETTLEMENT
    FOR EACH ROW
    BEGIN
        IF new.settlement_Type = 'S' THEN
            INSERT INTO STRONGHOLD_MAT_VIEW
                VALUE (new.settlement_Name,
                       new.settlement_Population,
                        new.controlled_By_Faction_Name,
                        new.stronghold_Garrison_Unit_Count);
        END IF;
    END $$
DELIMITER ;

DELIMITER $$
 CREATE TRIGGER settlement_city_after_update_trigger
     AFTER UPDATE ON SETTLEMENT
     FOR EACH ROW
     BEGIN  -- delete old row from city_mat_view, then insert new row

        IF old.settlement_Type = 'C' THEN
            DELETE FROM CITY_MAT_VIEW
                WHERE CITY_MAT_VIEW.settlement_Name_Of_City = old.settlement_Name;
        END IF;

        IF new.settlement_Type = 'C' THEN
            INSERT INTO CITY_MAT_VIEW
                VALUE (new.settlement_Name,
                        new.settlement_Population,
                        new.controlled_By_Faction_Name,
                        new.city_Taxes_Collected);
            END IF;
     END $$
DELIMITER ;

DELIMITER $$
 CREATE TRIGGER settlement_stronghold_after_update_trigger
     AFTER UPDATE ON SETTLEMENT
     FOR EACH ROW
     BEGIN  -- delete old row from stronghold_mat_view, then insert new row

        IF old.settlement_Type = 'S' THEN
            DELETE FROM STRONGHOLD_MAT_VIEW
                WHERE STRONGHOLD_MAT_VIEW.settlement_Name_Of_Stronghold = old.settlement_Name;
        END IF;

        IF new.settlement_Type = 'S' THEN
            INSERT INTO STRONGHOLD_MAT_VIEW
                VALUE (new.settlement_Name,
                        new.settlement_Population,
                        new.controlled_By_Faction_Name,
                       new.stronghold_Garrison_Unit_Count);
            END IF;
     END $$
DELIMITER ;

DELIMITER $$
 CREATE TRIGGER settlement_city_before_delete_trigger
     BEFORE DELETE ON SETTLEMENT
     FOR EACH ROW
     BEGIN  -- delete old row from city_mat_view
         IF old.settlement_Name
                IN (SELECT settlement_Name_Of_City FROM CITY_MAT_VIEW)
             THEN
             DELETE FROM CITY_MAT_VIEW
             WHERE CITY_MAT_VIEW.settlement_Name_Of_City = old.settlement_Name;
         END IF;
     END $$
DELIMITER ;

DELIMITER $$
 CREATE TRIGGER settlement_stronghold_before_delete_trigger
     BEFORE DELETE ON SETTLEMENT
     FOR EACH ROW
     BEGIN  -- delete old row from stronghold_mat_view
         IF old.settlement_Name
                IN (SELECT settlement_Name_Of_Stronghold FROM STRONGHOLD_MAT_VIEW)
             THEN
             DELETE FROM STRONGHOLD_MAT_VIEW
             WHERE STRONGHOLD_MAT_VIEW.settlement_Name_Of_Stronghold = old.settlement_Name;
         END IF;
     END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER battled_after_insert_trigger
    AFTER INSERT ON BATTLED
    FOR EACH ROW
    BEGIN
		DECLARE force_1_letter char(1);
		DECLARE force_2_letter char(1);

		SET force_1_letter := (SELECT military_Force_Type FROM MILITARY_FORCE WHERE military_Force_Name = new.battling_Military_Force_Name_1);
		SET force_2_letter := (SELECT military_Force_Type FROM MILITARY_FORCE WHERE military_Force_Name = new.battling_Military_Force_Name_2);
		DECLARE valid BOOLEAN;

        UPDATE MILITARY_FORCE 
		SET navy_Ship_Count = (SELECT navy_Ship_Count FROM MILITARY_FORCE WHERE  military_Force_Name = new.battling_Military_Force_Name_1 AND force_1_letter = 'N') * (1 - (new.attacking_Military_Force_Name_Losses/(SELECT unitCount FROM MILITARY_FORCE WHERE military_Force_Name 
			= new.battling_Military_Force_Name_1));
	UPDATE MILITARY FORCE
		SET navy_Ship_Count = (SELECT navy_Ship_Count FROM MILITARY_FORCE WHERE  military_Force_Name = new.battling_Military_Force_Name_2 AND force_2_letter = 'N') * (1 - (new.defending_Military_Force_Name_Losses/(SELECT unitCount FROM MILITARY_FORCE WHERE military_Force_Name 
			= new.battling_Military_Force_Name_2));
	UPDATE MILITARY FORCE
		SET faction_Army_Cavalry_Count = (SELECT faction_Army_Cavalry_Count FROM MILITARY_FORCE WHERE  military_Force_Name = new.battling_Military_Force_Name_1 AND force_1_letter = 'A') * (1 - (new.attacking_Military_Force_Name_Losses/(SELECT unitCount FROM MILITARY_FORCE WHERE military_Force_Name 
			= new.battling_Military_Force_Name_1));
	UPDATE MILITARY FORCE
		SET faction_Army_Cavalry_Count = (SELECT faction_Army_Cavalry_Count FROM MILITARY_FORCE WHERE  military_Force_Name = new.battling_Military_Force_Name_2 AND force_2_letter = 'A') * (1 - (new.defending_Military_Force_Name_Losses/(SELECT unitCount FROM MILITARY_FORCE WHERE military_Force_Name 
			= new.battling_Military_Force_Name_2));
	UPDATE MILITARY FORCE
		SET unitCount 
		= (SELECT unitCount FROM MILITARY_FORCE WHERE military_Force_Name 
			= new.battling_Military_Force_Name_1)- new.attacking_Military_Force_Name_Losses
			WHERE military_Force_Name = battling_Military_Force_Name_1;
	UPDATE MILITARY FORCE
		SET unitCount
			= (SELECT unitCount FROM MILITARY_FORCE
			WHERE military_Force_Name
			= new.battling_Military_Force_Name_2) - new.defending_Military_Force_Name_Losses
			WHERE military_Force_Name = battling_Military_Force_Name_2;
			
    END $$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER settlement_after_insert_trigger
    AFTER INSERT ON SETTLEMENT
    FOR EACH ROW
    BEGIN
		UPDATE Faction 
			SET total_Faction_Population
			= (SELECT total_Faction_Population FROM Faction WHERE faction_Name = new.controlled_By_Faction_Name) + new.settlement_Population;
    END $$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER settlement_after_update_trigger
    AFTER UPDATE ON SETTLEMENT
    FOR EACH ROW
    BEGIN
		UPDATE Faction 
			SET total_Faction_Population
			= (SELECT total_Faction_Population FROM Faction WHERE faction_Name = new.controlled_By_Faction_Name) + new.settlement_Population;
		UPDATE Faction 
			SET total_Faction_Population
			= (SELECT total_Faction_Population FROM Faction WHERE faction_Name = old.controlled_By_Faction_Name) - new.settlement_Population;
    END $$
DELIMITER ;

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
















/* brainstorm triggers(before-inserts to be implemented)

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


*/
