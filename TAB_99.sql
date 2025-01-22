-- -------------------------------------------------------------------------
-- Description   : Creation de la table &&V_APPLI.TAB_99
--   Nom de la base   :  Code projet de l'application
--   Nom de SGBD      :  ORACLE Version 10
--   Date de creation :   
-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------
-- Chargement des paramètres ORACLE
-- -------------------------------------------------------------------------
@@table_param.sql

DROP TABLE &&V_APPLI..TAB_99 CASCADE CONSTRAINTS;

CREATE TABLE &&V_APPLI..TAB_99
(
  DATE_SITUATION     	DATE,
  NOM_CHAIN		VARCHAR2 (10) NOT NULL,
  DATE_DEB		DATE NOT NULL,
  DATE_FIN		DATE,
  NOM_TRAIT		VARCHAR2(100),
  STATUS_CHAIN		VARCHAR2(1),
  STATUS_TRAIT		VARCHAR2(1),
  LOG_ERROR		VARCHAR2(150),
  INSERTS		NUMBER,
  UPDATES		NUMBER,
  PRIMARY KEY ( NOM_CHAIN, DATE_DEB, NOM_TRAIT )
   )
   TABLESPACE &&V_TBS_D
   STORAGE(  INITIAL     &&V_INIT3
             NEXT        &&V_NEXT3
             MINEXTENTS  &&V_MIN3
             MAXEXTENTS  &&V_MAX3
             PCTINCREASE &&V_INCR3
   )
/

-- -------------------------------------------------------------------------
-- GRANT
-- -------------------------------------------------------------------------

GRANT SELECT ON &&V_APPLI..TAB_99 TO SCHEMA4;

COMMENT ON TABLE &&V_APPLI..TAB_99 IS 'Suivi des traitements';

COMMENT ON COLUMN &&V_APPLI..TAB_99.NOM_CHAIN is 'Nom de la chaîne'

COMMENT ON COLUMN &&V_APPLI..TAB_99.DATE_DEB IS 'Date de début du traitement';

COMMENT ON COLUMN &&V_APPLI..TAB_99.DATE_FIN IS 'Date de fin du traitement';

COMMENT ON COLUMN &&V_APPLI..TAB_99.NOM_TRAIT IS 'Nom du traitement';

COMMENT ON COLUMN &&V_APPLI..TAB_99.STATUS_CHAIN is 'Statut de la chaîne';

COMMENT ON COLUMN &&V_APPLI..TAB_99.STATUS_TRAIT is 'Statut du traitement';

COMMENT ON COLUMN &&V_APPLI..TAB_99.LOG_ERROR IS 'Message Erreur pl/sql';

COMMENT ON COLUMN &&V_APPLI..TAB_99.INSERTS IS 'Nombre d''insertions';

COMMENT ON COLUMN &&V_APPLI..TAB_99.UPDATES IS 'Nombre de mises a jour';


