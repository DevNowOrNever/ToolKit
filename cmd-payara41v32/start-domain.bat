@set PATH=D:\EnvKyuden\payara\payara\bin;%PATH%;
pushd %PATH%
call set DOMAIN_NAME=domain1
call asadmin start-domain --debug %DOMAIN_NAME%


pause



