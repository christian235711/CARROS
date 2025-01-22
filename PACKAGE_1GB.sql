create or replace PACKAGE PACKAGE_1GB AS 
---------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------  VP   ----------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

------------------ 01

FUNCTION ALIM_1A (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;

------------------ 02
FUNCTION ALIM_2B (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;

------------------ 03
FUNCTION ALIM_3C (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;

------------------ 04
FUNCTION ALIM_4D (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;

------------------UPDATE CAPDER VP

FUNCTION UPDATE_FONCTION_1A (  NOMLOG varchar2, P_DATE_TRAI date) Return Number;
--FUNCTION UPDATE_FONCTION_2B (  NOMLOG varchar2, P_DATE_TRAI date) Return Number;


---------------------------------------------------------------------------------------------------------------------------
----------------------------------------------        MAIN        ---------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
FUNCTION MAIN_ALIM_VIP1 (NOMLOG VARCHAR2, P_DATE_TRAI DATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2 ) RETURN NUMBER;

FUNCTION MAIN_ALIM_VIP2 (NOMLOG VARCHAR2, P_DATE_TRAI DATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2 ) RETURN NUMBER;
                                
FUNCTION MAIN_PRINCIPAL (NOMLOG VARCHAR2, P_DATE_TRAI DATE) RETURN NUMBER;


END PACKAGE_1GB;
/