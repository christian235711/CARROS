/**
*-- Description : Creation de la table def
*-- Auteur : moi
*-- Date Creation : dateFFGG
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

DROP TABLE SCHEMA1.TAB_DEF_2 CASCADE CONSTRAINTS;


CREATE TABLE SCHEMA1.TAB_DEF_2 (
    DATE_MAJ DATE,   
    CHAMP11 NUMBER(14,0),
    CHAMP21 Varchar2(19),
    CHAMP31 NUMBER(14,0),
    CHAMP41 NUMBER(14,0),
    CHAMP51 NUMBER(14,0),
    CHAMP61 NUMBER(14,0),
    CHAMP71 Varchar2(50),
    CHAMP81 date,
    CHAMP91 date,
    CHAMP_YT NUMBER(14,0),
    CHAMP_IU VARCHAR2(2 BYTE),
    CHAMP_PI VARCHAR2(1 BYTE),
    CHAMP_GH VARCHAR2(1 BYTE),
    CHAMP_RT VARCHAR2(1 BYTE),
    CHAMP_SD VARCHAR2(1 BYTE),
    CHAMP_WX VARCHAR2(2 BYTE)
);



-- -------------------------------------------------------------------------
-- INDEX
-- -------------------------------------------------------------------------
----------------------------------------------------------------------------
CREATE UNIQUE INDEX SCHEMA1.NAME_INDEX_2 ON SCHEMA1.TAB_DEF_2
		(CHAMP11)
TABLESPACE &&V_TBS_I;



----------------------------------------------------------------------------
-- CONSTRAINT PK
----------------------------------------------------------------------------
ALTER TABLE SCHEMA1.TAB_DEF_2 ADD (
  CONSTRAINT NAME_INDEX_2 PRIMARY KEY
(CHAMP11)
    USING INDEX 
    TABLESPACE &&V_TBS_I);


---------------------------------------------------------------------------- 
-- SYNONYM
---------------------------------------------------------------------------- 

----------------------------------------------------------------------------
-- GRANT
----------------------------------------------------------------------------

GRANT SELECT ON SCHEMA1.TAB_DEF_2 TO SCHEMA5;

----------------------------------------------------------------------------
-- COMMENTS
----------------------------------------------------------------------------


SHOW ERRORS
SPOOL OFF
exit;
