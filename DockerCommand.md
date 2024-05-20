# Docker命令

## 容器命令

**创建CentOS容器**

```she
docker pull centos
```

**新建容器**

```shell
docker run [args] image

--name="Name" 别名
-d			  Run container in background and print container ID
-it           交互模式，进入容器
-p            端口random
-P            指定端口
```

**列出运行的容器**

```shell
docker ps

-a, --all		Show all containers (default shows just running) 附带历史容器
-n, --last	-1	Show n last created containers (includes all states)
-q, --quiet		Only display container IDs

```

**退出容器**

```shell
exit   停止退出
ctrl + p + q 停止不退出
```

**删除容器**

```shell
docker rm id
docker rm -f $(docekr ps -aq)
```

**启动/停止容器**

```shell
docker start id
docker restart
docker stop
docker kill    强制停止
```



## 常用命令

**后台启动**

```shel
docker run -d imageName
```

**查看日志**

```shell
docker logs -f -t --tail [lines] 容器id
```

**查询进程中数据**

```shell
docker top 容器id
```

**查看镜像元数据**

```shell
docker inspect 容器id
```

**进入当前运行的容器**

```shell
#进入后台运行的容器，修改配置
docker exec -it 容器id bashShell


[root@iZbp1ibhafma1zroo3wos1Z /]# docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
b69ae2231f1b   centos    "/bin/sh -c 'while t…"   33 minutes ago   Up 33 minutes             amazing_fermat
[root@iZbp1ibhafma1zroo3wos1Z /]# docker exec -it b69ae2231f1b /bin/bash
[root@b69ae2231f1b /]# ls
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var

#方式2
docker attach 容器id
进入正在执行的命令/代码

#docker exec     进入容器后开启一个新的终端，可以在里面操作
#docker attach   进入容器正在执行的终端，不启动新进程
```



**从容器内拷贝到主机上**

```shell
docker cp 容器id：内部路径 目的主机路径

#测试
[root@iZbp1ibhafma1zroo3wos1Z home]# docker run -it centos /bin/bash
[root@f47b96bff436 /]# [root@iZbp1ibhafma1zroo3wos1Z home]# 
[root@iZbp1ibhafma1zroo3wos1Z home]# docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED         STATUS         PORTS     NAMES
f47b96bff436   centos    "/bin/bash"   8 seconds ago   Up 7 seconds             relaxed_keldysh
[root@iZbp1ibhafma1zroo3wos1Z home]# docker attach f47b96bff436
[root@f47b96bff436 /]# ls
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@f47b96bff436 /]# cd /home
#创建文件
[root@f47b96bff436 home]# touch cedric.java
[root@f47b96bff436 home]# ls
cedric.java
#退出容器
[root@f47b96bff436 home]# exit  
[root@iZbp1ibhafma1zroo3wos1Z home]# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
#拷贝命令
[root@iZbp1ibhafma1zroo3wos1Z home]# docker cp f47b96bff436:/home/cedric.java /home
Successfully copied 1.54kB to /home
#拷贝成功
[root@iZbp1ibhafma1zroo3wos1Z home]# ls
cedric01.java  cedric.java


#拷贝是手动过程，使用-v命令可以实现自动化
```





