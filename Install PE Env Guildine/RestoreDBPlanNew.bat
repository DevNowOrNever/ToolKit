@echo

set plaindumpfile=D:\EnvKyuden\pe31cdemo.dmp

psql.exe -U postgres -d postgres -h 127.0.0.1 -p 5433 -W -c "DROP DATABASE pe31cdemo;"
psql.exe -U postgres -d postgres -h 127.0.0.1 -p 5432 -W -c "CREATE USER pe20 password 'postgres';"
psql.exe -U postgres -d postgres -h 127.0.0.1 -p 5432 -W -c "CREATE database pe31cdemo owner pe20 TEMPLATE = template0 lc_collate='C' lc_ctype='C' encoding='UTF-8';"
psql.exe -U postgres -d pe31cdemo -h 127.0.0.1 -p 5432 -W -c "create extension if not exists hstore;"
psql.exe -U postgres -d pe31cdemo -h 127.0.0.1 -p 5432 -W -c "create extension if not exists pg_stat_statements;"
psql.exe -U postgres -d pe31cdemo -h 127.0.0.1 -p 5432 -W -c "create extension if not exists pldbgapi;"

set PGPASSWORD=postgres
pg_restore.exe -v -Fc -U pe20 -d pe31cdemo D:\EnvKyuden\pe31cdemo.dmp  >>dump.log 2>&1




