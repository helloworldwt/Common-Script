## 简介
    tomcat的部署脚本,可以通过同一个tomcat程序部署多个应用
## 使用方法
1. 配置程序名称PROCESS,项目目录APP_HOME,tomcat目录TOMCAT_HOME,jvm参数JAVA_OPTS_TMP这四个参数.其中APP_HOME内需要包含tomcat的配置文件server.xml等,webapp中有项目文件
2. sh start.sh start即可启动应用