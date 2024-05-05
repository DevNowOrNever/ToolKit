@echo

set DEMOHOME=C:\PE31cDEMO
set PGHOME=%DEMOHOME%\PostgreSQLPortable\App\PgSQL
set plaindumpfile=%DEMOHOME%\PEDB\pe31cdemo.dump

%PGHOME%\bin\psql.exe -U postgres -d postgres -c "DROP DATABASE pe31cdemo;"
%PGHOME%\bin\psql.exe -U postgres -d postgres -c "CREATE USER pe20 password 'jupiter';"
%PGHOME%\bin\psql.exe -U postgres -d postgres -c "CREATE database pe31cdemo owner pe20 lc_collate='C' lc_ctype='C' encoding='UTF-8';"
%PGHOME%\bin\psql.exe -U postgres -d pe31cdemo -c "create extension if not exists hstore;"
%PGHOME%\bin\psql.exe -U postgres -d pe31cdemo -c "create extension if not exists pg_stat_statements;"

set PGPASSWORD=jupiter

%PGHOME%\bin\psql.exe  -a -U pe20 -d pe31cdemo -f %plaindumpfile%  >>dump.log 2>&1

