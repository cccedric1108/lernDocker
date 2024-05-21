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





# Docker小练习

> 使用Dockers导入Nginx

**导入nginx镜像**

```shell
docker pull nginx		
#使用公网端口映射，将公网3344映射到80端口   宿主机端口：容器端口
[root@iZbp1ibhafma1zroo3wos1Z /]# docker run -d --name nginx01 -p 3344:80 nginx
5ccceec03fd6a2fbbbbe6a81b1b05cf93c06b91f73141aa44a640b2f99344f42

[root@iZbp1ibhafma1zroo3wos1Z /]# docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                   NAMES
5ccceec03fd6   nginx     "/docker-entrypoint.…"   4 seconds ago   Up 4 seconds   0.0.0.0:3344->80/tcp, :::3344->80/tcp   nginx01
#进行测试
[root@iZbp1ibhafma1zroo3wos1Z /]# curl localhost:3344
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

```

![00fef837883b4c381390d242f0e8489](C:\Users\cedric\Documents\WeChat Files\wxid_jjeageo0quzq22\FileStorage\Temp\00fef837883b4c381390d242f0e8489.jpg)

**进入nginx访问**

```shell
[root@iZbp1ibhafma1zroo3wos1Z /]# docker exec -it nginx01 /bin/bash
root@5ccceec03fd6:/# whereis nginx
nginx: /usr/sbin/nginx /usr/lib/nginx /etc/nginx /usr/share/nginx
root@5ccceec03fd6:/# cd etc/nginx 
root@5ccceec03fd6:/etc/nginx# ls
conf.d	fastcgi_params	mime.types  modules  nginx.conf  scgi_params  uwsgi_params
```



> Docker安装Tomcat

```shell
docker run -it --rm tomcat:9.0       
# --rm 供测试使用，用完自动关闭容器

#启动tomcat
docker run -d -p 3344:8080 tomcat

#测试访问成功，进入容器
docker exec -it e53a78c1400a /bin/bash
#问题： 因为是默认最小镜像，所以功能被阉割


```

> 安装elasticsearch

```shell
docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.6.2

# 查看 
curl localhost:9200

# 增加内存的限制，修改配置文件
docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e ES_JAVA_OPTS="-Xms64m -Xmx512m" elasticsearch:7.6.2
```

#  可视化工具

**portainer**

```shell
docker run -d -p 8088:9000 \
--restart=always -v /var/run/docker.sock:/var/run/docker.sock --privileged=true portainer/portainer
```

# Commit镜像

```shell
docker commit 提交容器作为新的副本

docker commit -m="描述信息" -a="作者" 容器id 目标镜像名：[Tag]
```

**测试**

```shell
#启动tomcat并操作

docker commit -a="cedric" -m="simpliefy" 548275c39d63

[root@iZbp1ibhafma1zroo3wos1Z ~]# docker images
REPOSITORY            TAG       IMAGE ID       CREATED         SIZE
tomcat02              1.0       708240b5cea2   3 seconds ago   460MB

```



# 容器数据卷

## 什么是容器数据集

> 数据持久化，使容器之间的数据可以共享的技术
>
> 将容器内的目录挂载到Linux上

**将容器数据持久化和同步。容器间也可以数据共享**





## 使用数据卷

> 方式1：直接使用命令挂载

```shell
docker run -it -v 主机目录:容器内目录   #目录映射

#使用dockers inspect id 查看挂载信息

"Mounts": [
            {
                "Type": "bind",
                "Source": "/home/test",
                "Destination": "/home",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            }
        ],

```

**数据修改只需在本地修改！！！**





## 实战：安装MySQL

```shell
docker pull mysql:5.7

# 启动mysql
docker run -d -p 3310:3306 -v /home/mysql/conf:/etc/mysql/conf.d -v /home/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 --name mysql01 mysql:5.7
```



## 具名挂载和匿名挂载

```shell
# 匿名挂载
-v 容器内路径

# docker volume ls
DRIVER    VOLUME NAME
local     9a3ee25224ebc7d003897845413867d80b4e1526d3b7bfcca5cb41f9f3c77185
local     b9a410f87932650e72c4c8acb14fa82210d9023d5c06e506de98c1be8e66b5a8

# 具名挂载
-v 卷名：容器内路径
会具名存储在 /var/lib/docker/volumes/xxx
[root@iZbp1ibhafma1zroo3wos1Z ~]# docker run -d -P --name nginx02 -v JuMingNginx:/etc/nginx nginx

# 查看具名挂载内容
[root@iZbp1ibhafma1zroo3wos1Z ~]# docker volume inspect JuMingNginx
[
    {
        "CreatedAt": "2024-05-21T20:42:37+08:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/JuMingNginx/_data",
        "Name": "JuMingNginx",
        "Options": null,
        "Scope": "local"
    }
]

# 指定路径挂载
-v /xxx/xxx/xxx:/xx/xxx/xxx
```

**拓展**

```shell
# docker run -d -P --name nginx02 -v JuMingNginx:/etc/nginx：ro nginx

# 设定权限后，容器内部不可改变
ro   read only   #只可从外部改变
rw   read write
```





## Dockerfile

**Dockerfile是用来构建docker镜像的构建文件** ===>命令脚本



通过脚本生成镜像，镜像有很多层，对应脚本一行行命令

> 方式2：创建dockerfile脚本

```shell
# 指令(大写) + 参数
FROM centos

# 自己挂载的目录
VOLUME ["volume01","volume02"]

CMD echo "-----end-----"
CMD /bin/bash

# 每个命令对应一层



#构建命令
[root@iZbp1ibhafma1zroo3wos1Z docker_test_volume]# docker build -f /home/docker_test_volume/dockerfile1 -t cedric/centos:1.0 .
[+] Building 0.1s (5/5) FINISHED                                                                                                                         docker:default
 => [internal] load build definition from dockerfile1                                                                                                              0.0s
 => => transferring dockerfile: 122B                                                                                                                               0.0s
 => [internal] load metadata for docker.io/library/centos:latest                                                                                                   0.0s
 => [internal] load .dockerignore                                                                                                                                  0.0s
 => => transferring context: 2B                                                                                                                                    0.0s
 => [1/1] FROM docker.io/library/centos:latest                                                                                                                     0.0s
 => exporting to image                                                                                                                                             0.0s
 => => exporting layers                                                                                                                                            0.0s
 => => writing image sha256:9b5949716ba89bddf4ffe5fd733518ef885c358b3d30a74a57782a1cda5986b7                                                                       0.0s
 => => naming to docker.io/cedric/centos:1.0                                                                                                                       0.0s
[root@iZbp1ibhafma1zroo3wos1Z docker_test_volume]# 

```

**启动容器后**

![image-20240521215305036](C:\Users\cedric\AppData\Roaming\Typora\typora-user-images\image-20240521215305036.png)

使用 

```shell
docekr inspect 容器id  #查看挂载卷位置信息
```

![image-20240521215720259](C:\Users\cedric\AppData\Roaming\Typora\typora-user-images\image-20240521215720259.png)

**如果构建镜像时没有设置自动挂载卷，则需要在启动时使用 -v 手动挂载**



## 数据卷容器

多个mysql间同步数据

![e291370bbc655a5b8b459d0311aa929](C:\Users\cedric\Documents\WeChat Files\wxid_jjeageo0quzq22\FileStorage\Temp\e291370bbc655a5b8b459d0311aa929.jpg)

```shell
# 启动第一个容器
[root@iZbp1ibhafma1zroo3wos1Z /]# docker run -it --name docker01 cedric/centos:1.0
[root@57dad887e0ef /]# ls
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var  volume01	volume02

# 启动第二个容器
[root@iZbp1ibhafma1zroo3wos1Z /]# docker run -it --name docker02 --volumes-from docker01 cedric/centos:1.0
[root@bcdfa97cb570 /]# ls
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var  volume01	volume02

# --volumes-from docker01 继承操作
# 测试发现
# 在第一个容器内volume01创建文件 自动同步到volume02中，
```

***在这里，volume01相当于数据卷容器***    删除docker01后数据依然可以在02查到，因为宿主机还在。 **docker01和 02 的volume目录同时指向宿主机目录地址**





### 两个mysql实现同步

```shell
# 第一个
docker run -d -p 3310:3306 -v /etc/mysql/conf.d -v /var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 --name mysql01 mysql:5.7

# 第二个
docker run -d -p 3320:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mysql02 --volumes-from mysql01 mysql:5.7

# 即可实现容器数据同步
```

