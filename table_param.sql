-- ###############################################################
-- Fichier de parametrage a adapter en fonction de l'environnement 
-- ###############################################################
/*APPLICATION*/
DEFINE V_NOM_SCHEMA1 = 'SCHEMA1'
DEFINE V_NOM_SCHEMA2 = 'SCHEMA2'
DEFINE V_NOM_SCHEMA3 = 'SCHEMA3'
DEFINE V_NOM_SCHEMA4 = 'SCHEMA4'

/*TABLESPACES*/
DEFINE V_TBS_1 = 'SCHEMAQD' 
DEFINE V_TBS_2 = 'SCHEMAXI'
DEFINE V_TBS_3 = 'SCHEMAFT' 

/*PARAMETRES*/
/*VOLUMES DE DONNEES : Petit */
DEFINE V_INIT1 = 120
DEFINE V_NEXT1 = 120
DEFINE V_MIN1 = 1
DEFINE V_MAX1 = 1024
DEFINE V_INCR1 = 0

/*VOLUMES DE DONNEES : Moyen */ 
DEFINE V_INIT2 = 120 --128K
DEFINE V_NEXT2 = 120 --128K
DEFINE V_MIN2 = 1
DEFINE V_MAX2 = 1024
DEFINE V_INCR2 = 0

/*VOLUMES DE DONNEES : Grand */ 
DEFINE V_INIT3 = 120 --128K
DEFINE V_NEXT3 = 120 --128K
DEFINE V_MIN3 = 1
DEFINE V_MAX3 = 1024 --2048
DEFINE V_INCR3 = 0

