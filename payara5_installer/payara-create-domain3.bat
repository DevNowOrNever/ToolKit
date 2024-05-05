call set GF_DIR=C:\pe4jdev\payara5\glassfish
call set JDBC_DVR_PATH=C:\pe4jdev\payara5_installer\postgresql-jdbc41.jar
@set SSL_CERT_DIR=C:\pe4jdev\payara5_installer

call set ADMIN_PORT=4950
call set HTTP_PORT=8090
call set POSTFIX_PORT=82
call set DOMAIN_NAME=domain3
call set DB_NAME=n2-autogencode-v33
call set DB_USER=pe20
call set DB_PWD=jupiter
call set DB_HOST=192.168.136.12
call set DB_PORT=9006

call pushd %GF_DIR%\bin

echo.
echo Creating domain %DOMAIN_NAME%...

call asadmin.bat create-domain --user admin --nopassword --domainproperties domain.adminPort=%ADMIN_PORT%:domain.instancePort=%HTTP_PORT%:domain.jmxPort=86%POSTFIX_PORT%:http.ssl.port=91%POSTFIX_PORT%:jms.port=76%POSTFIX_PORT%:orb.listener.port=37%POSTFIX_PORT%:orb.mutualauth.port=39%POSTFIX_PORT%:orb.ssl.port=38%POSTFIX_PORT%:osgi.shell.telnet.port=66%POSTFIX_PORT%  %DOMAIN_NAME%

echo Create domain %DOMAIN_NAME% sucessfully

echo.
echo Copy JDBC driver...

call copy /Y %JDBC_DVR_PATH% %GF_DIR%\domains\%DOMAIN_NAME%\lib\ext

call copy /Y %JDBC_DVR_PATH% %GF_DIR%\lib

echo.
echo Start domain...

call asadmin --port %ADMIN_PORT% start-domain %DOMAIN_NAME%
call asadmin --port %ADMIN_PORT% set server.iiop-service.iiop-listener.orb-listener-1.port=37%POSTFIX_PORT%
call asadmin --port %ADMIN_PORT% set server.iiop-service.iiop-listener.SSL.port=38%POSTFIX_PORT%
call asadmin --port %ADMIN_PORT% set server.iiop-service.iiop-listener.SSLMUTUALAUTH.port=39%POSTFIX_PORT%


echo.
echo delete JVM option...

call asadmin --port %ADMIN_PORT% delete-jvm-options --target server-config '-Djavax.net.ssl.trustStore=${com.sun.aas.instanceRoot}/config/cacerts.jks'
call asadmin --port %ADMIN_PORT% delete-jvm-options --target server-config -client:-Xmx512m
call asadmin --port %ADMIN_PORT% delete-jvm-options --target server-config -XX\:MaxPermSize=192m


echo.
echo Setting up JVM options...

@rem call asadmin --port %ADMIN_PORT% delete-jvm-options -XX:MaxPermSize=512m
call asadmin --port %ADMIN_PORT% delete-jvm-options -Xms2g
call asadmin --port %ADMIN_PORT% delete-jvm-options -Xmx2g
call asadmin --port %ADMIN_PORT% delete-jvm-options -Xmx1024m
call asadmin --port %ADMIN_PORT% delete-jvm-options -client
call asadmin --port %ADMIN_PORT% create-jvm-options -- '-Dsun.nio.cs.map=x-windows-iso2022jp/ISO-2022-JP'
call asadmin --port %ADMIN_PORT% create-jvm-options -Duser.timezone=Asia/Tokyo
call asadmin --port %ADMIN_PORT% create-jvm-options -Duser.country=JP
call asadmin --port %ADMIN_PORT% create-jvm-options -Duser.language=ja
call asadmin --port %ADMIN_PORT% create-jvm-options -server
call asadmin --port %ADMIN_PORT% create-jvm-options -- -Xrs
@rem call asadmin --port %ADMIN_PORT% create-jvm-options -XX:MaxPermSize=384m
call asadmin --port %ADMIN_PORT% create-jvm-options -Xmx768m
call asadmin --port %ADMIN_PORT% list-jvm-options


call asadmin --port %ADMIN_PORT% create-jvm-options --target server-config -Djava.net.preferIPv4Stack=true	
call asadmin --port %ADMIN_PORT% create-jvm-options --target server-config -Dorg.jboss.weld.conversation.concurrentAccessTimeout=60000	
call asadmin --port %ADMIN_PORT% create-jvm-options --target server-config -Djavax.net.ssl.trustStore='%SSL_CERT_DIR%/cacerts.jks'	

echo.
echo Setting up Logs

call asadmin --port %ADMIN_PORT% set-log-attributes com.sun.enterprise.server.logging.GFFileHandler.rotationLimitInBytes=50000000
call asadmin --port %ADMIN_PORT% set-log-attributes com.sun.enterprise.server.logging.GFFileHandler.maxHistoryFiles=10
call asadmin --port %ADMIN_PORT% list-log-attributes

echo.
echo Creating JMS resources...

call asadmin --port %ADMIN_PORT% create-jms-resource --restype javax.jms.QueueConnectionFactory  jms/BatchQueueFactory
call asadmin --port %ADMIN_PORT% create-jms-resource --restype javax.jms.QueueConnectionFactory  jms/PWJobQueueFactory
call asadmin --port %ADMIN_PORT% create-jms-resource --restype javax.jms.Queue --property Name=BatchJobQueue jms/BatchJobQueue
call asadmin --port %ADMIN_PORT% create-jms-resource --restype javax.jms.Queue --property Name=PWJobQueue jms/PWJobQueue


@rem TODO
echo.
echo JMS dest factory...
call asadmin --port %ADMIN_PORT% create-jmsdest --desttype queue --property maxNumMsgs=100:maxBytesPerMsg=100k Batchjobqueue
call asadmin --port %ADMIN_PORT% create-jmsdest --desttype queue --property maxNumMsgs=100:maxBytesPerMsg=100k PWJobQueue

@rem TODO
echo.
echo add option JMS config...
echo imq.hostname=localhost>>%GF_DIR%\domains\%DOMAIN_NAME%\imq\instances\imqbroker\props\config.properties

echo.
echo Creating JDBC resources...

call asadmin --port %ADMIN_PORT% create-jdbc-connection-pool --datasourceclassname org.postgresql.ds.PGSimpleDataSource --restype javax.sql.DataSource --property portNumber=%DB_PORT%:password=%DB_PWD%:user=%DB_USER%:serverName=%DB_HOST%:databaseName=%DB_NAME% pe4jConnectionPool
call asadmin --port %ADMIN_PORT% list-jdbc-connection-pools
call asadmin --port %ADMIN_PORT% create-jdbc-resource --connectionpoolid pe4jConnectionPool jdbc/pe4jds
call asadmin --port %ADMIN_PORT% list-jdbc-resources

echo.
echo Disable header admin/http-listner...
call asadmin --port %ADMIN_PORT% set configs.config.server-config.network-config.protocols.protocol.admin-listener.http.xpowered-by=false
call asadmin --port %ADMIN_PORT% set configs.config.server-config.network-config.protocols.protocol.admin-listener.http.server-header=false
call asadmin --port %ADMIN_PORT% set configs.config.server-config.network-config.protocols.protocol.http-listener-1.http.xpowered-by=false
call asadmin --port %ADMIN_PORT% set configs.config.server-config.network-config.protocols.protocol.http-listener-1.http.server-header=false


echo.
echo setup http listeners ...
call asadmin --port %ADMIN_PORT% set server-config.network-config.network-listeners.network-listener.http-listener-1.jk-enabled=false

echo.
echo delete http listeners ...
call asadmin --port %ADMIN_PORT% delete-http-listener http-listener-2

echo.
echo http thread pool ...
call asadmin --port %ADMIN_PORT% set server-config.thread-pools.thread-pool.http-thread-pool.max-thread-pool-size=64
call asadmin --port %ADMIN_PORT% set server-config.thread-pools.thread-pool.http-thread-pool.min-thread-pool-size=16
call asadmin --port %ADMIN_PORT% set server-config.thread-pools.thread-pool.http-thread-pool.max-queue-size=200

echo.
echo timeer datasource for EJB container ...
call asadmin --port %ADMIN_PORT% set server-config.ejb-container.ejb-timer-service.timer-datasource=jdbc/pe4jds

echo.
echo Setting up Protocols
call asadmin --port %ADMIN_PORT% set configs.config.server-config.network-config.protocols.protocol.http-listener-1.http.compression=on
call asadmin --port %ADMIN_PORT% set configs.config.server-config.network-config.protocols.protocol.http-listener-1.http.compression-min-size-bytes=10000
call asadmin --port %ADMIN_PORT% set configs.config.server-config.network-config.protocols.protocol.http-listener-1.http.compressable-mime-type=text/html,text/xml,text/plain,text/css,text/javascript


call asadmin --port %ADMIN_PORT% stop-domain %DOMAIN_NAME%

echo.
echo Finish

pause