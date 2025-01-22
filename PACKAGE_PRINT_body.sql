create or replace Package Body     PACKAGE_PRINT IS
----------------------------------------------------------------------------------------------------------------------------
FUNCTION Func_Open (f_name varchar2) return utl_file.file_type
IS
BEGIN
   DECLARE
      file_id        utl_file.file_type;
      intval         binary_integer;
      strval         varchar2(256);
      partyp         binary_integer;
      file_name      varchar2(30);
   BEGIN
      file_name := f_name;
      file_id:=utl_file.fopen('DFTLOG',file_name,'a');

      return file_id;

      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH THEN
            RAISE_APPLICATION_ERROR(-20100,'Invalid Path');
         WHEN UTL_FILE.INVALID_MODE THEN
            RAISE_APPLICATION_ERROR(-20101,'Invalid Mode');
         WHEN UTL_FILE.INVALID_FILEHANDLE THEN
            RAISE_APPLICATION_ERROR(-20102,'Invalid Filehandle');
         WHEN UTL_FILE.INVALID_OPERATION THEN
            RAISE_APPLICATION_ERROR(-20103,'Invalid Operation -- May signal a file locked by the OS');
         WHEN UTL_FILE.READ_ERROR THEN
            RAISE_APPLICATION_ERROR(-20104,'Read Error');
         WHEN UTL_FILE.WRITE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20105,'Write Error');
         WHEN UTL_FILE.INTERNAL_ERROR THEN
            RAISE_APPLICATION_ERROR(-20106,'Internal Error');
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20107,'No Data Found');
         WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20108,'Value Error');
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20109,sqlerrm);
   END;
END Func_Open;
----------------------------------------------------------------------------------------------------------------------------
FUNCTION Func_Write (f_id utl_file.file_type, v_pack varchar2, v_msg varchar2, v_type varchar2 default 'I') return number
IS
BEGIN
   DECLARE
      s_pack varchar2(20);
   BEGIN
      s_pack := SUBSTR(RPAD(v_pack,20,' '),1,20);

      utl_file.put_line(f_id,s_pack||' '||to_char(sysdate,'dd/mm/yyyy HH24:MI:SS')||' '||v_type||' '||v_msg);
      utl_file.fflush(f_id);
      return 0;
   END;
END Func_Write;
----------------------------------------------------------------------------------------------------------------------------
FUNCTION Func_Open_CVS (f_path varchar2,f_name varchar2) return utl_file.file_type
IS
BEGIN
   DECLARE
      file_id        utl_file.file_type;
      intval         binary_integer;
      strval         varchar2(256);
      partyp         binary_integer;
      file_name      varchar2(100);
   BEGIN
      file_name := f_name;
      strval    := f_path;
      file_id:=utl_file.fopen(strval,file_name,'a', 32767);

      return file_id;

      EXCEPTION
         WHEN UTL_FILE.INVALID_PATH THEN
            RAISE_APPLICATION_ERROR(-20100,'Invalid Path');
         WHEN UTL_FILE.INVALID_MODE THEN
            RAISE_APPLICATION_ERROR(-20101,'Invalid Mode');
         WHEN UTL_FILE.INVALID_FILEHANDLE THEN
            RAISE_APPLICATION_ERROR(-20102,'Invalid Filehandle');
         WHEN UTL_FILE.INVALID_OPERATION THEN
            RAISE_APPLICATION_ERROR(-20103,'Invalid Operation -- May signal a file locked by the OS');
         WHEN UTL_FILE.READ_ERROR THEN
            RAISE_APPLICATION_ERROR(-20104,'Read Error');
         WHEN UTL_FILE.WRITE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20105,'Write Error');
         WHEN UTL_FILE.INTERNAL_ERROR THEN
            RAISE_APPLICATION_ERROR(-20106,'Internal Error');
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20107,'No Data Found');
         WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20108,'Value Error');
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20109,sqlerrm);
   END;
END Func_Open_CVS;
-------------------------------------------------------------------------------------
FUNCTION Func_Write_CVS (f_id utl_file.file_type, v_msg varchar2) return number
IS
BEGIN
   BEGIN
      utl_file.put_line(f_id, v_msg);
      utl_file.fflush(f_id);
      return 0;
   END;
END Func_Write_CVS;
----------------------------------------------------------------------------------------
FUNCTION Func_Open_CVS_UTF8 (f_path varchar2,f_name varchar2) return utl_file.file_type
IS
BEGIN
	DECLARE
	   file_id	  utl_file.file_type;
	   intval	  binary_integer;
	   strval	  varchar2(256);
	   partyp	  binary_integer;
	   file_name	  varchar2(30);

	BEGIN
	   file_name := f_name;
	   file_id:=UTL_FILE.FOPEN_NCHAR(f_path, file_name, 'a', 32767);

	   return file_id;

	   EXCEPTION
	      WHEN UTL_FILE.INVALID_PATH THEN
		 RAISE_APPLICATION_ERROR(-20100,'Invalid Path');
	      WHEN UTL_FILE.INVALID_MODE THEN
		 RAISE_APPLICATION_ERROR(-20101,'Invalid Mode');
	      WHEN UTL_FILE.INVALID_FILEHANDLE THEN
		 RAISE_APPLICATION_ERROR(-20102,'Invalid Filehandle');
	      WHEN UTL_FILE.INVALID_OPERATION THEN
		 RAISE_APPLICATION_ERROR(-20103,'Invalid Operation -- May signal a file locked by the OS');
	      WHEN UTL_FILE.READ_ERROR THEN
		 RAISE_APPLICATION_ERROR(-20104,'Read Error');
	      WHEN UTL_FILE.WRITE_ERROR THEN
		 RAISE_APPLICATION_ERROR(-20105,'Write Error');
	      WHEN UTL_FILE.INTERNAL_ERROR THEN
		 RAISE_APPLICATION_ERROR(-20106,'Internal Error');
	      WHEN NO_DATA_FOUND THEN
		 RAISE_APPLICATION_ERROR(-20107,'No Data Found');
	      WHEN VALUE_ERROR THEN
		 RAISE_APPLICATION_ERROR(-20108,'Value Error');
	      WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-20109,sqlerrm);
	END;
END Func_Open_CVS_UTF8;
----------------------------------------------------------------------------------------------------------------------------
FUNCTION Func_Write_CVS_UTF8 (f_id utl_file.file_type, v_msg varchar2) return number
IS
text_raw RAW(32767);
BEGIN
	BEGIN
	   text_raw := UTL_I18N.STRING_TO_RAW(v_msg, 'UTF8');
	   UTL_FILE.PUT_NCHAR(f_id, UTL_I18N.RAW_TO_NCHAR(text_raw, 'UTF8'));
	   utl_file.new_line(f_id);
	   return 0;
	END;
END Func_Write_CVS_UTF8;





END PACKAGE_PRINT;
/