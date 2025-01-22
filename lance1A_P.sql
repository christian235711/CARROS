WHENEVER SQLERROR EXIT FAILURE
rem
rem ===================================================================
rem = Composition du nom du fichier log
rem = Lancement de la fonction de alimentation 
rem =  - datertf
rem ===================================================================
rem
variable Vcode number
define x=0
column x new_value x
set serveroutput on
set termout off
set echo on
set feed off
set head off
declare
v_code                  number := 0;
v_date_trait            DATE;
v_code_pays             char(1);
v_ficlog                varchar2(40);
V_INSERTS               NUMBER := 0;
V_UPDATES               NUMBER := 0;
V_ERROR                 VARCHAR2(4000);
v_path                  varchar2(30);
traitement_erreur       exception;
v_filename              varchar2(30);


begin
    
    SELECT to_date('&1','YYYYMMDDHH24MISS') INTO v_date_trait from dual;
    SELECT to_char(SYSDATE, 'YYYYMMDDHH24MI')||'_NameDetails_Paral.log' INTO v_ficlog FROM dual;

        v_code := SCHEMA1.PACKAGE_1MT.MAIN_PARALLELE_CODE(v_ficlog, v_date_trait);
 
        if v_code = 1 then 
                raise traitement_erreur;
        end if;  
        :Vcode := 0;

        exception
        when traitement_erreur then
        :Vcode := 1;
        when others then 
        :Vcode := 1;
end;
/

select :Vcode x from dual;
exit x
/
