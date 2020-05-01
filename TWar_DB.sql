CREATE TABLE FACTION
(
	fName VARCHAR(50) NOT NULL,
	total_population INTEGER,
	religion VARCHAR(50),
	CONSTRAINT fName_pk
        PRIMARY KEY (fName)
);

CREATE TABLE AT_WAR
(
    fName_1 VARCHAR(50) NOT NULL,
    fName_2 VARCHAR(50) NOT NULL,
    CONSTRAINT War_Factions_PK
        PRIMARY KEY (fName_1, fName_2),
    CONSTRAINT War_fN_1_fk
        FOREIGN KEY (fName_1)
            REFERENCES FACTION (fName)
                ON UPDATE CASCADE,
    CONSTRAINT War_fN_2_fk
        FOREIGN KEY (fName_2)
            REFERENCES FACTION (fName)
                ON UPDATE CASCADE
);

CREATE TABLE ALLIED
(
    fName_1 VARCHAR(50) NOT NULL,
    fName_2 VARCHAR(50) NOT NULL,
    CONSTRAINT Ally_Factions_PK
        PRIMARY KEY (fName_1, fName_2),
    CONSTRAINT Ally_fN_1_fk
        FOREIGN KEY (fName_1)
            REFERENCES FACTION (fName)
                ON UPDATE CASCADE,
    CONSTRAINT Ally_fN_2_fk
        FOREIGN KEY (fName_2)
            REFERENCES FACTION (fName)
                ON UPDATE CASCADE
);

CREATE TABLE MILITARY_FORCE
(
    mID INT NOT NULL,
	mName VARCHAR(100) NOT NULL,
	unit_Count INT,
	morale SET ('eager', 'fair', 'poor'),
	cavalry_Count INT,
	ship_Count INT,
	military_Force_Type CHAR NOT NULL,
	fName VARCHAR(50) NOT NULL,
	CONSTRAINT F_MF_recruits_fName_fk
        FOREIGN KEY (fName)
            REFERENCES FACTION (fName)
                ON UPDATE CASCADE,
	CONSTRAINT mID_pk
        PRIMARY KEY (mID)
);

CREATE TABLE FACTION_ARMY
(
	mID INT NOT NULL,
	cavalry_Count INT,
	CONSTRAINT FA_mID_pk
        PRIMARY KEY (mID),
    CONSTRAINT MF_FA_mID_fk
	    FOREIGN KEY (mID)
	        REFERENCES MILITARY_FORCE (mID)
                ON UPDATE CASCADE
);

CREATE TABLE NAVY
(
	mID INT NOT NULL,
	ship_Count INT,
	CONSTRAINT NAVY_mID_pk
        PRIMARY KEY (mID),
    CONSTRAINT MF_NAVY_mID_fk
	    FOREIGN KEY (mID)
	        REFERENCES MILITARY_FORCE (mID)
                ON UPDATE CASCADE
);

CREATE TABLE BATTLED
(
    mID_1 INT NOT NULL,
    mID_2 INT NOT NULL,
    victor VARCHAR(50) NOT NULL,
    attacker VARCHAR(50) NOT NULL,
    defender VARCHAR(50) NOT NULL,
    att_Losses INT,
    def_Losses INT NOT NULL,
    CONSTRAINT B_mID_pk
        PRIMARY KEY (mID_1, mID_2),
    CONSTRAINT MF_B_mID1_fk
        FOREIGN KEY (mID_1)
            REFERENCES MILITARY_FORCE (mID)
                ON UPDATE CASCADE,
    CONSTRAINT MF_B_mID2_fk
        FOREIGN KEY (mID_2)
            REFERENCES MILITARY_FORCE (mID)
                ON UPDATE CASCADE,
    CONSTRAINT F_B_vic_fk
        FOREIGN KEY (victor)
            REFERENCES FACTION (fName)
                ON UPDATE CASCADE,
    CONSTRAINT F_B_att_fk
        FOREIGN KEY (attacker)
            REFERENCES FACTION (fName)
                ON UPDATE CASCADE,
    CONSTRAINT F_B_def_fk
        FOREIGN KEY (defender)
            REFERENCES FACTION (fNAME)
                ON UPDATE CASCADE
);

CREATE TABLE SETTLEMENT
(
	sName VARCHAR(50) NOT NULL,
	Population INT NOT NULL,
	taxesCollected INTEGER,
	Garrison_Unit_Count INTEGER,
	settlement_Type CHAR NOT NULL,
	fName VARCHAR(50) NOT NULL,
	mID INT,
	date_Occupied DATE,
	CONSTRAINT F_S_controls_fName_fk
        FOREIGN KEY (fName)
            REFERENCES FACTION (fName)
                ON UPDATE CASCADE,
    CONSTRAINT MF_S_garrison_mID_fk
        FOREIGN KEY (mID)
            REFERENCES MILITARY_FORCE (mID)
                ON UPDATE CASCADE,
	CONSTRAINT S_sName_pk
	    PRIMARY KEY (sName)
);

CREATE TABLE CITY
(
	sName VARCHAR(50) NOT NULL,
	taxesCollected INTEGER,
	CONSTRAINT C_sName_pk
	    PRIMARY KEY (sName),
	CONSTRAINT S_C_sName_fk
	    FOREIGN KEY (sName)
	        REFERENCES SETTLEMENT (sName)
                ON UPDATE CASCADE
);

CREATE TABLE STRONGHOLD
(
	sName VARCHAR(50) NOT NULL,
	Garrison_Unit_Count INTEGER,
	mID INT,
	CONSTRAINT S_MF_Str_garrison_mID_fk
        FOREIGN KEY (mID)
            REFERENCES SETTLEMENT (mID)
                ON UPDATE CASCADE,
	CONSTRAINT Str_sName_pk
	    PRIMARY KEY (sName),
	CONSTRAINT S_Str_sName_fk
	    FOREIGN KEY (sName)
	        REFERENCES SETTLEMENT (sName)
                ON UPDATE CASCADE
);

CREATE TABLE SETTLEMENT_ROAD
(
    sName_1 VARCHAR(50) NOT NULL,
    sName_2 VARCHAR(50) NOT NULL,
    distance INT NOT NULL,
    road_Quality SET ('dirt', 'paved', 'brick'),
    travel_Time TIME,
    CONSTRAINT SRd_sName1_sName2_pk
        PRIMARY KEY (sName_1, sName_2),
    CONSTRAINT S_SRd_sName1_fk
        FOREIGN KEY (sName_1)
            REFERENCES SETTLEMENT (sName)
                ON UPDATE CASCADE,
    CONSTRAINT S_SRd_sName2_fk
        FOREIGN KEY (sName_2)
            REFERENCES SETTLEMENT (sName)
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
	sName VARCHAR(50) NOT NULL,
    sB_Name VARCHAR(50) NOT NULL,
	structural_Integrity SET ('good', 'damaged', 'destroyed'),
	smithType VARCHAR(50),
	foodType VARCHAR(50),
	resourceType VARCHAR(50),
	strategic_Building_Type CHAR NOT NULL,
	CONSTRAINT SB_sName_pk
        PRIMARY KEY (sName, sB_Name),
    CONSTRAINT S_SB_sName_fk
        FOREIGN KEY (sName)
            REFERENCES SETTLEMENT (sName)
                ON UPDATE CASCADE
);

CREATE TABLE BLACKSMITH
(
	sName VARCHAR(50) NOT NULL,
	sB_Name VARCHAR(50) NOT NULL,
    smithType VARCHAR(50),
	CONSTRAINT BS_sName_sBName_pk
        PRIMARY KEY (sName, sB_Name),
    CONSTRAINT SB_BS_sName_fk
        FOREIGN KEY (sName)
            REFERENCES STRATEGIC_BUILDING (sName)
                ON UPDATE CASCADE,
    CONSTRAINT SB_BS_sBName_fk
        FOREIGN KEY (sB_Name)
            REFERENCES STRATEGIC_BUILDING (sB_Name)
                ON UPDATE CASCADE
);

CREATE TABLE FARM
(
	sName VARCHAR(50) NOT NULL,
	sB_Name VARCHAR(50) NOT NULL,
    foodType VARCHAR(50),
	CONSTRAINT Farm_sName_sBName_pk
        PRIMARY KEY (sName, sB_Name),
    CONSTRAINT SB_Farm_sName_fk
        FOREIGN KEY (sName)
            REFERENCES STRATEGIC_BUILDING (sName)
                ON UPDATE CASCADE,
    CONSTRAINT SB_Farm_sBName_fk
        FOREIGN KEY (sB_Name)
            REFERENCES STRATEGIC_BUILDING (sB_Name)
                ON UPDATE CASCADE
);

CREATE TABLE MINE
(
	sName VARCHAR(50) NOT NULL,
	sB_Name VARCHAR(50) NOT NULL,
    resourceType VARCHAR(50),
	CONSTRAINT Mine_sName_sBName_pk
        PRIMARY KEY (sName, sB_Name),
    CONSTRAINT SB_Mine_sName_fk
        FOREIGN KEY (sName)
            REFERENCES STRATEGIC_BUILDING (sName)
                ON UPDATE CASCADE,
    CONSTRAINT SB_Mine_sBName_fk
        FOREIGN KEY (sB_Name)
            REFERENCES STRATEGIC_BUILDING (sB_Name)
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
