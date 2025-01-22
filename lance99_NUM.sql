WHENEVER SQLERROR EXIT FAILURE
rem
rem =====================================================================
rem = SUIVI DES TRAITEMENTS DE PRO
rem 1er  paramètre : nom du traitement shell
rem 2ème paramètre : date du début du traitement ou 'SYSDATE'
rem 3ème paramètre : type de date ('D' pour début, 'F' pour fin)
rem 4er,5 and 6   paramètre : Statut
rem =====================================================================
rem
variable Vcode number
define x=0
column x new_value x
set serveroutput on
set termout off
set echo off
set feed off
set head off
spool name_details_99.log
declare

 v_date_debut_traitement_shell date;
 v_code number := 0; 
 traitement_erreur exception;

begin
  
  if upper('&2') = 'SYSDATE' then
    v_date_debut_traitement_shell := sysdate;
  else
    v_date_debut_traitement_shell := to_date('&2','YYYYMMDDHH24MISS');
  end if;
  v_code := SCHEMA3.PACKAGE_07.ALIM_TAB99('&1', v_date_debut_traitement_shell, upper('&3'),0,null,0,0);
  if v_code = 1 then 
     raise traitement_erreur;
  end if;  

  :Vcode := 0;

exception
   when traitement_erreur then
   :Vcode := 1;
   when others then 
   :Vcode := 1;
   DBMS_OUTPUT.PUT_LINE('ERREUR TRAITEMENT : '||sqlerrm); 
   DBMS_OUTPUT.PUT_LINE('************************************');

end;
/
spool off
select :Vcode x from dual;
exit x
/

