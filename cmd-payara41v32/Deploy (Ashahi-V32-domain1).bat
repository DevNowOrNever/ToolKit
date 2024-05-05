
title Deployment ASHAHI V32

@set DOMAIN_NAME=domain1
@set GLASSFISH_HOME=D:\EnvKyuden\payara\payara\glassfish
@set GLASSFISH_PORT=4848
rem @set SRC_FOLDER_EAR=D:\Projects\ashahi\stage1
@set SRC_FOLDER_EAR=D:\temp\20230821\ear\AP01
rem @set EX_SRC_FOLDER=C:\pe4jdev\workspaces\Exkeihi\ex-keihi

rem @set RESOURCE_BUNDLE=%SRC_FOLDER%\properties,%SRC_FOLDER%\resources,%EX_SRC_FOLDER%\resources
@set RESOURCE_BUNDLE=D:\Projects\ashahi\appLib,D:\PE4J\Applibs\ex-appLib,D:\PE4J\Applibs\v32\appLib,D:\PE4J\Applibs\v32\properties

@rem call %SCRIPT_FOLDER%\setEnv30.bat
call %GLASSFISH_HOME%\bin\asadmin --port %GLASSFISH_PORT% undeploy pe4j-ear
call %GLASSFISH_HOME%\bin\asadmin --port %GLASSFISH_PORT% stop-domain --kill true %DOMAIN_NAME%

rmdir /S /Q %GLASSFISH_HOME%\domains\%DOMAIN_NAME%\applications\pe4j-ear

rmdir /S /Q %GLASSFISH_HOME%\domains\%DOMAIN_NAME%\generated
mkdir %GLASSFISH_HOME%\domains\%DOMAIN_NAME%\generated

rmdir /S /Q %GLASSFISH_HOME%\domains\%DOMAIN_NAME%\osgi-cache
mkdir %GLASSFISH_HOME%\domains\%DOMAIN_NAME%\osgi-cache

call %GLASSFISH_HOME%\bin\asadmin --port %GLASSFISH_PORT% start-domain --debug %DOMAIN_NAME%
rem call %GLASSFISH_HOME%\bin\asadmin --port %GLASSFISH_PORT% undeploy pe4j-ear

@echo ****************deploy pe4j-ear start*****************
call %GLASSFISH_HOME%\bin\asadmin --port %GLASSFISH_PORT% deploy --name pe4j-ear --libraries %RESOURCE_BUNDLE%  %SRC_FOLDER_EAR%\pe4j-ear.ear
@echo ****************deploy pe4j-ear end*****************


pause

