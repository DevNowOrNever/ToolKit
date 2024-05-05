@echo

set DEMOHOME=C:\PE31cDEMO
set PGHOME=%DEMOHOME%\PostgreSQLPortable\App\PgSQL

set DATESTR=%date:~-10,4%%date:~-5,2%%date:~-2,2%
set TIMESTR_TMP=%time: =0%
set TIMESTR=%TIMESTR_TMP:~0,2%%TIMESTR_TMP:~3,2%%TIMESTR_TMP:~6,2%

set PGPORT=5432
set PGDBNAME=pe31cdemo
set BACKUPDUMPNAME=dump_%DATESTR%%TIMESTR%.dump

%PGHOME%\bin\pg_dump.exe -U postgres -F plain --no-owner -h localhost -p %PGPORT% -f %BACKUPDUMPNAME% %PGDBNAME%
