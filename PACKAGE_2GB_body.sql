create or replace PACKAGE PARAM_4 PACKAGE_2GB AS


  FUNCTION ALIM_TAB_CARROS_REC_KPI (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
  V_NUM   NUMBER(10);
  V_NUM_2 NUMBER(10);
  V_SEQ   VARCHAR2(2);

    V_countryCode VARCHAR2(2);
    V_NbActive NUMBER := 0;
    V_LastDate DATE;
    V_StartDate DATE;
    V_VAR_RA1 NUMBER := 0;
    V_VAR_RA2 DATE;
    V_VAR_RA3 DATE;
    V_VAR_A NUMBER := 0;
    V_NB_P NUMBER;
    V_NB_U NUMBER;
    V_NbActive_U VARCHAR2(5);
    V_VAR_1 VARCHAR2(5);
    V_VAR_B DATE;
    V_VAR_C DATE;
    V_VAR_1 NUMBER := 0;
    V_VAR_2 DATE;
    V_VAR_3 DATE;
    v_attribut_1 VARCHAR2(100);
    v_attribut_2 VARCHAR2(100);
    V_SQL_ID VARCHAR2(3000);
    v_nb_attribut NUMBER(1);


        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;


 Cursor C_nomen Is
     select distinct entity, code, champs_PC
     from SCHEMA2B.TAB_PARAM_NOMEN
     where entity in ('PARAM_2101', 'PARAM_2102','1A', 'PARAM_2103','2B','PARAM_2104','PARAM_2105','PARAM_2106','PARAM_2107','PARAM_2108');



 /*******************************************************************************/
  BEGIN

  File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_REC_KPI','------------- BEGIN  -----------------');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_REC_KPI','## Alimentation de la table SCHEMA2B.TAB_RECU_KPI ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_REC_KPI','## Flux BILAN   ##');


        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;

        ----TABLE DES KPI
        BEGIN
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCHEMA2B.TAB_RECU_KPI';
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS_REC_KPI',
                                   '## TRUNCATE OK ##' || SQL%ROWCOUNT);
            COMMIT;
        EXCEPTION WHEN OTHERS THEN
            V_ERR := 1;
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS_REC_KPI',
                                   '## TRUNCATE KO - FIN DU TRAITEMENT ##' || SQL%ROWCOUNT);
            RETURN V_ERR;
        END;



  FOR REC_nomen IN C_nomen
  LOOP

       /*************************************************************************/

        BEGIN

        V_VAR_1 := NULL;
        V_NbActive_U := NULL;

        IF REC_nomen.etty = 'PARAM_2102' then
            v_nb_attribut := 1;
            v_attribut_1 := 'carros.bdCode';
        END IF;

        IF REC_nomen.etty = 'PARAM_2101' then
            v_nb_attribut := 2;
            v_attribut_1 := 'carros.famCode';
            v_attribut_2 := 'carros.bdCode';
        END IF;

    
        IF REC_nomen.etty = '1A'  THEN
            v_nb_attribut := 2;
            v_attribut_1 := 'carros.PARAM_2_GEN';
            v_attribut_2 := 'carros.bdCode';
        END IF;
        IF REC_nomen.etty = '2B' then
            v_nb_attribut := 2;
            v_attribut_1 := 'carros.TRIM';
            v_attribut_2 := 'carros.bdCode||carros.PARAM_2_GEN';
        END IF;
        IF REC_nomen.etty = 'PARAM_2103'  THEN
            v_nb_attribut := 1;
            v_attribut_1 := 'carros.PARAM_4CODE';
        END IF;
        IF REC_nomen.etty = 'PARAM_2104' then
            v_nb_attribut := 1;
            v_attribut_1 := 'carros.champs_MK';
        END IF;
        IF REC_nomen.etty = 'PARAM_2105' then
            v_nb_attribut := 1;
            v_attribut_1 := 'carros.ener_code123';
        END IF;
        IF REC_nomen.etty = 'PARAM_2106' then
            v_nb_attribut := 1;
            v_attribut_1 := 'carros.KATcode';
        END IF;
        IF REC_nomen.etty = 'PARAM_2107' then
            v_nb_attribut := 1;
            v_attribut_1 := 'carros.champs_ARE';
        END IF;
        IF REC_nomen.etty = 'PARAM_2108' then
            v_nb_attribut := 1;
            v_attribut_1 := 'carros.champs_code123';
        END IF;


        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;

        V_countryCode := 'COUNTRY_INVENT';

        ---- IS VAP/VAU :
        IF v_nb_attribut = 2 THEN
        V_SQL_ID := '
         SELECT sum(case when VH_type = ''VAP'' then 1 else 0 end) as nb_VAP,
                sum(case when VH_type = ''VAU'' then 1 else 0 end) as nb_VAU
         FROM SCHEMA2B.TAB_CARROS veh
         where '|| v_attribut_1 || ' = '''|| REC_nomen.code || '''
         and   '|| v_attribut_2 || ' = '''|| REC_nomen.champs_PC || '''
         AND ValStartDate <= to_date('''|| to_char(V_SITU_DATE, 'YYYYMMDD') || ''', ''YYYYMMDD'')
         AND nvl(ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy'')) >= to_date('''|| to_char(V_SITU_DATE, 'YYYYMMDD') || ''', ''YYYYMMDD'')
         AND haveprecio = ''true''';
        END IF;

        IF v_nb_attribut = 1 THEN
        V_SQL_ID := '
         SELECT sum(case when VH_type = ''VAP'' then 1 else 0 end) as nb_VAP,
                sum(case when VH_type = ''VAU'' then 1 else 0 end) as nb_VAU
         FROM SCHEMA2B.TAB_CARROS veh
         where '|| v_attribut_1 || ' = '''|| REC_nomen.code || '''
         AND ValStartDate <= to_date('''|| to_char(V_SITU_DATE, 'YYYYMMDD') || ''', ''YYYYMMDD'')
         AND nvl(ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy'')) >= to_date('''|| to_char(V_SITU_DATE, 'YYYYMMDD') || ''', ''YYYYMMDD'')
         AND haveprecio = ''true''';
        END IF;

        BEGIN
            EXECUTE IMMEDIATE V_SQL_ID INTO V_NB_P, V_NB_U;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            V_NB_P := NULL;
            V_NB_U := NULL;
                  WHEN OTHERS THEN
            V_NB_P := NULL;
            V_NB_U := NULL;
            dbms_output.put_line(Sqlerrm);
        END;

        IF V_NB_P > 0 THEN V_VAR_1 := 'true'; ELSE V_VAR_1 := 'false'; END IF;
        IF V_NB_U > 0 THEN V_NbActive_U := 'true'; ELSE V_NbActive_U := 'false'; END IF;



        -- NB VEH ACTIF
        IF v_nb_attribut = 2 THEN
        V_SQL_ID := '
         SELECT count(*) AS COUNT_TOTAL, -- TOTAL
                max(nvl(ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy''))) AS END_TOTAL, -- TOTAL
                max(ValStartDate) AS START_TOTAL, -- TOTAL
                nvl(sum(case when champs_MJ = ''ENTERPRISE_ANONYM'' THEN 1 ELSE 0 END),0) AS COUNT_ENTREPRISE,
                max(case when champs_MJ = ''ENTERPRISE_ANONYM'' THEN nvl( ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy''))ELSE NULL END) AS END_ENTREPRISE,
                max(case when champs_MJ = ''ENTERPRISE_ANONYM'' THEN ValStartDate ELSE NULL END) AS START_RAM,
                nvl(sum(case when VH_type = ''VAP'' THEN 1 ELSE 0 END),0) AS COUNT_VAP,
                max(case when VH_type = ''VAP'' THEN nvl( ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy''))ELSE NULL END) AS END_VAP,
                max(case when VH_type = ''VAP'' THEN ValStartDate ELSE NULL END) AS START_VAP,
                nvl(sum(case when VH_type = ''VAU'' THEN 1 ELSE 0 END),0) AS COUNT_VAU,
                max(case when VH_type = ''VAU'' THEN nvl( ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy''))ELSE NULL END) AS END_VAU,
                max(case when VH_type = ''VAU'' THEN ValStartDate ELSE NULL END) AS START_VAU
         FROM SCHEMA2B.TAB_CARROS veh
         where '|| v_attribut_1 || ' = '''|| REC_nomen.code || '''
         and   '|| v_attribut_2 || ' = '''|| REC_nomen.champs_PC || '''
         AND ValStartDate <= to_date('''|| to_char(V_SITU_DATE, 'YYYYMMDD') || ''', ''YYYYMMDD'')
         AND nvl(ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy'')) >= to_date('''|| to_char(V_SITU_DATE, 'YYYYMMDD') || ''', ''YYYYMMDD'')
         AND haveprecio = ''true''';
        END IF;

        IF v_nb_attribut = 1 THEN
        V_SQL_ID := '
         SELECT count(*) AS COUNT_TOTAL, -- TOTAL
                max(nvl(ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy''))) AS END_TOTAL, -- TOTAL
                max(ValStartDate) AS START_TOTAL, -- TOTAL
                nvl(sum(case when champs_MJ = ''ENTERPRISE_ANONYM'' THEN 1 ELSE 0 END),0) AS COUNT_ENTREPRISE,
                max(case when champs_MJ = ''ENTERPRISE_ANONYM'' THEN nvl( ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy''))ELSE NULL END) AS END_ENTREPRISE,
                max(case when champs_MJ = ''ENTERPRISE_ANONYM'' THEN ValStartDate ELSE NULL END) AS START_RAM,
                nvl(sum(case when VH_type = ''VAP'' THEN 1 ELSE 0 END),0) AS COUNT_VAP,
                max(case when VH_type = ''VAP'' THEN nvl( ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy''))ELSE NULL END) AS END_VAP,
                max(case when VH_type = ''VAP'' THEN ValStartDate ELSE NULL END) AS START_VAP,
                nvl(sum(case when VH_type = ''VAU'' THEN 1 ELSE 0 END),0) AS COUNT_VAU,
                max(case when VH_type = ''VAU'' THEN nvl( ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy''))ELSE NULL END) AS END_VAU,
                max(case when VH_type = ''VAU'' THEN ValStartDate ELSE NULL END) AS START_VAU
         FROM SCHEMA2B.TAB_CARROS veh
         where '|| v_attribut_1 || ' = '''|| REC_nomen.code || '''
         AND ValStartDate <= to_date('''|| to_char(V_SITU_DATE, 'YYYYMMDD') || ''', ''YYYYMMDD'')
         AND nvl(ValEndDate, to_date(''31/12/9999'', ''dd/MM/yyyy'')) >= to_date('''|| to_char(V_SITU_DATE, 'YYYYMMDD') || ''', ''YYYYMMDD'')
         AND haveprecio = ''true''';
        END IF;

        BEGIN
            EXECUTE IMMEDIATE V_SQL_ID INTO V_NbActive, V_LastDate, V_StartDate, V_VAR_RA1, V_VAR_RA2, V_VAR_RA3, V_VAR_1, V_VAR_2, V_VAR_3, V_VAR_A, V_VAR_B, V_VAR_C;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            V_NbActive := NULL;
            V_LastDate := NULL;
            V_StartDate := NULL;
            V_VAR_RA1 := NULL;
            V_VAR_RA2 := NULL;
            V_VAR_RA3 := NULL;
            V_VAR_1 := NULL;
            V_VAR_2 := NULL;
            V_VAR_3 := NULL;
            V_VAR_A := NULL;
            V_VAR_B := NULL;
            V_VAR_C := NULL;
                  WHEN OTHERS THEN
            V_NbActive := NULL;
            V_LastDate := NULL;
            V_StartDate := NULL;
            V_VAR_RA1 := NULL;
            V_VAR_RA2 := NULL;
            V_VAR_RA3 := NULL;
            V_VAR_1 := NULL;
            V_VAR_2 := NULL;
            V_VAR_3 := NULL;
            V_VAR_A := NULL;
            V_VAR_B := NULL;
            V_VAR_C := NULL;
            dbms_output.put_line(Sqlerrm);
        END;


        INSERT INTO SCHEMA2B.TAB_RECU_KPI
              (
    entity,
    code,
    champs_PC,
    countryCode,
    nbUsedActive,
    usedLastDate,
    latestStartDate,
    champs_1AA,
    champs_2AA,
    champs_3AA,
    nbVAUActive,
    isVAUUsed,
    isVAPUsed,
    champs_1BB,
    champs_2BB,
    nbVAPActive,
    champs_1CC,
    champs_2CC
                )
        VALUES
              (
REC_nomen.etty,
REC_nomen.code,
REC_nomen.champs_PC,
V_countryCode,
V_NbActive,
CASE WHEN V_StartDate is null and V_LastDate = to_date('31/12/9999', 'dd/MM/yyyy') then null else V_LastDate end,
V_StartDate,
V_VAR_RA1,
CASE WHEN V_VAR_RA3 is null and V_VAR_RA2 = to_date('31/12/9999', 'dd/MM/yyyy') then null else V_VAR_RA2 end,
V_VAR_RA3,
V_VAR_A,
V_NbActive_U,
V_VAR_1,
CASE WHEN V_VAR_C is null and V_VAR_B = to_date('31/12/9999', 'dd/MM/yyyy') then null else V_VAR_B end,
V_VAR_C,
V_VAR_1,
CASE WHEN V_VAR_3 is null and V_VAR_2 = to_date('31/12/9999', 'dd/MM/yyyy') then null else V_VAR_2 end,
V_VAR_3
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_RECU_KPI
        Set     countryCode = V_countryCode,
                nbUsedActive    = V_NbActive,
                usedLastDate    = CASE WHEN V_StartDate is null and V_LastDate = to_date('31/12/9999', 'dd/MM/yyyy') then null else V_LastDate end,
                latestStartDate = V_StartDate,
                champs_1AA = V_VAR_RA1,
                champs_2AA = CASE WHEN V_VAR_RA3 is null and V_VAR_RA2 = to_date('31/12/9999', 'dd/MM/yyyy') then null else V_VAR_RA2 end,
                champs_3AA = V_VAR_RA3,
                nbVAUActive = V_VAR_A,
                isVAUUsed = V_NbActive_U,
                isVAPUsed = V_VAR_1,
                champs_1BB = CASE WHEN V_VAR_C is null and V_VAR_B = to_date('31/12/9999', 'dd/MM/yyyy') then null else V_VAR_B end,
                champs_2BB = V_VAR_C,
                nbVAPActive = V_VAR_1,
                champs_1CC = CASE WHEN V_VAR_3 is null and V_VAR_2 = to_date('31/12/9999', 'dd/MM/yyyy') then null else V_VAR_2 end,
                champs_2CC = V_VAR_3

        where  entity          =   REC_nomen.etty
        and    code            =   REC_nomen.code
        and    champs_PC          =   REC_nomen.champs_PC
        ;

        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_REC_KPI','Message Erreur pl/sql :'||Sqlerrm,'E');

        RETURN V_ERR;

      END;  ----
      --END IF;  ----

       -- END;
   END LOOP;

   COMMIT;



   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_REC_KPI','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));


   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_TAB_CARROS_REC_KPI;




FUNCTION ALIM_TAB_CARROS_DOUBLON_BLAD   (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;

  V_NUM   NUMBER(10);
  V_NUM_1 NUMBER(10);
  V_SEQ   VARCHAR2(2);

  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;

  Cursor C_carros Is

WITH DOUBLON AS (SELECT BLAD FROM SCHEMA2B.TAB_CARROS_INIT GROUP BY BLAD HAVING COUNT(COMP_CLE_PRIMAIRE)>0)
SELECT DISTINCT INIT.BLAD, INIT.COMP_CODE_C, SUBSTR(INIT.BLAD,1,15) AS BLAD_15, SUBSTR(INIT.BLAD,16,1) AS BLAD_LAST
FROM SCHEMA2B.TAB_CARROS_INIT INIT, DOUBLON WHERE INIT.BLAD = DOUBLON.BLAD;

  BEGIN

  File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_DOUBLON_BLAD  ','##Alim de la table SCHEMA2B.TAB_DOUBLON_BLAD ##');

  FOR REC_CARROS IN C_carros
  LOOP

       BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD, 100)=0 THEN COMMIT;
        END IF;

        BEGIN
         SELECT NUM_ID into V_NUM_1
         from   SCHEMA2B.TAB_DOUBLON_BLAD
         where  BLAD_15 = REC_CARROS.BLAD_15
         and    COMP_CODE_C = REC_CARROS.COMP_CODE_C ;
        EXCEPTION WHEN OTHERS THEN
         V_NUM_1 := NULL;
        END;


        IF V_NUM_1 is not null then
          V_SEQ := SCHEMA2B.PACKAGE_2GB.secuencia1(V_NUM_1);
        else
            BEGIN
                SELECT NVL(max(NUM_ID), 0) into V_NUM
                from   SCHEMA2B.TAB_DOUBLON_BLAD
                where  BLAD_15 = REC_CARROS.BLAD_15;
            EXCEPTION WHEN OTHERS THEN
                V_NUM := 0;
            END;

           V_NUM := V_NUM +1;     ---- changement
           V_SEQ := SCHEMA2B.PACKAGE_2GB.secuencia1(V_NUM);

        END IF ;


-------------------------

        INSERT INTO SCHEMA2B.TAB_DOUBLON_BLAD
              (
                COMP_CODE_C,
                BLAD_15,
                NUM_ID,
                BLAD_LAST
              )
        VALUES
              (
                REC_CARROS.COMP_CODE_C,
                REC_CARROS.BLAD_15,
                NVL(V_NUM_1, V_NUM),
                V_SEQ
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_DOUBLON_BLAD
        Set     NUM_ID =   NVL(V_NUM_1, V_NUM),
                BLAD_LAST = V_SEQ
        where BLAD_15 =  REC_CARROS.BLAD_15
        AND COMP_CODE_C  =  REC_CARROS.COMP_CODE_C;

        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_DOUBLON_BLAD','Message Erreur pl/sql :'||Sqlerrm,'E');

        RETURN V_ERR;

      END;
----------------------------
   END LOOP;

   COMMIT;
   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_DOUBLON_BLAD','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));





   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

END ALIM_TAB_CARROS_DOUBLON_BLAD;




  FUNCTION UPDATE_CARROS_INIT (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;

  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;

  Cursor C_CARROS_INIT Is
select  distinct
init.COMP_CLE_PRIMAIRE as COMP_CLE_PRIMAIRE,
(doublon.BLAD_15 || doublon.BLAD_LAST)  as BLAD
from SCHEMA2B.TAB_CARROS_init init,  SCHEMA2B.TAB_DOUBLON_BLAD doublon
where init.COMP_CODE_C = doublon.COMP_CODE_C
and init.BLAD = doublon.BLAD_15 || '0'  ;


  BEGIN

  File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'UPDATE_CARROS_INIT','##UPDATE la table SCHEMA2B.TAB_CARROS_init ##');


  FOR REC_CARROS_init IN C_CARROS_INIT
  LOOP

        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD, 100)=0 THEN COMMIT;
        END IF;

				Update  SCHEMA2B.TAB_CARROS_init
        Set   BLAD          =      REC_CARROS_init.BLAD
        where COMP_CLE_PRIMAIRE          =      REC_CARROS_init.COMP_CLE_PRIMAIRE  ;

        V_UPD := V_UPD + 1;

        EXCEPTION WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'UPDATE_CARROS_INIT','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'UPDATE_CARROS_INIT','Nombre de mises a jour : '||TO_CHAR(V_UPD));
   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END UPDATE_CARROS_INIT;





FUNCTION ALIM_TAB_CARROS_INIT  (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;

  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;

  Cursor C_carros Is
select
TECH_ID AS TECH_ID,
tech_dateExtract AS tech_dateExtract,
tech_dateInsert AS tech_dateInsert,
COUNTRYCODE AS COUNTRYCODE,
COMP_CLE_PRIMAIRE AS COMP_CLE_PRIMAIRE,
VersSTATE AS VersSTATE,
ValStartDate AS ValStartDate,
ValEndDate AS ValEndDate,
champs_MQ AS champs_MQ,
champs_MJ AS champs_MJ,
bdCode AS bdCode,
bdLabel AS bdLabel,
famCode AS famCode,
famLabel AS famLabel,
gener AS gener,
VersYear AS VersYear,
VersTrimester AS VersTrimester,
champs_MK AS champs_MK,
champs_FL AS champs_FL,
KATcode AS KATcode,
PARAM_4CODE AS PARAM_4CODE,
dimension_T1 AS dimension_T1,
dimension_T2 AS dimension_T2,
champs_ASP AS champs_ASP,
champs_NC AS champs_NC,
champs_NCA AS champs_NCA,
champs_TY AS champs_TY,
champs_PKI AS champs_PKI,
champs_FT AS champs_FT,
champs_FD AS champs_FD,
champs_ETY AS champs_ETY,
champs_EN1 AS champs_EN1,
champs_EN2 AS champs_EN2,
champs_EN3 AS champs_EN3,
ener_code123 AS ener_code123,
champs_ALT AS champs_ALT,
motor AS motor,
motorCOMB AS motorCOMB,
cubicCap AS cubicCap,
champs_ARE AS champs_ARE,
champs_code123 AS champs_code123,
champs_ATR AS champs_ATR,
champs_AVR AS champs_AVR,
champs_ATT AS champs_ATT,
seatNB AS seatNB,
doorNB AS doorNB,
champs_ACT AS champs_ACT,
champs_AX AS champs_AX,
champs_AB AS champs_AB,
champs_AP AS champs_AP,
champs_HP AS champs_HP,
champs_HY AS champs_HY,
champs_HI AS champs_HI,
champs_HB AS champs_HB,
champs_HM AS champs_HM,
champs_HW AS champs_HW,
BaCap AS BaCap,
champs_WQ AS champs_WQ,
champs_WZ AS champs_WZ,
champs_DE AS champs_DE,
Tele AS Tele,
champs_AN1 AS champs_AN1,
champs_RT AS champs_RT,
champs_NB1 AS champs_NB1,
champs_FGG AS champs_FGG,
champs_FGT AS champs_FGT,
VALID_USER AS VALID_USER,
VALID_DATE AS VALID_DATE,
UPDATEUSER AS UPDATEUSER,
UPDATEDATE AS UPDATEDATE,
champs_AY AS champs_AY,
champs_BC AS champs_BC,
champs_SH AS champs_SH,
VLGSHORT AS VLGSHORT,
VLGLONG AS VLGLONG,
VLLSHORT AS VLLSHORT,
VLLLONG AS VLLLONG,
VH_TYPE AS VH_TYPE,
PARAM_2_GEN AS PARAM_2_GEN,
TRIM AS TRIM,
motorBLAD AS motorBLAD,
DIMS AS DIMS,
PARAM_8 AS PARAM_8,
PARAM_9 AS PARAM_9,
COMP_CODE_C AS COMP_CODE_C,
CODE_CONSTR AS CODE_CONSTR,
BLAD AS BLAD
from SCHEMA2B.TAB_CARROS VEH
WHERE NOT EXISTS (SELECT 1 FROM SCHEMA2B.TAB_CARROS_INIT VEI WHERE carros.COMP_CLE_PRIMAIRE = VEI.COMP_CLE_PRIMAIRE);



  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_INIT ','##Alim de la table SCHEMA2B.TAB_CARROS_INIT ##');



  FOR REC_CARROS IN C_carros
  LOOP




        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD, 100)=0 THEN COMMIT;
        END IF;

        BEGIN

        INSERT INTO SCHEMA2B.TAB_CARROS_INIT
              (
TECH_ID,
tech_dateExtract,
tech_dateInsert,
COUNTRYCODE,
COMP_CLE_PRIMAIRE,
VersSTATE,
ValStartDate,
ValEndDate,
champs_MQ,
champs_MJ,
bdCode,
bdLabel,
famCode,
famLabel,
gener,
VersYear,
VersTrimester,
champs_MK,
champs_FL,
KATcode,
PARAM_4CODE,
dimension_T1,
dimension_T2,
champs_ASP,
champs_NC,
champs_NCA,
champs_TY,
champs_PKI,
champs_FT,
champs_FD,
champs_ETY,
champs_EN1,
champs_EN2,
champs_EN3,
ener_code123,
champs_ALT,
motor,
motorCOMB,
cubicCap,
champs_ARE,
champs_code123,
champs_ATR,
champs_AVR,
champs_ATT,
seatNB,
doorNB,
champs_ACT,
champs_AX,
champs_AB,
champs_AP,
champs_HP,
champs_HY,
champs_HI,
champs_HB,
champs_HM,
champs_HW,
BaCap,
champs_WQ,
champs_WZ,
champs_DE,
Tele,
champs_AN1,
champs_RT,
champs_NB1,
champs_FGG,
champs_FGT,
VALID_USER,
VALID_DATE,
UPDATEUSER,
UPDATEDATE,
champs_AY,
champs_BC,
champs_SH,
VLGSHORT,
VLGLONG,
VLLSHORT,
VLLLONG,
VH_TYPE,
PARAM_2_GEN,
TRIM,
motorBLAD,
DIMS,
PARAM_8,
PARAM_9,
COMP_CODE_C,
CODE_CONSTR,
BLAD
              )
        VALUES
              (
REC_CARROS.TECH_ID,
REC_CARROS.tech_dateExtract,
REC_CARROS.tech_dateInsert,
REC_CARROS.COUNTRYCODE,
REC_CARROS.COMP_CLE_PRIMAIRE,
REC_CARROS.VersSTATE,
REC_CARROS.ValStartDate,
REC_CARROS.ValEndDate,
REC_CARROS.champs_MQ,
REC_CARROS.champs_MJ,
REC_CARROS.bdCode,
REC_CARROS.bdLabel,
REC_CARROS.famCode,
REC_CARROS.famLabel,
REC_CARROS.gener,
REC_CARROS.VersYear,
REC_CARROS.VersTrimester,
REC_CARROS.champs_MK,
REC_CARROS.champs_FL,
REC_CARROS.KATcode,
REC_CARROS.PARAM_4CODE,
REC_CARROS.dimension_T1,
REC_CARROS.dimension_T2,
REC_CARROS.champs_ASP,
REC_CARROS.champs_NC,
REC_CARROS.champs_NCA,
REC_CARROS.champs_TY,
REC_CARROS.champs_PKI,
REC_CARROS.champs_FT,
REC_CARROS.champs_FD,
REC_CARROS.champs_ETY,
REC_CARROS.champs_EN1,
REC_CARROS.champs_EN2,
REC_CARROS.champs_EN3,
REC_CARROS.ener_code123,
REC_CARROS.champs_ALT,
REC_CARROS.motor,
REC_CARROS.motorCOMB,
REC_CARROS.cubicCap,
REC_CARROS.champs_ARE,
REC_CARROS.champs_code123,
REC_CARROS.champs_ATR,
REC_CARROS.champs_AVR,
REC_CARROS.champs_ATT,
REC_CARROS.seatNB,
REC_CARROS.doorNB,
REC_CARROS.champs_ACT,
REC_CARROS.champs_AX,
REC_CARROS.champs_AB,
REC_CARROS.champs_AP,
REC_CARROS.champs_HP,
REC_CARROS.champs_HY,
REC_CARROS.champs_HI,
REC_CARROS.champs_HB,
REC_CARROS.champs_HM,
REC_CARROS.champs_HW,
REC_CARROS.BaCap,
REC_CARROS.champs_WQ,
REC_CARROS.champs_WZ,
REC_CARROS.champs_DE,
REC_CARROS.Tele,
REC_CARROS.champs_AN1,
REC_CARROS.champs_RT,
REC_CARROS.champs_NB1,
REC_CARROS.champs_FGG,
REC_CARROS.champs_FGT,
REC_CARROS.VALID_USER,
REC_CARROS.VALID_DATE,
REC_CARROS.UPDATEUSER,
REC_CARROS.UPDATEDATE,
REC_CARROS.champs_AY,
REC_CARROS.champs_BC,
REC_CARROS.champs_SH,
REC_CARROS.VLGSHORT,
REC_CARROS.VLGLONG,
REC_CARROS.VLLSHORT,
REC_CARROS.VLLLONG,
REC_CARROS.VH_TYPE,
REC_CARROS.PARAM_2_GEN,
REC_CARROS.TRIM,
REC_CARROS.motorBLAD,
REC_CARROS.DIMS,
REC_CARROS.PARAM_8,
REC_CARROS.PARAM_9,
REC_CARROS.COMP_CODE_C,
REC_CARROS.CODE_CONSTR,
REC_CARROS.BLAD
              );

        V_INS := V_INS + 1;

        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
        NULL;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_INIT ','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_INIT ','Nombre d insertion : '||TO_CHAR(V_INS));
   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_TAB_CARROS_INIT;





-----APRES L'ALIMENTATION DE precio
FUNCTION ALIM_TAB_CARROS_FLAG   (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;

  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;

  Cursor C_carros Is

select
carros.COMP_CLE_PRIMAIRE AS COMP_CLE_PRIMAIRE,
(CASE WHEN carros.BLAD IS NOT NULL
AND carros.ener_code123 IS NOT NULL
AND carros.KATcode IS NOT NULL
AND carros.PARAM_4Code IS NOT NULL
AND carros.ValStartDate IS NOT NULL
AND EXISTS (SELECT 1
            FROM   SCHEMA2B.TAB_CARROS_PRIX precio
			WHERE  carros.COMP_CLE_PRIMAIRE = precio.COMP_CLE_PRIMAIRE
			AND precio.moneda = 'GBP'
			AND precio.champs_PWF1 IS NOT NULL
			)
          THEN 'true' ELSE 'false' END) as champs_FGT,
--53
(CASE WHEN EXISTS (SELECT 1
            FROM   SCHEMA2B.TAB_CARROS_PRIX precio
			WHERE  carros.COMP_CLE_PRIMAIRE = precio.COMP_CLE_PRIMAIRE
			AND precio.champs_PWF1 != 0
			)
          THEN 'true' ELSE 'false' END) as haveprecio
from SCHEMA2B.TAB_CARROS veh;


  BEGIN

  File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_FLAG  ','##Alim de la table SCHEMA2B.TAB_CARROS ##');


  FOR REC_CARROS IN C_carros
  LOOP

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD, 100)=0 THEN COMMIT;
        END IF;

        BEGIN
				Update  SCHEMA2B.TAB_CARROS
        Set     champs_FGT = REC_CARROS.champs_FGT,
                haveprecio = REC_CARROS.haveprecio
        where   COMP_CLE_PRIMAIRE          =      REC_CARROS.COMP_CLE_PRIMAIRE  ;

        V_UPD := V_UPD + 1;

        EXCEPTION  WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_FLAG  ','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_FLAG  ','Nombre de mises a jour : '||TO_CHAR(V_UPD));
   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_TAB_CARROS_FLAG;






--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
  FUNCTION UPDATE_CARROS_CONST_VAP (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;

  v_ES   VARCHAR2(5 BYTE);


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;

  Cursor C_MIXREFS_VAP Is
select
carros.COMP_CLE_PRIMAIRE AS COMP_CLE_PRIMAIRE,
REPLACE(REPLACE(LTRIM(RTRIM(cap.titre)), CHR(9),''),CHR(34),'')AS titre,  ----cap.titre AS titre
carros.bdCode AS bdCode,
carros.code_constr AS code_constr
from SCHEMA2B.TAB_CARROS veh, SCHEMA2B.TAB_CODIGOS_CONSTR_VAP cap
where  substr(carros.COMP_CLE_PRIMAIRE, 1, dimension_T2(carros.COMP_CLE_PRIMAIRE) -8) = 'P1' || cap.capa_ID  || substr(cap.LATEST_PARAM_2_YEAR, 0,4)  ||  (( cap.LATEST_PARAM_2_YEAR - floor(cap.LATEST_PARAM_2_YEAR) )*4+1)
and  carros.VH_type = 'VAP'
ORDER BY capa_ID, LATEST_PARAM_2_YEAR, EFFECTIVE_DATE, TITRE ;



  BEGIN

  File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'UPDATE_CARROS_CONST_VAP','## du code constructeur a la table SCHEMA2B.TAB_CARROS ##');



  FOR REC_MIXREFS_VAP IN C_MIXREFS_VAP
  LOOP


        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD, 100)=0 THEN COMMIT;
        END IF;

        ----40
        IF REC_MIXREFS_VAP.bdCode in ('AFI', 'AAL', 'AJE', 'ALN', 'AAB') THEN
            IF substr(REC_MIXREFS_VAP.code_constr,dimension_T2(REC_MIXREFS_VAP.code_constr)-2,3) = '000' THEN
                v_ES := 'false';
            ELSE
                v_ES := 'true';
            END IF;
        ELSE
            v_ES := NULL;
        END IF;


				Update  SCHEMA2B.TAB_CARROS
        Set
          code_constr          =      REC_MIXREFS_VAP.titre,
          champs_AN1     =      v_ES

        where COMP_CLE_PRIMAIRE          =      REC_MIXREFS_VAP.COMP_CLE_PRIMAIRE  ;

        V_UPD := V_UPD + 1;

        EXCEPTION WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'UPDATE_CARROS_CONST_VAP','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'UPDATE_CARROS_CONST_VAP','Nombre de mises a jour : '||TO_CHAR(V_UPD));
   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END UPDATE_CARROS_CONST_VAP;






  FUNCTION UPDATE_carro_BLAD_VAP (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;

  Cursor C_MIXREFS_VAP Is
select  distinct
COMP_CLE_PRIMAIRE as COMP_CLE_PRIMAIRE,
BLAD as BLAD,
SUBSTR(BLAD, 3, 2) as PARAM_2GenCode,
SUBSTR(BLAD, 9, 2) as trimCode
from SCHEMA2B.TAB_CARROS_init
where VH_type = 'VAP';



  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'UPDATE_carro_BLAD_VAP','## du code BLAD à la table SCHEMA2B.TAB_CARROS ##');


  FOR REC_MIXREFS_VAP IN C_MIXREFS_VAP
  LOOP


        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD, 100)=0 THEN COMMIT;
        END IF;



				Update  SCHEMA2B.TAB_CARROS
        Set
          BLAD          =      REC_MIXREFS_VAP.BLAD,
          PARAM_2GenCode = REC_MIXREFS_VAP.PARAM_2GenCode,
          trimCode = REC_MIXREFS_VAP.trimCode

        where COMP_CLE_PRIMAIRE          =      REC_MIXREFS_VAP.COMP_CLE_PRIMAIRE  ;

        V_UPD := V_UPD + 1;

        EXCEPTION WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'UPDATE_carro_BLAD_VAP','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'UPDATE_carro_BLAD_VAP','Nombre de mises a jour : '||TO_CHAR(V_UPD));
   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END UPDATE_carro_BLAD_VAP;





-----------------------------------------




FUNCTION EXPORT_CARROS_TXT(NOMLOG	VARCHAR2, P_DATE_TRAI	DATE, P_PATH    VARCHAR2, P_FILENAME  VARCHAR2) RETURN NUMBER AS

V_ERR                NUMBER := 0;
N_SAUV               NUMBER:=0;
v_ligne         VARCHAR2(4000);
file_id_cvs     utl_file.file_type;
file_name       VARCHAR2(30);

FILE_ID   UTL_FILE.FILE_TYPE;
RES       NUMBER := 0;

Cursor C_REC Is
     select
          null as carro_id,
          BLAD as BLAD,
          VLLLong as label_BLAD,
          'COUNTRY_INVENT' as country,
          bdCode as PARAM_1,
          CODE_CONSTR as carro_manufacturer_code,
          COMP_CODE_C as capa_code,
          tech_id as capa_id,
          null as option_code_manu,
          null as option_code_mato,
          null as option_label,
          to_char(ValStartDate,'YYYY-MM-DD') as ValStartDate,
          to_char(ValEndDate,'YYYY-MM-DD') as ValEndDate
          from  SCHEMA2B.TAB_CARROS
          where (champs_MJ = 'ENTERPRISE_ANONYM' or bdCode = 'LTB') 
          and substr(BLAD,16,1) != ' '
          and haveprecio = 'true';
          ---and nvl(carros.ValEndDate, SYSDATE) >= add_months(SYSDATE, -12)



	BEGIN
  file_name := p_filename;
  FILE_ID := SCHEMA3.PACKAGE_PRINT.Func_Open(NOMLOG);
  file_id_cvs:= SCHEMA3.PACKAGE_PRINT.Func_Open_CVS(p_path,file_name);
  RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'EXPORT_CARROS_TXT', ' ## MISE A DISPOSITION du fichier ##');

---- V_LIGNE := 'carro_id;BLAD;label_BLAD;country;PARAM_1;carro_manufacturer_code;capa_code;capa_id;option_code_manu;option_code_mato;option_label';

----  RES := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS (file_id_cvs, V_LIGNE);
  FOR REC IN C_REC LOOP

      BEGIN
           IF V_ERR=1 THEN
              EXIT;
           END IF;
                       V_LIGNE :=
                              REC.carro_id|| ';' ||
                              REC.BLAD|| ';' ||
                              RECchamps_EX4_BLAD || ';' ||
                              REC.country|| ';' ||
                              REC.PARAM_1|| ';' ||
                              REC.carro_manufacturer_code|| ';' ||
                              REC.capa_code || ';' ||
                              REC.capa_id || ';' ||
                              REC.option_code_manu|| ';' ||
                              REC.option_code_mato|| ';' ||
                              REC.option_label || ';' ||
                              REC.ValStartDate || ';' ||
                              REC.ValEndDate ;


  res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS(file_id_cvs, v_ligne);

            N_SAUV := N_SAUV + 1;
			EXCEPTION
      WHEN OTHERS THEN
                COMMIT;
                V_ERR  := 1;
                res     := SCHEMA3.PACKAGE_PRINT.Func_Write(file_id,
                                          'EXPORT_CARROS_TXT ',
                                         'Message Erreur pl/sql : ' ||
                                         SQLERRM );
                                         RETURN V_ERR;
      END;
  END LOOP;


	UTL_FILE.FCLOSE(file_id_cvs);

  res := SCHEMA3.PACKAGE_PRINT.Func_Write(file_id, 'EXPORT_CARROS_TXT', 'Nombre de lignes ?crites :' || N_SAUV);

  UTL_FILE.FCLOSE(file_id);

    RETURN V_ERR;

EXCEPTION WHEN OTHERS THEN
COMMIT;
          V_ERR  := 1;

          res     := SCHEMA3.PACKAGE_PRINT.Func_Write(file_id,
                                          'EXPORT_CARROS_TXT',
                                         'Message Erreur pl/sql : ' ||
                                         SQLERRM);
          RETURN V_ERR;

END EXPORT_CARROS_TXT;




FUNCTION EXPORT_TABNOMEN_TXT(NOMLOG	VARCHAR2, P_DATE_TRAI	DATE, P_PATH    VARCHAR2, P_FILENAME  VARCHAR2) RETURN NUMBER AS

V_ERR                NUMBER := 0;
N_SAUV               NUMBER:=0;
v_ligne         VARCHAR2(4000);
file_id_cvs     utl_file.file_type;
file_name       VARCHAR2(30);

FILE_ID   UTL_FILE.FILE_TYPE;
RES       NUMBER := 0;
--V_NB_BO_ATTENDU NUMBER(2) := 0;
--V_NB_BO_PA      NUMBER(2) := 0;
--V_PASSAGE        NUMBER(2)  := NULL;

Cursor C_REC Is
     select
          ENTITY as entity,
          CODE as code,
          start_Val_Date as validity_start_date,
          start_End_Date as validity_end_date,
          (case when champs_PC = ' ' then null else champs_PC end) as champs_PC,
          (case when champs_MA2_champs_EX3 = ' ' then null else champs_MA2_champs_EX3 end) as champs_MA2_champs_EX3,
          champs_MA2_LABEL as champs_MA2_label,
          NULL as mixref_type_code,
          NULL as champs_TP2,
          NULL as champs_TP3,
          (case when traco_champs_EX3 = ' ' then null else traco_champs_EX3 end) as traco_champs_EX3,
          traco_LABEL as traco
          from TAB_PARAM_NOMEN;


	BEGIN
  file_name := p_filename;
  FILE_ID := SCHEMA3.PACKAGE_PRINT.Func_Open(NOMLOG);
  file_id_cvs:= SCHEMA3.PACKAGE_PRINT.Func_Open_CVS(p_path,file_name);
  RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'EXPORT_TABNOMEN_TXT', ' ## MISE A DISPOSITION du fichier ##');

---- V_LIGNE := 'entity;code;validity_start_date ;validity_end_date;champs_PC;champs_MA2_champs_EX3;champs_MA2_label;mixref_type_code ;champs_TP2;champs_TP3;traco_champs_EX3;traco';
----  RES := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS (file_id_cvs, V_LIGNE);
  FOR REC IN C_REC LOOP

      BEGIN
           IF V_ERR=1 THEN
              EXIT;
           END IF;
                       V_LIGNE :=
          REC.etty|| ';' ||
          REC.code|| ';' ||
          REC.validity_start_date || ';' ||
          REC.validity_end_date|| ';' ||
          REC.champs_PC|| ';' ||
          REC.champs_MA2_champs_EX3|| ';' ||
          REC.champs_MA2_label|| ';' ||
          REC.mixref_type_code || ';' ||
          REC.champs_TP2|| ';' ||
          REC.champs_TP3|| ';' ||
          REC.traco_champs_EX3|| ';' ||
          REC.traco ;


  res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS(file_id_cvs, v_ligne);

            N_SAUV := N_SAUV + 1;
			EXCEPTION
      WHEN OTHERS THEN
                COMMIT;
                V_ERR  := 1;
                res     := SCHEMA3.PACKAGE_PRINT.Func_Write(file_id,
                                          'EXPORT_TABNOMEN_TXT ',
                                         'Message Erreur pl/sql : ' ||
                                         SQLERRM );
                                         RETURN V_ERR;
      END;
  END LOOP;


	UTL_FILE.FCLOSE(file_id_cvs);

   res := SCHEMA3.PACKAGE_PRINT.Func_Write(file_id, 'EXPORT_TABNOMEN_TXT', 'Nombre de lignes ?crites :' || N_SAUV);


  UTL_FILE.FCLOSE(file_id);

    RETURN V_ERR;

EXCEPTION WHEN OTHERS THEN
COMMIT;
          V_ERR  := 1;

          res     := SCHEMA3.PACKAGE_PRINT.Func_Write(file_id,
                                          'EXPORT_TABNOMEN_TXT',
                                         'Message Erreur pl/sql : ' ||
                                         SQLERRM);
          RETURN V_ERR;

END EXPORT_TABNOMEN_TXT;


FUNCTION FONC_EXPORT_CARRO_JSON (NOMLOG varchar2,P_DATE_TRAI date, P_PATH VARCHAR2, P_FILENAME VARCHAR2) return number IS
    V_ERR       number:=0;
    N_SAUV      NUMBER := 0;
    FILE_ID     UTL_FILE.FILE_TYPE;
    FILE_ID_CVS UTL_FILE.FILE_TYPE;
    V_LIGNE     VARCHAR2(4000);
    RES         NUMBER := 0;
    file_name   VARCHAR2(30);

    V_NB_ENREG  NUMBER := 0;
    V_NB_MIXREFS NUMBER(3);
    V_NB_PRIX NUMBER(5);
    V_NB_OPCIONES NUMBER(5);
    V_NB_OPCIONESLABELS NUMBER(5);
    V_NB_OPCIONESPRIX NUMBER(5);
    V_NB_EQUIPOS NUMBER(5);
    V_NB_AGREGADOSOPT NUMBER(5); --- 21
    V_NB_AGGOPTLABEL NUMBER(5); --- 29

    V_NB_ENREG_TRAITE NUMBER := 0;
    V_NB_MIXREFS_TRAITE NUMBER := 0;
    V_NB_PRIX_TRAITE NUMBER := 0;
    V_NB_OPCIONES_TRAITE NUMBER := 0;
    V_NB_OPCIONESLABELS_TRAITE NUMBER := 0;
    V_NB_OPCIONESPRIX_TRAITE NUMBER := 0;
    V_NB_EQUIPOS_TRAITE NUMBER := 0;
    V_NB_AGREGADOSOPT_TRAITE NUMBER := 0; --- 21
    V_NB_AGGOPTLABEL_TRAITE NUMBER := 0; --- 29

-----------------------carro-----------------
CURSOR C_TAB_CARROS IS
select
tech_id as tech_id,
tech_dateExtract as tech_dateExtract,
tech_dateInsert as tech_dateInsert,
countryCode as countryCode,
COMP_CLE_PRIMAIRE as COMP_CLE_PRIMAIRE,
VersState as VersState,
TO_CHAR(ValStartDate,'YYYY-MM-DD') as ValStartDate,
(CASE WHEN TO_CHAR(ValEndDate,'YYYY-MM-DD') is null then '9999-12-31' else TO_CHAR(ValEndDate,'YYYY-MM-DD')  end) as ValEndDate,
champs_MQ as champs_MQ,
champs_MJ as champs_MJ,
bdCode as bdCode,
bdLabel as bdLabel,
famCode as famCode,
famLabel as famLabel,
gener as gener,
VersYear as VersYear,
VersTrimester as VersTrimester,
champs_MK as champs_MK,
champs_FL as champs_FL,
KATcode as KATcode,
PARAM_4Code as PARAM_4Code,
dimension_T1 as dimension_T1,
dimension_T2 as dimension_T2,
champs_ASP as champs_ASP,
champs_NC as champs_NC,
champs_NCA as champs_NCA,
champs_TY as champs_TY,
champs_PKI as champs_PKI,
champs_FT as champs_FT,
champs_FD as champs_FD,
champs_ETY as champs_ETY,
champs_EN1 as champs_EN1,
champs_EN2 as champs_EN2,
champs_EN3 as champs_EN3,
ener_code123 as ener_code123,
champs_ALT as champs_ALT,
motor as motor,
motorComb as motorComb,
cubicCap as cubicCap,
champs_ARE as champs_ARE,
champs_code123 as champs_code123,
champs_ATR as champs_ATR,
champs_AVR as champs_AVR,
champs_ATT as champs_ATT,
seatNB as seatNB,
doorNB as doorNB,
champs_ACT as champs_ACT,
champs_AX as champs_AX,
champs_AB as champs_AB,
champs_AP as champs_AP,
champs_HP as champs_HP,
champs_HY as champs_HY,
champs_HI as champs_HI,
champs_HB as champs_HB,
champs_HM as champs_HM,
champs_HW as champs_HW,
BaCap as BaCap,
champs_WQ as champs_WQ,
champs_WZ as champs_WZ,
champs_DE as champs_DE,
Tele as Tele,
champs_RT as champs_RT,
champs_NB1 as champs_NB1,
champs_FGG as champs_FGG,
champs_FGT as champs_FGT,
VALID_User as VALID_User,
VALID_Date as VALID_Date,
updateUser as updateUser,
updateDate as updateDate,
champs_AY as champs_AY,
champs_BC as champs_BC,
champs_SH as champs_SH,
VLGShort as VLGShort,
VLGLong as VLGLong,
VLLShort as VLLShort,
VLLLong as VLLLong,
VH_TYPE as VH_TYPE,
champs_AN1 as champs_AN1,
PARAM_2GenCode as PARAM_2GenCode, -- 38
trimCode as trimCode
from SCHEMA2B.TAB_CARROS
where substr(BLAD,16,1) != ' '
and haveprecio = 'true'; 
-----------------------MIXREFS-----------------
CURSOR C_TAB_CARROS_MIXREFS (P_COMP_CLE_PRIMAIRE  VARCHAR2) IS
SELECT * FROM SCHEMA2B.TAB_CARROS_MIXREFS MIXREFS
WHERE MIXREFS.COMP_CLE_PRIMAIRE = P_COMP_CLE_PRIMAIRE
AND    MIXREFS.ident IS NOT NULL
;

-----------------------PRIX-----------------
CURSOR C_TAB_CARROS_PRIX (P_COMP_CLE_PRIMAIRE  VARCHAR2) IS
select
champs_P1A as champs_P1A,
champs_P1B as champs_P1B,
champs_P1C as champs_P1C,
champs_D1A as champs_D1A,
TO_CHAR(champs_D1B,'YYYY-MM-DD') as champs_D1B,
(CASE WHEN TO_CHAR(champs_D1C,'YYYY-MM-DD') is null then '9999-12-31' else TO_CHAR(champs_D1C,'YYYY-MM-DD')  end) as champs_D1C,
champs_P as champs_P,
champs_PWF1 as champs_PWF1,
champs_PWF2 as champs_PWF2,
champs_PWF3 as champs_PWF3,
moneda as moneda,
champs_AMT as champs_AMT,
champs_AMG as champs_AMG,
VAL_Amount as VAL_Amount,
VAL_Rate as VAL_Rate,
champs_PP1 as champs_PP1,
champs_PP2 as champs_PP2,
champs_PP3 as champs_PP3
from SCHEMA2B.TAB_CARROS_PRIX PRIX
WHERE PRIX.COMP_CLE_PRIMAIRE =  P_COMP_CLE_PRIMAIRE ;
-----------------------OPCIONES-----------------
CURSOR C_TAB_CARROS_OPCIONES(P_COMP_CLE_PRIMAIRE VARCHAR2 ) IS
SELECT distinct
COMP_CLE_PRIMAIRE as COMP_CLE_PRIMAIRE,
code as code,
champs_CA1 as champs_CA1,
champs_CA2 as champs_CA2,
Packi as Packi,
Present_YN as Present_YN,
TO_CHAR(startDate,'YYYY-MM-DD') as startDate,
(CASE WHEN TO_CHAR(endDate,'YYYY-MM-DD') is null then '9999-12-31' else TO_CHAR(endDate,'YYYY-MM-DD')  end) as endDate,
startDate AS OPCIONEStartDate
from SCHEMA2B.TAB_CARROS_OPCIONES OPCIONES
WHERE OPCIONES.COMP_CLE_PRIMAIRE = P_COMP_CLE_PRIMAIRE;
-----------------------OPCIONESLABELS-----------------
CURSOR C_TAB_OPCIONESLABELS(P_Code VARCHAR2, P_COMP_CLE_PRIMAIRE VARCHAR2 ) IS
SELECT
COMP_CLE_PRIMAIRE as COMP_CLE_PRIMAIRE,
code as code,
champs_EX3 as champs_EX3,
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(labelShort, '\', '\\'), '"', '\"'), CHR(9), ''), CHR(13), ''), CHR(29), '') AS labelShort,
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(labelLong, '\', '\\'), '"', '\"'), CHR(9), ''), CHR(13), ''), CHR(29), '') AS labelLong
FROM SCHEMA2B.TAB_CARROS_OPCIONESLABELS OPCIONESLABELS
WHERE OPCIONESLABELS.Code = P_Code
AND   OPCIONESLABELS.COMP_CLE_PRIMAIRE = P_COMP_CLE_PRIMAIRE;
-----------------------OPCIONESPRIX-----------------
CURSOR C_TAB_OPCIONESPRIX (P_Code VARCHAR2, P_COMP_CLE_PRIMAIRE VARCHAR2, P_champs_D1B DATE ) IS ---  P_champs_D1B 16 01 2023
SELECT
COMP_CLE_PRIMAIRE as COMP_CLE_PRIMAIRE,
code as code,
champs_CA5 as champs_CA5,
champs_P1B as champs_P1B,
champs_P1C as champs_P1C,
champs_D1A as champs_D1A,
TO_CHAR(champs_D1B, 'YYYY-MM-DD') as champs_D1B,
(CASE WHEN TO_CHAR(champs_D1C,'YYYY-MM-DD') is null then '9999-12-31' else TO_CHAR(champs_D1C,'YYYY-MM-DD')  end) as champs_D1C,
champs_P as champs_P,
moneda as moneda,
champs_PWF1 as champs_PWF1,
champs_PWF2 as champs_PWF2,
champs_PWF3 as champs_PWF3,
champs_BS1 as champs_BS1,
champs_BS2 as champs_BS2,
champs_BS3 as champs_BS3
FROM SCHEMA2B.TAB_CARROS_OPCIONESPRIX OPCIONESPRIX
WHERE OPCIONESPRIX.Code = P_Code
AND OPCIONESPRIX.COMP_CLE_PRIMAIRE = P_COMP_CLE_PRIMAIRE
AND OPCIONESPRIX.champs_D1B = P_champs_D1B  
;
-----------------------EQUIP-----------------
CURSOR C_TAB_CARROS_EQUIPOS (P_COMP_CLE_PRIMAIRE VARCHAR2) IS
SELECT * FROM SCHEMA2B.TAB_CARROS_EQUIPOS EQUIP
WHERE  EQUIP.COMP_CLE_PRIMAIRE = P_COMP_CLE_PRIMAIRE;
-----------------------AGREGADOSOPT-----------------
CURSOR C_TAB_CARROS_AGREGADOSOPT (P_COMP_CLE_PRIMAIRE VARCHAR2) IS
SELECT * FROM SCHEMA2B.TAB_CARROS_AGREGADOSOPT AGREGADOSOPT
WHERE  AGREGADOSOPT.COMP_CLE_PRIMAIRE = P_COMP_CLE_PRIMAIRE;
-----------------------AGREGADOSOptLab-----------------
CURSOR C_TAB_AGREGADOSOptLab (P_COMP_CLE_PRIMAIRE VARCHAR2,  P_CODE VARCHAR2) IS
SELECT
TECH_ID AS TECH_ID,
COMP_CLE_PRIMAIRE AS COMP_CLE_PRIMAIRE,
CODE AS CODE,
VH_TYPE AS VH_TYPE,
'en_ANONYM' AS champs_EX3,
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(champs_MA1, '\', '\\'), '"', '\"'), CHR(9), ''), CHR(13), ''), CHR(29), '') AS champs_MA1
FROM SCHEMA2B.TAB_CARROS_AGREGADOSOptLab  AGREGADOSOptLab
WHERE  AGREGADOSOptLab.COMP_CLE_PRIMAIRE = P_COMP_CLE_PRIMAIRE
AND    AGREGADOSOptLab.CODE =P_CODE;



BEGIN
  file_name := p_filename;
  FILE_ID := SCHEMA3.PACKAGE_PRINT.Func_Open(NOMLOG);
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'FONC_EXPORT_CARRO_JSON', ' ## EXPORT VEH ' ||  ' ##');
  file_id_cvs:= SCHEMA3.PACKAGE_PRINT.Func_Open_CVS_UTF8(p_path,file_name);

 -----------------------carro-----------------
  BEGIN
       SELECT COUNT(*)
       INTO   V_NB_ENREG
       FROM   SCHEMA2B.TAB_CARROS ;
  EXCEPTION WHEN OTHERS THEN
       V_NB_ENREG := 0;
  END;

      V_LIGNE := '[';
      res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
      FOR S_TAB_CARROS IN C_TAB_CARROS LOOP

      IF  MOD(V_NB_ENREG_TRAITE,1000) = 0 THEN  res := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'V_NB_ENREG_TRAITE :=', TO_CHAR(V_NB_ENREG_TRAITE)); END IF;

      IF  V_NB_ENREG_TRAITE > 0 THEN  V_LIGNE := ',' ; res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE); END IF; --- a la fin de la boucle apres le 1 element

      V_NB_MIXREFS_TRAITE := 0;
      V_NB_PRIX_TRAITE := 0;
      V_NB_OPCIONES_TRAITE := 0;
      V_NB_EQUIPOS_TRAITE := 0;
      V_NB_AGREGADOSOPT_TRAITE :=0;
      BEGIN
              V_NB_ENREG_TRAITE := V_NB_ENREG_TRAITE+1;
              V_LIGNE := '{
"tech_id":"' || UPPER(REPLACE(S_TAB_CARROS.tech_id, '"','')) || '",';



V_LIGNE := V_LIGNE || '"countryCode":"' || UPPER(REPLACE(S_TAB_CARROS.countryCode, '"','')) || '",';
V_LIGNE := V_LIGNE || '"COMP_CLE_PRIMAIRE":"' || UPPER(REPLACE(S_TAB_CARROS.COMP_CLE_PRIMAIRE, '"','')) || '",';


V_LIGNE := V_LIGNE || '"ValStartDate":"' || S_TAB_CARROS.ValStartDate || '",';
V_LIGNE := V_LIGNE || '"ValEndDate":"' || S_TAB_CARROS.ValEndDate || '", ';



IF S_TAB_CARROS.champs_MJ != ' ' THEN
V_LIGNE := V_LIGNE || '"champs_MJ":"' ||  UPPER(REPLACE(S_TAB_CARROS.champs_MJ, '"','')) || '",';

END IF;

V_LIGNE := V_LIGNE || '"bdCode":"' ||  UPPER(REPLACE(S_TAB_CARROS.bdCode, '"','')) || '",';
V_LIGNE := V_LIGNE || '"bdLabel":"' ||  UPPER(REPLACE(S_TAB_CARROS.bdLabel, '"','')) || '",';
V_LIGNE := V_LIGNE || '"famCode":"' ||  UPPER(REPLACE(S_TAB_CARROS.famCode, '"','')) || '",';
V_LIGNE := V_LIGNE || '"famLabel":"' ||  UPPER(REPLACE(S_TAB_CARROS.famLabel, '"','')) || '",';


IF S_TAB_CARROS.gener is not null THEN
V_LIGNE := V_LIGNE || '"gener":"' || S_TAB_CARROS.gener || '",';

END IF;

V_LIGNE := V_LIGNE || '"VersYear":"' || S_TAB_CARROS.VersYear || '",';
V_LIGNE := V_LIGNE || '"VersTrimester":"' || S_TAB_CARROS.VersTrimester || '",';


IF S_TAB_CARROS.champs_MK is not null THEN
V_LIGNE := V_LIGNE || '"champs_MK":"' ||  UPPER(REPLACE(S_TAB_CARROS.champs_MK, '"','')) || '",';

END IF;

IF S_TAB_CARROS.champs_FL is not null THEN
V_LIGNE := V_LIGNE || '"champs_FL":"' || S_TAB_CARROS.champs_FL || '",';

END IF;

V_LIGNE := V_LIGNE || '"KATcode":"' ||  UPPER(REPLACE(S_TAB_CARROS.KATcode, '"','')) || '",';
V_LIGNE := V_LIGNE || '"PARAM_4Code":"' ||  UPPER(REPLACE(S_TAB_CARROS.PARAM_4Code, '"','')) || '",';



IF S_TAB_CARROS.dimension_T1 is not null THEN
V_LIGNE := V_LIGNE || '"dimension_T1":"' || S_TAB_CARROS.dimension_T1 || '",';

END IF;

IF S_TAB_CARROS.dimension_T2 is not null THEN
V_LIGNE := V_LIGNE || '"dimension_T2":"' || S_TAB_CARROS.dimension_T2 || '",';

END IF;


IF S_TAB_CARROS.champs_NCA is not null THEN
V_LIGNE := V_LIGNE || '"champs_NCA":"' || S_TAB_CARROS.champs_NCA || '",';

END IF;


IF S_TAB_CARROS.champs_FT is not null THEN
V_LIGNE := V_LIGNE || '"champs_FT":"' || S_TAB_CARROS.champs_FT || '",';

END IF;

IF S_TAB_CARROS.champs_FD is not null THEN
V_LIGNE := V_LIGNE || '"champs_FD":"' || S_TAB_CARROS.champs_FD || '",';

END IF;

IF S_TAB_CARROS.champs_ETY is not null THEN
V_LIGNE := V_LIGNE || '"champs_ETY":"' || UPPER(REPLACE(S_TAB_CARROS.champs_ETY, '"','')) || '",';

END IF;


V_LIGNE := V_LIGNE || '"ener_code123":"' ||  UPPER(REPLACE(S_TAB_CARROS.ener_code123, '"','')) || '",';
V_LIGNE := V_LIGNE || '"champs_ALT":"' ||  UPPER(REPLACE(S_TAB_CARROS.champs_ALT, '"','')) || '",';



IF S_TAB_CARROS.cubicCap is not null THEN
V_LIGNE := V_LIGNE || '"cubicCap":"' || S_TAB_CARROS.cubicCap || '",';

END IF;

IF S_TAB_CARROS.champs_ARE is not null THEN
V_LIGNE := V_LIGNE || '"champs_ARE":"' ||  UPPER(REPLACE(S_TAB_CARROS.champs_ARE, '"','')) || '",';

END IF;

V_LIGNE := V_LIGNE || '"champs_code123":"' ||  UPPER(REPLACE(S_TAB_CARROS.champs_code123, '"','')) || '",';


IF S_TAB_CARROS.champs_ATR is not null THEN
V_LIGNE := V_LIGNE || '"champs_ATR":"' || S_TAB_CARROS.champs_ATR || '",';

END IF;



IF S_TAB_CARROS.champs_ATT is not null THEN
V_LIGNE := V_LIGNE || '"champs_ATT":"' ||  UPPER(REPLACE(S_TAB_CARROS.champs_ATT, '"','')) || '",';

END IF;

IF S_TAB_CARROS.seatNB is not null THEN
V_LIGNE := V_LIGNE || '"seatNB":"' || S_TAB_CARROS.seatNB || '",';

END IF;

IF S_TAB_CARROS.doorNB is not null THEN
V_LIGNE := V_LIGNE || '"doorNB":"' || S_TAB_CARROS.doorNB || '",';

END IF;



IF S_TAB_CARROS.champs_AP is not null THEN
V_LIGNE := V_LIGNE || '"champs_AP":"' || S_TAB_CARROS.champs_AP || '",';

END IF;

IF S_TAB_CARROS.champs_HP is not null THEN
V_LIGNE := V_LIGNE || '"champs_HP":"' || S_TAB_CARROS.champs_HP || '",';

END IF;

IF S_TAB_CARROS.champs_HY is not null THEN
V_LIGNE := V_LIGNE || '"champs_HY":"' || S_TAB_CARROS.champs_HY || '",';

END IF;

IF S_TAB_CARROS.champs_HI is not null THEN
V_LIGNE := V_LIGNE || '"champs_HI":"' || S_TAB_CARROS.champs_HI || '",';

END IF;

IF S_TAB_CARROS.champs_HB is not null THEN
V_LIGNE := V_LIGNE || '"champs_HB":"' || S_TAB_CARROS.champs_HB || '",';

END IF;

IF S_TAB_CARROS.champs_HM is not null THEN
V_LIGNE := V_LIGNE || '"champs_HM":"' || S_TAB_CARROS.champs_HM || '",';

END IF;

IF S_TAB_CARROS.champs_HW is not null THEN
V_LIGNE := V_LIGNE || '"champs_HW":"' || S_TAB_CARROS.champs_HW || '",';

END IF;

IF S_TAB_CARROS.BaCap is not null THEN
V_LIGNE := V_LIGNE || '"BaCap":"' || S_TAB_CARROS.BaCap || '",';

END IF;

IF S_TAB_CARROS.champs_WQ is not null THEN
V_LIGNE := V_LIGNE || '"champs_WQ":"' || S_TAB_CARROS.champs_WQ || '",';

END IF;

IF S_TAB_CARROS.champs_WZ is not null THEN
V_LIGNE := V_LIGNE || '"champs_WZ":"' || S_TAB_CARROS.champs_WZ || '",';

END IF;


IF S_TAB_CARROS.champs_DE is not null THEN
V_LIGNE := V_LIGNE || '"champs_DE":"' || S_TAB_CARROS.champs_DE || '",';

END IF;


V_LIGNE := V_LIGNE || '"Tele":' ||  LOWER(REPLACE(S_TAB_CARROS.Tele, '"','')) || ',';

IF S_TAB_CARROS.champs_AN1 IS NOT NULL THEN
V_LIGNE := V_LIGNE || '"champs_AN1":' ||  LOWER(S_TAB_CARROS.champs_AN1) || ',';
END IF;
V_LIGNE := V_LIGNE || '"champs_FGT":' ||  LOWER(S_TAB_CARROS.champs_FGT) || ',';
V_LIGNE := V_LIGNE || '"VLLShort":"' ||  UPPER(REPLACE(S_TAB_CARROS.VLLShort, '"','')) || '",';
V_LIGNE := V_LIGNE || '"VLLLong":"' ||  UPPER(REPLACE(S_TAB_CARROS.VLLLong, '"',''))  || '",';   
V_LIGNE := V_LIGNE || '"PARAM_2GenCode":"' ||  S_TAB_CARROS.PARAM_2GenCode  || '",';
V_LIGNE := V_LIGNE || '"trimCode":"' ||  S_TAB_CARROS.trimCode  || '"';

res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);

    -----------------------MIXREFS-----------------
    BEGIN
         SELECT COUNT(*)
         INTO   V_NB_MIXREFS
         FROM   SCHEMA2B.TAB_CARROS_MIXREFS MIXREFS
         WHERE  MIXREFS.COMP_CLE_PRIMAIRE = S_TAB_CARROS.COMP_CLE_PRIMAIRE
         AND    MIXREFS.ident IS NOT NULL;
    EXCEPTION WHEN OTHERS THEN
              V_NB_MIXREFS := NULL;
    END;

    IF NVL(V_NB_MIXREFS, 0) > 0 THEN

       V_LIGNE := ', "MIXREFS": [';

       FOR S_TAB_CARROS_MIXREFS IN C_TAB_CARROS_MIXREFS (S_TAB_CARROS.COMP_CLE_PRIMAIRE) LOOP
            V_NB_MIXREFS_TRAITE := V_NB_MIXREFS_TRAITE+1;   

            IF S_TAB_CARROS_MIXREFS.ident is not NULL THEN   ------  if constr vide alors on affiche rien
            V_LIGNE := V_LIGNE || '{"identType":"' ||  UPPER(REPLACE(S_TAB_CARROS_MIXREFS.identType, '"',''))  || '",';
                V_LIGNE := V_LIGNE || '"ident":"' ||  UPPER(REPLACE(S_TAB_CARROS_MIXREFS.ident, '"',''))  || '"';

                IF S_TAB_CARROS_MIXREFS.bdCodeSource IS NOT NULL THEN
                V_LIGNE := V_LIGNE || ',"bdCodeSource":"' || S_TAB_CARROS_MIXREFS.bdCodeSource  || '"';
                END IF;
                IF S_TAB_CARROS_MIXREFS.champs_AN1 IS NOT NULL THEN
                V_LIGNE := V_LIGNE || ',"champs_AN1":"' || S_TAB_CARROS_MIXREFS.champs_AN1 || '"';
                END IF;

                if V_NB_MIXREFS_TRAITE = V_NB_MIXREFS THEN V_LIGNE := V_LIGNE || '}';
                else V_LIGNE := V_LIGNE || '},';
                end if;

            

            END IF;
       END LOOP;
       V_LIGNE := V_LIGNE || ']';      ---------   virgule ee dans la boucle suivant
       res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
    END IF;
    V_LIGNE := '';  -------- null

    -----------------------PRIX-----------------
    BEGIN
         SELECT  COUNT(*)
         INTO   V_NB_PRIX
         FROM   SCHEMA2B.TAB_CARROS_PRIX PRIX
         WHERE  PRIX.COMP_CLE_PRIMAIRE =  S_TAB_CARROS.COMP_CLE_PRIMAIRE;
    EXCEPTION WHEN OTHERS THEN
              V_NB_PRIX := NULL;
    END;

    IF NVL(V_NB_PRIX, 0) > 0 THEN

        V_LIGNE := ', "PRIX": [';
        

        FOR S_TAB_CARROS_PRIX IN C_TAB_CARROS_PRIX (S_TAB_CARROS.COMP_CLE_PRIMAIRE) LOOP
            V_NB_PRIX_TRAITE := V_NB_PRIX_TRAITE+1;   
            V_LIGNE := V_LIGNE || '{"champs_D1B":"' || S_TAB_CARROS_PRIX.champs_D1B || '",';
                

                IF S_TAB_CARROS_PRIX.champs_D1C is not null THEN
                V_LIGNE := V_LIGNE || '"champs_D1C":"' || S_TAB_CARROS_PRIX.champs_D1C || '",';
                
                END IF;

                V_LIGNE := V_LIGNE || '"champs_PWF1":' || REPLACE(S_TAB_CARROS_PRIX.champs_PWF1,',','.') || ',';

                V_LIGNE := V_LIGNE || '"moneda":"' ||  UPPER(REPLACE(S_TAB_CARROS_PRIX.moneda, '"','')) || '",';
                V_LIGNE := V_LIGNE || '"champs_PP1":' || REPLACE(S_TAB_CARROS_PRIX.champs_PP1,',','.') || '';


                if V_NB_PRIX_TRAITE = V_NB_PRIX THEN V_LIGNE := V_LIGNE || '}';
                else V_LIGNE := V_LIGNE || '},';
                end if;

            
        END LOOP;
        V_LIGNE := V_LIGNE || ']'; ---------   virgule ee dans la boucle suivant
        res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);

    END IF;
    V_LIGNE := '';  -------- null

    -----------------------OPCIONES-----------------
    BEGIN
         SELECT COUNT(*)
         INTO   V_NB_OPCIONES
         FROM   SCHEMA2B.TAB_CARROS_OPCIONES OPCIONES
         WHERE  OPCIONES.COMP_CLE_PRIMAIRE =  S_TAB_CARROS.COMP_CLE_PRIMAIRE;
    EXCEPTION WHEN OTHERS THEN
              V_NB_OPCIONES := NULL;
    END;

    IF NVL(V_NB_OPCIONES, 0) > 0 THEN

        V_LIGNE := ', "OPCIONES": [';
        res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);


        FOR S_TAB_CARROS_OPCIONES IN C_TAB_CARROS_OPCIONES (S_TAB_CARROS.COMP_CLE_PRIMAIRE) LOOP

            V_NB_OPCIONES_TRAITE := V_NB_OPCIONES_TRAITE+1;   
            V_NB_OPCIONESLABELS_TRAITE := 0; --------- POUR LA BOUCLE OPCIONESLABELS
            V_NB_OPCIONESPRIX_TRAITE := 0;-------- POUR LA BOUCLE OPCIONESPRIX


            V_LIGNE := '{"code":"' ||  UPPER(REPLACE(S_TAB_CARROS_OPCIONES.code, '"','')) || '",';
            V_LIGNE := V_LIGNE || '"champs_CA1":"' ||  UPPER(REPLACE(S_TAB_CARROS_OPCIONES.code, '"','')) || '",';
            V_LIGNE := V_LIGNE || '"champs_CA2":"' ||  UPPER(REPLACE(S_TAB_CARROS_OPCIONES.champs_CA2, '"','')) || '",';
            V_LIGNE := V_LIGNE || '"Packi":' ||  LOWER(REPLACE(S_TAB_CARROS_OPCIONES.Packi, '"','')) || ',';
            V_LIGNE := V_LIGNE || '"startDate":"' ||  S_TAB_CARROS_OPCIONES.startDate || '",';

              

              IF S_TAB_CARROS_OPCIONES.endDate is not NULL THEN
                V_LIGNE := V_LIGNE || '"endDate":"' ||  S_TAB_CARROS_OPCIONES.endDate || '",';
              END IF;
            V_LIGNE := V_LIGNE || '"isAGREGADOS":' ||  LOWER(REPLACE(S_TAB_CARROS_OPCIONES.Present_YN, '"','')) || ','; --42
            


                ---------------------------------------------------------------
                ----------------------------------------------------------------

                    -----------------------OPCIONESLABELS-----------------
                    BEGIN
                        SELECT  COUNT(*)
                        INTO   V_NB_OPCIONESLABELS
                        FROM   SCHEMA2B.TAB_CARROS_OPCIONESLABELS OPCIONESLABELS
                        WHERE  OPCIONESLABELS.Code = S_TAB_CARROS_OPCIONES.code
                        AND    OPCIONESLABELS.COMP_CLE_PRIMAIRE = S_TAB_CARROS_OPCIONES.COMP_CLE_PRIMAIRE;

                    EXCEPTION WHEN OTHERS THEN
                            V_NB_OPCIONESLABELS := NULL;
                    END;

                    IF NVL(V_NB_OPCIONESLABELS, 0) > 0 THEN
                        V_LIGNE := V_LIGNE || '"labels": [';
                        


                        FOR S_TAB_OPCIONESLABELS IN C_TAB_OPCIONESLABELS (S_TAB_CARROS_OPCIONES.code, S_TAB_CARROS.COMP_CLE_PRIMAIRE) LOOP
                            V_NB_OPCIONESLABELS_TRAITE := V_NB_OPCIONESLABELS_TRAITE+1;   
                            V_LIGNE := V_LIGNE || '{"champs_EX3":"' ||  REPLACE(S_TAB_OPCIONESLABELS.champs_EX3, '"','') || '",';
                            V_LIGNE := V_LIGNE || '"labelShort":"' ||  UPPER(S_TAB_OPCIONESLABELSchamps_EX4Short) || '",';
                            V_LIGNE := V_LIGNE || '"labelLong":"' ||  UPPER(S_TAB_OPCIONESLABELSchamps_EX4Long) || '"';

                            if V_NB_OPCIONESLABELS_TRAITE = V_NB_OPCIONESLABELS THEN V_LIGNE := V_LIGNE || '}';
                            else V_LIGNE := V_LIGNE || '},';
                            end if;

                            
                        END LOOP;
                        V_LIGNE := V_LIGNE || '],';
                        
                    END IF;

                    ---------  ---------- --------  ---------   ---------   ---------   ---------  ---------   ---------  ---------  ---------

                   -- res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);    
                    -----------------------OPCIONESPRIX-----------------
                    BEGIN
                        SELECT  COUNT(*)
                        INTO   V_NB_OPCIONESPRIX
                        FROM   SCHEMA2B.TAB_CARROS_OPCIONESPRIX OPCIONESPRIX
                        WHERE  OPCIONESPRIX.Code = S_TAB_CARROS_OPCIONES.code
                        AND    OPCIONESPRIX.COMP_CLE_PRIMAIRE = S_TAB_CARROS_OPCIONES.COMP_CLE_PRIMAIRE
                        AND  OPCIONESPRIX.champs_D1B = S_TAB_CARROS_OPCIONES.OPCIONEStartDate; 

                    EXCEPTION WHEN OTHERS THEN
                            V_NB_OPCIONESPRIX := NULL;
                    END;

                    IF NVL(V_NB_OPCIONESPRIX, 0) > 0 THEN
                        V_LIGNE := V_LIGNE || '"PRIX": [';
                        


                        FOR S_TAB_OPCIONESPRIX IN C_TAB_OPCIONESPRIX (S_TAB_CARROS_OPCIONES.code, S_TAB_CARROS.COMP_CLE_PRIMAIRE, S_TAB_CARROS_OPCIONES.OPCIONEStartDate) LOOP  
                            V_NB_OPCIONESPRIX_TRAITE := V_NB_OPCIONESPRIX_TRAITE+1;   
                            V_LIGNE := V_LIGNE || '{"champs_D1B":"' || S_TAB_OPCIONESPRIX.champs_D1B || '",';
                                

                                IF S_TAB_OPCIONESPRIX.champs_D1C is not NULL THEN
                                V_LIGNE := V_LIGNE || '"champs_D1C":"' || S_TAB_OPCIONESPRIX.champs_D1C || '",';
                                
                                END IF;

                                V_LIGNE := V_LIGNE || '"moneda":"' ||  UPPER(REPLACE(S_TAB_OPCIONESPRIX.moneda, '"','')) || '",';
                                


                                V_LIGNE := V_LIGNE || '"champs_PWF1":' || REPLACE(S_TAB_OPCIONESPRIX.champs_PWF1,',','.') || '';

                                --


                            if V_NB_OPCIONESPRIX_TRAITE = V_NB_OPCIONESPRIX THEN V_LIGNE := V_LIGNE || '}';
                            else V_LIGNE := V_LIGNE || '},';
                            end if;

                            
                        END LOOP;
                        V_LIGNE := V_LIGNE || ']'; ----------MOI   JEUDI   --- sans virgule a la fin
                        
                    END IF;

          ----------------------------------------------------------------
          ----------------------------------------------------------------
            --V_LIGNE := ''; ----------MOI   JEUDI
            if V_NB_OPCIONES_TRAITE = V_NB_OPCIONES THEN V_LIGNE := V_LIGNE || '}';
            else V_LIGNE := V_LIGNE || '},';
            end if;

            res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);


        END LOOP;
        V_LIGNE := ']';
        res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
    END IF;
    V_LIGNE := '';  -------- null

    ---------------------------------------------------------
    -----------------------AGREGADOSOPT-----------------
     BEGIN
         SELECT  COUNT(*)
         INTO   V_NB_AGREGADOSOPT
         FROM   SCHEMA2B.TAB_CARROS_AGREGADOSOPT AGREGADOSOPT
         WHERE    AGREGADOSOPT.COMP_CLE_PRIMAIRE = S_TAB_CARROS.COMP_CLE_PRIMAIRE;
         ---AND  AGREGADOSOPT.Code = S_TAB_CARROS_OPCIONES.code

     EXCEPTION WHEN OTHERS THEN
             V_NB_AGREGADOSOPT := NULL;
     END;

     IF NVL(V_NB_AGREGADOSOPT, 0) > 0 THEN
         --V_LIGNE := ',' ; res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
         V_LIGNE := ', "AGREGADOSOPCIONES": [';
         res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
         V_LIGNE := '';

         FOR S_TAB_CARROS_AGREGADOSOPT IN C_TAB_CARROS_AGREGADOSOPT (S_TAB_CARROS.COMP_CLE_PRIMAIRE) LOOP
             V_NB_AGGOPTLABEL_TRAITE := 0; --------- POUR LA BOUCLE AGREGADOSOptLab

             IF MOD(V_NB_AGREGADOSOPT_TRAITE, 4) = 0 AND V_NB_AGREGADOSOPT_TRAITE <> 0 THEN
                 res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
                 V_LIGNE := '';
             END IF;
             V_NB_AGREGADOSOPT_TRAITE := V_NB_AGREGADOSOPT_TRAITE+1;   
             V_LIGNE := V_LIGNE || '{"code":"' || S_TAB_CARROS_AGREGADOSOPT.code || '",';
             V_LIGNE := V_LIGNE || '"cateCode":"' || S_TAB_CARROS_AGREGADOSOPT.cateCode || '",';
             V_LIGNE := V_LIGNE || '"moneda":"' || S_TAB_CARROS_AGREGADOSOPT.moneda || '",';
             V_LIGNE := V_LIGNE || '"champs_PWF1":' || REPLACE(S_TAB_CARROS_AGREGADOSOPT.champs_PWF1,',','.') || '';

-------------------------------------------------


    ---------------------------------------------------------
    -----------------------AGREGADOSOptLab-----------------
     BEGIN
         SELECT  COUNT(*)
         INTO   V_NB_AGGOPTLABEL
         FROM   SCHEMA2B.TAB_CARROS_AGREGADOSOptLab AGREGADOSOptLab
         WHERE    AGREGADOSOptLab.COMP_CLE_PRIMAIRE = S_TAB_CARROS.COMP_CLE_PRIMAIRE
         AND     AGREGADOSOptLab.Code = S_TAB_CARROS_AGREGADOSOPT.code;

     EXCEPTION WHEN OTHERS THEN
             V_NB_AGGOPTLABEL := NULL;
     END;

     IF NVL(V_NB_AGGOPTLABEL, 0) > 0 THEN
         --V_LIGNE := ',' ; res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
         V_LIGNE := V_LIGNE || ', "labels": [';
         -
         ---V_LIGNE := '';

         FOR S_AGREGADOSOptLab IN C_TAB_AGREGADOSOptLab (S_TAB_CARROS.COMP_CLE_PRIMAIRE, S_TAB_CARROS_AGREGADOSOPT.code ) LOOP
             IF MOD(V_NB_AGGOPTLABEL_TRAITE, 4) = 0 AND V_NB_AGGOPTLABEL_TRAITE <> 0 THEN
                 res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
                 V_LIGNE := '';
             END IF;
             V_NB_AGGOPTLABEL_TRAITE := V_NB_AGGOPTLABEL_TRAITE+1;
             V_LIGNE := V_LIGNE || '{"champs_EX3":"' || S_AGREGADOSOptLab.champs_EX3 || '",';
             V_LIGNE := V_LIGNE || '"label":"' || S_AGREGADOSOptLab.champs_MA1 || '"';

             if V_NB_AGGOPTLABEL_TRAITE = V_NB_AGGOPTLABEL THEN V_LIGNE := V_LIGNE || '}';
             else V_LIGNE := V_LIGNE || '},';
             end if;

             
         END LOOP;
         V_LIGNE := V_LIGNE || ']';
        ---- res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
     END IF;


------------------------------------------------



             if V_NB_AGREGADOSOPT_TRAITE = V_NB_AGREGADOSOPT THEN V_LIGNE := V_LIGNE || '}';
             else V_LIGNE := V_LIGNE || '},';
             end if;

             
         END LOOP;
         V_LIGNE := V_LIGNE || ']';
         res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
     END IF;


    ---------------------------------------------------------
    -----------------------EQUIP-----------------
     BEGIN
         SELECT COUNT(*)
         INTO   V_NB_EQUIPOS
         FROM   SCHEMA2B.TAB_CARROS_EQUIPOS EQUIP
         WHERE  EQUIP.COMP_CLE_PRIMAIRE =  S_TAB_CARROS.COMP_CLE_PRIMAIRE;
    EXCEPTION WHEN OTHERS THEN
              V_NB_EQUIPOS := NULL;
    END;

    IF NVL(V_NB_EQUIPOS, 0) > 0 THEN

        V_LIGNE := ', "EQUIP": [';
        res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
        V_LIGNE := '';

        FOR S_TAB_CARROS_EQUIPOS IN C_TAB_CARROS_EQUIPOS (S_TAB_CARROS.COMP_CLE_PRIMAIRE) LOOP
            IF MOD(V_NB_EQUIPOS_TRAITE, 4) = 0 AND V_NB_EQUIPOS_TRAITE <> 0 THEN
                 res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
                 V_LIGNE := '';
             END IF;
            V_NB_EQUIPOS_TRAITE := V_NB_EQUIPOS_TRAITE+1;   
            V_LIGNE := V_LIGNE || '{"champs_EX1":"' ||  UPPER(REPLACE(S_TAB_CARROS_EQUIPOS.champs_EX1, '"','')) || '",';
            V_LIGNE := V_LIGNE || '"champs_EX3":"' ||  REPLACE(S_TAB_CARROS_EQUIPOS.champs_EX3, '"','') || '",';
            V_LIGNE := V_LIGNE || '"label":"' ||  UPPER(REPLACE(S_TAB_CARROS_EQUIPOSchamps_EX4, '"','')) || '"';

                if V_NB_EQUIPOS_TRAITE = V_NB_EQUIPOS THEN V_LIGNE := V_LIGNE || '}';
                else V_LIGNE := V_LIGNE || '},';
                end if;

            
        END LOOP;
        V_LIGNE := V_LIGNE || ']';    ------------ MOI PAS DE VIRGULE A LA FIN
        --if V_NB_ENREG_TRAITE = V_NB_ENREG THEN V_LIGNE := V_LIGNE || '}';   -----------------------
        --else V_LIGNE := V_LIGNE || '},';    ----------------------------------------
        --end if;  ----------------------------------------
        res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
    END IF;
    V_LIGNE := '';  -------- null
    ---if V_NB_ENREG_TRAITE = V_NB_ENREG THEN V_LIGNE := '}';   --------- 
    ---end if;
    if V_NB_ENREG_TRAITE = V_NB_ENREG THEN V_LIGNE := V_LIGNE || '}';   -----------------------
    else V_LIGNE := V_LIGNE || '}';    ------------------  en debut de la boucle
    end if;  ----------------------------------------
    res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);

    N_SAUV := N_SAUV +1;
    EXCEPTION WHEN OTHERS THEN COMMIT;
                V_ERR  := 1;
                 RES   := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,'FONC_EXPORT_CARRO_JSON','MESSAGE ERREUR PL/SQL : ' ||SQLERRM || S_TAB_CARROS.COMP_CLE_PRIMAIRE);
                --RETURN V_ERR;
                RETURN V_ERR;
    END;
  END LOOP;
   V_LIGNE := ']';
   res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
   UTL_FILE.FCLOSE(file_id_cvs);
  res := SCHEMA3.PACKAGE_PRINT.Func_Write(file_id,
                               'FONC_EXPORT_CARRO_JSON',
                               'Nombre de sauvegarde :' || N_SAUV);
    res := SCHEMA3.PACKAGE_PRINT.Func_Write(file_id, '', '');
    UTL_FILE.FCLOSE(file_id);

  --RETURN V_ERR;
  RETURN V_ERR;
EXCEPTION WHEN OTHERS THEN COMMIT;
          V_ERR  := 1;
          RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,'FONC_EXPORT_CARRO_JSON ','MESSAGE ERREUR PL/SQL : ' ||SQLERRM);
          --RETURN V_ERR;
          RETURN V_ERR;


END FONC_EXPORT_CARRO_JSON;





FUNCTION FONC_EXPORT_TABNOM_JSON (NOMLOG varchar2,P_DATE_TRAI date, P_PATH VARCHAR2, P_FILENAME VARCHAR2) return number IS
    V_ERR       number:=0;
    N_SAUV      NUMBER := 0;
    FILE_ID     UTL_FILE.FILE_TYPE;
    FILE_ID_CVS UTL_FILE.FILE_TYPE;
    V_LIGNE     VARCHAR2(4000);
    RES         NUMBER := 0;
    file_name   VARCHAR2(30);
    V_NB_ENREG  NUMBER(10) := 0;
    V_NB_ENREG_TRAITE NUMBER(10) := 0;
    V_NB_CROSSREF NUMBER(10) := 0;
    V_NB_mixref_TRAITE NUMBER(10) := 0;
    V_NB_champs_MA2 NUMBER(10) := 0;
    V_NB_champs_MA2_TRAITE NUMBER(10) := 0;
    V_NB_traco NUMBER(10) := 0;
    V_NB_traco_TRAITE NUMBER(10) := 0;
    V_NB_champs_PC NUMBER(10) := 0;
    V_NB_champs_PC_TRAITE NUMBER(10) := 0;
   -- V_NB_ADDRESS      NUMBER(3) := 0;
   -- V_NB_PHONE      NUMBER(3) := 0;
    --V_NB_MAIL      NUMBER(3) := 0;
    --V_NB_BANKING      NUMBER(3) := 0;
    V_countryCode           varchar2(2);
    V_NbActive          number(18);
    V_LastDate          varchar2(10);--date
    V_StartDate       varchar2(10);--date
    V_VAR_RA1    number(18);
    V_VAR_RA2    varchar2(10);--date
    V_VAR_RA3 varchar2(10);--date

    V_VAR_A            number(18);
    V_NbActive_U              varchar2(5);
    V_VAR_B      varchar2(10);--date
    V_VAR_C     varchar2(10);--date
    V_VAR_1            number(18);
    V_VAR_1              varchar2(5);
    V_VAR_2      varchar2(10);--date
    V_VAR_3     varchar2(10);--date


CURSOR C_TAB_PARAM_NOMEN IS
select
Entity as Entity,
code as code,
TO_CHAR(start_Val_Date, 'YYYY-MM-DD') as start_Val_Date,
TO_CHAR(start_End_Date, 'YYYY-MM-DD') as start_End_Date,
champs_PC as champs_PC,
MAX(CASE WHEN champs_W11 != ' ' THEN champs_W11 ELSE NULL END) as champs_W11,
PaysDiam as PaysDiam,
start_Val_Date AS start_Val_Date_DATE
from SCHEMA2B.TAB_PARAM_NOMEN
group by
Entity,
code,
TO_CHAR(start_Val_Date, 'YYYY-MM-DD'),
TO_CHAR(start_End_Date, 'YYYY-MM-DD'),
'COUNTRY_INVENT',
champs_PC,
PaysDiam,
start_Val_Date
;

CURSOR C_TAB_champs_PC (P_ENTITY VARCHAR2, P_CODE VARCHAR2, P_START_DATE DATE, P_champs_PC VARCHAR2, P_COUNTRY VARCHAR2) IS
SELECT DISTINCT champs_PC2 as champs_PC2,
champs_PC1 as champs_PC1
from SCHEMA2B.TAB_PARAM_NOMEN
WHERE Entity = P_ENTITY
AND   CODE    = P_CODE
AND   start_Val_Date = P_START_DATE
AND   champs_PC = P_champs_PC
and   PaysDiam = P_COUNTRY
and   champs_PC2 <> ' ';

CURSOR C_TAB_CROSSREF (P_ENTITY VARCHAR2, P_CODE VARCHAR2, P_START_DATE DATE, P_champs_PC VARCHAR2, P_COUNTRY VARCHAR2) IS
select DISTINCT
champs_TP1 as champs_TP1,
champs_TP2	 as champs_TP2,
(CASE WHEN entity in ('1A','2B','3C','4D') THEN UPPER(champs_TP3) ELSE champs_TP3 END)	as champs_TP3
from SCHEMA2B.TAB_PARAM_NOMEN
WHERE Entity = P_ENTITY
AND   CODE    = P_CODE
AND   start_Val_Date = P_START_DATE
AND   champs_PC = P_champs_PC
and   PaysDiam = P_COUNTRY
and   champs_TP3 <> ' ';

CURSOR C_TAB_champs_MA2 (P_ENTITY VARCHAR2, P_CODE VARCHAR2, P_START_DATE DATE, P_champs_PC VARCHAR2, P_COUNTRY VARCHAR2) IS
select DISTINCT
champs_MA2_champs_EX3 as champs_MA2_champs_EX3,
(CASE WHEN entity in ('1A','2B','3C','4D') THEN
UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(champs_MA2_label, '\', '\\'), '"', '\"'), CHR(9), ''), CHR(13), ''), CHR(29), ''))
ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(champs_MA2_label, '\', '\\'), '"', '\"'), CHR(9), ''), CHR(13), ''), CHR(29), '') END) as champs_MA2_label
from SCHEMA2B.TAB_PARAM_NOMEN
WHERE Entity = P_ENTITY
AND   CODE    = P_CODE
AND   start_Val_Date = P_START_DATE
AND   champs_PC = P_champs_PC
and   PaysDiam = P_COUNTRY
AND   champs_MA2_label  <> ' ';


CURSOR C_TAB_traco (P_ENTITY VARCHAR2, P_CODE VARCHAR2, P_START_DATE DATE, P_champs_PC VARCHAR2, P_COUNTRY VARCHAR2) IS
select DISTINCT
traco_champs_EX3 as traco_champs_EX3,
(CASE WHEN entity in ('1A','2B','3C','4D') THEN
UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(traco_label, '\', '\\'), '"', '\"'), CHR(9), ''), CHR(13), ''), CHR(29), ''))
ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(traco_label, '\', '\\'), '"', '\"'), CHR(9), ''), CHR(13), ''), CHR(29), '') END) as traco_label
from SCHEMA2B.TAB_PARAM_NOMEN
WHERE Entity = P_ENTITY
AND   CODE    = P_CODE
AND   start_Val_Date = P_START_DATE
AND   champs_PC = P_champs_PC
and   PaysDiam = P_COUNTRY
AND   traco_label  <> ' ';




BEGIN
  file_name := p_filename;
  FILE_ID := SCHEMA3.PACKAGE_PRINT.Func_Open(NOMLOG);
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'FONC_EXPORT_TABNOM_JSON', ' ## EXPORT NOMEN ' ||  ' ##');
  file_id_cvs:= SCHEMA3.PACKAGE_PRINT.Func_Open_CVS_UTF8(p_path,file_name);


  BEGIN
       SELECT COUNT(DISTINCT Entity || CODE || start_Val_Date || champs_PC || PaysDiam)
       INTO   V_NB_ENREG
       FROM   SCHEMA2B.TAB_PARAM_NOMEN;
       --WHERE entity = 'PARAM_2101'
       --and   code = '04'
       --and   champs_PC = 'CI';
  EXCEPTION WHEN OTHERS THEN
       V_NB_ENREG := 0;
  END;

      V_LIGNE := '[';
      res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);

      FOR S_TAB_PARAM_NOMEN IN C_TAB_PARAM_NOMEN LOOP
      BEGIN
         V_NB_ENREG_TRAITE := V_NB_ENREG_TRAITE +1;
              V_LIGNE := '{"entity":"' ||  S_TAB_PARAM_NOMEN.etty || '","code":"' ||  S_TAB_PARAM_NOMEN.code || '","start_Val_Date":"' || S_TAB_PARAM_NOMEN.start_Val_Date || '","start_End_Date":"' || S_TAB_PARAM_NOMEN.start_End_Date || '",';
-- V_LIGNE:='';

IF S_TAB_PARAM_NOMEN.champs_W11 is not null then
    V_LIGNE := V_LIGNE || '"champs_W11s": ["' || S_TAB_PARAM_NOMEN.champs_W11  || '"],';
    --
END IF;

V_LIGNE := V_LIGNE || '"PaysDiam":"' ||  S_TAB_PARAM_NOMEN.PaysDiam || '"';  ---''|| '",
 V_LIGNE:='';

IF S_TAB_PARAM_NOMEN.champs_PC != ' ' THEN
V_LIGNE := V_LIGNE || ',"champs_PC":"' ||  S_TAB_PARAM_NOMEN.champs_PC || '"';
- V_LIGNE := '';
END IF;

IF S_TAB_PARAM_NOMEN.etty in ('1A','2B','3C','4D') THEN
  BEGIN
    SELECT COUNT(DISTINCT champs_PC2||champs_PC1)
    INTO   V_NB_champs_PC
    FROM   SCHEMA2B.TAB_PARAM_NOMEN
    WHERE  Entity = S_TAB_PARAM_NOMEN.etty
    AND    CODE   =  S_TAB_PARAM_NOMEN.code
    AND    start_Val_Date = S_TAB_PARAM_NOMEN.start_Val_Date_DATE
    AND    champs_PC = S_TAB_PARAM_NOMEN.champs_PC
    AND    PaysDiam = S_TAB_PARAM_NOMEN.PaysDiam
    AND    champs_PC1  <> ' ';
  EXCEPTION WHEN OTHERS THEN
    V_NB_champs_PC := 0;
  END;

  IF V_NB_champs_PC <> 0 THEN
  V_NB_champs_PC_TRAITE := 0;
  V_LIGNE := V_LIGNE || ',"Details":[';
  FOR REC IN C_TAB_champs_PC (S_TAB_PARAM_NOMEN.etty, S_TAB_PARAM_NOMEN.code, S_TAB_PARAM_NOMEN.start_Val_Date_DATE, S_TAB_PARAM_NOMEN.champs_PC, S_TAB_PARAM_NOMEN.PaysDiam) LOOP
    V_NB_champs_PC_TRAITE := V_NB_champs_PC_TRAITE +1;
    V_LIGNE := V_LIGNE || '{"entity":"' || REC.champs_PC2 || '","code":"' || REC.champs_PC1 || '"}';
    IF V_NB_champs_PC_TRAITE <> V_NB_champs_PC THEN V_LIGNE := V_LIGNE || ','; END IF;
  END LOOP;
    V_LIGNE := V_LIGNE || ']';
  END IF;
END IF;

BEGIN
  SELECT COUNT(DISTINCT champs_MA2_champs_EX3||champs_MA2_label)
  INTO   V_NB_champs_MA2
  FROM   SCHEMA2B.TAB_PARAM_NOMEN
  WHERE  Entity = S_TAB_PARAM_NOMEN.etty
  AND    CODE   =  S_TAB_PARAM_NOMEN.code
  AND    start_Val_Date = S_TAB_PARAM_NOMEN.start_Val_Date_DATE
  AND    champs_PC = S_TAB_PARAM_NOMEN.champs_PC
  AND    PaysDiam = S_TAB_PARAM_NOMEN.PaysDiam
  AND    champs_MA2_label  <> ' ';
EXCEPTION WHEN OTHERS THEN
  V_NB_champs_MA2 := 0;
END;

IF V_NB_champs_MA2 <> 0 THEN
V_NB_champs_MA2_TRAITE := 0;
V_LIGNE := V_LIGNE || ',"champs_MA2s":[';
FOR REC IN C_TAB_champs_MA2 (S_TAB_PARAM_NOMEN.etty, S_TAB_PARAM_NOMEN.code, S_TAB_PARAM_NOMEN.start_Val_Date_DATE, S_TAB_PARAM_NOMEN.champs_PC, S_TAB_PARAM_NOMEN.PaysDiam) LOOP
  V_NB_champs_MA2_TRAITE := V_NB_champs_MA2_TRAITE +1;
  IF REC.champs_MA2_champs_EX3 <> ' ' THEN
    V_LIGNE := V_LIGNE || '{"champs_EX3":"' ||  REC.champs_MA2_champs_EX3 || '","label":"' ||  REC.champs_MA2_label || '"}';
  ELSE
    V_LIGNE := V_LIGNE || '{"label":"' ||  REC.champs_MA2_label || '"}';
  END IF;
  IF V_NB_champs_MA2_TRAITE <> V_NB_champs_MA2 THEN V_LIGNE := V_LIGNE || ','; END IF;
END LOOP;
  V_LIGNE := V_LIGNE || ']';
END IF;

BEGIN
  SELECT COUNT(DISTINCT champs_TP1||champs_TP3)
  INTO   V_NB_CROSSREF
  FROM   SCHEMA2B.TAB_PARAM_NOMEN
  WHERE  Entity = S_TAB_PARAM_NOMEN.etty
  AND    CODE   =  S_TAB_PARAM_NOMEN.code
  AND    start_Val_Date = S_TAB_PARAM_NOMEN.start_Val_Date_DATE
  AND    champs_PC = S_TAB_PARAM_NOMEN.champs_PC
  AND    PaysDiam = S_TAB_PARAM_NOMEN.PaysDiam
  AND    champs_TP3  <> ' ';
EXCEPTION WHEN OTHERS THEN
  V_NB_CROSSREF := 0;
END;

IF V_NB_CROSSREF <> 0 THEN
V_NB_mixref_TRAITE := 0;
V_LIGNE := V_LIGNE || ',"MIXREFS":[';
FOR REC IN C_TAB_CROSSREF (S_TAB_PARAM_NOMEN.etty, S_TAB_PARAM_NOMEN.code, S_TAB_PARAM_NOMEN.start_Val_Date_DATE, S_TAB_PARAM_NOMEN.champs_PC, S_TAB_PARAM_NOMEN.PaysDiam) LOOP
  V_NB_mixref_TRAITE := V_NB_mixref_TRAITE +1;
  IF S_TAB_PARAM_NOMEN.etty in ('PARAM_2107','PARAM_2106') THEN
    V_LIGNE := V_LIGNE || '{"champs_CA2":"' ||  REPLACE(REC.champs_TP1,' ','') || '","code":"' ||  REPLACE(REC.champs_TP3,' ','') || '"';
    IF REC.champs_TP2 <> ' ' THEN
        V_LIGNE := V_LIGNE || ',"country":"' || REC.champs_TP2 || '"}';
    ELSE
        V_LIGNE := V_LIGNE || '}';
    END IF;
  ELSE
    V_LIGNE := V_LIGNE || '{"champs_CA2":"' ||  REC.champs_TP1 || '","code":"' ||  REC.champs_TP3 || '"';
    IF REC.champs_TP2 <> ' ' THEN
        V_LIGNE := V_LIGNE || ',"country":"' || REC.champs_TP2 || '"}';
    ELSE
        V_LIGNE := V_LIGNE || '}';
    END IF;
  END IF;
  IF V_NB_mixref_TRAITE <> V_NB_CROSSREF THEN V_LIGNE := V_LIGNE || ','; END IF;
END LOOP;
  V_LIGNE := V_LIGNE || ']';
END IF;

BEGIN
  SELECT COUNT(DISTINCT traco_champs_EX3||traco_label)
  INTO   V_NB_traco
  FROM   SCHEMA2B.TAB_PARAM_NOMEN
  WHERE  Entity = S_TAB_PARAM_NOMEN.etty
  AND    CODE   =  S_TAB_PARAM_NOMEN.code
  AND    start_Val_Date = S_TAB_PARAM_NOMEN.start_Val_Date_DATE
  AND    champs_PC = S_TAB_PARAM_NOMEN.champs_PC
  AND    PaysDiam = S_TAB_PARAM_NOMEN.PaysDiam
  AND    traco_label  <> ' ';
EXCEPTION WHEN OTHERS THEN
  V_NB_traco := 0;
END;

IF V_NB_traco <> 0 THEN
V_NB_traco_TRAITE := 0;
V_LIGNE := V_LIGNE || ',"tracos":[';
FOR REC IN C_TAB_traco (S_TAB_PARAM_NOMEN.etty, S_TAB_PARAM_NOMEN.code, S_TAB_PARAM_NOMEN.start_Val_Date_DATE, S_TAB_PARAM_NOMEN.champs_PC, S_TAB_PARAM_NOMEN.PaysDiam) LOOP
  V_NB_traco_TRAITE := V_NB_traco_TRAITE +1;
  IF REC.traco_champs_EX3 = ' ' and REC.traco_label != ' '  THEN
    V_LIGNE := V_LIGNE || '{"label":"' || REC.traco_label || '"}' ;
  END IF;
  IF REC.traco_champs_EX3 != ' ' and REC.traco_label != ' '  THEN
    V_LIGNE := V_LIGNE || '{"champs_EX3":"' ||  REC.traco_champs_EX3 || '","label":"' ||  REC.traco_label || '"}';
  END IF;
  IF V_NB_traco_TRAITE <> V_NB_traco THEN V_LIGNE := V_LIGNE || ','; END IF;
END LOOP;
  V_LIGNE := V_LIGNE || ']';
END IF;


---------46
IF S_TAB_PARAM_NOMEN.etty in ('PARAM_2101', 'PARAM_2102','1A', 'PARAM_2103','2B','PARAM_2104','PARAM_2105','PARAM_2106','PARAM_2107','PARAM_2108') THEN

    BEGIN
    SELECT
    kpi.countryCode,
    kpi.nbUsedActive,
    TO_CHAR(kpi.usedLastDate,'YYYY-MM-DD'),
    TO_CHAR(kpi.latestStartDate,'YYYY-MM-DD'),
    kpi.champs_1AA,
    TO_CHAR(kpi.champs_2AA,'YYYY-MM-DD'),
    TO_CHAR(kpi.champs_3AA,'YYYY-MM-DD'),
    kpi.nbVAUActive,
    kpi.isVAUUsed,
    TO_CHAR(kpi.champs_1BB,'YYYY-MM-DD'),
    TO_CHAR(kpi.champs_2BB,'YYYY-MM-DD'),
    kpi.nbVAPActive,
    kpi.isVAPUsed,
    TO_CHAR(kpi.champs_1CC,'YYYY-MM-DD'),
    TO_CHAR(kpi.champs_2CC,'YYYY-MM-DD')
    INTO
    V_countryCode,
    V_NbActive,
    V_LastDate,
    V_StartDate,
    V_VAR_RA1,
    V_VAR_RA2,
    V_VAR_RA3,
    V_VAR_A,
    V_NbActive_U,
    V_VAR_B,
    V_VAR_C,
    V_VAR_1,
    V_VAR_1,
    V_VAR_2,
    V_VAR_3

    FROM SCHEMA2B.TAB_RECU_KPI KPI
    WHERE   KPI.etty    =   S_TAB_PARAM_NOMEN.etty
    and     KPI.CODE      =   S_TAB_PARAM_NOMEN.CODE
    and     KPI.champs_PC    =   S_TAB_PARAM_NOMEN.champs_PC;

    EXCEPTION WHEN OTHERS THEN
    V_countryCode           :=NULL;
    V_NbActive          :=NULL;
    V_LastDate          :=NULL;
    V_StartDate       :=NULL;
    V_VAR_RA1    :=NULL;
    V_VAR_RA2    :=NULL;
    V_VAR_RA3 :=NULL;
    V_VAR_A            :=NULL;
    V_NbActive_U              :=NULL;
    V_VAR_B      :=NULL;
    V_VAR_C     :=NULL;
    V_VAR_1            :=NULL;
    V_VAR_1              :=NULL;
    V_VAR_2      :=NULL;
    V_VAR_3     :=NULL;
    END ;

    V_LIGNE := V_LIGNE || ',"kpis":[{'  || '"countryCode":"' ||  V_countryCode || '","nbUsedActive":' || V_NbActive || ',"usedLastDate":"' || V_LastDate || '","latestStartDate":"' || V_StartDate || '","champs_1AA":'  ||V_VAR_RA1 || ',"champs_2AA":"' || V_VAR_RA2 || '","champs_3AA":"' || V_VAR_RA3;
    V_LIGNE := V_LIGNE || '","nbVAUActive":' || V_VAR_A || ',"isVAUUsed":' || V_NbActive_U || ',"champs_1BB":"' || V_VAR_B || '","champs_2BB":"'  || V_VAR_C || '","nbVAPActive":'  ||V_VAR_1 || ',"isVAPUsed":' ||  V_VAR_1   || ',"champs_1CC":"' || V_VAR_2 || '","champs_2CC":"' || V_VAR_3  || '"}]';

    --V_LIGNE := V_LIGNE || ',"kpis":['  || '"countryCode":"' ||  S_TAB_PARAM_NOMEN.countryCode || '","nbUsedActive":' || S_TAB_PARAM_NOMEN.nbUsedActive || ',"usedLastDate":"' || S_TAB_PARAM_NOMEN.usedLastDate || '","latestStartDate":"' || S_TAB_PARAM_NOMEN.latestStartDate || '","champs_1AA":'  ||S_TAB_PARAM_NOMEN.champs_1AA || ',"champs_2AA":"' || S_TAB_PARAM_NOMEN.champs_2AA || '","champs_3AA":"' || S_TAB_PARAM_NOMEN.champs_3AA  || '"]';

END IF;



---------

    if V_NB_ENREG_TRAITE = V_NB_ENREG THEN V_LIGNE := V_LIGNE || '}';
    else V_LIGNE := V_LIGNE || '},';    ------------------  fin balise
    end if;
    res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);

    N_SAUV := N_SAUV +1;

    EXCEPTION WHEN OTHERS THEN COMMIT;
                V_ERR  := 1;
                RES   := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,'FONC_EXPORT_TABNOM_JSON ','MESSAGE ERREUR PL/SQL : ' ||SQLERRM || S_TAB_PARAM_NOMEN.etty);
                --RETURN V_ERR;
                RETURN V_ERR;
    END;
  END LOOP;
   V_LIGNE := ']';
   res := SCHEMA3.PACKAGE_PRINT.Func_Write_CVS_UTF8(file_id_cvs, V_LIGNE);
   UTL_FILE.FCLOSE(file_id_cvs);
  res := SCHEMA3.PACKAGE_PRINT.Func_Write(file_id,
                               'FONC_EXPORT_TABNOM_JSON',
                               'Nombre de sauvegarde :' || N_SAUV);
    res := SCHEMA3.PACKAGE_PRINT.Func_Write(file_id, '', '');
    UTL_FILE.FCLOSE(file_id);

  --RETURN V_ERR;
  RETURN V_ERR;
EXCEPTION WHEN OTHERS THEN COMMIT;
          V_ERR  := 1;
          RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,'FONC_EXPORT_TABNOM_JSON ','MESSAGE ERREUR PL/SQL : ' ||SQLERRM);
          --RETURN V_ERR;
          RETURN V_ERR;
END FONC_EXPORT_TABNOM_JSON;







  function secuencia1(n in integer ) return varchar2    as
       ret       varchar2(30);
       RES     NUMBER := 0;
       FILE_ID UTL_FILE.FILE_TYPE;
       ---quotient  integer;
       ---digit     char(1);
       chars varchar2(100) := '00123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
       ---len int := dimension_T2(chars);
    begin
      if n > 37 then return ' ';   end if;
      ret := substr(chars,n+1,1) ;
      return ret;
   end ;




  function secuencia2(n in integer ) return varchar2    as
       ret       varchar2(30);
       quotient  integer;
       digit     char(1);
       chars varchar2(100) := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
       chars2 varchar2(100) := '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ ';
       len int := dimension_T2(chars);
       len2 int := dimension_T2(chars2);
    begin
      if n > 1295 then return '  ';   end if;
      quotient := n;
      ret := substr(chars,mod(quotient,len)+1,1) || ret;
      quotient := floor(quotient/len);
      len := dimension_T2(chars2)+1;
      while quotient > 0
      loop
          ret := substr(chars2,mod(quotient,len2),1) || ret;
          quotient := floor(quotient/len2);
      end loop ;
      return lpad(ret, 2, '0');
   end ;

    function secuencia3(n in integer, NOMLOG      VARCHAR2) return varchar2    as
       FILE_ID UTL_FILE.FILE_TYPE;
       RES     NUMBER := 0;
       ret       varchar2(30);
       quotient  integer;
       digit     char(1);
       chars varchar2(100) := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
       chars2 varchar2(100) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ';
       len int := dimension_T2(chars);
       len2 int := dimension_T2(chars2);
    begin
      File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
      quotient := n;
      RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','quotient : ' || quotient);
      ret := substr(chars,mod(quotient,len)+1,1) || ret;
      RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','mod(quotient,len) : ' || mod(quotient,len));
      RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','ret : ' || ret);
      quotient := floor(quotient/len);
      RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','quotient : ' || quotient);
      len := dimension_T2(chars2)+1;
      while quotient > 0
      loop
          ret := substr(chars2,mod(quotient,len2),1) || ret;
          quotient := floor(quotient/len2);
      end loop ;
      return lpad(ret, 2, '0');
   end ;



  FUNCTION ALIM_PARAM_2GEN_1A (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
  V_NUM   NUMBER(10);
  V_NUM_2 NUMBER(10);
  V_SEQ   VARCHAR2(2);


        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;


 Cursor C_VEHRA Is
     select distinct PARAM_1.code as bdCode,
                    CAPAMAN.NAME || ':' || CAPARAN.NAME || ':' || 'GEN' || B.gener AS VH_NAME, --CAPAMAN.NAME || '| ' ||
                    CAPAMAN.NAME as CAPAMAN_NAME,
                    'VIP' AS VH_TYPE,
                    DER.TANCODE || 'GEN' || B.gener AS champs_TP3,
                   (CAPARAN.NAME || ' (' || 'GEN' || B.gener || ')') AS traco_LABEL,  
                   DER.DANCODE as DANCODE  ---- 28-10-22

     from    SCHEMA2B.TAB_DEF1 B,
             SCHEMA2B.TAB_DEF3 DER,
             SCHEMA2B.TAB_DEFMAN   CAPAMAN,
             SCHEMA2B.TAB_DEFRANGE CAPARAN,
             SCHEMA2B.TAB_PARAM_NOMEN PARAM_1

     where   B.ID = DER.ID
     and     DER.DANCODE  = CAPAMAN.CODE
     AND     DER.TANCODE  = CAPARAN.CODE
     --AND     gener.ID(+) = DER.ID
     --AND     gener.techcode(+) = 47100
     and     PARAM_1.etty(+) = 'PARAM_2102'
     and     PARAM_1.champs_TP1(+) = 'CAPA'
     and     PARAM_1.champs_TP3(+) = concat('CP1',DER.DANCODE);




 /*******************************************************************************/
  BEGIN

  File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A','------------- BEGIN  -----------------');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A','## Alimentation de la table SCHEMA2B.TAB_PARAM_2GEN_1A ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_PARAM_2GEN_1A','## Flux BILAN   ##');


        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;


  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'Pour VAP : ',' ');


  FOR REC_VEHRA IN C_VEHRA LOOP

       /*************************************************************************/
      BEGIN

        IF REC_VEHRA.bdCode IS NULL THEN
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A :', ' bdCode ABSENT DANS LA TABLE NOMEN');
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, '                ', ' -VH_NAME : ' || TO_CHAR(REC_VEHRA.VH_NAME));
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, '                ', ' -DANCODE : ' || TO_CHAR(REC_VEHRA.DANCODE));
        ELSE

        BEGIN

          IF V_ERR=1 THEN EXIT;
          END IF;

          IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
          END IF;

          BEGIN
           SELECT PARAM_2_gen_num into V_NUM_2
           from   SCHEMA2B.TAB_PARAM_2GEN_1A
           where  PARAM_1_CODE = REC_VEHRA.bdCode
           AND    VH_NAME = REC_VEHRA.VH_NAME
           and    VH_TYPE = REC_VEHRA.VH_TYPE;
          EXCEPTION WHEN OTHERS THEN
           V_NUM_2 := NULL;
          END;

          IF V_NUM_2 is not null then
            V_SEQ := SCHEMA2B.PACKAGE_2GB.secuencia2 (V_NUM_2);
          ELSE
              BEGIN
                  SELECT NVL(max(PARAM_2_gen_num), 0) into V_NUM
                  from   SCHEMA2B.TAB_PARAM_2GEN_1A
                  where  PARAM_1_CODE = REC_VEHRA.bdCode;
              EXCEPTION WHEN OTHERS THEN
                  V_NUM := 0;
              END;
             V_NUM := V_NUM +1;     ---- changement
             V_SEQ := SCHEMA2B.PACKAGE_2GB.secuencia2 (V_NUM);
          END IF ;

          INSERT INTO SCHEMA2B.TAB_PARAM_2GEN_1A
                (
                  PARAM_1_CODE,
                  VH_NAME,
                  CAPAMAN_NAME, 
                  VH_TYPE,
                  PARAM_2_gen_num,
                  PARAM_2_GEN_ID,
                  champs_TP3,   
                  traco_LABEL  -- 
                )
          VALUES
                (
                  REC_VEHRA.bdCode,
                  REC_VEHRA.VH_NAME,
                  REC_VEHRA.CAPAMAN_NAME, 
                  REC_VEHRA.VH_TYPE,
                  NVL(V_NUM_2, V_NUM),
                  V_SEQ,
                  REC_VEHRA.champs_TP3,     
                  REC_VEHRA.traco_LABEL  -- 
                );

          V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
			  	  Update  SCHEMA2B.TAB_PARAM_2GEN_1A
            Set     PARAM_2_gen_num =   NVL(V_NUM_2, V_NUM),
                    PARAM_2_GEN_ID = V_SEQ,
                    CAPAMAN_NAME = REC_VEHRA.CAPAMAN_NAME,
                    traco_LABEL = REC_VEHRA.traco_LABEL   -- 
            where  PARAM_1_CODE          =   REC_VEHRA.bdCode
            and    VH_NAME  = REC_VEHRA.VH_NAME
            and    VH_TYPE  = REC_VEHRA.VH_TYPE
            AND    champs_TP3  = REC_VEHRA.champs_TP3     
            ;

            V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
			  	  COMMIT;
			  	  V_ERR := 1;

			  	  V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
			  	  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A','Message Erreur pl/sql :'||Sqlerrm,'E');

            RETURN V_ERR;

        END;  ----
        END IF;  ----
      END;
  END LOOP;

   COMMIT;
   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_PARAM_2GEN_1A','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));

   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_PARAM_2GEN_1A;








  ----TRIM


  FUNCTION ALIM_PARAM_2GEN_2B (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
  V_NUM   NUMBER(10);
  V_NUM_2 NUMBER(10);
  V_SEQ   VARCHAR2(2);


        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;


 Cursor C_VEHRA Is
     select distinct  PARAM_1.code as bdCode,
            CAPAMAN.NAME || ':' || CAPARAN.NAME || ':' || 'GEN' || B.gener AS VH_NAME,
            'VAP' AS VH_TYPE,
            (case when CAPTRIM.NAME is null then ' ' else  CAPTRIM.NAME end) as VH_TRIM,  
            concat('C1', DER.TrimCode) as champs_TP3,  
            DER.DANCODE as DANCODE --

     from    SCHEMA2B.TAB_DEF1 B,
             SCHEMA2B.TAB_DEF3 DER,
             SCHEMA2B.TAB_DEFMAN   CAPAMAN,
             SCHEMA2B.TAB_DEFRANGE CAPARAN,
             SCHEMA2B.TAB_PARAM_NOMEN PARAM_1,
             SCHEMA2B.TAB_DEFTRIM CAPTRIM  trim

     where   B.ID = DER.ID
     AND     DER.DANCODE = CAPAMAN.CODE
     AND     DER.TANCODE = CAPARAN.CODE
     --AND     gener.ID(+) = DER.ID
     --AND     gener.techcode(+) = 47100
     and     PARAM_1.etty(+) = 'PARAM_2102'
     and     PARAM_1.champs_TP1(+) = 'CAPA'
     and     PARAM_1.champs_TP3(+) = concat('C1',DER.DANCODE)

     and    CAPTRIM.CODE(+) =  DER.TrimCode;  

   
 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_2B','------------- BEGIN  -----------------');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_2B','## Alimentation de la table SCHEMA2B.TAB_PARAM_2GEN_2B ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_PARAM_2GEN_2B','## Flux BILAN   ##');


        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;


  FOR REC_VEHRA IN C_VEHRA
  LOOP

       /*************************************************************************/
        BEGIN

        IF REC_VEHRA.bdCode IS NULL THEN
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A : bdCode ABSENT DANS LA TABLE NOMEN ', 'VH_NAME : ' || TO_CHAR(REC_VEHRA.VH_NAME));
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A : bdCode ABSENT DANS LA TABLE NOMEN ', 'DANCODE : ' || TO_CHAR(REC_VEHRA.DANCODE));
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A : bdCode ABSENT DANS LA TABLE NOMEN ', 'VH_TRIM : ' || TO_CHAR(REC_VEHRA.VH_TRIM));
        ELSE

        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;

        BEGIN
         SELECT trim_num into V_NUM_2
         from   SCHEMA2B.TAB_PARAM_2GEN_2B
         where  PARAM_1_CODE = REC_VEHRA.bdCode
         AND    VH_NAME = REC_VEHRA.VH_NAME
         and    VH_TYPE = REC_VEHRA.VH_TYPE
         and    VH_TRIM =  REC_VEHRA.VH_TRIM   
         and    champs_TP3 = REC_VEHRA.champs_TP3 
         ;
        EXCEPTION WHEN OTHERS THEN
         V_NUM_2 := NULL;
        END;

        IF V_NUM_2 is not null then
          V_SEQ := SCHEMA2B.PACKAGE_2GB.secuencia2 (V_NUM_2);
        else
           BEGIN
         SELECT NVL(max(trim_num), 0) into V_NUM
         from   SCHEMA2B.TAB_PARAM_2GEN_2B
         where  PARAM_1_CODE = REC_VEHRA.bdCode
         AND    VH_NAME = REC_VEHRA.VH_NAME  
         and    VH_TYPE = REC_VEHRA.VH_TYPE  
         ;
        EXCEPTION WHEN OTHERS THEN
         V_NUM := 0;
        END;
            V_NUM := V_NUM +1;     ---- changement
           V_SEQ := SCHEMA2B.PACKAGE_2GB.secuencia2 (V_NUM);
           --V_NUM := V_NUM +1;
        END IF ;

        INSERT INTO SCHEMA2B.TAB_PARAM_2GEN_2B
              (
                PARAM_1_CODE,
                VH_NAME,
                VH_TYPE,
                VH_TRIM, ---
                trim_num,
                TRIM_ID,  ---
                champs_TP3   
              )
        VALUES
              (
REC_VEHRA.bdCode,
REC_VEHRA.VH_NAME,
REC_VEHRA.VH_TYPE,
REC_VEHRA.VH_TRIM, --
NVL(V_NUM_2, V_NUM),
V_SEQ,
REC_VEHRA.champs_TP3   
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_PARAM_2GEN_2B
        Set     trim_num =   NVL(V_NUM_2, V_NUM),
                TRIM_ID = V_SEQ
        where  PARAM_1_CODE          =   REC_VEHRA.bdCode
        and    VH_NAME  = REC_VEHRA.VH_NAME
        and    VH_TYPE  = REC_VEHRA.VH_TYPE
        and  VH_TRIM = REC_VEHRA.VH_TRIM  
        AND  champs_TP3 = REC_VEHRA.champs_TP3   
        ;

        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_2B','Message Erreur pl/sql :'||Sqlerrm,'E');

        RETURN V_ERR;

      END;
      END IF;

        END;
   END LOOP;

   COMMIT;
   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_PARAM_2GEN_2B','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));


   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_PARAM_2GEN_2B;



  FUNCTION ALIM_PARAM_2GEN_3C (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
  V_NUM   NUMBER(10);
  V_NUM_2 NUMBER(10);
  V_SEQ   VARCHAR2(2);


        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;


 Cursor C_VEHRA Is
     select distinct  PARAM_1.code as bdCode,
            CAPAMAN.NAME || ':' || CAPARAN.NAME || ':' || 'GEN' || B.gener AS VH_NAME,
            'VAP' AS VH_TYPE,
            (B.champs_FT  || '/' || DER.PARAM_6 || '/' || DER.DriveTrain || '/' ||  B.champs_ATR  || '/' || B.BaCap) as VH_motorBLAD,
            DER.DANCODE as DANCODE  ---  28-10-2022

     from    SCHEMA2B.TAB_DEF1 B,
             SCHEMA2B.TAB_DEF3 DER,
             SCHEMA2B.TAB_DEFMAN   CAPAMAN,
             SCHEMA2B.TAB_DEFRANGE CAPARAN,
             SCHEMA2B.TAB_PARAM_NOMEN PARAM_1

     where   B.ID = DER.ID
     AND     DER.DANCODE = CAPAMAN.CODE
     AND     DER.TANCODE = CAPARAN.CODE
     and     PARAM_1.etty(+) = 'PARAM_2102'
     and     PARAM_1.champs_TP1(+) = 'CAPA'
     and     PARAM_1.champs_TP3(+) = concat('C1',DER.DANCODE);


 
 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_3C','------------- BEGIN  -----------------');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_3C','## Alimentation de la table SCHEMA2B.TAB_PARAM_2GEN_3C ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_PARAM_2GEN_3C','## Flux BILAN   ##');


        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;


  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'Pour VAP : ',' ');


  FOR REC_VEHRA IN C_VEHRA
  LOOP

       /*************************************************************************/
        BEGIN

        IF REC_VEHRA.bdCode IS NULL THEN
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A : bdCode ABSENT DANS LA TABLE NOMEN ', 'VH_NAME : ' || TO_CHAR(REC_VEHRA.VH_NAME));
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A : bdCode ABSENT DANS LA TABLE NOMEN ', 'DANCODE : ' || TO_CHAR(REC_VEHRA.DANCODE));
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A : bdCode ABSENT DANS LA TABLE NOMEN ', 'VH_motorBLAD : ' || TO_CHAR(REC_VEHRA.VH_motorBLAD));
        ELSE

        BEGIN



        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;

        BEGIN
         SELECT motorBLAD_num into V_NUM_2
         from   SCHEMA2B.TAB_PARAM_2GEN_3C
         where  PARAM_1_CODE = REC_VEHRA.bdCode
         AND    VH_NAME = REC_VEHRA.VH_NAME
         and    VH_TYPE = REC_VEHRA.VH_TYPE
         and    VH_motorBLAD =  REC_VEHRA.VH_motorBLAD   
         ;
        EXCEPTION WHEN OTHERS THEN
         V_NUM_2 := NULL;
        END;

        IF V_NUM_2 is not null then
          V_SEQ := SCHEMA2B.PACKAGE_2GB.secuencia2 (V_NUM_2);
        else
           BEGIN
         SELECT NVL(max(motorBLAD_num), 0) into V_NUM
         from   SCHEMA2B.TAB_PARAM_2GEN_3C
         where  PARAM_1_CODE = REC_VEHRA.bdCode
         AND    VH_NAME = REC_VEHRA.VH_NAME  
         and    VH_TYPE = REC_VEHRA.VH_TYPE  
         ;
        EXCEPTION WHEN OTHERS THEN
         V_NUM := 0;
        END;
            V_NUM := V_NUM +1;     ---- changement
           V_SEQ := SCHEMA2B.PACKAGE_2GB.secuencia2 (V_NUM);
           --V_NUM := V_NUM +1;
        END IF ;

        INSERT INTO SCHEMA2B.TAB_PARAM_2GEN_3C
              (
                PARAM_1_CODE,
                VH_NAME,
                VH_TYPE,
                VH_motorBLAD, ---
                motorBLAD_num,
                motorBLAD_ID   ---
              )
        VALUES
              (
                REC_VEHRA.bdCode,
                REC_VEHRA.VH_NAME,
                REC_VEHRA.VH_TYPE,
                REC_VEHRA.VH_motorBLAD, --
                NVL(V_NUM_2, V_NUM),
                V_SEQ
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_PARAM_2GEN_3C
        Set     motorBLAD_num =   NVL(V_NUM_2, V_NUM),
                motorBLAD_ID = V_SEQ
        where  PARAM_1_CODE =   REC_VEHRA.bdCode
        and    VH_NAME   =   REC_VEHRA.VH_NAME
        and    VH_TYPE   =   REC_VEHRA.VH_TYPE
        and  VH_motorBLAD = REC_VEHRA.VH_motorBLAD  
        ;

        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_3C','Message Erreur pl/sql :'||Sqlerrm,'E');

        RETURN V_ERR;

      END;
      END IF;

        END;
   END LOOP;

   COMMIT;
   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_PARAM_2GEN_3C','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));



   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_PARAM_2GEN_3C;




  FUNCTION ALIM_PARAM_2GEN_4D (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
  V_NUM   NUMBER(10);
  V_NUM_2 NUMBER(10);
  V_SEQ   VARCHAR2(2);


        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;


 Cursor C_VEHRA Is
     select distinct  PARAM_1.code as bdCode,
            CAPAMAN.NAME || ':' || CAPARAN.NAME || ':' || 'GEN' || B.gener AS VH_NAME,
            'VAP' AS VH_TYPE,
            (PARAM_4.code || ':' || B.dimension_T1 || ':' || B.dimension_T2 || ':' || ':' || B.champs_WQ)   as  VH_DIMS,
            DER.DANCODE as DANCODE

     from    SCHEMA2B.TAB_DEF1 B,
             SCHEMA2B.TAB_DEF3 DER,
             SCHEMA2B.TAB_DEFMAN   CAPAMAN,
             SCHEMA2B.TAB_DEFRANGE CAPARAN,
             SCHEMA2B.TAB_PARAM_NOMEN PARAM_1,
             SCHEMA2B.TAB_PARAM_NOMEN PARAM_4  

     where   B.ID = DER.ID
     AND     DER.DANCODE = CAPAMAN.CODE
     AND     DER.TANCODE = CAPARAN.CODE
     and     PARAM_1.etty(+) = 'PARAM_2102'
     and     PARAM_1.champs_TP1(+) = 'CAPA'
     and     PARAM_1.champs_TP3(+) = concat('C1',DER.DANCODE)

     and     PARAM_4.etty (+) = 'PARAM_2103'    
     and     PARAM_4.champs_TP3(+) = 'C1' || substr(DER.COMP_CODE_C,11,1) ;  



 /*******************************************************************************/
  BEGIN

  File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_4D','------------- BEGIN  -----------------');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_4D','## Alimentation de la table SCHEMA2B.TAB_PARAM_2GEN_4D ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_PARAM_2GEN_4D','## Flux BILAN   ##');


        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;


  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'Pour VAP : ',' ');


  FOR REC_VEHRA IN C_VEHRA
  LOOP

       /*************************************************************************/
        BEGIN

        IF REC_VEHRA.bdCode IS NULL THEN
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A : bdCode ABSENT DANS LA TABLE NOMEN ', 'VH_NAME : ' || TO_CHAR(REC_VEHRA.VH_NAME));
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A : bdCode ABSENT DANS LA TABLE NOMEN ', 'DANCODE : ' || TO_CHAR(REC_VEHRA.DANCODE));
              Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_1A : bdCode ABSENT DANS LA TABLE NOMEN ', 'VH_DIMS : ' || TO_CHAR(REC_VEHRA.VH_DIMS));
        ELSE

        BEGIN




        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;

        BEGIN
         SELECT DIMS_num into V_NUM_2
         from   SCHEMA2B.TAB_PARAM_2GEN_4D
         where  PARAM_1_CODE = REC_VEHRA.bdCode
         AND    VH_NAME = REC_VEHRA.VH_NAME
         and    VH_TYPE = REC_VEHRA.VH_TYPE
         and    VH_DIMS =  REC_VEHRA.VH_DIMS   
         ;
        EXCEPTION WHEN OTHERS THEN
         V_NUM_2 := NULL;
        END;

        IF V_NUM_2 is not null then
          V_SEQ := SCHEMA2B.PACKAGE_2GB.secuencia2 (V_NUM_2);
        else
           BEGIN
         SELECT NVL(max(DIMS_num), 0) into V_NUM
         from   SCHEMA2B.TAB_PARAM_2GEN_4D
         where  PARAM_1_CODE = REC_VEHRA.bdCode
         AND    VH_NAME = REC_VEHRA.VH_NAME  
         and    VH_TYPE = REC_VEHRA.VH_TYPE  
         ;
        EXCEPTION WHEN OTHERS THEN
         V_NUM := 0;
        END;
            V_NUM := V_NUM +1;     ---- changement
           V_SEQ := SCHEMA2B.PACKAGE_2GB.secuencia2 (V_NUM);
           --V_NUM := V_NUM +1;

        END IF ;

        INSERT INTO SCHEMA2B.TAB_PARAM_2GEN_4D
              (
                PARAM_1_CODE,
                VH_NAME,
                VH_TYPE,
                VH_DIMS, ---
                DIMS_num,
                DIMS_ID   ---
              )
        VALUES
              (
                REC_VEHRA.bdCode,
                REC_VEHRA.VH_NAME,
                REC_VEHRA.VH_TYPE,
                REC_VEHRA.VH_DIMS, --
                NVL(V_NUM_2, V_NUM),
                V_SEQ
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_PARAM_2GEN_4D
        Set     DIMS_num =   NVL(V_NUM_2, V_NUM),
                DIMS_ID = V_SEQ
        where  PARAM_1_CODE          =   REC_VEHRA.bdCode
        and    VH_NAME  = REC_VEHRA.VH_NAME
        and    VH_TYPE  = REC_VEHRA.VH_TYPE
        and  VH_DIMS = REC_VEHRA.VH_DIMS  
        ;

        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARAM_2GEN_4D','Message Erreur pl/sql :'||Sqlerrm,'E');

        RETURN V_ERR;

     END;
     END IF;

        END;
   END LOOP;

   COMMIT;
   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_PARAM_2GEN_4D','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));

   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_PARAM_2GEN_4D;




  FUNCTION ALIM_TAB_CARROS (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
  V_INS2  NUMBER := 0;

        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;

  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;
    v_isSpeEdi VARCHAR2(5 BYTE);

 Cursor C_VEHRA is
    select distinct id from SCHEMA2B.TAB_DEF1 B WHERE nvl(B.effectiveto, to_date('01/01/2999', 'dd/MM/yyyy')) >= add_months(P_DATE_TRAI, -96);

 Cursor C_VEHRA_DETAIL (V_ID NUMBER) Is

     select distinct
A.Id as tech_id,
NULL as tech_dateExtract,
NULL as tech_dateInsert,
'COUNTRY_INVENT' as countryCode,
'P1' || A.Id || substr(B.refe, 0,4) ||  (( B.refe - floor(B.refe) )*4+1) || TO_CHAR(B.effectivefrom, 'YYYYMMDD') as COMP_CLE_PRIMAIRE,
NULL as VersState,
B.effectivefrom as ValStartDate,
B.effectiveto as ValEndDate,
NULL  as champs_MQ,
PARAM_1.champs_PC as champs_MJ,
PARAM_1.code as bdCode,
PARAM_1.champs_MA2_label  as bdLabel,
concat('C1',A.DANCODE) as DANCODE,
concat('C1',A.TANCODE) as TANCODE,
PARAM_2.code as famCode,
PARAM_2.champs_MA2_label as famLabel,
B.gener  as gener, ----------- 471
substr(B.refe, 0,4)  as VersYear,
( B.refe - floor(B.refe) )*4+1 as VersTrimester, --OK
PARAM_3.code as champs_MK,
NULL as champs_FL,
(case when substr(A.COMP_CODE_C,20,1) is null then 'P1' else substr(A.COMP_CODE_C,20,1) end  ) as KATcode,   -- OK
PARAM_4.code as PARAM_4Code,
B.dimension_T1 as dimension_T1,  ----------- 34
B.dimension_T2 as dimension_T2, ----------- 4
NULL as champs_ASP,
NULL as champs_NC,
(case when substr(A.COMP_CODE_C, 12, 1) in ('Z','A','R','X') then B.champs_NCA_285 when substr(A.COMP_CODE_C, 12, 1) in ('D','Y','P1','F','G','H','B') then  B.champs_NCA_173 when substr(A.COMP_CODE_C, 12, 1) in ('E','C1') then '0' end) as champs_NCA,
NULL as champs_TY,
NULL as champs_PKI,
B.champs_FT as champs_FT, ----------- 21
B.champs_FD  as champs_FD, ----------- 48
substr(A.COMP_CODE_C, 12, 1) as champs_ETY,
NULL as champs_EN1,
NULL as champs_EN2,
NULL as champs_EN3,
CASE WHEN substr(A.COMP_CODE_C, 12, 1) = 'D' AND B.champs_ALT = 'True' THEN 'A'
     WHEN substr(A.COMP_CODE_C, 12, 1) = 'P1' AND B.champs_ALT = 'True' THEN 'B'
     ELSE PARAM_5.code END AS ener_code123,  
B.champs_ALT as champs_ALT,--473
NULL as motor,
NULL as motorComb,
B.cubicCap as cubicCap, ----------- 20
PARAM_6.code as champs_ARE,
PARAM_7.code as champs_code123,
B.champs_ATR as champs_ATR, ----------- 66
NULL as champs_AVR,
CAPTRIM.Name   as champs_ATT, 
B.seatNB as seatNB, ----------- 47
A.doors as doorNB,
NULL as champs_ACT,
NULL as champs_AX,
NULL as champs_AB,
B.champs_AP  as champs_AP,  ----------- 184
B.champs_HP  as champs_HP, ----------- 185
B.champs_HY  as champs_HY, ----------- 186
B.champs_HI as champs_HI, -----------187
B.champs_HB as champs_HB,-----------188
B.champs_HM  as champs_HM,-----------164
B.champs_HW  as champs_HW,-----------165
B.BaCap  as BaCap,-----------163
B.champs_WQ  as champs_WQ,-----------14
B.champs_WZ as champs_WZ,-----------3
NULL as champs_DE,
(case when C.status = 'S' and C.genericcode ='9' then 'True' else 'False' end  ) as Tele,
NULL as VLGShort,
NULL as VLGLong,
replace(PARAM_2.traco_label,':',' ') as VLLShort,  
(replace(PARAM_2.traco_label,':',' ') || ' ' || A.name) as VLLLong,  
'VAP' as VH_TYPE,
MG.PARAM_2_GEN_ID as PARAM_2_GEN_ID,
TRIM.TRIM_ID as TRIM_ID,
motorBLAD.motorBLAD_ID as motorBLAD_ID,
DIMS.DIMS_ID as DIMS_ID,
(case when PARAM_8.champs_TP3 in ('0-1','0-2','2-1','2-2','2-4','3-2','3-4','3-5','4-4','4-5','5-2','5-4','5-5','5-7','5-8','5-9','4-3','2-3') then PARAM_8.code else 'Z' end) as PARAM_8,
PARAM_9.code as PARAM_9,
A.COMP_CODE_C as COMP_CODE_CS

from SCHEMA2B.TAB_DEF3 A,
     SCHEMA2B.TAB_DEF1 B,
     SCHEMA2B.TAB_DEF5 C,

     SCHEMA2B.TAB_PARAM_NOMEN PARAM_1,
     SCHEMA2B.TAB_PARAM_NOMEN PARAM_2,
     SCHEMA2B.TAB_PARAM_NOMEN PARAM_3,
     SCHEMA2B.TAB_PARAM_NOMEN PARAM_4,
     SCHEMA2B.TAB_PARAM_NOMEN PARAM_5,
     SCHEMA2B.TAB_PARAM_NOMEN PARAM_6,
     SCHEMA2B.TAB_PARAM_NOMEN PARAM_7,
     SCHEMA2B.TAB_PARAM_NOMEN PARAM_8, 
     SCHEMA2B.TAB_PARAM_NOMEN PARAM_9, 

     SCHEMA2B.TAB_PARAM_2GEN_1A MG,
     SCHEMA2B.TAB_DEFMAN   CAPAMAN,
     SCHEMA2B.TAB_DEFRANGE CAPARAN,
     SCHEMA2B.TAB_PARAM_2GEN_2B  TRIM,
     SCHEMA2B.TAB_DEFTRIM CAPTRIM,   trim
     SCHEMA2B.TAB_PARAM_2GEN_3C motorBLAD,
     SCHEMA2B.TAB_PARAM_2GEN_4D DIMS

where A.id = B.id
and A.id = C.id (+)
and B.effectivefrom = C.effectivefrom (+)
and B.effectiveto = C.effectiveto (+)
and c.status(+) = 'S'            ---
and c.genericcode(+) = '9'        ---
and PARAM_1.etty(+) = 'PARAM_2102'
and PARAM_1.champs_TP1(+) = 'CAPA'
and PARAM_1.champs_TP3(+) = concat('C1',A.DANCODE)
and PARAM_2.champs_TP1(+)= 'CAPA'  --- 30012023
and PARAM_2.etty(+) = 'PARAM_2101'
and PARAM_2.champs_TP3(+) = concat('C1',A.TANCODE)
and PARAM_3.etty(+) = 'PARAM_2104'
and PARAM_3.champs_TP3(+) = A.carroSECTOR
and PARAM_4.etty(+) = 'PARAM_2103'
and PARAM_4.champs_TP3(+) = concat('C1',substr(A.COMP_CODE_C, 11,1))
and PARAM_5.champs_TP1 (+)= 'CAPA'
and PARAM_5.etty (+)= 'PARAM_2105'
and PARAM_5.champs_TP3(+) = substr(A.COMP_CODE_C, 12, 1)
and PARAM_6.etty (+)= 'PARAM_2107'
and PARAM_6.champs_TP3(+) = A.drivetrain
and PARAM_6.champs_TP1(+) = 'CAPA'
and PARAM_7.etty (+) = 'PARAM_2108'
and PARAM_7.champs_TP3(+) = A.PARAM_6
and PARAM_7.champs_TP1(+) = 'CAPA'

--  FILTRE SUR 8 ANS (-96)
--AND nvl(B.effectiveto, to_date('01/01/2999', 'dd/MM/yyyy')) >= add_months(P_DATE_TRAI, -96)
AND B.ID = V_ID
-- PARAM_2 GEN
AND MG.PARAM_1_CODE(+)  = PARAM_1.code
and MG.VH_NAME(+)  = CAPAMAN.NAME || ':' || CAPARAN.NAME || ':' || 'GEN' || B.gener  --CAPAMAN.NAME || '| ' ||
AND MG.VH_TYPE(+)  = 'VAP'
AND MG.champs_TP3(+)  =  A.TANCODE || 'GEN' || B.gener
    AND A.DANCODE = CAPAMAN.CODE
    AND A.TANCODE = CAPARAN.CODE
-- TRIM
AND TRIM.PARAM_1_CODE(+) = PARAM_1.code
AND TRIM.VH_NAME(+)  = CAPAMAN.NAME || ':' || CAPARAN.NAME || ':' || 'GEN' || B.gener
AND TRIM.VH_TYPE(+)  = 'VAP'
AND TRIM.VH_TRIM(+)  = (case when CAPTRIM.NAME is null then ' ' else  CAPTRIM.NAME end)
AND TRIM.champs_TP3(+)  = concat('C1', A.TrimCode)
    AND  CAPTRIM.CODE =  A.TrimCode
-- motor
AND motorBLAD.PARAM_1_CODE(+) = PARAM_1.code
AND motorBLAD.VH_NAME(+)  = CAPAMAN.NAME || ':' || CAPARAN.NAME || ':' || 'GEN' || B.gener
AND motorBLAD.VH_TYPE(+)  = 'VAP'
AND motorBLAD.VH_motorBLAD(+)  =  (B.champs_FT  || '/' || A.PARAM_6 || '/' || A.DriveTrain || '/' || B.champs_ATR  || '/' || B.BaCap)
-- DIMENSION
AND DIMS.PARAM_1_CODE(+) = PARAM_1.code
AND DIMS.VH_NAME(+)  = CAPAMAN.NAME || ':' || CAPARAN.NAME || ':' || 'GEN' || B.gener
AND DIMS.VH_TYPE(+)  = 'VAP'
AND DIMS.VH_DIMS(+) =  (PARAM_4.code || ':' || B.dimension_T1 || ':' || B.dimension_T2 || ':' || ':' || B.champs_WQ)


and PARAM_8.etty(+) ='PARAM_8' and PARAM_8.champs_TP1(+) ='CAPA'
and PARAM_8.champs_TP3(+) = concat(concat(A.doors,'-'),B.seatNB)
and PARAM_9.etty(+) ='PARAM_9'
and PARAM_9.champs_MA2_label(+) = replace(B.refe, ',', '.')
;


 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS','------------- BEGIN  -----------------');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS','## Alimentation de la table SCHEMA2B.TAB_CARROS ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','## Flux BILAN   ##');

        ----TABLE DES VEHS
        BEGIN
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCHEMA2B.TAB_CARROS';
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS',
                                   '## TRUNCATE OK ##' || SQL%ROWCOUNT);
            COMMIT;
        EXCEPTION WHEN OTHERS THEN
            V_ERR := 1;
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS',
                                   '## TRUNCATE KO - FIN DU TRAITEMENT ##' || SQL%ROWCOUNT);
            RETURN V_ERR;
        END;

        ----TABLE DES VEHS SANS BLAD
        BEGIN
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCHEMA2B.TAB_CODES_OUBLIES';
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS',
                                   '## TRUNCATE OK ##' || SQL%ROWCOUNT);
            COMMIT;
        EXCEPTION WHEN OTHERS THEN
            V_ERR := 1;
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS',
                                   '## TRUNCATE KO - FIN DU TRAITEMENT ##' || SQL%ROWCOUNT);
            RETURN V_ERR;
        END;

        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;

  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'Pour VAP : ',' ');

  FOR REC_CARROS IN C_VEHRA LOOP
  FOR REC_VEHRA IN C_VEHRA_DETAIL(REC_CARROS.ID)
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;

        IF REC_VEHRA.bdCode is not null
            and REC_VEHRA.bdLabel is not null
            and REC_VEHRA.famLabel is not null ---
            ---and KATcode is not null
            and REC_VEHRA.PARAM_4Code is not null
            and REC_VEHRA.TRIM_ID is not null
            and REC_VEHRA.ener_code123 is not null
            and REC_VEHRA.champs_FT is not null ---
            and REC_VEHRA.champs_ARE is not null
            and REC_VEHRA.champs_code123 is not null
            and REC_VEHRA.PARAM_9 is not null
            and REC_VEHRA.DIMS_ID <> '  '
        THEN
        BEGIN

        INSERT INTO SCHEMA2B.TAB_CARROS
              (
tech_id,
tech_dateExtract,
tech_dateInsert,
countryCode,
COMP_CLE_PRIMAIRE,
VersState,
ValStartDate,
ValEndDate,
champs_MQ,
champs_MJ,
bdCode,
bdLabel,
famCode,
famLabel,
gener,
VersYear,
VersTrimester,
champs_MK,
champs_FL,
KATcode,
PARAM_4Code,
dimension_T1,
dimension_T2,
champs_ASP,
champs_NC,
champs_NCA,
champs_TY,
champs_PKI,
champs_FT,
champs_FD,
champs_ETY,
champs_EN1,
champs_EN2,
champs_EN3,
ener_code123,
champs_ALT,
motor,
motorComb,
cubicCap,
champs_ARE,
champs_code123,
champs_ATR,
champs_AVR,
champs_ATT,
seatNB,
doorNB,
champs_ACT,
champs_AX,
champs_AB,
champs_AP,
champs_HP,
champs_HY,
champs_HI,
champs_HB,
champs_HM,
champs_HW,
BaCap,
champs_WQ,
champs_WZ,
champs_DE,
Tele,
champs_RT,
champs_NB1,
champs_FGG,
champs_FGT,
VALID_User,
VALID_Date,
updateUser,
updateDate,
champs_AY,
champs_BC,
champs_SH,
VLGShort,
VLGLong,
VLLShort,
VLLLong,
VH_TYPE,
PARAM_2_GEN,
TRIM,
motorBLAD,
DIMS,
PARAM_8,
PARAM_9,
COMP_CODE_C,
BLAD,
BLAD_modif
              )
        VALUES
              (
REC_VEHRA.tech_id,
REC_VEHRA.tech_dateExtract,
REC_VEHRA.tech_dateInsert,
REC_VEHRA.countryCode,
REC_VEHRA.COMP_CLE_PRIMAIRE,
REC_VEHRA.VersState,
REC_VEHRA.ValStartDate,
REC_VEHRA.ValEndDate,
REC_VEHRA.champs_MQ,
REC_VEHRA.champs_MJ,
REC_VEHRA.bdCode,
REC_VEHRA.bdLabel,
REC_VEHRA.famCode,
REC_VEHRA.famLabel,
REC_VEHRA.gener,
REC_VEHRA.VersYear,
REC_VEHRA.VersTrimester,
REC_VEHRA.champs_MK,
REC_VEHRA.champs_FL,
REC_VEHRA.KATcode,
REC_VEHRA.PARAM_4Code,
REC_VEHRA.dimension_T1,
REC_VEHRA.dimension_T2,
REC_VEHRA.champs_ASP,
REC_VEHRA.champs_NC,
REC_VEHRA.champs_NCA,
REC_VEHRA.champs_TY,
REC_VEHRA.champs_PKI,
REC_VEHRA.champs_FT,
REC_VEHRA.champs_FD,
REC_VEHRA.champs_ETY,
REC_VEHRA.champs_EN1,
REC_VEHRA.champs_EN2,
REC_VEHRA.champs_EN3,
REC_VEHRA.ener_code123,
REC_VEHRA.champs_ALT,
REC_VEHRA.motor,
REC_VEHRA.motorComb,
REC_VEHRA.cubicCap,
REC_VEHRA.champs_ARE,
REC_VEHRA.champs_code123,
REC_VEHRA.champs_ATR,
REC_VEHRA.champs_AVR,
NVL(REC_VEHRA.champs_ATT, '-'),
REC_VEHRA.seatNB,
REC_VEHRA.doorNB,
REC_VEHRA.champs_ACT,
REC_VEHRA.champs_AX,
REC_VEHRA.champs_AB,
REC_VEHRA.champs_AP,
REC_VEHRA.champs_HP,
REC_VEHRA.champs_HY,
REC_VEHRA.champs_HI,
REC_VEHRA.champs_HB,
REC_VEHRA.champs_HM,
REC_VEHRA.champs_HW,
REC_VEHRA.BaCap,
REC_VEHRA.champs_WQ,
REC_VEHRA.champs_WZ,
REC_VEHRA.champs_DE,
REC_VEHRA.Tele,
REC_VEHRA.champs_RT,
REC_VEHRA.champs_NB1,
REC_VEHRA.champs_FGG,
REC_VEHRA.champs_FGT,
REC_VEHRA.VALID_User,
REC_VEHRA.VALID_Date,
REC_VEHRA.updateUser,
REC_VEHRA.updateDate,
REC_VEHRA.champs_AY,
REC_VEHRA.champs_BC,
REC_VEHRA.champs_SH,
REC_VEHRA.VLGShort,
REC_VEHRA.VLGLong,
REC_VEHRA.VLLShort,
REC_VEHRA.VLLLong,
REC_VEHRA.VH_TYPE,
reC_VEHRA.PARAM_2_GEN_ID,
REC_VEHRA.TRIM_ID,
REC_VEHRA.motorBLAD_ID,
REC_VEHRA.DIMS_ID,
REC_VEHRA.PARAM_8,
REC_VEHRA.PARAM_9,
REC_VEHRA.COMP_CODE_C,
(REC_VEHRA.bdCode || REC_VEHRA.PARAM_2_GEN_ID || REC_VEHRA.KATcode || REC_VEHRA.DIMS_ID || REC_VEHRA.PARAM_8 || REC_VEHRA.TRIM_ID || REC_VEHRA.ener_code123 || REC_VEHRA.motorBLAD_ID || REC_VEHRA.PARAM_9 || '0' ),
(REC_VEHRA.bdCode || REC_VEHRA.PARAM_2_GEN_ID || REC_VEHRA.KATcode || REC_VEHRA.DIMS_ID || REC_VEHRA.PARAM_8 || REC_VEHRA.TRIM_ID || REC_VEHRA.ener_code123 || REC_VEHRA.motorBLAD_ID || REC_VEHRA.PARAM_9 || '0' )
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_CARROS
        Set
tech_id  =     REC_VEHRA.tech_id,
tech_dateExtract  = REC_VEHRA.tech_dateExtract,
tech_dateInsert   = REC_VEHRA.tech_dateInsert,
countryCode  = REC_VEHRA.countryCode,
VersState     = REC_VEHRA.VersState,
ValStartDate    = REC_VEHRA.ValStartDate,
ValEndDate  = REC_VEHRA.ValEndDate,
champs_MQ   = REC_VEHRA.champs_MQ,
champs_MJ  = REC_VEHRA.champs_MJ,
bdCode    = REC_VEHRA.bdCode,
bdLabel   = REC_VEHRA.bdLabel,
famCode   = REC_VEHRA.famCode,
famLabel  = REC_VEHRA.famLabel,
gener   = REC_VEHRA.gener,
VersYear  = REC_VEHRA.VersYear,
VersTrimester     = REC_VEHRA.VersTrimester,
champs_MK    = REC_VEHRA.champs_MK,
champs_FL   = REC_VEHRA.champs_FL,
KATcode     = REC_VEHRA.KATcode,
PARAM_4Code     = REC_VEHRA.PARAM_4Code,
dimension_T1   = REC_VEHRA.dimension_T1,
dimension_T2   = REC_VEHRA.dimension_T2,
champs_ASP   = REC_VEHRA.champs_ASP,
champs_NC  = REC_VEHRA.champs_NC,
champs_NCA  = REC_VEHRA.champs_NCA,
champs_TY     = REC_VEHRA.champs_TY,
champs_PKI     = REC_VEHRA.champs_PKI,
champs_FT  = REC_VEHRA.champs_FT,
champs_FD   = REC_VEHRA.champs_FD,
champs_ETY  = REC_VEHRA.champs_ETY,
champs_EN1    = REC_VEHRA.champs_EN1,
champs_EN2  = REC_VEHRA.champs_EN2,
champs_EN3    = REC_VEHRA.champs_EN3,
ener_code123   = REC_VEHRA.ener_code123,
champs_ALT = REC_VEHRA.champs_ALT,
motor     = REC_VEHRA.motor,
motorComb     = REC_VEHRA.motorComb,
cubicCap    = REC_VEHRA.cubicCap,
champs_ARE     = REC_VEHRA.champs_ARE,
champs_code123  = REC_VEHRA.champs_code123,
champs_ATR   = REC_VEHRA.champs_ATR,
champs_AVR   = REC_VEHRA.champs_AVR,
champs_ATT    = NVL(REC_VEHRA.champs_ATT,'-'),
seatNB   = REC_VEHRA.seatNB,
doorNB   = REC_VEHRA.doorNB,
champs_ACT   = REC_VEHRA.champs_ACT,
champs_AX    = REC_VEHRA.champs_AX,
champs_AB     = REC_VEHRA.champs_AB,
champs_AP   = REC_VEHRA.champs_AP,
champs_HP    = REC_VEHRA.champs_HP,
champs_HY  = REC_VEHRA.champs_HY,
champs_HI     = REC_VEHRA.champs_HI,
champs_HB  = REC_VEHRA.champs_HB,
champs_HM  = REC_VEHRA.champs_HM,
champs_HW    = REC_VEHRA.champs_HW,
BaCap  = REC_VEHRA.BaCap,
champs_WQ   = REC_VEHRA.champs_WQ,
champs_WZ   = REC_VEHRA.champs_WZ,
champs_DE  = REC_VEHRA.champs_DE,
Tele  = REC_VEHRA.Tele,
champs_RT  = REC_VEHRA.champs_RT,
champs_NB1    = REC_VEHRA.champs_NB1,
champs_FGG     = REC_VEHRA.champs_FGG,
champs_FGT     = REC_VEHRA.champs_FGT,
VALID_User   = REC_VEHRA.VALID_User,
VALID_Date   = REC_VEHRA.VALID_Date,
updateUser   = REC_VEHRA.updateUser,
updateDate   = REC_VEHRA.updateDate,
champs_AY    = REC_VEHRA.champs_AY,
champs_BC  = REC_VEHRA.champs_BC,
champs_SH   = REC_VEHRA.champs_SH,
VLGShort  = REC_VEHRA.VLGShort,
VLGLong    = REC_VEHRA.VLGLong,
VLLShort   = REC_VEHRA.VLLShort,
VLLLong                       = REC_VEHRA.VLLLong,
VH_TYPE           =       REC_VEHRA.VH_TYPE,
PARAM_2_gen                = REC_VEHRA.PARAM_2_GEN_ID,
TRIM                 =  REC_VEHRA.TRIM_ID,
motorBLAD    = REC_VEHRA.motorBLAD_ID,
DIMS       = REC_VEHRA.DIMS_ID,
PARAM_8 = REC_VEHRA.PARAM_8,
PARAM_9 = REC_VEHRA.PARAM_9,
COMP_CODE_C = REC_VEHRA.COMP_CODE_C,
BLAD_modif = (REC_VEHRA.bdCode || REC_VEHRA.PARAM_2_GEN_ID || REC_VEHRA.KATcode || REC_VEHRA.DIMS_ID || REC_VEHRA.PARAM_8 || REC_VEHRA.TRIM_ID || REC_VEHRA.ener_code123 || REC_VEHRA.motorBLAD_ID || REC_VEHRA.PARAM_9 || '0' )

        where  COMP_CLE_PRIMAIRE  = REC_VEHRA.COMP_CLE_PRIMAIRE  ;



        V_UPD := V_UPD + 1;
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','MAJ : '|| REC_VEHRA.COMP_CLE_PRIMAIRE);
        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS','Message Erreur pl/sql :'||Sqlerrm,'E');
                --Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS',to_char(REC_VEHRA.tech_id|| '-' || REC_VEHRA.COMP_CLE_PRIMAIRE) );
        RETURN V_ERR;


     END;--------

    ELSE
        --V_ERR := 1;
       /* RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','IMPOSSIBLE D INSERER CAR UN DES CHAMPS MANQUANTS : '|| REC_VEHRA.COMP_CLE_PRIMAIRE);
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','bdCode: '|| REC_VEHRA.bdCode);
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','bdLabel: '|| REC_VEHRA.bdLabel);
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','famLabel: '|| REC_VEHRA.famLabel);---
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','PARAM_4Code: '|| REC_VEHRA.PARAM_4Code);
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','TRIM_ID: '|| REC_VEHRA.TRIM_ID);
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','ener_code123: '|| REC_VEHRA.ener_code123);
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','champs_FT: '|| REC_VEHRA.champs_FT);---
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','champs_ARE: '|| REC_VEHRA.champs_ARE);
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','champs_code123: '|| REC_VEHRA.champs_code123);
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','PARAM_9: '|| REC_VEHRA.PARAM_9);
        RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','DIMS: '|| REC_VEHRA.DIMS_ID);*/
        --RETURN V_ERR;

    ----TABLE DES VEHS SANS BLAD
        INSERT INTO SCHEMA2B.TAB_CODES_OUBLIES(
        COMP_CLE_PRIMAIRE,
        ValStartDate,
        ValEndDate,
        date_situ,
        DANCODE,
        TANCODE,
        bdCode,
        bdLabel,
        famLabel,
        PARAM_4Code,
        TRIM_ID,
        ener_code123,
        champs_FT,
        champs_ARE,
        champs_code123,
        PARAM_9,
        DIMS
        )
        VALUES (
        REC_VEHRA.COMP_CLE_PRIMAIRE,
        REC_VEHRA.ValStartDate,
        REC_VEHRA.ValEndDate,
        P_DATE_TRAI,
        REC_VEHRA.DANCODE,
        REC_VEHRA.TANCODE,
        REC_VEHRA.bdCode,
        REC_VEHRA.bdLabel,
        REC_VEHRA.famLabel,
        REC_VEHRA.PARAM_4Code,
        REC_VEHRA.TRIM_ID,
        REC_VEHRA.ener_code123,
        REC_VEHRA.champs_FT,
        REC_VEHRA.champs_ARE,
        REC_VEHRA.champs_code123,
        REC_VEHRA.PARAM_9,
        REC_VEHRA.DIMS_ID
        );

        V_INS2 := V_INS2 + 1;


    END IF;


        END;

   END LOOP;
   END LOOP;

   COMMIT;
   V_INSERTS := V_INS;
   V_Updates := V_Upd;

   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));


   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS',' ');
   Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS','## Alimentation de la table SCHEMA2B.TAB_CODES_OUBLIES ##');
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS','Nombre d''insertions : '||TO_CHAR(V_INS2));


   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;

   EXCEPTION WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS','Message Erreur pl/sql :'||Sqlerrm,'E');
   End;

  END ALIM_TAB_CARROS;



  FUNCTION ALIM_TAB_CARROS_MIXREFS (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;

v_bdCodeSource VARCHAR2(2 BYTE);
v_ES VARCHAR2(3 BYTE);

  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;


  Cursor C_carros_mixrefs Is
select  distinct
COMP_CLE_PRIMAIRE as COMP_CLE_PRIMAIRE,
'BLAD' as identType_BLAD,
'CONSATR' as identType_CONSTR,
'FOURNI_CODE' as identType_COMP_CODE_C,
'FOURNI_ID' as identType_FOURNI_ID,
BLAD AS ident_BLAD,
code_constr as ident_CONSTR,
COMP_CODE_C AS ident_COMP_CODE_C,
tech_id as ident_FOURNI_ID,
bdCode as bdCode,
KATcode as KATcode
from TAB_CARROS;




 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_MIXREFS','------------- BEGIN  -----------------');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_MIXREFS','## Alimentation de la table SCHEMA2B.TAB_CARROS_MIXREFS ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_MIXREFS','## Flux BILAN   ##');

   BEGIN
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCHEMA2B.TAB_CARROS_MIXREFS';
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS_MIXREFS',
                                   '## TRUNCATE OK ##' || SQL%ROWCOUNT);
            COMMIT;
        EXCEPTION WHEN OTHERS THEN
            V_ERR := 1;
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS_MIXREFS',
                                   '## TRUNCATE KO - FIN DU TRAITEMENT ##' || SQL%ROWCOUNT);
            RETURN V_ERR;
        END;


        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;

  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'BLAD: ',' ');



  FOR REC_carros_mixrefs IN C_carros_mixrefs
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_CARROS_MIXREFS
              (
              --tech_id,
              COMP_CLE_PRIMAIRE,
              identType,
              ident
              )
        VALUES
              (
              --REC_carros_mixrefs.tech_id,
              REC_carros_mixrefs.COMP_CLE_PRIMAIRE,
              REC_carros_mixrefs.identType_BLAD,
              REC_carros_mixrefs.ident_BLAD
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_CARROS_MIXREFS
        Set

        ident = REC_carros_mixrefs.ident_BLAD

        where   COMP_CLE_PRIMAIRE = REC_carros_mixrefs.COMP_CLE_PRIMAIRE
        and identType = REC_carros_mixrefs.identType_BLAD;



        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_MIXREFS','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_MIXREFS','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));




   V_INS :=0;
   V_Upd :=0;
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'CONSTR : ',' ');

  FOR REC_carros_mixrefs IN C_carros_mixrefs
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        v_bdCodeSource := NULL;
        IF REC_carros_mixrefs.bdCode = 'FI' AND REC_carros_mixrefs.KATcode = 'P1'   THEN
            v_bdCodeSource := '001';
        END IF;
        IF REC_carros_mixrefs.bdCode = 'FI' AND REC_carros_mixrefs.KATcode = 'C1'   THEN
            v_bdCodeSource := '771';
        END IF;
        IF REC_carros_mixrefs.bdCode = 'AL' THEN
            v_bdCodeSource := '831';
        END IF;
        IF REC_carros_mixrefs.bdCode = 'JE' THEN
            v_bdCodeSource := '571';
        END IF;
        IF REC_carros_mixrefs.bdCode = 'LN' THEN
            v_bdCodeSource := '701';
        END IF;
        IF REC_carros_mixrefs.bdCode = 'AB' THEN
            v_bdCodeSource := '661';
        END IF;


        INSERT INTO SCHEMA2B.TAB_CARROS_MIXREFS
              (
              --tech_id,
              COMP_CLE_PRIMAIRE,
              identType,
              ident,
              champs_AN1,
              bdCodeSource
              )
        VALUES
              (
              --REC_carros_mixrefs.tech_id,
              REC_carros_mixrefs.COMP_CLE_PRIMAIRE,
              REC_carros_mixrefs.identType_CONSTR,
              REC_carros_mixrefs.ident_CONSTR,
              v_ES,
              v_bdCodeSource
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_CARROS_MIXREFS
        Set

        ident = REC_carros_mixrefs.ident_CONSTR,
        champs_AN1 = v_ES,
        bdCodeSource = v_bdCodeSource

        where   COMP_CLE_PRIMAIRE = REC_carros_mixrefs.COMP_CLE_PRIMAIRE
        and identType = REC_carros_mixrefs.identType_CONSTR;



        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_MIXREFS','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_MIXREFS','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));





   V_INS :=0;
   V_Upd :=0;
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'COMP_CODE_C : ',' ');

  FOR REC_carros_mixrefs IN C_carros_mixrefs
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;




        INSERT INTO SCHEMA2B.TAB_CARROS_MIXREFS
              (
              --tech_id,
              COMP_CLE_PRIMAIRE,
              identType,
              ident
              )
        VALUES
              (
              --REC_carros_mixrefs.tech_id,
              REC_carros_mixrefs.COMP_CLE_PRIMAIRE,
              REC_carros_mixrefs.identType_COMP_CODE_C,
              REC_carros_mixrefs.ident_COMP_CODE_C
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_CARROS_MIXREFS
        Set

        ident = REC_carros_mixrefs.ident_COMP_CODE_C

        where   COMP_CLE_PRIMAIRE = REC_carros_mixrefs.COMP_CLE_PRIMAIRE
        and identType = REC_carros_mixrefs.identType_COMP_CODE_C;



        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_MIXREFS','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_MIXREFS','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));




------
   V_INS :=0;
   V_Upd :=0;
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'FOURNI_ID : ',' ');

  FOR REC_carros_mixrefs IN C_carros_mixrefs
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;



        INSERT INTO SCHEMA2B.TAB_CARROS_MIXREFS
              (
            --tech_id,
            COMP_CLE_PRIMAIRE,
            identType,
            ident
              )
        VALUES
              (
            --REC_ca  rros_mixrefs.tech_id,
            REC_carros_mixrefs.COMP_CLE_PRIMAIRE,
            REC_carros_mixrefs.identType_FOURNI_ID,
            REC_carros_mixrefs.ident_FOURNI_ID
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_CARROS_MIXREFS
        Set

        ident = REC_carros_mixrefs.ident_FOURNI_ID

        where   COMP_CLE_PRIMAIRE = REC_carros_mixrefs.COMP_CLE_PRIMAIRE
        and identType = REC_carros_mixrefs.identType_FOURNI_ID;



        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_MIXREFS','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_MIXREFS','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));





   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;

   EXCEPTION WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_MIXREFS','Message Erreur pl/sql :'||Sqlerrm,'E');
   End;

  END ALIM_TAB_CARROS_MIXREFS;





  FUNCTION ALIM_TAB_CARROS_PRIX (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;

---- pas de doublons

  Cursor C_VH_PRIX Is
  WITH precio_VAP AS (Select distinct
carros.tech_id AS tech_id, ------  POUR JOINTURE AVEC TAB_NVDprecios_VAP
COMP_CLE_PRIMAIRE as COMP_CLE_PRIMAIRE,  ------  POUR JOINTURE AVEC VEH
'VAP' as VH_TYPE,
NULL AS champs_P1A,
NULL AS champs_P1B,
NULL AS champs_P1C,
NULL AS champs_D1A,
carros.ValStartDate,
carros.ValEndDate,
GREATEST(effectivefrom, ValStartDate) as champs_D1B,
case when effectiveto is null and ValEndDate is not null then ValEndDate
     when ValEndDate is null and effectiveto is not null then effectiveto
     else least(effectiveto, ValEndDate) end
as champs_D1C,
NULL AS champs_P,
B.champs_NK AS champs_PWF1,
NULL AS champs_PWF2,
NULL AS champs_PWF3,
'ANONYM'AS moneda,
NULL AS champs_AMT,
NULL AS champs_AMG,
NULL AS VAL_Amount,
NULL AS VAL_Rate,
B.champs_NK AS champs_PP1,
NULL AS champs_PP2,
NULL AS champs_PP3

    FROM SCHEMA2B.TAB_CARROS veh, SCHEMA2B.TAB_NVDprecios_VAP B
 where  carros.tech_id = B.Id and carros.VH_TYPE = 'VAP'),
 precio_VAU AS (Select distinct
carros.tech_id AS tech_id, ------  POUR JOINTURE AVEC TAB_NVDprecios_VAP
COMP_CLE_PRIMAIRE as COMP_CLE_PRIMAIRE,  ------  POUR JOINTURE AVEC VEH
'VAU' as VH_TYPE,
NULL AS champs_P1A,
NULL AS champs_P1B,
NULL AS champs_P1C,
NULL AS champs_D1A,
carros.ValStartDate,
carros.ValEndDate,
GREATEST(effectivefrom, ValStartDate) as champs_D1B,
case when effectiveto is null and ValEndDate is not null then ValEndDate
     when ValEndDate is null and effectiveto is not null then effectiveto
     else least(effectiveto, ValEndDate) end
as champs_D1C,
NULL AS champs_P,
B.champs_NK AS champs_PWF1,
NULL AS champs_PWF2,
NULL AS champs_PWF3,
'ANONYM'AS moneda,
NULL AS champs_AMT,
NULL AS champs_AMG,
NULL AS VAL_Amount,
NULL AS VAL_Rate,
B.champs_NK AS champs_PP1,
NULL AS champs_PP2,
NULL AS champs_PP3

    FROM SCHEMA2B.TAB_CARROS veh, SCHEMA2B.TAB_NVDprecios_VAU B
 where  carros.tech_id = B.Id and carros.VH_TYPE = 'VAU')
 select VAP.*,
       CASE WHEN champs_D1B = champs_D1C THEN 0
            WHEN champs_D1B > ValEndDate THEN 0
            WHEN champs_D1C < ValStartDate THEN 0
            WHEN champs_D1B >= ValStartDate THEN 1
            ELSE 0
       END AS FLAG_PEC
FROM   precio_VAP VAP
WHERE   CASE WHEN champs_D1B = champs_D1C THEN 0
            WHEN champs_D1B > ValEndDate THEN 0
            WHEN champs_D1C < ValStartDate THEN 0
            WHEN champs_D1B >= ValStartDate THEN 1
            ELSE 0
       END = 1

union
  select VAU.*,
       CASE WHEN champs_D1B = champs_D1C THEN 0
            WHEN champs_D1B > ValEndDate THEN 0
            WHEN champs_D1C < ValStartDate THEN 0
            WHEN champs_D1B >= ValStartDate THEN 1
            ELSE 0
       END AS FLAG_PEC
FROM   precio_VAU VAU
WHERE   CASE WHEN champs_D1B = champs_D1C THEN 0
            WHEN champs_D1B > ValEndDate THEN 0
            WHEN champs_D1C < ValStartDate THEN 0
            WHEN champs_D1B >= ValStartDate THEN 1
            ELSE 0
       END = 1
;


 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_PRIX','------------------BEGIN------------------##');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_PRIX','## Alimentation de la table SCHEMA2B.TAB_CARROS_PRIX ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_PRIX','## Flux BILAN   ##');

  BEGIN
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCHEMA2B.TAB_CARROS_PRIX';
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS_PRIX',
                                   '## TRUNCATE OK ##' || SQL%ROWCOUNT);
            COMMIT;
        EXCEPTION WHEN OTHERS THEN
            V_ERR := 1;
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS_PRIX',
                                   '## TRUNCATE KO - FIN DU TRAITEMENT ##' || SQL%ROWCOUNT);
            RETURN V_ERR;
        END;

        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;

  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'Pour VAP + VAU : ',' ');

  FOR REC_VH_PRIX IN C_VH_PRIX
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_CARROS_PRIX
              (
tech_id,    ------  POUR JOINTURE
COMP_CLE_PRIMAIRE,------  POUR JOINTURE
VH_TYPE,------  POUR JOINTURE
champs_P1A,
champs_P1B,
champs_P1C,
champs_D1A,
champs_D1B,
champs_D1C,
champs_P,
champs_PWF1,
champs_PWF2,
champs_PWF3,
moneda,
champs_AMT,
champs_AMG,
VAL_Amount,
VAL_Rate,
champs_PP1,
champs_PP2,
champs_PP3
              )
        VALUES
              (
REC_VH_PRIX.tech_id,    ------  POUR JOINTURE
REC_VH_PRIX.COMP_CLE_PRIMAIRE,------  POUR JOINTURE
REC_VH_PRIX.VH_TYPE,------  POUR JOINTURE
REC_VH_PRIX.champs_P1A,
REC_VH_PRIX.champs_P1B,
REC_VH_PRIX.champs_P1C,
REC_VH_PRIX.champs_D1A,
REC_VH_PRIX.champs_D1B,
REC_VH_PRIX.champs_D1C,
REC_VH_PRIX.champs_P,
REC_VH_PRIX.champs_PWF1,
REC_VH_PRIX.champs_PWF2,
REC_VH_PRIX.champs_PWF3,
REC_VH_PRIX.moneda,
REC_VH_PRIX.champs_AMT,
REC_VH_PRIX.champs_AMG,
REC_VH_PRIX.VAL_Amount,
REC_VH_PRIX.VAL_Rate,
REC_VH_PRIX.champs_PP1,
REC_VH_PRIX.champs_PP2,
REC_VH_PRIX.champs_PP3
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_CARROS_PRIX
        Set
tech_id          =      REC_VH_PRIX.tech_id,
champs_P1A = REC_VH_PRIX.champs_P1A,
champs_P1B = REC_VH_PRIX.champs_P1B,
champs_P1C = REC_VH_PRIX.champs_P1C,
champs_D1A = REC_VH_PRIX.champs_D1A,
--champs_D1B = REC_VH_PRIX.champs_D1B,
champs_D1C = REC_VH_PRIX.champs_D1C,
champs_P = REC_VH_PRIX.champs_P,
champs_PWF1 = REC_VH_PRIX.champs_PWF1,
champs_PWF2 = REC_VH_PRIX.champs_PWF2,
champs_PWF3 = REC_VH_PRIX.champs_PWF3,
moneda = REC_VH_PRIX.moneda,
champs_AMT = REC_VH_PRIX.champs_AMT,
champs_AMG = REC_VH_PRIX.champs_AMG,
VAL_Amount = REC_VH_PRIX.VAL_Amount,
VAL_Rate = REC_VH_PRIX.VAL_Rate,
champs_PP1 = REC_VH_PRIX.champs_PP1,
champs_PP2 = REC_VH_PRIX.champs_PP2,
champs_PP3 = REC_VH_PRIX.champs_PP3,
VH_TYPE = REC_VH_PRIX.VH_TYPE

        where  COMP_CLE_PRIMAIRE = REC_VH_PRIX.COMP_CLE_PRIMAIRE
                and champs_D1B = REC_VH_PRIX.champs_D1B
        ;

        V_UPD := V_UPD + 1;
        --Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_PRIX',to_char(REC_VH_PRIX.COMP_CLE_PRIMAIRE)|| '-' || to_char(REC_VH_PRIX.champs_D1B) || '-' || to_char(REC_VH_PRIX.PARAM_2_GEN) );
        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_PRIX','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_PRIX','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));


   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_TAB_CARROS_PRIX;




  FUNCTION ALIM_TAB_CARROS_OPCIONES (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS_1   NUMBER := 0;
  V_UPD_1   NUMBER := 0;
  V_INS_2   NUMBER := 0;
  V_UPD_2   NUMBER := 0;
  V_INS_3   NUMBER := 0;
  V_UPD_3   NUMBER := 0;
  V_INS_4   NUMBER := 0;
  V_UPD_4   NUMBER := 0;
  V_INS_5   NUMBER := 0;
  V_UPD_5   NUMBER := 0;

  V_Packi_VAP  VARCHAR2(5);

        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;



  Cursor C_CARROS_OPCIONES Is

    WITH OPTION_VAP AS (Select /*+ PARALLEL(4) */ distinct
carros.tech_id AS tech_id, ------  POUR JOINTURE AVEC TAB_NVDprecios_VAP
carros.COMP_CLE_PRIMAIRE as COMP_CLE_PRIMAIRE,  ------  POUR JOINTURE AVEC VEH
'VAP' as VH_TYPE, ------  POUR JOINTURE
A.optioncode as code,
NULL as champs_CA1,
(case when B.catcode in (44, 45, 73, 74, 75, 76) then 'C1' when B.catcode in (81, 82, 86, 90, 97) then 'T' else 'O' end) as champs_CA2,
--(case when D.periodcode is not null then 'True' else 'False' end) as Packi,
(case when B.catcode in (44, 45, 73, 74, 75, 76, 81, 82, 86, 90, 97) then 'true' else 'false' end) as Present_YN, --- -21
carros.ValStartDate,
carros.ValEndDate,
A.effectivefrom as startDate,
A.effectiveto as endDate,
GREATEST(A.effectivefrom, ValStartDate) as OPCIONEStartDate,
case when A.effectiveto is null and ValEndDate is not null then ValEndDate
     when ValEndDate is null and A.effectiveto is not null then A.effectiveto
     else least(A.effectiveto, ValEndDate) end
as optionEndDate,
'en_ANONYM' as champs_EX3, --
B.champs_MA2 as champs_MA2,
B.champs_MA1 as champs_MA1,
A.champs_NK as champs_NK,
NULL as champs_CA5,
NULL as champs_P1B,
NULL as champs_P1C,
NULL as champs_D1A,
---effectiveFrom as champs_D1B,
---effectiveTo as champs_D1C,
NULL as champs_P,
'ANONYM'as moneda,
--champs_NK as champs_PWF1,
NULL as champs_PWF2,
NULL as champs_PWF3,
NULL as champs_BS1,
NULL as champs_BS2,
NULL as champs_BS3

from TAB_CARROS veh, SCHEMA2B.TAB_NVDOption_VAP A, SCHEMA2B.TAB_OPCIONES_ORIG B--, SCHEMA2B.TAB_NVDPackContents_VAP C, TAB_NVDPackPeriods_VAP D
where carros.tech_id = A.id --and (carros.ValStartDate < A.effectiveto or A.effectiveto is null) and (carros.ValEndDate > A.effectivefrom or carros.ValEndDate is null)
and carros.VH_TYPE = 'VAP'
and A.optioncode = B.optioncode)
--and A.optioncode = C.optioncode (+)
--and C.periodcode = D.periodcode (+))
 select VAP.*,
       CASE WHEN OPCIONEStartDate = optionEndDate THEN 0
            WHEN OPCIONEStartDate > ValEndDate THEN 0
            WHEN optionEndDate < ValStartDate THEN 0
            WHEN OPCIONEStartDate >= ValStartDate THEN 1
            ELSE 0
       END AS FLAG_PEC
FROM   OPTION_VAP VAP
WHERE   CASE WHEN OPCIONEStartDate = optionEndDate THEN 0
            WHEN OPCIONEStartDate > ValEndDate THEN 0
            WHEN optionEndDate < ValStartDate THEN 0
            WHEN OPCIONEStartDate >= ValStartDate THEN 1
            ELSE 0
       END = 1;


 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
    Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_OPCIONES','------------------BEGIN------------------##');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_OPCIONES','## Alimentation de la table SCHEMA2B.TAB_CARROS_OPCIONES ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_OPCIONES','## Flux BILAN   ##');

    BEGIN
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCHEMA2B.TAB_CARROS_OPCIONES';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCHEMA2B.TAB_CARROS_OPCIONESlabels';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCHEMA2B.TAB_CARROS_OPCIONESPRIX';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCHEMA2B.TAB_CARROS_AGREGADOSOpt';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCHEMA2B.TAB_CARROS_AGREGADOSOptLab'; --- -29
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS_OPCIONES',
                                   '## TRUNCATE OK ##' || SQL%ROWCOUNT);
            COMMIT;
        EXCEPTION WHEN OTHERS THEN
            V_ERR := 1;
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS_OPCIONES',
                                   '## TRUNCATE KO - FIN DU TRAITEMENT ##' || SQL%ROWCOUNT);
            RETURN V_ERR;
        END;

        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;


  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'Pour VAP : ',' ');

  FOR REC_CARROS_OPCIONES IN C_CARROS_OPCIONES
  LOOP

       /*************************************************************************/
       -- SCHEMA2B.TAB_CARROS_OPCIONES
       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD_1 + V_INS_1 + V_UPD_2 + V_INS_2 + V_UPD_3 + V_INS_3 + V_UPD_4 + V_INS_4 + V_UPD_5 + V_INS_5, 50000)=0 THEN COMMIT;
        END IF;

        BEGIN
          select 'True'
          INTO   V_Packi_VAP
          from   SCHEMA2B.TAB_NVDPackContents_VAP C,
                 TAB_NVDPackPeriods_VAP D
          WHERE  C.optioncode = REC_CARROS_OPCIONES.code
          AND    C.periodcode = D.periodcode;
        EXCEPTION WHEN NO_DATA_FOUND THEN
          V_Packi_VAP := 'False';
                  WHEN OTHERS THEN
          V_Packi_VAP := 'False';
        END;


        INSERT INTO SCHEMA2B.TAB_CARROS_OPCIONES
              (
tech_id,    ------  POUR JOINTURE
COMP_CLE_PRIMAIRE,------  POUR JOINTURE
VH_TYPE,------  POUR JOINTURE
code,
champs_CA1,
champs_CA2,
Packi,
Present_YN,
startDate,
endDate,
champs_MA2, 
champs_MA1, 
--effectivefrom, 
--effectiveto, 
champs_NK  
              )

        VALUES
              (
REC_CARROS_OPCIONES.tech_id,    ------  POUR JOINTURE
REC_CARROS_OPCIONES.COMP_CLE_PRIMAIRE,------  POUR JOINTURE
REC_CARROS_OPCIONES.VH_TYPE,------  POUR JOINTURE
REC_CARROS_OPCIONES.code,
REC_CARROS_OPCIONES.champs_CA1,
REC_CARROS_OPCIONES.champs_CA2,
V_Packi_VAP,
REC_CARROS_OPCIONES.Present_YN,
REC_CARROS_OPCIONES.OPCIONEStartDate,
REC_CARROS_OPCIONES.optionEndDate,
REC_CARROS_OPCIONES.champs_MA2, 
REC_CARROS_OPCIONES.champs_MA1, 
--REC_CARROS_OPCIONES.effectivefrom, 
--REC_CARROS_OPCIONES.effectiveto, 
REC_CARROS_OPCIONES.champs_NK  
              );

        V_INS_1 := V_INS_1 + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_CARROS_OPCIONES
        Set

--code = REC_CARROS_OPCIONES.code,
tech_id = REC_CARROS_OPCIONES.tech_id,
VH_TYPE = REC_CARROS_OPCIONES.VH_TYPE,
champs_CA1 = REC_CARROS_OPCIONES.champs_CA1,
champs_CA2 = REC_CARROS_OPCIONES.champs_CA2,
Packi   = V_Packi_VAP,
Present_YN = REC_CARROS_OPCIONES.Present_YN,
endDate  = REC_CARROS_OPCIONES.optionEndDate,
champs_MA2 = REC_CARROS_OPCIONES.champs_MA2, 
champs_MA1 = REC_CARROS_OPCIONES.champs_MA1, 
--effectivefrom = REC_CARROS_OPCIONES.effectivefrom, 
--effectiveto = REC_CARROS_OPCIONES.effectiveto, 
champs_NK = REC_CARROS_OPCIONES.champs_NK  

        where code = REC_CARROS_OPCIONES.code
        and   COMP_CLE_PRIMAIRE = REC_CARROS_OPCIONES.COMP_CLE_PRIMAIRE
        and   startDate = REC_CARROS_OPCIONES.OPCIONEStartDate;


        V_UPD_1 := V_UPD_1 + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_OPCIONES','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;



   END LOOP;

   COMMIT;

   V_INSERTS := V_INS_1 + V_INS_2 + V_INS_3 + V_INS_4 + V_INS_5;
   V_Updates := V_Upd_1 + V_UPD_2 + V_UPD_3 + V_UPD_4 + V_UPD_5;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_OPCIONES','Nombre de mises a jour : '||TO_CHAR(V_UPD_1)||', d''insertions : '||TO_CHAR(V_INS_1));

   /*************************************************************************/
   -- SCHEMA2B.TAB_CARROS_OPCIONESlabels
   /*************************************************************************/
   BEGIN
   INSERT /*+ append */ INTO  TAB_CARROS_OPCIONESLABELS (TECH_ID,
                              COMP_CLE_PRIMAIRE,
                              VH_TYPE,
                              CODE,
                              champs_EX3,
                              LABELSHORT,
                              LABELLONG)
                              SELECT DISTINCT TECH_ID, COMP_CLE_PRIMAIRE, VH_TYPE, CODE, 'en_ANONYM', champs_MA2, champs_MA1
                              FROM TAB_CARROS_OPCIONES
                              WHERE VH_TYPE = 'VAP';
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_OPCIONESlabels','Nombre de mises a jour : '||0||', d''insertions : '||TO_CHAR(SQL%ROWCOUNT));
   COMMIT;
   EXCEPTION WHEN OTHERS THEN
    V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
    Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_OPCIONESlabels','Message Erreur pl/sql :'||Sqlerrm,'E');
    COMMIT;
    V_ERR := 1;
    RETURN V_ERR;
   END;

   /*************************************************************************/
   -- SCHEMA2B.TAB_CARROS_OPCIONESPRIX
   /*************************************************************************/
   BEGIN
   INSERT /*+ append */ INTO  TAB_CARROS_OPCIONESPRIX (TECH_ID,
                              COMP_CLE_PRIMAIRE,
                              VH_TYPE,
                              CODE,
                              champs_CA5,
                              champs_P1B,
                              champs_P1C,
                              champs_D1A,
                              champs_D1B,
                              champs_D1C,
                              champs_P,
                              moneda,
                              champs_PWF1,
                              champs_PWF2,
                              champs_PWF3,
                              champs_BS1,
                              champs_BS2,
                              champs_BS3)
                              SELECT DISTINCT TECH_ID, COMP_CLE_PRIMAIRE, VH_TYPE, CODE, NULL, NULL, NULL, NULL, STARTDATE, ENDDATE, NULL, 'GBP', champs_NK, NULL, NULL, NULL, NULL, NULL
                              FROM TAB_CARROS_OPCIONES
                              WHERE VH_TYPE = 'VAP';
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_OPCIONES_PRIX','Nombre de mises a jour : '||0||', d''insertions : '||TO_CHAR(SQL%ROWCOUNT));
   COMMIT;
   EXCEPTION WHEN OTHERS THEN
    V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
    Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_OPCIONES_PRIX','Message Erreur pl/sql :'||Sqlerrm,'E');
    COMMIT;
    V_ERR := 1;
    RETURN V_ERR;
   END;



-----------------------------
   /*************************************************************************/
   -- SCHEMA2B.TAB_CARROS_AGREGADOSOpt
   /*************************************************************************/
   BEGIN
   INSERT /*+ append */ INTO  TAB_CARROS_AGREGADOSOpt (tech_id,
                              COMP_CLE_PRIMAIRE,
                              VH_TYPE,
                              code,
                              cateCode,
                              moneda,
                              champs_PWF1,
                              champs_PWF2,
                              champs_PWF3,
                              champs_P
                              )
                              SELECT  tech_id AS tech_id,
                              COMP_CLE_PRIMAIRE AS COMP_CLE_PRIMAIRE,
                              VH_TYPE AS VH_TYPE,
                              code AS code,
                              (case when champs_CA2 = 'C1' then 'ext' when champs_CA2 = 'T' then 'int' end) AS cateCode,
                              'ANONYM'AS moneda,
                              max(champs_NK) AS champs_PWF1,
                              NULL AS champs_PWF2,
                              NULL AS champs_PWF3,
                              NULL AS champs_P
                              FROM SCHEMA2B.TAB_CARROS_OPCIONES
                              WHERE VH_TYPE = 'VAP'
                              AND Present_YN = 'true'
                              group by
                              tech_id,
                              COMP_CLE_PRIMAIRE,
                              VH_TYPE,
                              code,
                              (case when champs_CA2 = 'C1' then 'ext' when champs_CA2 = 'T' then 'int' end),
                              'GBP';
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_AGREGADOSOpt','Nombre de mises a jour : '||0||', d''insertions : '||TO_CHAR(SQL%ROWCOUNT));
   COMMIT;
   EXCEPTION WHEN OTHERS THEN
    V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
    Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_AGREGADOSOpt','Message Erreur pl/sql :'||Sqlerrm,'E');
    COMMIT;
    V_ERR := 1;
    RETURN V_ERR;
   END;





   ----------------------

   /*************************************************************************/
   -- SCHEMA2B.TAB_CARROS_AGREGADOSOptLab
   /*************************************************************************/
   BEGIN
   INSERT /*+ append */ INTO  TAB_CARROS_AGREGADOSOPTLAB (tech_id,
                              COMP_CLE_PRIMAIRE,
                              code,
                              VH_TYPE,
                              champs_MA1
                              )
                              SELECT DISTINCT TECH_ID, COMP_CLE_PRIMAIRE, code, VH_TYPE, champs_MA1
                              FROM TAB_CARROS_OPCIONES
                              WHERE VH_TYPE = 'VAP'
                              AND Present_YN = 'true';
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_AGREGADOSOptLab','Nombre de mises a jour : '||0||', d''insertions : '||TO_CHAR(SQL%ROWCOUNT));
   COMMIT;
   EXCEPTION WHEN OTHERS THEN
    V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
    Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_AGREGADOSOptLab','Message Erreur pl/sql :'||Sqlerrm,'E');
    COMMIT;
    V_ERR := 1;
    RETURN V_ERR;
   END;


   -----------------------------

   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;

   EXCEPTION WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_OPCIONES','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
   End;


  END ALIM_TAB_CARROS_OPCIONES;



  FUNCTION ALIM_TAB_CARROS_EQUIPOS (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;




  Cursor C_CARROS_EQUIPOS Is
Select distinct
tech_id,    ------  POUR JOINTURE
COMP_CLE_PRIMAIRE,------  POUR JOINTURE
------VersYear,------  POUR JOINTURE
------VersTrimester,------  POUR JOINTURE
------gener,
------DIMS,  
------PARAM_2_GEN,
VH_TYPE,------  POUR JOINTURE
A.optioncode as champs_EX1,
NULL as champs_EX2,
'en_ANONYM' as champs_EX3,
B.champs_MA2 as label

from SCHEMA2B.TAB_CARROS veh, SCHEMA2B.TAB_EQUIPOS A, SCHEMA2B.TAB_OPCIONES_ORIG B
where carros.tech_id = A.Id and carros.VH_TYPE = 'VAP'
and A.optioncode = B.optioncode  (+)
and (carros.ValStartDate < A.effectiveto or A.effectiveto is null) and (carros.ValEndDate > A.effectivefrom or carros.ValEndDate is null);


 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
    Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_EQUIPOS','------------------BEGIN------------------##');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_EQUIPOS','## Alimentation de la table SCHEMA2B.TAB_CARROS_EQUIPOS ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_EQUIPOS','## Flux BILAN   ##');


  BEGIN
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCHEMA2B.TAB_CARROS_EQUIPOS';
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS_EQUIPOS',
                                   '## TRUNCATE OK ##' || SQL%ROWCOUNT);
            COMMIT;
        EXCEPTION WHEN OTHERS THEN
            V_ERR := 1;
            RES     := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID,
                                   'ALIM_TAB_CARROS_EQUIPOS',
                                   '## TRUNCATE KO - FIN DU TRAITEMENT ##' || SQL%ROWCOUNT);
            RETURN V_ERR;
        END;

        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;


  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'Pour VAP + VAU : ',' ');


  FOR REC_CARROS_EQUIPOS IN C_CARROS_EQUIPOS
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 10000)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_CARROS_EQUIPOS
              (
tech_id,    ------  POUR JOINTURE
COMP_CLE_PRIMAIRE,------  POUR JOINTURE
------VersYear,------  POUR JOINTURE
------VersTrimester,------  POUR JOINTURE
------gener,
------DIMS,  
------PARAM_2_GEN,
VH_TYPE,------  POUR JOINTURE
champs_EX1,
champs_EX2,
champs_EX3,
label
              )

        VALUES
              (
REC_CARROS_EQUIPOS.tech_id,    ------  POUR JOINTURE
REC_CARROS_EQUIPOS.COMP_CLE_PRIMAIRE,------  POUR JOINTURE
------REC_CARROS_EQUIPOS.VersYear,------  POUR JOINTURE
------REC_CARROS_EQUIPOS.VersTrimester,------  POUR JOINTURE
------REC_CARROS_EQUIPOS.gener,
------REC_CARROS_EQUIPOS.DIMS,  
------REC_CARROS_EQUIPOS.PARAM_2_GEN,
REC_CARROS_EQUIPOS.VH_TYPE,------  POUR JOINTURE
REC_CARROS_EQUIPOS.champs_EX1,
REC_CARROS_EQUIPOS.champs_EX2,
REC_CARROS_EQUIPOS.champs_EX3,
REC_CARROS_EQUIPOSchamps_EX4
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_CARROS_EQUIPOS
        Set
--champs_EX1= REC_CARROS_EQUIPOS.champs_EX1,
tech_id          =      REC_CARROS_EQUIPOS.tech_id,
VH_TYPE = REC_CARROS_EQUIPOS.VH_TYPE,
champs_EX2= REC_CARROS_EQUIPOS.champs_EX2,
champs_EX3= REC_CARROS_EQUIPOS.champs_EX3,
label= REC_CARROS_EQUIPOSchamps_EX4

        where  champs_EX1          =      REC_CARROS_EQUIPOS.champs_EX1
        and  COMP_CLE_PRIMAIRE = REC_CARROS_EQUIPOS.COMP_CLE_PRIMAIRE ;



        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TAB_CARROS_EQUIPOS','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TAB_CARROS_EQUIPOS','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));




   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_TAB_CARROS_EQUIPOS;

-----------------------------------------------------------------
-----------------------------------------------------------------



  FUNCTION ALIM_TRACOCO_1A (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;

  Cursor C_TRACOCO_1A Is

 select  distinct

                 PARAM_1_CODE     as  champs_PC,  -- bdCode
                CAPAMAN_NAME || ' | ' || VH_NAME   as  champs_MA2_label,
                --VH_TYPE,
                --PARAM_2_gen_num,
                PARAM_2_GEN_ID    as code,
                champs_TP3   as champs_TP3,
                traco_LABEL as traco_LABEL

 from  SCHEMA2B.TAB_PARAM_2GEN_1A
;


 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
    Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_1A','--------------BEGIN----------------');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_1A','## Alimentation de la table SCHEMA2B.TAB_PARAM_NOMEN ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TRACOCO_1A','## Flux BILAN   ##');


        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;



  FOR REC_tracoco IN C_TRACOCO_1A
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_PARAM_NOMEN
              (
Entity,
code,
start_Val_Date,
start_End_Date,
champs_PC,
champs_PC2,
champs_PC1,
champs_MA2_champs_EX3,
champs_MA2_label,
champs_TP1,
champs_TP2,
champs_TP3,
traco_champs_EX3,
traco_label,
champs_W11,
PaysDiam
              )
        VALUES
              (
'1A', --Entity
REC_tracoco.code, --code
to_date('01/01/2010', 'MM/DD/YYYY'), --start_Val_Date
to_date('12/31/2999', 'MM/DD/YYYY'), --start_End_Date
REC_tracoco.champs_PC, --- champs_NKchamps_PC1 = champs_PC
'bdCode', --champs_PC2
REC_tracoco.champs_PC, -- champs_PC1
'en_ANONYM', --champs_MA2_champs_EX3,
REC_tracoco.champs_MA2_label, --champs_MA2_label
'CAPA',  -- champs_TP1,
'COUNTRY_INVENT', --champs_TP2,
REC_tracoco.champs_TP3,  --champs_TP3
'en_ANONYM',  --traco_champs_EX3,
REC_tracoco.traco_LABEL, --- champs_NKtraco_label = champs_MA2_label  -- changement
'', --champs_W11,
'COUNTRY_INVENT'    --PaysDiam
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_PARAM_NOMEN
        Set


      champs_PC1 = REC_tracoco.champs_PC, --- mapping  champs_PC1 = champs_PC;
      traco_label = REC_tracoco.traco_LABEL,  --- mappring traco_label = champs_MA2_label  -- changement
      champs_MA2_label = REC_tracoco.champs_MA2_label

      where  entity = '1A'
      and start_Val_Date = to_date('01/01/2010', 'MM/DD/YYYY')
      and start_End_Date = to_date('12/31/2999', 'MM/DD/YYYY')
      and champs_PC2 = 'bdCode'
      and champs_MA2_champs_EX3 = 'en_ANONYM'
      and champs_TP1 = 'CAPA'
      and champs_TP2 = 'COUNTRY_INVENT'
      and traco_champs_EX3 = 'en_ANONYM'
      and champs_W11 = '1A'
      and PaysDiam = 'COUNTRY_INVENT'
       and code = REC_tracoco.code
       --and champs_MA2_label = REC_tracoco.champs_MA2_label  --NOUVEAU
       and champs_TP3 = REC_tracoco.champs_TP3
        and  champs_PC =   REC_tracoco.champs_PC ;


        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_1A','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TRACOCO_1A','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'I',' ',' ');



   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   EXCEPTION WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_1A','Message Erreur pl/sql :'||Sqlerrm,'E');

   End;

  END ALIM_TRACOCO_1A;





  FUNCTION ALIM_TRACOCO_2B (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;

  Cursor C_TRACOCO_2B Is


 select  distinct
                TRIM.PARAM_1_CODE || PARAM_2_gen.PARAM_2_gen_id     as  champs_PC,  -- bdCode
               --TRIM.VH_NAME  || ' | '  || TRIM.VH_TRIM as  champs_MA2_label,
               TRIM.VH_TRIM as  champs_MA2_label, --  -34
                --VH_TYPE,
                --PARAM_2_gen_num,
                TRIM.TRIM_ID    as code,
                TRIM.champs_TP3   as champs_TP3,
                TRIM.PARAM_1_CODE as champs_PC1_bdCode, -- 1 loop
                PARAM_2_gen.PARAM_2_gen_id as champs_PC1    -- 2 loop

 from  SCHEMA2B.TAB_PARAM_2GEN_2B  TRIM, SCHEMA2B.TAB_PARAM_2GEN_1A PARAM_2_gen
  where TRIM.PARAM_1_CODE = PARAM_2_gen.PARAM_1_CODE
 and TRIM.VH_NAME = PARAM_2_gen.VH_NAME
  and TRIM.VH_TYPE = PARAM_2_gen.VH_TYPE
;





 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_2B','##  champs_MA2_label = bdCode ##');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_2B','## Alimentation de la table SCHEMA2B.TAB_PARAM_NOMEN ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TRACOCO_2B','## Flux BILAN   ##');


        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;





  FOR REC_tracoco IN C_TRACOCO_2B
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_PARAM_NOMEN
              (
Entity,
code,
start_Val_Date,
start_End_Date,
champs_PC,
champs_PC2,
champs_PC1,
champs_MA2_champs_EX3,
champs_MA2_label,
champs_TP1,
champs_TP2,
champs_TP3,
traco_champs_EX3,
traco_label,
champs_W11,
PaysDiam
              )
        VALUES
              (
'2B', --Entity
REC_tracoco.code, --code
to_date('01/01/2010', 'MM/DD/YYYY'), --start_Val_Date
to_date('12/31/2999', 'MM/DD/YYYY'), --start_End_Date
REC_tracoco.champs_PC, --REC_tracoco.champs_PC
'bdCode', --champs_PC2
REC_tracoco.champs_PC1_bdCode, -- champs_PC1
'en_ANONYM', --champs_MA2_champs_EX3,
REC_tracoco.champs_MA2_label, --champs_MA2_label
'CAPA',  -- champs_TP1,
'COUNTRY_INVENT', --champs_TP2,
REC_tracoco.champs_TP3,  --champs_TP3
'en_ANONYM',  --traco_champs_EX3,
REC_tracoco.champs_MA2_label, --- champs_NKtraco_label = champs_MA2_label
'champs_ATT', --champs_W11,
'COUNTRY_INVENT'    --PaysDiam
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_PARAM_NOMEN
        Set
       champs_PC1 =   REC_tracoco.champs_PC1_bdCode,   -- champs_PC = champs_PC1
      traco_label = REC_tracoco.champs_MA2_label,  --- mappring traco_label = champs_MA2_label
      champs_MA2_label = REC_tracoco.champs_MA2_label

      where  entity = '2B'
      and start_Val_Date = to_date('01/01/2010', 'MM/DD/YYYY')
      and start_End_Date = to_date('12/31/2999', 'MM/DD/YYYY')
      and champs_PC2 = 'bdCode'
      and champs_MA2_champs_EX3 = 'en_ANONYM'
      and champs_TP1 = 'CAPA'
      and champs_TP2 = 'COUNTRY_INVENT'
      and traco_champs_EX3 = 'en_ANONYM'
      and champs_W11 = 'champs_ATT'
      and PaysDiam = 'COUNTRY_INVENT'
       and code = REC_tracoco.code
       --and champs_MA2_label = REC_tracoco.champs_MA2_label  --NOUVEAU
       and champs_TP3 = REC_tracoco.champs_TP3
      and champs_PC = REC_tracoco.champs_PC ;



        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_2B','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TRACOCO_2B','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'I',' ',' ');


  ------------ PARAM_2_gen
  V_INS  := 0;
  V_UPD  := 0;
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_2B','##  champs_MA2_label = PARAM_2_gen ##');

  FOR REC_tracoco IN C_TRACOCO_2B
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_PARAM_NOMEN
              (
Entity,
code,
start_Val_Date,
start_End_Date,
champs_PC,
champs_PC2,
champs_PC1,
champs_MA2_champs_EX3,
champs_MA2_label,
champs_TP1,
champs_TP2,
champs_TP3,
traco_champs_EX3,
traco_label,
champs_W11,
PaysDiam
              )
        VALUES
              (
'2B', --Entity
REC_tracoco.code, --code
to_date('01/01/2010', 'MM/DD/YYYY'), --start_Val_Date
to_date('12/31/2999', 'MM/DD/YYYY'), --start_End_Date
REC_tracoco.champs_PC, --REC_tracoco.champs_PC
'1A', --champs_PC2
REC_tracoco.champs_PC1, -- champs_PC1
'en_ANONYM', --champs_MA2_champs_EX3,
REC_tracoco.champs_MA2_label, --champs_MA2_label
'CAPA',  -- champs_TP1,
'COUNTRY_INVENT', --champs_TP2,
REC_tracoco.champs_TP3,  --champs_TP3
'en_ANONYM',  --traco_champs_EX3,
REC_tracoco.champs_MA2_label, --- champs_NKtraco_label = champs_MA2_label
'champs_ATT', --champs_W11,
'COUNTRY_INVENT'    --PaysDiam
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_PARAM_NOMEN
        Set

      champs_PC1 =   REC_tracoco.champs_PC1,   -- champs_PC = champs_PC1
      traco_label = REC_tracoco.champs_MA2_label,  --- mappring traco_label = champs_MA2_label
      champs_MA2_label = REC_tracoco.champs_MA2_label

      where  entity = '2B'
      and start_Val_Date = to_date('01/01/2010', 'MM/DD/YYYY')
      and start_End_Date = to_date('12/31/2999', 'MM/DD/YYYY')
      and champs_PC2 = '1A'
      and champs_MA2_champs_EX3 = 'en_ANONYM'
      and champs_TP1 = 'CAPA'
      and champs_TP2 = 'COUNTRY_INVENT'
      and traco_champs_EX3 = 'en_ANONYM'
      and champs_W11 = 'champs_ATT'
      and PaysDiam = 'COUNTRY_INVENT'
       and code = REC_tracoco.code
       --and champs_MA2_label = REC_tracoco.champs_MA2_label  --NOUVEAU
       and champs_TP3 = REC_tracoco.champs_TP3
       and champs_PC = REC_tracoco.champs_PC ;


        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_2B','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TRACOCO_2B','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'I',' ',' ');






   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_TRACOCO_2B;






  FUNCTION ALIM_TRACOCO_3C (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;

--471   gener
--477   gener

  Cursor C_TRACOCO_3C Is

 select  distinct
                motorBLAD.PARAM_1_CODE || PARAM_2_gen.PARAM_2_gen_id     as  champs_PC,  -- bdCode
                --motorBLAD.VH_NAME || ' | ' ||  motorBLAD.VH_motorBLAD   as  champs_MA2_label,
                motorBLAD.VH_motorBLAD   as  champs_MA2_label, --  -34
                --VH_TYPE,
                --PARAM_2_gen_num,
                motorBLAD.motorBLAD_ID    as code,
               -- motorBLAD.champs_TP3   as champs_TP3,
                motorBLAD.PARAM_1_CODE as champs_PC1_bdCode, -- 1 loop
                PARAM_2_gen.PARAM_2_gen_id as champs_PC1    -- 2 loop

 from  SCHEMA2B.TAB_PARAM_2GEN_3C  motorBLAD, SCHEMA2B.TAB_PARAM_2GEN_1A PARAM_2_gen
 where motorBLAD.PARAM_1_CODE = PARAM_2_gen.PARAM_1_CODE
 and motorBLAD.VH_NAME = PARAM_2_gen.VH_NAME
 and motorBLAD.VH_TYPE = PARAM_2_gen.VH_TYPE

;


 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_3C','##  champs_MA2_label = bdCode ##');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_3C','## Alimentation de la table SCHEMA2B.TAB_PARAM_NOMEN ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TRACOCO_3C','## Flux BILAN   ##');


        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;



  FOR REC_tracoco IN C_TRACOCO_3C
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_PARAM_NOMEN
              (
Entity,
code,
start_Val_Date,
start_End_Date,
champs_PC,
champs_PC2,
champs_PC1,
champs_MA2_champs_EX3,
champs_MA2_label,
champs_TP1,
champs_TP2,
champs_TP3,
traco_champs_EX3,
traco_label,
champs_W11,
PaysDiam
              )
        VALUES
              (
'3C', --Entity
REC_tracoco.code, --code
to_date('01/01/2010', 'MM/DD/YYYY'), --start_Val_Date
to_date('12/31/2999', 'MM/DD/YYYY'), --start_End_Date
REC_tracoco.champs_PC, --REC_tracoco.champs_PC,
'bdCode', --champs_PC2
REC_tracoco.champs_PC1_bdCode, -- champs_PC1
'en_ANONYM', --champs_MA2_champs_EX3,
REC_tracoco.champs_MA2_label, --champs_MA2_label
'CAPA',  -- champs_TP1,
'COUNTRY_INVENT', --champs_TP2,
REC_tracoco.champs_MA2_label,  --champs_TP3  --- champs_NKchamps_TP3 = champs_MA2_label
'en_ANONYM',  --traco_champs_EX3,
REC_tracoco.champs_MA2_label, --- champs_NKtraco_label = champs_MA2_label
'', --champs_W11,
'COUNTRY_INVENT'    --PaysDiam
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_PARAM_NOMEN
        Set

      champs_PC1 =   REC_tracoco.champs_PC1_bdCode,   -- champs_PC = champs_PC1
      traco_label = REC_tracoco.champs_MA2_label,  --- mapping traco_label = champs_MA2_label
      champs_MA2_label = REC_tracoco.champs_MA2_label

      where  entity = '3C'
      and start_Val_Date = to_date('01/01/2010', 'MM/DD/YYYY')
      and start_End_Date = to_date('12/31/2999', 'MM/DD/YYYY')
      and champs_PC2 = 'bdCode'
      and champs_MA2_champs_EX3 = 'en_ANONYM'
      and champs_TP1 = 'CAPA'
      and champs_TP2 = 'COUNTRY_INVENT'
      and traco_champs_EX3 = 'en_ANONYM'
      and champs_W11 = ''
      and PaysDiam = 'COUNTRY_INVENT'
       and code = REC_tracoco.code
       --and champs_MA2_label = REC_tracoco.champs_MA2_label  --NOUVEAU
      and champs_TP3 = REC_tracoco.champs_MA2_label
      and champs_PC = REC_tracoco.champs_PC ; --- mapping  champs_PC1 = champs_PC

        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_3C','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TRACOCO_3C','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'I',' ',' ');


  ------------ PARAM_2_gen
  V_INS  := 0;
  V_UPD  := 0;
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_3C','##  champs_MA2_label = PARAM_2_gen ##');


  FOR REC_tracoco IN C_TRACOCO_3C
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_PARAM_NOMEN
              (
Entity,
code,
start_Val_Date,
start_End_Date,
champs_PC,
champs_PC2,
champs_PC1,
champs_MA2_champs_EX3,
champs_MA2_label,
champs_TP1,
champs_TP2,
champs_TP3,
traco_champs_EX3,
traco_label,
champs_W11,
PaysDiam
              )
        VALUES
              (
'3C', --Entity
REC_tracoco.code, --code
to_date('01/01/2010', 'MM/DD/YYYY'), --start_Val_Date
to_date('12/31/2999', 'MM/DD/YYYY'), --start_End_Date
REC_tracoco.champs_PC, --REC_tracoco.champs_PC,
'1A', --champs_PC2
REC_tracoco.champs_PC1, -- champs_PC1
'en_ANONYM', --champs_MA2_champs_EX3,
REC_tracoco.champs_MA2_label, --champs_MA2_label
'CAPA',  -- champs_TP1,
'COUNTRY_INVENT', --champs_TP2,
REC_tracoco.champs_MA2_label,  --champs_TP3  --- champs_NKchamps_TP3 = champs_MA2_label
'en_ANONYM',  --traco_champs_EX3,
REC_tracoco.champs_MA2_label, --- champs_NKtraco_label = champs_MA2_label
'', --champs_W11,
'COUNTRY_INVENT'    --PaysDiam
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_PARAM_NOMEN
        Set

      champs_PC1 =   REC_tracoco.champs_PC1,   -- champs_PC = champs_PC1
      traco_label = REC_tracoco.champs_MA2_label,  --- mapping traco_label = champs_MA2_label
      champs_MA2_label = REC_tracoco.champs_MA2_label

      where  entity = '3C'
      and start_Val_Date = to_date('01/01/2010', 'MM/DD/YYYY')
      and start_End_Date = to_date('12/31/2999', 'MM/DD/YYYY')
      and champs_PC2 = '1A'
      and champs_MA2_champs_EX3 = 'en_ANONYM'
      and champs_TP1 = 'CAPA'
      and champs_TP2 = 'COUNTRY_INVENT'
      and traco_champs_EX3 = 'en_ANONYM'
      and champs_W11 = ''
      and PaysDiam = 'COUNTRY_INVENT'
       and code = REC_tracoco.code
       --and champs_MA2_label = REC_tracoco.champs_MA2_label  --NOUVEAU
       and champs_TP3 = REC_tracoco.champs_MA2_label
       and champs_PC = REC_tracoco.champs_PC; --- mapping  champs_PC1 = champs_PC

        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_3C','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TRACOCO_3C','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'I',' ',' ');







   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   EXCEPTION WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_3C','Message Erreur pl/sql :'||Sqlerrm,'E');
   End;

  END ALIM_TRACOCO_3C;






  FUNCTION ALIM_TRACOCO_4D (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;


  Cursor C_TRACOCO_4D Is

 select  distinct
                DIMS.PARAM_1_CODE || PARAM_2_gen.PARAM_2_gen_id     as  champs_PC,  -- bdCode
                --DIMS.VH_NAME || ' | ' || DIMS.VH_DIMS   as  champs_MA2_label,
                DIMS.VH_DIMS   as  champs_MA2_label, --  -34
                --VH_TYPE,
                --PARAM_2_gen_num,
                DIMS.DIMS_ID    as code,
               -- motorBLAD.champs_TP3   as champs_TP3,
                DIMS.PARAM_1_CODE as champs_PC1_bdCode, -- 1 loop
                PARAM_2_gen.PARAM_2_gen_id as champs_PC1    -- 2 loop

 from  SCHEMA2B.TAB_PARAM_2GEN_4D  DIMS, SCHEMA2B.TAB_PARAM_2GEN_1A PARAM_2_gen
  where DIMS.PARAM_1_CODE = PARAM_2_gen.PARAM_1_CODE
 and DIMS.VH_NAME = PARAM_2_gen.VH_NAME
 and DIMS.VH_TYPE = PARAM_2_gen.VH_TYPE

 and DIMS.DIMS_id != '  ';



 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_4D','##  champs_MA2_label = bdCode ##');
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_4D','## Alimentation de la table SCHEMA2B.TAB_PARAM_NOMEN ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TRACOCO_4D','## Flux BILAN   ##');


        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;




  FOR REC_tracoco IN C_TRACOCO_4D
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_PARAM_NOMEN
              (
Entity,
code,
start_Val_Date,
start_End_Date,
champs_PC,
champs_PC2,
champs_PC1,
champs_MA2_champs_EX3,
champs_MA2_label,
champs_TP1,
champs_TP2,
champs_TP3,
traco_champs_EX3,
traco_label,
champs_W11,
PaysDiam
              )
        VALUES
              (
'4D', --Entity
REC_tracoco.code, --code
to_date('01/01/2010', 'MM/DD/YYYY'), --start_Val_Date
to_date('12/31/2999', 'MM/DD/YYYY'), --start_End_Date
REC_tracoco.champs_PC, --REC_tracoco.champs_PC
'bdCode', --champs_PC2
REC_tracoco.champs_PC1_bdCode, -- champs_PC1
'en_ANONYM', --champs_MA2_champs_EX3,
REC_tracoco.champs_MA2_label, --champs_MA2_label
'CAPA',  -- champs_TP1,
'COUNTRY_INVENT', --champs_TP2,
REC_tracoco.champs_MA2_label,  --champs_TP3  --- champs_NKchamps_TP3 = champs_MA2_label
'en_ANONYM',  --traco_champs_EX3,
REC_tracoco.champs_MA2_label, --- champs_NKtraco_label = champs_MA2_label
'', --champs_W11,
'COUNTRY_INVENT'    --PaysDiam
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_PARAM_NOMEN
        Set

      champs_PC1 =   REC_tracoco.champs_PC1_bdCode,   -- champs_PC = champs_PC1
      traco_label = REC_tracoco.champs_MA2_label,  --- mappring traco_label = champs_MA2_label
      champs_MA2_label = REC_tracoco.champs_MA2_label

      where  entity = '4D'
      and start_Val_Date = to_date('01/01/2010', 'MM/DD/YYYY')
      and start_End_Date = to_date('12/31/2999', 'MM/DD/YYYY')
      and champs_PC2 = 'bdCode'
      and champs_MA2_champs_EX3 = 'en_ANONYM'
      and champs_TP1 = 'CAPA'
      and champs_TP2 = 'COUNTRY_INVENT'
      and traco_champs_EX3 = 'en_ANONYM'
      and champs_W11 = ''
      and PaysDiam = 'COUNTRY_INVENT'
       and code = REC_tracoco.code
       --and champs_MA2_label = REC_tracoco.champs_MA2_label  --NOUVEAU
       and champs_TP3 = REC_tracoco.champs_MA2_label
       and  champs_PC = REC_tracoco.champs_PC; --- mapping  champs_PC1 = champs_PC


        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_4D','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TRACOCO_4D','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'I',' ',' ');





  ------------ PARAM_2_gen
  V_INS  := 0;
  V_UPD  := 0;
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_4D','##  champs_MA2_label = PARAM_2_gen ##');


  FOR REC_tracoco IN C_TRACOCO_4D
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_PARAM_NOMEN
              (
Entity,
code,
start_Val_Date,
start_End_Date,
champs_PC,
champs_PC2,
champs_PC1,
champs_MA2_champs_EX3,
champs_MA2_label,
champs_TP1,
champs_TP2,
champs_TP3,
traco_champs_EX3,
traco_label,
champs_W11,
PaysDiam
              )
        VALUES
              (
'4D', --Entity
REC_tracoco.code, --code
to_date('01/01/2010', 'MM/DD/YYYY'), --start_Val_Date
to_date('12/31/2999', 'MM/DD/YYYY'), --start_End_Date
REC_tracoco.champs_PC, --REC_tracoco.champs_PC
'1A', --champs_PC2
REC_tracoco.champs_PC1, -- champs_PC1
'en_ANONYM', --champs_MA2_champs_EX3,
REC_tracoco.champs_MA2_label, --champs_MA2_label
'CAPA',  -- champs_TP1,
'COUNTRY_INVENT', --champs_TP2,
REC_tracoco.champs_MA2_label,  --champs_TP3  --- champs_NKchamps_TP3 = champs_MA2_label
'en_ANONYM',  --traco_champs_EX3,
REC_tracoco.champs_MA2_label, --- champs_NKtraco_label = champs_MA2_label
'', --champs_W11,
'COUNTRY_INVENT'    --PaysDiam
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_PARAM_NOMEN
        Set

      champs_PC1 =   REC_tracoco.champs_PC1,   -- champs_PC = champs_PC1
      traco_label = REC_tracoco.champs_MA2_label,  --- mapping traco_label = champs_MA2_label
      champs_MA2_label = REC_tracoco.champs_MA2_label

      where  entity = '4D'
      and start_Val_Date = to_date('01/01/2010', 'MM/DD/YYYY')
      and start_End_Date = to_date('12/31/2999', 'MM/DD/YYYY')
      and champs_PC2 = '1A'
      and champs_MA2_champs_EX3 = 'en_ANONYM'
      and champs_TP1 = 'CAPA'
      and champs_TP2 = 'COUNTRY_INVENT'
      and traco_champs_EX3 = 'en_ANONYM'
      and champs_W11 = ''
      and PaysDiam = 'COUNTRY_INVENT'
       and code = REC_tracoco.code
       --and champs_MA2_label = REC_tracoco.champs_MA2_label  --NOUVEAU
       and champs_TP3 = REC_tracoco.champs_MA2_label
       and champs_PC = REC_tracoco.champs_PC ; --- mapping  champs_PC1 = champs_PC


        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_TRACOCO_4D','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_TRACOCO_4D','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'I',' ',' ');




   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_TRACOCO_4D;








  FUNCTION UPDATE_TRACOCO_PARAM_2 (  NOMLOG      VARCHAR2,
                                P_DATE_TRAI DATE DEFAULT SYSDATE,
                                V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2) Return Number AS
BEGIN
  DECLARE

  V_ERR   NUMBER := 0;
  V_INS   NUMBER := 0;
  V_UPD   NUMBER := 0;
        V_ANNEE NUMBER ;
        V_MOIS  NUMBER ;
        V_JOUR NUMBER;
        V_SITU_DATE Date;


  FILE_ID UTL_FILE.FILE_TYPE;
  RES     NUMBER := 0;

  Cursor C_TRACOCO_1A Is

  select

  Entity			    as Entity,
code			as code,
start_Val_Date	as start_Val_Date,
start_End_Date		as start_End_Date,
champs_PC			as champs_PC,
champs_PC2		   as champs_PC2,
--champs_PC1		as champs_PC1,
champs_MA2_champs_EX3		as champs_MA2_champs_EX3,
champs_MA2_label		as champs_MA2_label,
champs_TP1		as champs_TP1,
champs_TP2		as champs_TP2,
champs_TP3			as champs_TP3,
traco_champs_EX3	as traco_champs_EX3,
substr(champs_MA2_label,instr(champs_MA2_label,':')+1 )  	as traco_label,   -------- traco_labels   ----- modif
champs_W11		as champs_W11,
PaysDiam	as PaysDiam
  from SCHEMA2B.TAB_PARAM_NOMEN where entity = 'PARAM_2101'
;


 /*******************************************************************************/
  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);

  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'UPDATE_TRACOCO_PARAM_2','## champs_NK de bdCode dans champs_PC1 ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'UPDATE_TRACOCO_PARAM_2','## Flux BILAN   ##');


        SELECT trunc(P_DATE_TRAI) INTO V_SITU_DATE FROM dual;
        Select To_Number(To_Char(V_SITU_DATE,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_SITU_DATE,'YYYY'))   INTO V_ANNEE  from dual;
        SELECT to_number(to_char(V_SITU_DATE,'DD'))   INTO V_JOUR  from dual;





  FOR REC_tracoco IN C_TRACOCO_1A
  LOOP

       /*************************************************************************/
        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_PARAM_NOMEN
              (
Entity,
code,
start_Val_Date,
start_End_Date,
champs_PC,
champs_PC2,
champs_PC1,
champs_MA2_champs_EX3,
champs_MA2_label,
champs_TP1,
champs_TP2,
champs_TP3,
traco_champs_EX3,
traco_label,
champs_W11,
PaysDiam
              )
        VALUES  --REC_tracoco
              (
REC_tracoco.etty,
REC_tracoco.code,
REC_tracoco.start_Val_Date,
REC_tracoco.start_End_Date,
REC_tracoco.champs_PC,
REC_tracoco.champs_PC2,
REC_tracoco.champs_PC,   --- champs_PC1
REC_tracoco.champs_MA2_champs_EX3,
REC_tracoco.champs_MA2_label,
REC_tracoco.champs_TP1,
REC_tracoco.champs_TP2,
REC_tracoco.champs_TP3,
REC_tracoco.traco_champs_EX3,
REC_tracoco.traco_label,
REC_tracoco.champs_W11,
REC_tracoco.PaysDiam
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_PARAM_NOMEN
        Set

      champs_PC =   REC_tracoco.champs_PC,
      champs_PC1 = REC_tracoco.champs_PC, ------- mise a jour
      traco_label = REC_tracoco.traco_label,
      champs_MA2_label = REC_tracoco.champs_MA2_label

      where  entity = 'PARAM_2101'
      and start_Val_Date = to_date('01/01/2010', 'MM/DD/YYYY')
      and start_End_Date = to_date('12/31/2999', 'MM/DD/YYYY')
      and champs_PC2 = 'bdCode'
      and champs_MA2_champs_EX3 = 'en_ANONYM'
      and champs_TP1 = 'CAPA'
      and champs_TP2 = 'COUNTRY_INVENT'
      and traco_champs_EX3 = 'en_ANONYM'
      and champs_W11 = 'famCode'
      and PaysDiam = 'COUNTRY_INVENT'
       and code = REC_tracoco.code
       --and champs_MA2_label = REC_tracoco.champs_MA2_label  --NOUVEAU
       and champs_TP3 = REC_tracoco.champs_TP3 ;


        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'UPDATE_TRACOCO_PARAM_2','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'UPDATE_TRACOCO_PARAM_2','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'I',' ',' ');



   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   EXCEPTION WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'UPDATE_TRACOCO_PARAM_2','Message Erreur pl/sql :'||Sqlerrm,'E');
   End;

  END UPDATE_TRACOCO_PARAM_2;

--------------------------------------------------
-----------------------------------------------




	FUNCTION MAIN_EXPORT (   NOMLOG                          VARCHAR2,
                                P_DATE_TRAI                     DATE DEFAULT SYSDATE,
                                P_PATH                          VARCHAR2,
                                P_FILENAME_carro_JSON         VARCHAR2,
                                P_FILENAME_NOMEN_JSON    VARCHAR2,
                                P_FILENAME_carro_TXT          VARCHAR2,
                                P_FILENAME_NOMEN_TXT     VARCHAR2 ) RETURN NUMBER IS

		V_RET NUMBER := 0;

	V_INSERTS   NUMBER := 0;			
	V_UPDATES   NUMBER := 0;			
	V_ERROR     VARCHAR2(4000);  			

		V_ERR   NUMBER := 0;


        BEGIN

      ---------------EXPORT    carro_JSON
      V_ERR     := FONC_EXPORT_CARRO_JSON(NOMLOG,P_DATE_TRAI, P_PATH, P_FILENAME_carro_JSON  );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

      ---------------EXPORT    NOMEN_JSON
      V_ERR     := FONC_EXPORT_TABNOM_JSON(NOMLOG,P_DATE_TRAI, P_PATH, P_FILENAME_NOMEN_JSON  );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

      ---------------EXPORT   carro_TXT
      V_ERR     := EXPORT_CARROS_TXT(NOMLOG,P_DATE_TRAI, P_PATH, P_FILENAME_carro_TXT  );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

      ---------------EXPORT   NOMEN_TXT
      V_ERR     := EXPORT_TABNOMEN_TXT(NOMLOG,P_DATE_TRAI, P_PATH, P_FILENAME_NOMEN_TXT  );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;


			RETURN V_RET;

		/* ER APRES end; */

	END MAIN_EXPORT;






	FUNCTION MAIN_ALIM_TAB_CARROS (NOMLOG VARCHAR2, P_DATE_TRAI DATE) RETURN NUMBER IS

		V_RET NUMBER := 0;

	V_INSERTS   NUMBER := 0;
	V_UPDATES   NUMBER := 0;
	V_ERROR     VARCHAR2(4000); 

		V_ERR   NUMBER := 0;


        BEGIN

     ---------------01
      V_ERR     := ALIM_PARAM_2GEN_1A( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;
    ---------------02
     V_ERR     := ALIM_PARAM_2GEN_2B( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;
    ---------------03
      V_ERR     := ALIM_PARAM_2GEN_3C( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;
    ---------------04
      V_ERR     := ALIM_PARAM_2GEN_4D( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;




		---------------05
			V_ERR     := ALIM_TAB_CARROS( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

      ---------------06
			V_ERR     := ALIM_TAB_CARROS_INIT( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

         --------------- -33
            V_ERR     := ALIM_TAB_CARROS_DOUBLON_BLAD ( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

            V_ERR     := UPDATE_CARROS_INIT( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;
      ---------------07
			V_ERR     := UPDATE_carro_BLAD_VAP( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;



      ------------------------------------


      ---------------VAP		 26  non
			V_ERR     := UPDATE_CARROS_CONST_VAP( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;



		---------------09
			V_ERR     := ALIM_TAB_CARROS_MIXREFS( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;




        ---------------10
			V_ERR     := ALIM_TAB_CARROS_PRIX( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

      ---------------11
			V_ERR     := ALIM_TAB_CARROS_FLAG( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

        -------------------12
  	V_ERR     := ALIM_TAB_CARROS_OPCIONES( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

         -------------------14
			V_ERR     := ALIM_TAB_CARROS_EQUIPOS( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

          ------------------- MAIN NOMEN
			V_ERR     := MAIN_ALIM_NOMEN (NOMLOG, P_DATE_TRAI, V_INSERTS,V_UPDATES,V_Error) ;
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;


          ------------------- 46
			V_ERR     := ALIM_TAB_CARROS_REC_KPI (NOMLOG, P_DATE_TRAI, V_INSERTS,V_UPDATES,V_Error) ;
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;





			RETURN V_RET;

		/* ER APRES end; */

	END MAIN_ALIM_TAB_CARROS;




	FUNCTION MAIN_ALIM_NOMEN (NOMLOG VARCHAR2, P_DATE_TRAI DATE,  V_INSERTS   OUT NUMBER,
                                V_UPDATES   OUT NUMBER,
                                V_Error     Out Varchar2 ) RETURN NUMBER IS

		V_RET NUMBER := 0;                     
		V_ERR   NUMBER := 0;


        BEGIN

		---------------01
			V_ERR     := ALIM_TRACOCO_1A( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

		---------------02
			V_ERR     := ALIM_TRACOCO_2B( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

        ---------------03
			V_ERR     := ALIM_TRACOCO_3C( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

        -------------------04
			V_ERR     := ALIM_TRACOCO_4D( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

      -------------------05
			V_ERR     := UPDATE_TRACOCO_PARAM_2( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

			RETURN V_RET;

		/* ER APRES end; */

	END MAIN_ALIM_NOMEN;






END PACKAGE_2GB;
/