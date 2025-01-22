-- -------------------------------------------------------------------------
-- Description   : Creation de la table &&V_APPLI.TAB_98
--   Nom de la base   :  Code projet de l'application
--   Nom de SGBD      :  ORACLE Version 10
--   Date de creation :  
-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------
-- Chargement des paramètres ORACLE
-- -------------------------------------------------------------------------
@@table_param.sql

DROP TABLE &&V_APPLI..TAB_98 CASCADE CONSTRAINTS;

CREATE TABLE &&V_APPLI..TAB_98
(
  NOM_CHAINE    VARCHAR2 (20) NOT NULL,
  NOM_TRAIT     VARCHAR2 (40) NOT NULL, 
  LIB_TRAIT     VARCHAR2(100), 
  LSI_IMPACTE   VARCHAR2 (30) NOT NULL,
  TYPE_FLUX     VARCHAR2 (20),
  NOM_JOURNAL   VARCHAR2 (100),
  TRAIT_INIT    NUMBER,
  PRIMARY KEY ( NOM_CHAINE, NOM_TRAIT )
   )
   TABLESPACE &&V_TBS_D
   STORAGE(  INITIAL     &&V_INIT3
             NEXT        &&V_NEXT3
             MINEXTENTS  &&V_MIN3
             MAXEXTENTS  &&V_MAX3
             PCTINCREASE &&V_INCR3
   )
/

COMMENT ON TABLE &&V_APPLI..TAB_98 IS 'Referentiel des traitements';

COMMENT ON COLUMN &&V_APPLI..TAB_98.NOM_CHAINE IS 'Nom de la chaîne';

COMMENT ON COLUMN &&V_APPLI..TAB_98.NOM_TRAIT IS 'Nom du traitement';

COMMENT ON COLUMN &&V_APPLI..TAB_98.LIB_TRAIT IS 'Libellé du traitement';

COMMENT ON COLUMN &&V_APPLI..TAB_98.LSI_IMPACTE IS 'LSI Impacté';

COMMENT ON COLUMN &&V_APPLI..TAB_98.TYPE_FLUX IS 'Type de flux';

COMMENT ON COLUMN &&V_APPLI..TAB_98.NOM_JOURNAL IS 'Chemin et nom du journal';

COMMENT ON COLUMN &&V_APPLI..TAB_98.TRAIT_INIT IS 'Traitement du Init';

-- -------------------------------------------------------------------------
-- GRANT
-- -------------------------------------------------------------------------

GRANT SELECT ON &&V_APPLI..TAB_98 TO SCHEMA4;