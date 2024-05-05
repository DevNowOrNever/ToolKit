@echo

set DEMOHOME=C:\PE31cDEMO
set PGHOME=%DEMOHOME%\PostgreSQLPortable\App\PgSQL
set plaindumpfile=%DEMOHOME%\PEDB\pe31cdemo.dmp

%PGHOME%\bin\psql.exe -U postgres -d postgres -h 127.0.0.1 -c "DROP DATABASE pe31cdemo;"
%PGHOME%\bin\psql.exe -U postgres -d postgres -h 127.0.0.1 -c "CREATE USER pe20 password 'jupiter';"
%PGHOME%\bin\psql.exe -U postgres -d postgres -h 127.0.0.1 -c "CREATE database pe31cdemo owner pe20 lc_collate='C' lc_ctype='C' encoding='UTF-8';"
%PGHOME%\bin\psql.exe -U postgres -d pe31cdemo -h 127.0.0.1 -c "create extension if not exists hstore;"
%PGHOME%\bin\psql.exe -U postgres -d pe31cdemo -h 127.0.0.1 -c "create extension if not exists pg_stat_statements;"

set PGPASSWORD=jupiter

%PGHOME%\bin\pg_restore.exe -v -Fc -U pe20 -d pe31cdemo %plaindumpfile%  >>dump.log 2>&1

