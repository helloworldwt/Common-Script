使用方法:
1.修改go.sh文件中的host_conf_file路径,改为自己系统中host.conf的路径位置
2.配置host.conf文件,sys_name(系统名字),ip(ip地址),loginName(登录用户),password(登录密码),alias_name(用于区分的中文名字).例子见example-host.conf文件
3. ./go.sh list 命令可以看到可以登录的机器. ./go.sh sys_name 命令即可登录目标机器