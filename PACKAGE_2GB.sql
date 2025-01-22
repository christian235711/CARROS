create or replace PACKAGE PACKAGE_2GB AS 

------------------------------------DWH46
FUNCTION ALIM_TAB_CARROS_REC_KPI ( NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;  
  
------------------------------------ NOUVELLES JIRAS ------------------------------------    


FUNCTION ALIM_TAB_CARROS_DOUBLON_BLAD ( NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;

FUNCTION UPDATE_CARROS_INIT (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;

FUNCTION ALIM_TAB_CARROS_INIT (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;

FUNCTION ALIM_TAB_CARROS_FLAG (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;
   
    ------------------------------------ FONCTION CODE CONSTRUCTEUR------------------------------------   
 
FUNCTION UPDATE_CARROS_CONST_VAP (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;
  
  ------------------------------------ FONCTION UPDATE ------------------------------------   
  
  FUNCTION UPDATE_carro_BLAD_VAP (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number; 
    
  ------------------------------------ FONCTION POUR LA CREATION DES CODES ALPHANUMERIQUES ------------------------------------ 
  function secuencia1(n in integer ) return varchar2 ;
  function secuencia2(n in integer ) return varchar2 ;
  function secuencia3(n in integer, NOMLOG      VARCHAR2) return varchar2 ;



  ------------------------------------ ALIMENTATION DES 4 TABLES ------------------------------------
  FUNCTION ALIM_PARAM_2GEN_1A (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;
     
  FUNCTION ALIM_PARAM_2GEN_2B (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number; 
     

  FUNCTION ALIM_PARAM_2GEN_3C (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;
                                
                       
  FUNCTION ALIM_PARAM_2GEN_4D (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;
     

     
  ------------------------------------ ALIMENTATION DES TABLES(MAPPING) ------------------------------------
                                
  FUNCTION ALIM_TAB_CARROS (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;
      
  
  FUNCTION ALIM_TAB_CARROS_MIXREFS (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;

  FUNCTION ALIM_TAB_CARROS_PRIX (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;
  
         
  FUNCTIONALIM_TAB_CARROS_OPCIONES (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number; 
                                
         
  FUNCTION ALIM_TAB_CARROS_EQUIPOS (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;
     

  ------------------------------------ REMPLISSAGE DE LA TABLE TRANSCO ------------------------------------
                                
  FUNCTION ALIM_TRACOCO_1A (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;
                                
  FUNCTION ALIM_TRACOCO_2B (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;
                                
                            
  FUNCTION ALIM_TRACOCO_3C (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;


  FUNCTION ALIM_TRACOCO_4D (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;


  FUNCTION UPDATE_TRACOCO_PARAM_2 (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;


  ----------------------------------   EXPORT  ------------------------------------
 
    FUNCTION FONC_EXPORT_CARRO_JSON (NOMLOG varchar2,P_DATE_TRAI date, P_PATH VARCHAR2, P_FILENAME VARCHAR2)RETURN NUMBER;     
    FUNCTION FONC_EXPORT_TABNOM_JSON (NOMLOG varchar2,P_DATE_TRAI date, P_PATH VARCHAR2, P_FILENAME VARCHAR2)RETURN NUMBER;     

    FUNCTION EXPORT_CARROS_TXT(NOMLOG	VARCHAR2, P_DATE_TRAI	DATE, P_PATH    VARCHAR2, P_FILENAME  VARCHAR2) RETURN NUMBER;
    FUNCTION EXPORT_TABNOMEN_TXT(NOMLOG	VARCHAR2, P_DATE_TRAI	DATE, P_PATH    VARCHAR2, P_FILENAME  VARCHAR2) RETURN NUMBER;
   
  ----------------------------------   MAIN  ------------------------------------

  FUNCTION MAIN_EXPORT(      NOMLOG                          VARCHAR2,
                                P_DATE_TRAI                     DATE DEFAULT SYSDATE,
                                P_PATH                          VARCHAR2,
                                P_FILENAME_VEHICLE_JSON         VARCHAR2,
                                P_FILENAME_NOMENCLATURE_JSON    VARCHAR2,
                                P_FILENAME_VEHICLE_TXT          VARCHAR2,
                                P_FILENAME_NOMENCLATURE_TXT     VARCHAR2) Return Number;  




  FUNCTION MAIN_ALIM_TAB_CARROS(  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE) Return Number;    

  FUNCTION MAIN_ALIM_NOMEN (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;  
                                

     
                     
                            
END PACKAGE_2GB;