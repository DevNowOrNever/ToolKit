@set PATH=D:\EnvKyuden\payara\payara\bin;%PATH%;
pushd %PATH%
call set DOMAIN_NAME=domain1

call asadmin stop-domain %DOMAIN_NAME%


pause



