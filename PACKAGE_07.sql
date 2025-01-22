CREATE OR REPLACE package body SCHEMA3.PACKAGE_07 is
/************************************************************/
/***  TAB_99.SQL  pgm de mise a jour de la table TAB_99 ***/
/***  SUIVI DES TRAITEMENTS DE PROD       ***/
/***                                                      ***/
/*** V_NOM_TRAIT : nom du traitement shell                ***/
/*** V_DATE_DEB : date de debut du traitement             ***/
/*** V_TYPE_DATE : type de date                           ***/
/***           ('D' pour debut, 'F' pour fin)             ***/
/***                                                      ***/
/************************************************************/
/*** Modification by :                    	  ***/
/*** Project:                                      ***/
/*** Date of modification:                         ***/
/************************************************************/
Function ALIM_TAB_99(
  V_NOM_CHAIN VARCHAR2,
  V_DATE_DEB DATE,
  V_TYPE_DATE VARCHAR2,
  V_STATUT NUMBER DEFAULT 1,
  V_ERROR  VARCHAR2,
  V_INSERTS NUMBER DEFAULT 0,
  V_UPDATES NUMBER DEFAULT 0
  ) return number is
BEGIN
DECLARE
	V_ERR NUMBER:=0;
	traitement_erreur EXCEPTION;
	V_VCHAIN VARCHAR2(10);
	V_VTRAIT VARCHAR2(50);
 	v_date_deb_cal DATE ;
   BEGIN
    /*search chain*/
    IF V_TYPE_DATE NOT IN ( 'D','T', 'F') THEN
		SELECT DISTINCT(NOM_CHAIN)
    		INTO V_VCHAIN
		  FROM SCHEMA3.TAB_99
		 WHERE DATE_DEB = (SELECT MAX(DATE_DEB)
				   FROM SCHEMA3.TAB_99
                                   WHERE  NOM_TRAIT= V_NOM_CHAIN);
    END IF ;

    IF    V_TYPE_DATE ='T' THEN
		SELECT DISTINCT(NOM_CHAINE)
    		INTO V_VCHAIN
		  FROM SCHEMA3.TAB_98
		 WHERE NOM_TRAIT = V_NOM_CHAIN;
    END IF;

    IF    V_TYPE_DATE ='F' THEN
		SELECT DISTINCT(NOM_CHAIN), DATE_DEB
    		INTO V_VCHAIN , v_date_deb_cal
		  FROM SCHEMA3.TAB_99
		 WHERE DATE_DEB = (SELECT MAX(DATE_DEB)
		                   FROM SCHEMA3.TAB_99
                                   WHERE NOM_CHAIN = V_NOM_CHAIN);
    END IF;



    IF V_TYPE_DATE = 'D' THEN
      	   SELECT NOM_TRAIT INTO V_VTRAIT
	    FROM SCHEMA3.TAB_98
	   WHERE NOM_CHAINE = V_NOM_CHAIN
           AND TRAIT_INIT = '1';

      INSERT INTO SCHEMA3.TAB_99 (NOM_CHAIN,DATE_DEB,DATE_FIN,NOM_TRAIT,STATUS_CHAIN,STATUS_TRAIT,LOG_ERROR,INSERTS,UPDATES) VALUES (V_NOM_CHAIN, V_DATE_DEB, V_DATE_DEB, V_VTRAIT, 1, 1, NULL, 0, 0);
      COMMIT;

    ELSIF V_TYPE_DATE = 'U' THEN

		UPDATE SCHEMA3.TAB_99
		   SET STATUS_TRAIT = V_STATUT,
			   LOG_ERROR = V_ERROR,
			   INSERTS = V_INSERTS,
			   UPDATES = V_UPDATES
		 WHERE NOM_CHAIN = V_VCHAIN
		   AND DATE_DEB = V_DATE_DEB;

		COMMIT;
    ELSIF V_TYPE_DATE = 'F' THEN


		/* mise a jour du statut de la Chaine */
		UPDATE SCHEMA3.TAB_99
		   SET STATUS_CHAIN = (SELECT DECODE(SUM(STATUS_TRAIT),0,0,1)
					FROM SCHEMA3.TAB_99
					WHERE NOM_CHAIN = V_VCHAIN
					AND DATE_DEB = v_date_deb_cal),
		       DATE_FIN = SYSDATE
		 WHERE NOM_CHAIN = V_VCHAIN
		   AND DATE_DEB = v_date_deb_cal;
		COMMIT;
    ELSIF V_TYPE_DATE = 'T' THEN

		/* Mise a jour du statut du traitement lors du Lot 2 */
		INSERT INTO SCHEMA3.TAB_99(NOM_CHAIN,DATE_DEB,DATE_FIN,NOM_TRAIT,STATUS_CHAIN,STATUS_TRAIT,LOG_ERROR,INSERTS,UPDATES) VALUES (V_VCHAIN, V_DATE_DEB, NULL, V_NOM_CHAIN, 1, V_STATUT,V_ERROR,V_INSERTS,V_UPDATES);
		COMMIT;

    ELSE
      RAISE traitement_erreur;
    END IF;
    RETURN V_ERR;

  EXCEPTION
    WHEN traitement_erreur THEN V_ERR := 1;
      RETURN V_ERR;
    WHEN OTHERS THEN V_ERR := 1;
      COMMIT;
      RETURN V_ERR;
  END;

END ALIM_TAB_99;
/***************************************************************************/
END PACKAGE_07;
/