create or replace PACKAGE BODY  PACKAGE_1GB AS

FUNCTION UPDATE_FONCTION_1A (NOMLOG varchar2, P_DATE_TRAI date) Return Number AS
  --BEGIN
  -- DECLARE

    V_ERR                          NUMBER := 0;
    N_UPD_gener                    NUMBER := 0;
    N_UPD_nbRap                    NUMBER := 0;

    FILE_ID                         UTL_FILE.FILE_TYPE;
    RES                             NUMBER := 0;

  Cursor C_gener Is
    Select distinct
           B.ID as ID,
           B.start_date as start_date,
           gener.ValString as gener 
    FROM   SCHEMA2B.TAB_DEF1 B,
           SCHEMA2B.TAB_DEF2 gener
    where  gener.id(+) = B.id
    and gener.techcode(+) = 47100
    and gener.start_date = (select max(c.start_date)
                                    from   TAB_DEF2 C
                                    where  C.ID=gener.id
                                    and    C.techcode = 47100
                                    and    C.ValString is not null
                                    and    B.start_date  >=C.start_date);


  Cursor C_nbRap Is
    Select distinct
           B.ID as ID,
           B.start_date as start_date,
           (case when nbRap.ValString not in ('AUTOMATIC','N') then ( case  when substr(nbRap.ValString, 2,1) ='S' then  substr(nbRap.ValString, 1,1) else replace(substr(nbRap.ValString, 1,2),' ','') end )  else null end) as nbRap
    FROM   SCHEMA2B.TAB_DEF1 B,
           SCHEMA2B.TAB_DEF2 nbRap
    where  nbRap.id(+) = B.id
    and nbRap.techcode(+) = 6600
    and nbRap.start_date = (select max(c.start_date)
                                    from   TAB_DEF2 C
                                    where  C.ID=nbRap.id
                                    and    C.techcode = 6600
                                    and (case when nbRap.ValString not in ('AUTOMATIC','N') then ( case  when substr(nbRap.ValString, 2,1) ='S' then  substr(nbRap.ValString, 1,1) else replace(substr(nbRap.ValString, 1,2),' ','') end )  else null end) is not null
                                    and    B.start_date  >=C.start_date);


  BEGIN

  FILE_ID := SCHEMA_PRIN.FONCTION_PRIN.F_OPEN(NOMLOG);
  RES := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID, 'UPDATE_FONCTION_1A', ' ## MISE A JOUR ' ||  ' ##');
      ---------------
      FOR S_gener IN C_gener LOOP
          BEGIN
            IF MOD(N_UPD_gener, 1000) = 0 THEN COMMIT; END IF;

            UPDATE SCHEMA2B.TAB_DEF1
            SET    gener			= S_gener.gener
            WHERE  ID         = S_gener.ID
            AND    start_date = S_gener.start_date;

            N_UPD_gener  := N_UPD_gener +1;

          EXCEPTION WHEN OTHERS THEN COMMIT;
                          V_ERR  := 1;
                          RES   := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID,'UPDATE_FONCTION_1A ','MESSAGE ERREUR PL/SQL : ' ||SQLERRM || S_gener.ID);
                          RETURN V_ERR;
          END;
      END LOOP;
      COMMIT;
      res := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(file_id, 'UPDATE_FONCTION_1A', 'Nombre de mises a jour gener : ' || N_UPD_gener);
      ---------------
      ---------------
      FOR S_nbRap IN C_nbRap LOOP
          BEGIN
            IF MOD(N_UPD_nbRap, 1000) = 0 THEN COMMIT; END IF;

            UPDATE SCHEMA2B.TAB_DEF1
            SET   nbRap			  = S_nbRap.nbRap
            WHERE  ID         = S_nbRap.ID
            AND    start_date = S_nbRap.start_date;

            N_UPD_nbRap  := N_UPD_nbRap +1;

          EXCEPTION WHEN OTHERS THEN COMMIT;
                          V_ERR  := 1;
                          RES   := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID,'UPDATE_FONCTION_1A ','MESSAGE ERREUR PL/SQL : ' ||SQLERRM || S_nbRap.ID);
                          RETURN V_ERR;
          END;
      END LOOP;
      COMMIT;
      res := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(file_id, 'UPDATE_FONCTION_1A', 'Nombre de mises a jour nbRap : ' || N_UPD_nbRap);
      ---------------
  res := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(file_id, '', '');
  UTL_FILE.FCLOSE(file_id);

  RETURN V_ERR;


  EXCEPTION WHEN OTHERS THEN COMMIT;
          V_ERR  := 1;
          RES     := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID,'UPDATE_FONCTION_1A ','MESSAGE ERREUR PL/SQL : ' ||SQLERRM);
          RETURN V_ERR;


END UPDATE_FONCTION_1A;


FUNCTION ALIM_3C (  NOMLOG      VARCHAR2,
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

  Cursor C_TAB_TEMP3 Is
  Select *
  FROM SCHEMA1A.TAB_TEMP3;



  BEGIN

  File_Id := SCHEMA_PRIN.FONCTION_PRIN.F_Open(Nomlog);
  Res := SCHEMA_PRIN.FONCTION_PRIN.F_Write(File_Id, 'ALIM_3C','## Alimentation de la table SCHEMA2B.TAB_DEF2 ##');
  RES := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID, 'ALIM_3C','## Flux BILAN   ##');


  FOR REC_TAB_TEMP3 IN C_TAB_TEMP3 LOOP

      BEGIN

        IF V_ERR=1 THEN EXIT; END IF;

        IF MOD(V_UPD + V_INS, 1000)=0 THEN COMMIT;END IF;


        INSERT INTO SCHEMA2B.TAB_DEF3
              (
              DATE_MAJ,
              ID,
              BAPCODE,
              TANCODE,
              DANCODE,
              TODCODE,
              GRIMCODE,
              NAME,
              INTRODUCED,
              DISCONTINUED
              )
        VALUES
              (
              V_DATE_SITU, 
              REC_TAB_TEMP3.ID,
              REC_TAB_TEMP3.BAPCODE,
              REC_TAB_TEMP3.TANCODE,
              REC_TAB_TEMP3.DANCODE,
              REC_TAB_TEMP3.TODCODE,
              REC_TAB_TEMP3.GRIMCODE,
              REC_TAB_TEMP3.NAME,
              REC_TAB_TEMP3.INTRODUCED,
              REC_TAB_TEMP3.DISCONTINUED 
              );

        V_INS := V_INS + 1;

      EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_DEF3
        Set
        DATE_MAJ = P_DATE_TRAI,
        BAPCODE     =       REC_TAB_TEMP3.BAPCODE,
        TANCODE     =       REC_TAB_TEMP3.TANCODE,
        DANCODE     =       REC_TAB_TEMP3.DANCODE,
        TODCODE     =       REC_TAB_TEMP3.TODCODE,
        GRIMCODE    =       REC_TAB_TEMP3.GRIMCODE,
        NAME        =       REC_TAB_TEMP3.NAME,
        INTRODUCED  =       REC_TAB_TEMP3.INTRODUCED,
        DISCONTINUED =       REC_TAB_TEMP3.DISCONTINUED

        where  ID          =      REC_TAB_TEMP3.ID ;


        V_UPD := V_UPD + 1;

      WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA_PRIN.FONCTION_PRIN.F_Write(File_Id, 'ALIM_3C','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
      END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID, 'ALIM_3C','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;

END ALIM_3C;


FUNCTION ALIM_2B (  NOMLOG      VARCHAR2,
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


  --Cursor C_TAB_TEMP2 Is
  --Select *
  --FROM SCHEMA1A.TAB_TEMP2 ;


 /*******************************************************************************/
  BEGIN

  File_Id := SCHEMA_PRIN.FONCTION_PRIN.F_Open(Nomlog);
  Res := SCHEMA_PRIN.FONCTION_PRIN.F_Write(File_Id, 'ALIM_2B','## Alimentation de la table SCHEMA2B.TAB_DEF2 ##');
  RES := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID, 'ALIM_2B','## Flux BILAN   ##');



  --FOR REC_TAB_TEMP2 IN C_TAB_TEMP2
  --LOOP

       /*************************************************************************/
      BEGIN

        --IF V_ERR=1 THEN EXIT;
        --END IF;

        --IF MOD(V_UPD + V_INS, 50000)=0 THEN COMMIT;
        --END IF;

        --TO GET FASTER THE EXECUCTION OF THIS FUNCTION. FIRST STEP --> UPDATE OF EXISTING RECORDS		   
            MERGE INTO SCHEMA2B.TAB_DEF2 A
            USING (SELECT *
                    FROM SCHEMA1A.TAB_TEMP2) B
                    ON (A.ID            = B.ID
                    AND A.TechCode      = B.TechCode
                    AND A.start_date = B.start_date)		
            WHEN MATCHED THEN UPDATE SET DATE_MAJ       = P_DATE_TRAI,
                                         end_date 	    = B.end_date,
                                         ValDatetime  = B.ValDatetime,
                                         ValFloat     = B.ValFloat,
                                         ValString    = B.ValString,
                                         ValBoolean   = B.ValBoolean
                                         
            WHEN NOT MATCHED THEN INSERT 		(
                DATE_MAJ,
                ID,
                TechCode,
                start_date,
                end_date,
                ValDatetime,
                ValFloat,
                ValString,
                ValBoolean)		
                VALUES (              
                V_DATE_SITU,
                B.ID,
                B.TechCode,
                B.start_date,
                B.end_date,
                B.ValDatetime,
                B.ValFloat,
                B.ValString,
                B.ValBoolean
               );
                                         
            V_INS:=SQL%ROWCOUNT;
            COMMIT;

        /*INSERT INTO SCHEMA2B.TAB_DEF2
              (
              DATE_MAJ,
              ID,
              TechCode,
              start_date,
              end_date,
              ValDatetime,
              ValFloat,
              ValString,
              ValBoolean
              )
        VALUES
              (
              V_DATE_SITU,
              REC_TAB_TEMP2.ID,
              REC_TAB_TEMP2.TechCode,
              REC_TAB_TEMP2.start_date,
              REC_TAB_TEMP2.end_date,
              REC_TAB_TEMP2.ValDatetime,
              REC_TAB_TEMP2.ValFloat,
              REC_TAB_TEMP2.ValString,
              REC_TAB_TEMP2.ValBoolean
              );

        V_INS := V_INS + 1;

      EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_DEF2
        Set
            DATE_MAJ        =  P_DATE_TRAI,
            end_date     =   REC_TAB_TEMP2.end_date,
            ValDatetime   =   REC_TAB_TEMP2.ValDatetime,
            ValFloat      =   REC_TAB_TEMP2.ValFloat,
            ValString     =   REC_TAB_TEMP2.ValString,
            ValBoolean    =   REC_TAB_TEMP2.ValBoolean

        where  ID              =    REC_TAB_TEMP2.ID
        and    TechCode        =    REC_TAB_TEMP2.TechCode
        and    start_date   =    REC_TAB_TEMP2.start_date   ;

        V_UPD := V_UPD + 1;*/

      EXCEPTION WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA_PRIN.FONCTION_PRIN.F_Write(File_Id, 'ALIM_2B','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
      END;
   --END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   --RES := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID, 'ALIM_2B','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   RES := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID, 'ALIM_2B','Nombre de ligne traitees : '||TO_CHAR(V_INS));
   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;


END ALIM_2B;


FUNCTION ALIM_1A (  NOMLOG      VARCHAR2,
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


  Cursor C_TAB_TEMP1 Is
  Select *
  FROM SCHEMA1A.TAB_TEMP1 ;


 /*******************************************************************************/
  BEGIN

  File_Id := SCHEMA_PRIN.FONCTION_PRIN.F_Open(Nomlog);
  Res := SCHEMA_PRIN.FONCTION_PRIN.F_Write(File_Id, 'ALIM_1A','## Alimentation de la table SCHEMA2B.TAB_DEF1 ##');
  RES := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID, 'ALIM_1A','## Flux BILAN   ##');


  FOR REC_TAB_TEMP1 IN C_TAB_TEMP1
  LOOP

       /*************************************************************************/
      BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 1000)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_DEF1
              (
              DATE_MAJ,
              ID,
              start_date,
              end_date,
              Refe,
              ImageId,
              ImageNotExactMatch
              )

        VALUES
              (
              V_DATE_SITU,
              REC_TAB_TEMP1.ID,
              REC_TAB_TEMP1.start_date,
              REC_TAB_TEMP1.end_date,
              REC_TAB_TEMP1.Refe,
              REC_TAB_TEMP1.ImageId,
              REC_TAB_TEMP1.ImageNotExactMatch
              );

        V_INS := V_INS + 1;

      EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_DEF1
        Set
        DATE_MAJ          = P_DATE_TRAI,
        end_date          = REC_TAB_TEMP1.end_date,
        Refe              = REC_TAB_TEMP1.Refe,
        ImageId           = REC_TAB_TEMP1.ImageId,
        ImageNotExactMatch= REC_TAB_TEMP1.ImageNotExactMatch

        where  ID          = REC_TAB_TEMP1.ID
        and     start_date = REC_TAB_TEMP1.start_date  ;

        V_UPD := V_UPD + 1;

      WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA_PRIN.FONCTION_PRIN.F_Write(File_Id, 'ALIM_1A','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
      END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID, 'ALIM_1A','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
   End;


END ALIM_1A;


FUNCTION ALIM_4D (  NOMLOG      VARCHAR2,
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


  Cursor C_TAB_TEMP4 Is
  Select *
  FROM SCHEMA1A.TAB_TEMP4 ;


 /*******************************************************************************/
  BEGIN

  File_Id := SCHEMA_PRIN.FONCTION_PRIN.F_Open(Nomlog);
  Res := SCHEMA_PRIN.FONCTION_PRIN.F_Write(File_Id, 'ALIM_4D','## Alimentation de la table SCHEMA2B.TAB_DEF4 ##');
  RES := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID, 'ALIM_4D','## Flux BILAN   ##');


  FOR REC_TAB_TEMP4 IN C_TAB_TEMP4 Is
  LOOP

       /*************************************************************************/
      BEGIN

        IF V_ERR=1 THEN EXIT;
        END IF;

        IF MOD(V_UPD + V_INS, 1000)=0 THEN COMMIT;
        END IF;


        INSERT INTO SCHEMA2B.TAB_DEF4
              (
              DATE_MAJ,
              ID,
              start_date,
              end_date,
              Basic,
              Vat,
              Delivery
              )
        VALUES
              (
              V_DATE_SITU,
              REC_TAB_TEMP4.ID,
              REC_TAB_TEMP4.start_date,
              REC_TAB_TEMP4.end_date,
              REC_TAB_TEMP4.Basic,
              REC_TAB_TEMP4.Vat,
              REC_TAB_TEMP4.Delivery
              );

        V_INS := V_INS + 1;

      EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
				Update  SCHEMA2B.TAB_DEF4
        Set
        DATE_MAJ        = P_DATE_TRAI,
        end_date 	      = REC_TAB_TEMP4.end_date,
        Basic		        = REC_TAB_TEMP4.Basic,
        Vat   		      = REC_TAB_TEMP4.Vat,
        Delivery        = REC_TAB_TEMP4.Delivery

        where  ID          = REC_TAB_TEMP4.ID
        and     start_date = REC_TAB_TEMP4.start_date ;

        V_UPD := V_UPD + 1;

      WHEN OTHERS THEN
				COMMIT;
				V_ERR := 1;

				V_Error := Substr('SQLCODE: '||To_Char(Sqlcode)||' -ERROR: '||Sqlerrm,1,4000);
				Res := SCHEMA_PRIN.FONCTION_PRIN.F_Write(File_Id, 'ALIM_4D','Message Erreur pl/sql :'||Sqlerrm,'E');
        RETURN V_ERR;
      END;
   END LOOP;

   COMMIT;

   V_INSERTS := V_INS;
   V_Updates := V_Upd;
   RES := SCHEMA_PRIN.FONCTION_PRIN.F_WRITE(FILE_ID, 'ALIM_4D','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
   UTL_FILE.FCLOSE(FILE_ID);
   RETURN V_ERR;
  End;

END ALIM_4D;


---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------   MAIN     --------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------


FUNCTION MAIN_ALIM_VIP (NOMLOG VARCHAR2, 
                        P_DATE_TRAI DATE,
                        V_INSERTS   OUT NUMBER,
                        V_UPDATES   OUT NUMBER,
                        V_Error     Out Varchar2 ) RETURN NUMBER IS

		V_RET NUMBER := 0;
		V_ERR   NUMBER := 0;


    BEGIN

		  ---------------01
		  V_ERR     := ALIM_1A( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

		  ---------------02
			V_ERR     := ALIM_2B( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

      ---------------03
			V_ERR     := ALIM_3C( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

      ---------------05
			V_ERR     := ALIM_4D( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

      --------------UPDATE
			V_ERR     := UPDATE_FONCTION_1A( NOMLOG, P_DATE_TRAI);
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;


		RETURN V_RET;

END MAIN_ALIM_VIP;


FUNCTION MAIN_PRINCIPAL (NOMLOG VARCHAR2, P_DATE_TRAI DATE) RETURN NUMBER IS                           

		V_RET NUMBER := 0;                     

	  V_INSERTS   NUMBER := 0;			
		V_UPDATES   NUMBER := 0;		
		V_ERROR   VARCHAR2(255);  			

		V_ERR   NUMBER := 0;


    BEGIN
		  ---------------01
			V_ERR     := MAIN_ALIM_VIP1( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

		  ---------------02
			V_ERR     := MAIN_ALIM_VIP2( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;


		RETURN V_RET;

		

END MAIN_PRINCIPAL;



END PACKAGE_1GB;
/