create or replace Package PACKAGE_PRINT IS

FUNCTION FUNCT_OPEN (f_name varchar2) return utl_file.file_type;

FUNCTION FUNCT_WRITE (f_id utl_file.file_type, v_pack varchar2, v_msg varchar2, v_type varchar2 default 'I') return NUMBER;

FUNCTION FUNCT_OPEN_CVS (f_path VARCHAR2,f_name VARCHAR2) RETURN utl_file.file_type;

FUNCTION FUNCT_WRITE_CVS (f_id utl_file.file_type, v_msg VARCHAR2) RETURN NUMBER;


FUNCTION FUNCT_OPEN_CVS_UTF8 (f_path VARCHAR2,f_name VARCHAR2) RETURN utl_file.file_type;
FUNCTION FUNCT_WRITE_CVS_UTF8 (f_id utl_file.file_type, v_msg VARCHAR2) RETURN NUMBER;


END PACKAGE_PRINT;
/