#!/bin/bash
PATH="/sbin:/usr/sbin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/bin:/bin:/usr/local/bin:/sbin:/usr/sbin:/bin:/usr/bin";export PATH
. /etc/init.d/functions

source /etc/profile

action=$1
if [ "$1" == "" ];then
    action=restart
fi

case "$action" in
    start)
        deploy2init
        start
        ;;
    restart)
		stop
        deploy2init
        start
        ;;
    stop)
        stop
        ;;
    deploy)
        deploy2init
        ;;
    *)
        echo $"Usage: $0 {deploy|start|stop|restart}"
    ;;
esac

deploy2init() {
    # 服务名称
    PROCESS=appname
    APP_HOME=/home/my/system/app
    # copy app file
    WARNAME=$PROCESS.war
    rm -rf ./webapps/ROOT/*
	cp ./$WARNAME ./webapps/ROOT
    cd ./webapps/ROOT
    source /etc/profile
    jar -xvf $WARNAME
	rm -f $WARNAME

    JAVA_OPTS_TMP="-Dfile.encoding=UTF-8 -Xms1024m -Xmx1024m -Xmn512m -XX:PermSize=256m -server -XX:-OmitStackTraceInFastThrow -XX:MaxTenuringThreshold=15 -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC  -XX:+CMSParallelRemarkEnabled -XX:SurvivorRatio=8 -XX:CMSInitiatingOccupancyFraction=70 -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:$CATALINA_BASE/logs/gc.log -XX:+HeapDumpOnOutOfMemoryError -Dlog4j.dir=$APP_HOME/logs"

    # app项目目录
    export CATALINA_BASE="$APP_HOME"
    # tomcat目录
    export CATALINA_HOME="/usr/local/tomcat7"

    # 可选
    export JAVA_OPTS=$JAVA_OPTS_TMP
}

start() {
    if [ -f $CATALINA_HOME/bin/startup.sh ];then
        echo $"Start Tomcat"
        $CATALINA_HOME/bin/startup.sh
    fi
}

stop() {

    count=`ps aux | grep tomcat | grep "/${PROCESS}/" | grep org.apache.catalina.startup.Bootstrap | wc -l`
        if [ $count -eq 0 ]
        then
            echo ${PROCESS}" Tomcat is not run"
            return
        fi
    if [ -f $CATALINA_HOME/bin/shutdown.sh ];then
        echo $"Stop Tomcat"
        $CATALINA_HOME/bin/shutdown.sh
    fi
    SLEEPATIME=10
    while (($SLEEPATIME > 0 ))
    do
        count=`ps aux | grep tomcat | grep "/${PROCESS}/" | grep org.apache.catalina.startup.Bootstrap | wc -l`
        if [ $count -eq 0 ]
        then
            break
        fi
        sleep 1
        echo  sleep $SLEEPATIME ...
        SLEEPATIME=$(($SLEEPATIME-1))
    done
    count=`ps aux | grep tomcat | grep "/${PROCESS}/" | grep org.apache.catalina.startup.Bootstrap | wc -l`
    if [ $count -gt 0 ]
    then
        echo kill tomcat instance $PROCESS
        `ps aux | grep tomcat | grep "/${PROCESS}/" | grep org.apache.catalina.startup.Bootstrap | awk '{print $2}' | xargs kill -9`
    else
        echo Tomcat instance $PROCESS no exist.
    fi
    # 删除之前的war包
    rm -rf ./webapps/$PROCESS
}

