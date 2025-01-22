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

DROP TABLE SCHEMA1.TAB_PARAM_NOMEN CASCADE CONSTRAINTS; 


CREATE TABLE SCHEMA1.TAB_PARAM_NOMEN(
Entity			VARCHAR2(255 CHAR),
code			VARCHAR2(20 CHAR),
start_Val_Date		DATE,
start_End_Date		DATE,
champs_PC		VARCHAR2(255 CHAR),
champs_PC2		VARCHAR2(20 CHAR),
champs_PC1		VARCHAR2(20 CHAR),
champs_MA1		VARCHAR2(20 CHAR),
champs_MA2		VARCHAR2(255 CHAR),
champs_TP1		VARCHAR2(255 CHAR),
champs_TP2		VARCHAR2(2 CHAR),
champs_TP3		VARCHAR2(67 CHAR),
traco_champs_EX3	VARCHAR2(255 CHAR),
traco_label		VARCHAR2(67 CHAR),
champs_W11		VARCHAR2(20 CHAR),
PaysDiam		VARCHAR2(5 CHAR)
);


-- -------------------------------------------------------------------------
-- INDEX
-- -------------------------------------------------------------------------
---------------------------------------------------------------------------- parent
CREATE UNIQUE INDEX SCHEMA1.INDEX_NOMEN ON SCHEMA1.TAB_PARAM_NOMEN
	(Entity, code, start_Val_Date, champs_PC, champs_PC2, champs_MA1, champs_MA2)
TABLESPACE &&V_TBS_I;

CREATE INDEX INDEX_NOMEN_1 ON TAB_PARAM_NOMEN (Entity, code) TABLESPACE &&V_TBS_I;
CREATE INDEX INDEX_NOMEN_2 ON TAB_PARAM_NOMEN (Entity, code, start_Val_Date) TABLESPACE &&V_TBS_I;
CREATE INDEX INDEX_NOMEN_3 ON TAB_PARAM_NOMEN (Entity, code, start_Val_Date, champs_PC) TABLESPACE &&V_TBS_I;
CREATE INDEX INDEX_NOMEN_4 ON TAB_PARAM_NOMEN (champs_MA1) TABLESPACE &&V_TBS_I;

----------------------------------------------------------------------------
-- CONSTRAINT PK
----------------------------------------------------------------------------
ALTER TABLE SCHEMA1.TAB_PARAM_NOMEN ADD (
  CONSTRAINT INDEX_NOMEN PRIMARY KEY
	(Entity, code, start_Val_Date, champs_PC, champs_PC2, champs_MA1, champs_MA2)
    USING INDEX 
    TABLESPACE &&V_TBS_I);


---------------------------------------------------------------------------- 
-- SYNONYM
---------------------------------------------------------------------------- 

----------------------------------------------------------------------------
-- GRANT
----------------------------------------------------------------------------

GRANT SELECT ON SCHEMA1.TAB_PARAM_NOMEN TO SCHEMA5;

----------------------------------------------------------------------------
-- COMMENTS
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- INSERT
----------------------------------------------------------------------------
Insert into SCHEMA1.TAB_PARAM_NOMEN (Entity, code, start_Val_Date, champs_PC, champs_PC2, champs_MA1, champs_MA2) values ('year_trimester','6C',to_date('01/01/2010','DD/MM/RRRR'),'1007','TAP','1007','PAYS');
Insert into SCHEMA1.TAB_PARAM_NOMEN (Entity, code, start_Val_Date, champs_PC, champs_PC2, champs_MA1, champs_MA2) values ('year_trimester','6D',to_date('01/01/2010','DD/MM/RRRR'),'1007.25','TAP','1007.25','PAYS');

commit;


SHOW ERRORS
SPOOL OFF
exit;
