
title Deployment SANKYO V32

@set DOMAIN_NAME=domain1
@set GLASSFISH_HOME=D:\EnvKyuden\payara\payara\glassfish
@set GLASSFISH_PORT=4848
@set SRC_FOLDER_SRC=D:\Projects\sankyo
@set SRC_FOLDER_EAR=%SRC_FOLDER_SRC%\target

@set RESOURCE_BUNDLE=%SRC_FOLDER_SRC%\resources,D:\PE4J\Applibs\ex-appLib,D:\PE4J\Applibs\v32\appLib,D:\PE4J\Applibs\v32\properties

@rem call %SCRIPT_FOLDER%\setEnv30.bat
call %GLASSFISH_HOME%\bin\asadmin --port %GLASSFISH_PORT% undeploy pe4j-ear
call %GLASSFISH_HOME%\bin\asadmin --port %GLASSFISH_PORT% stop-domain --kill true %DOMAIN_NAME%

rmdir /S /Q %GLASSFISH_HOME%\domains\%DOMAIN_NAME%\applications\pe4j-ear

rmdir /S /Q %GLASSFISH_HOME%\domains\%DOMAIN_NAME%\generated
mkdir %GLASSFISH_HOME%\domains\%DOMAIN_NAME%\generated

rmdir /S /Q %GLASSFISH_HOME%\domains\%DOMAIN_NAME%\osgi-cache
mkdir %GLASSFISH_HOME%\domains\%DOMAIN_NAME%\osgi-cache


pause

