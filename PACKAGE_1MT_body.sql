create or replace PACKAGE BODY PACKAGE_1MT AS


  FUNCTION ALIM_PARALLELE_CODE (  NOMLOG      VARCHAR2,
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

  Cursor C_PARA Is
  Select distinct

EFFECTIVE_DATE AS EFFECTIVE_DATE,
Champs_YY AS Champs_YY,
'TR' AS VEHICULE_TYPE,
Champs_XX AS Champs_XX,
Champs_HH AS Champs_HH,
Champs_DD AS Champs_DD,
Champs_CC AS Champs_CC,
Champs_BB AS Champs_BB,
Champs_AA AS Champs_AA

  FROM SCHEMA2.TABTEMP_PARALLELE_CODE
  WHERE Champs_HH not like  '<%';



  BEGIN

    File_Id := SCHEMA3.PACKAGE_PRINT.Func_Open(Nomlog);
  Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARALLELE_CODE','## Alimentation de la table SCHEMA1.TAB_PARALLELE_CODE ##');
  RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_PARALLELE_CODE','## Flux BILAN   ##');

        SELECT trunc(P_DATE_TRAI) INTO V_DATE_SITU FROM dual;

  
  FOR REC_PARA IN C_PARA
  LOOP


        BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA1.TAB_PARALLELE_CODE
              (
DATE_MAJ,
EFFECTIVE_DATE,
Champs_YY,
VEHICULE_TYPE,
Champs_XX,
Champs_DD,
Champs_HH,
Champs_CC,
Champs_AA,
Champs_BB
              )

        VALUES
              (
V_DATE_SITU,
REC_PARA.EFFECTIVE_DATE,
REC_PARA.Champs_YY,
REC_PARA.VEHICULE_TYPE,
REC_PARA.Champs_XX,
REC_PARA.Champs_DD,
REC_PARA.Champs_HH,
REC_PARA.Champs_CC,
REC_PARA.Champs_AA,
REC_PARA.Champs_BB
              );

        V_INS := V_INS + 1;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA1.TAB_PARALLELE_CODE
        Set
DATE_MAJ                =           V_DATE_SITU,
EFFECTIVE_DATE          = REC_PARA.EFFECTIVE_DATE,
Champs_DD            = REC_PARA.Champs_DD,
Champs_AA              = REC_PARA.Champs_AA,
Champs_BB                   = REC_PARA.Champs_BB

        where  Champs_YY          =      REC_PARA.Champs_YY
        and VEHICULE_TYPE		 = REC_PARA.VEHICULE_TYPE
        and Champs_XX                = REC_PARA.Champs_XX
        and Champs_HH                   = REC_PARA.Champs_HH
        and Champs_CC       = REC_PARA.Champs_CC;

        V_UPD := V_UPD + 1;

        WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA3.PACKAGE_PRINT.Func_Write(File_Id, 'ALIM_PARALLELE_CODE','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
        END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA3.PACKAGE_PRINT.Func_Write(FILE_ID, 'ALIM_PARALLELE_CODE','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

  END ALIM_PARALLELE_CODE;




  FUNCTION MAIN_ALIM_PARALLELE_CODE (NOMLOG VARCHAR2,
                                P_DATE_TRAI DATE) RETURN NUMBER AS

    V_RET NUMBER := 0;

    V_ERR   NUMBER := 0;
    V_INSERTS NUMBER := 0;
    V_UPDATES NUMBER := 0;
    V_ERROR VARCHAR2 (4000);




  BEGIN

			V_ERR     := ALIM_PARALLELE_CODE( NOMLOG , P_DATE_TRAI , V_INSERTS , V_UPDATES , V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;


  RETURN V_RET;

  END MAIN_ALIM_PARALLELE_CODE;



  FUNCTION MAIN_PARALLELE_CODE (NOMLOG VARCHAR2,
                                P_DATE_TRAI DATE) RETURN NUMBER AS

    V_RET NUMBER := 0;

    V_ERR   NUMBER := 0;
    V_INSERTS NUMBER := 0;
    V_UPDATES NUMBER := 0;
    V_ERROR VARCHAR2 (4000);




  BEGIN

			V_ERR     := MAIN_PARALLELE_CODE( NOMLOG , P_DATE_TRAI , V_INSERTS , V_UPDATES , V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;


  RETURN V_RET;

  END MAIN_PARALLELE_CODE;




END PACKAGE_1MT;
/