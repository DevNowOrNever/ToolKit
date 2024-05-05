set SERVER_DIR=D:\EnvKyuden\payara\payara\glassfish
set PROJECT=pe4j-ear
set DOMAIN_NAME=domain3

pushd %SERVER_DIR%\bin

rmdir /S /Q %SERVER_DIR%\domains\%DOMAIN_NAME%\applications\pe4j-ear
rmdir /S /Q %SERVER_DIR%\domains\%DOMAIN_NAME%\applications\__internal
rmdir /S /Q %SERVER_DIR%\domains\%DOMAIN_NAME%\applications\ejb-timer-service-app

rmdir /S /Q %SERVER_DIR%\domains\%DOMAIN_NAME%\generated\ejb
rmdir /S /Q %SERVER_DIR%\domains\%DOMAIN_NAME%\generated\policy
rmdir /S /Q %SERVER_DIR%\domains\%DOMAIN_NAME%\generated\xml
rmdir /S /Q %SERVER_DIR%\domains\%DOMAIN_NAME%\generated\jsp
rmdir /S /Q %SERVER_DIR%\domains\%DOMAIN_NAME%\generated\altdd
rmdir /S /Q %SERVER_DIR%\domains\%DOMAIN_NAME%\osgi-cache\felix

pause

