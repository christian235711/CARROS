/**
*-- Description : Creation de la table def
*-- Auteur : moi
*-- Date Creation : 
*/
-- -------------------------------------------------------------------------
-- Chargement des parametres ORACLE
-- -------------------------------------------------------------------------

SET SERVEROUTPUT ON
SET TERMOUT ON
SET ECHO ON
SET FEED ON
SET HEAD ON
@@table_param.sql
-- -------------------------------------------------------------------------
-- LOG
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- TABLE
-- -------------------------------------------------------------------------

DROP TABLE SCHEMA1.TAB_CARROS CASCADE CONSTRAINTS; 


CREATE TABLE SCHEMA1.TAB_CARROS(
champ_1		varchar2(14),
champ_2		Date,
champ_3		Date,
champ_4		varchar2(2),
champ_5		varchar2(20),
champ_6		varchar2(1),
champ_7		Date,
champ_8		Date,
champ_9		varchar2(10),
champ_A		varchar2(22),
champ_B		varchar2(2),
champ_C		varchar2(30),
champ_D		varchar2(2),
champ_E		varchar2(39),
champ_1A		varchar2(14),
champ_2A		Date,
champ_3A		Date,
champ_4A		varchar2(2),
champ_5A		varchar2(20),
champ_6A		varchar2(1),
champ_7A		Date,
champ_8A		Date,
champ_9A		varchar2(10),
champ_AB		varchar2(22),
champ_BB		varchar2(2),
champ_CB		varchar2(30),
champ_DB		varchar2(2),
champ_EB		varchar2(39)
);



-- -------------------------------------------------------------------------
-- INDEX
-- -------------------------------------------------------------------------
----------------------------------------------------------------------------
CREATE UNIQUE INDEX SCHEMA1.INDEX_CARROS_1 ON SCHEMA1.TAB_CARROS
		(champ_1) 
TABLESPACE &&V_TBS_I;

CREATE INDEX SCHEMA1.SCHEMA1.INDEX_CARROS_1 ON SCHEMA1.TAB_CARROS (CHAMP_4, CHAMP_A) TABLESPACE &&V_TBS_I;
CREATE INDEX SCHEMA1.SCHEMA1.INDEX_CARROS_2 ON SCHEMA1.TAB_CARROS (CHAMP_A) TABLESPACE &&V_TBS_I;
CREATE INDEX SCHEMA1.SCHEMA1.INDEX_CARROS_3 ON SCHEMA1.TAB_CARROS (CHAMP_2, champ_7) TABLESPACE &&V_TBS_I;

----------------------------------------------------------------------------
-- CONSTRAINT PK
----------------------------------------------------------------------------
ALTER TABLE SCHEMA1.TAB_CARROS ADD (
  	CONSTRAINT INDEX_CARROS_1 PRIMARY KEY
(champ_1) 
    USING INDEX 
    TABLESPACE &&V_TBS_I);


---------------------------------------------------------------------------- 
-- SYNONYM
---------------------------------------------------------------------------- 

----------------------------------------------------------------------------
-- GRANT
----------------------------------------------------------------------------

GRANT SELECT ON SCHEMA1.TAB_CARROS TO SCHEMA5;

----------------------------------------------------------------------------
-- COMMENTS
----------------------------------------------------------------------------


SHOW ERRORS
SPOOL OFF
exit;
