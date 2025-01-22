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

DROP TABLE SCHEMA1.TAB_DEF_1 CASCADE CONSTRAINTS;


CREATE TABLE SCHEMA1.TAB_DEF_1 (
    DATE_MAJ DATE,   
    CHAMP1 NUMBER(14,0),
    CHAMP2 Varchar2(19),
    CHAMP3 NUMBER(14,0),
    CHAMP4 NUMBER(14,0),
    CHAMP5 NUMBER(14,0),
    CHAMP6 NUMBER(14,0),
    CHAMP7 Varchar2(50),
    CHAMP8 date,
    CHAMP9 date,
    CHAMP10 NUMBER(14,0),
    CHAMP11 VARCHAR2(2 BYTE),
    CHAMP12 VARCHAR2(1 BYTE),
    CHAMP13 VARCHAR2(1 BYTE),
    CHAMP14 VARCHAR2(1 BYTE),
    CHAMP15 VARCHAR2(1 BYTE),
    CHAMP16 VARCHAR2(2 BYTE)
);



-- -------------------------------------------------------------------------
-- INDEX
-- -------------------------------------------------------------------------
----------------------------------------------------------------------------
CREATE UNIQUE INDEX SCHEMA1.NAME_INDEX_1 ON SCHEMA1.TAB_DEF_1
		(CHAMP1)
TABLESPACE &&V_TBS_I;



----------------------------------------------------------------------------
-- CONSTRAINT PK
----------------------------------------------------------------------------
ALTER TABLE SCHEMA1.TAB_DEF_1 ADD (
  CONSTRAINT NAME_INDEX_1 PRIMARY KEY
(CHAMP1)
    USING INDEX 
    TABLESPACE &&V_TBS_I);


---------------------------------------------------------------------------- 
-- SYNONYM
---------------------------------------------------------------------------- 

----------------------------------------------------------------------------
-- GRANT
----------------------------------------------------------------------------

GRANT SELECT ON SCHEMA1.TAB_DEF_1 TO SCHEMA5;

----------------------------------------------------------------------------
-- COMMENTS
----------------------------------------------------------------------------


SHOW ERRORS
SPOOL OFF
exit;
