create or replace PACKAGE  PACKAGE_1MT AS


FUNCTION ALIM_PARALLELE_CODE (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number;


FUNCTION MAIN_ALIM_PARALLELE_CODE (NOMLOG VARCHAR2,
                                P_DATE_TRAI DATE) RETURN NUMBER;



END PACKAGE_1MT;
/