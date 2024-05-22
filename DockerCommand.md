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





## Dockerfile简单介绍

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





# Dockerfile

dockerfile是用来构建docker镜像的文件 即命令行参数脚本

```shell
编写dockerfile文件->使用docker build 构建成一个镜像->docker run 运行容器->docker push发布镜像
```

很多 官方镜像是基础版，很多功能都没有，使用时一般搭建自己的镜像



## Dockerfile 构建过程

* 每个指令都是大写字母

* 从上到下顺序执行

* 使用#表示注释

* 每个指令都创建提交一个新的镜像层，并且提交

  



## DockerFile 基础命令

```shell
FROM			# 基础镜像，从这里构建
MAINTAINER		# 镜像是谁写的
RUN				# 镜像构建时需要的命令
ADD				# 添加内容 比如Tomcat压缩包
WORKDIR			# 镜像的工作目录
VOLUME			# 挂载目录
EXPOSE			# 暴露端口
CMD				# 指定容器启动运行的命令，只有最后一个会生效
ENTRYPOINT		# 指定容器启动运行的命令，可以追加命令
ONBUILD			# 构建一个继承DockerFile时会运行。   触发指令
COPY			# 类似ADD，将文件拷贝到镜像
ENV				# 构建时设置环境变量
```



## 使用DockerFile构建自己的centos



```shell
# 编写dockerfile文件
FROM centos

MAINTAINER cedric<ceddric1108@126.com>

ENV MYPATH /user/local    # 工作目录

WORKDIR $MYPATH

RUN yum -y install vim
RUN yum -y install net-tools

EXPOSE 80

CMD echo $MYPATH
CMD echo "-------end-------"
CMD /bin/bash


# 使用docker build 构建
docker build -f mydockerfile-centos -t mycentos:0.1 .

# 成功
[root@iZbp1ibhafma1zroo3wos1Z dockerfile]# docker images
REPOSITORY            TAG       IMAGE ID       CREATED          SIZE                                                                                                
mycentos              0.1       92abeee8cca7   21 seconds ago   727MB


# 测试运行
docker run -it mycentos:0.1 

#使用 docker history 92abeee8cca7 查看构建历史
IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
92abeee8cca7   9 minutes ago    CMD ["/bin/sh" "-c" "/bin/bash"]                0B        buildkit.dockerfile.v0
<missing>      9 minutes ago    CMD ["/bin/sh" "-c" "echo \"-------end------…   0B        buildkit.dockerfile.v0
<missing>      9 minutes ago    CMD ["/bin/sh" "-c" "echo $MYPATH"]             0B        buildkit.dockerfile.v0
<missing>      9 minutes ago    EXPOSE map[80/tcp:{}]                           0B        buildkit.dockerfile.v0
<missing>      9 minutes ago    RUN /bin/sh -c yum -y install net-tools # bu…   217MB     buildkit.dockerfile.v0
<missing>      9 minutes ago    RUN /bin/sh -c yum -y install vim # buildkit    306MB     buildkit.dockerfile.v0
<missing>      10 minutes ago   WORKDIR /user/local                             0B        buildkit.dockerfile.v0
<missing>      10 minutes ago   ENV MYPATH=/user/local                          0B        buildkit.dockerfile.v0
<missing>      10 minutes ago   MAINTAINER cedric<ceddric1108@126.com>          0B        buildkit.dockerfile.v0
<missing>      2 years ago      /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B        
<missing>      2 years ago      /bin/sh -c #(nop)  LABEL org.label-schema.sc…   0B        
<missing>      2 years ago      /bin/sh -c #(nop) ADD file:b3ebbe8bd304723d4…   204MB    
```

 

## 使用DockerFile构建自己的Tomcat

1、准备镜像文件--Tomcat压缩包--jdk压缩包

2、编写dockerfile文件，官方命名`Dockerfile`  ，build时自动寻找，不需要 `-f` 指定

```shell
FROM centos:7
MAINTAINER cedric<cedric1108@126.com>

COPY readme.txt /usr/local/readme.txt

ADD apache-tomcat-9.0.89.tar.gz /usr/local/
ADD jdk-8u411-linux-x64.tar.gz /usr/local/

RUN yum -y install vim

ENV MYPATH /usr/local
WORKDIR $MYPATH

ENV JAVA_HOME /usr/local/jdk1.8.0_411
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

ENV CATALINA_HOME /usr/local/apache-tomcat-9.0.89
ENV CATALINA_BASH /usr/local/apache-tomcat-9.0.89

ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin

EXPOSE 8080

CMD /usr/local/apache-tomcat-9.0.89/bin/startup.sh && tail -F /usr/local/apache-tomcat-9.0.89/bin/logs/catalina.out
```

3、构建镜像

```shell
docker build -t cedricstomcat .
```

4、启动容器，设施挂载目录

```shell
docker run -d -p 9090:8080 --name diytomcat -v /home/cedric/build/tomcat/test:/usr/local/apache-tomcat-9.0.89/webapps/test -v /home/cedric/build/tomcat/tomcatlogs/:/usr/local/apache-tomcat-9.0.89/logs cedricstomcat
```

5、进入容器，启动测试

```shell
[root@iZbp1ibhafma1zroo3wos1Z tomcat]# docker exec -it 03a73b6db652 /bin/bash
[root@03a73b6db652 local]# pwd
/usr/local
[root@03a73b6db652 local]# ll
total 52
drwxr-xr-x 1 root root 4096 May 22 09:31 apache-tomcat-9.0.89
drwxr-xr-x 2 root root 4096 Apr 11  2018 bin
drwxr-xr-x 2 root root 4096 Apr 11  2018 etc
drwxr-xr-x 2 root root 4096 Apr 11  2018 games
drwxr-xr-x 2 root root 4096 Apr 11  2018 include
drwxr-xr-x 8 root root 4096 May 22 09:32 jdk1.8.0_411
drwxr-xr-x 2 root root 4096 Apr 11  2018 lib
drwxr-xr-x 2 root root 4096 Apr 11  2018 lib64
drwxr-xr-x 2 root root 4096 Apr 11  2018 libexec
-rw-r--r-- 1 root root    0 May 22 09:31 readme.txt
drwxr-xr-x 2 root root 4096 Apr 11  2018 sbin
drwxr-xr-x 5 root root 4096 Nov 13  2020 share
drwxr-xr-x 2 root root 4096 Apr 11  2018 src
```

6、使用卷挂载，即可在本地目录编写代码



## 在Docker Hub发布自己的镜像

```shell
# 登录
docker login
		-u		# username
		-p		# password

# 登陆后即可push
docker push
```



# Dockers网络

## Docker0

```shell
# ip addr 查看网络
```

![image-20240522185033791](C:\Users\cedric\AppData\Roaming\Typora\typora-user-images\image-20240522185033791.png)

有三个网络

> 原理

**1、每启动一个docker容器，docker都会给docker容器分配一个ip。只要安装docker就会拥有一个网卡 `docker0` 。使用桥接模式，技术是 `veth-pair`**

![image-20240522190843429](C:\Users\cedric\AppData\Roaming\Typora\typora-user-images\image-20240522190843429.png)

**新增的一对网卡就是容器内的网卡**

```shell
# 容器带来的新增网卡成对出现
# veth-pair技术 就是一对虚拟设备接口，成对出现  一端连接协议，一端彼此相连
# 使得veth-pair充当桥梁，连接各种网络设备  
```

测试发现：容器之间是可以ping通的

**原理如下**



![6d68a91073e9191d6f5c084b4f73b14](C:\Users\cedric\Documents\WeChat Files\wxid_jjeageo0quzq22\FileStorage\Temp\6d68a91073e9191d6f5c084b4f73b14.jpg)

tomcat01和tomcat02共同使用同一个路由器 ---> docker0 

使用的容器在不指定网络情况下，都是由docker0路由，docker会给分配一个默认的可用IP

> 总结：Docker中使用了Linux中的桥接技术。 Docker里面所有的网络接口都是虚拟的，因为虚拟的转发效率高。（内网传递文件）



## 自定义网络

> 查看所有docker网络

![image-20240522215641548](C:\Users\cedric\AppData\Roaming\Typora\typora-user-images\image-20240522215641548.png)

**网络模式**

bridge：桥接 docker（默认，自己创建也使用）

none：不配置网络

host：和宿主机共享网络

container：容器内网络连通（少用）

**测试**

```shell
# 直接启动容器时  默认命令 --net brige (docker0)
docker run -d -P --name tomcat01 --net bridge tomcat

# docker0特点:域名不可以访问，需要使用--link打通连接

# 自定义网络
# --driver bridge
# --subnet 192.168.0.0/16  	子网
# --gateway 192.168.0.1 	网关
[root@iZbp1ibhafma1zroo3wos1Z ~]# docker network create --driver bridge --subnet 192.168.0.0/16 --gateway 192.168.0.1 mynet
6304580283f1a3da384beeb01eec14f830d0a4547055428b655c96594c90de8d
[root@iZbp1ibhafma1zroo3wos1Z ~]# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
88b346f068c1   bridge    bridge    local
4344b58e1606   host      host      local
6304580283f1   mynet     bridge    local
3d91d88aaa66   none      null      local

```

![image-20240522220757667](C:\Users\cedric\AppData\Roaming\Typora\typora-user-images\image-20240522220757667.png)

创建两个容器使用自己创建的网络：

```shell
[root@iZbp1ibhafma1zroo3wos1Z ~]# docker run -d -P --name tomcat-net-01 --net mynet tomcat
eba671133ec32da1e6959f614d13f476544553d09ecd6b74a70bfdfad68dec5c
[root@iZbp1ibhafma1zroo3wos1Z ~]# docker run -d -P --name tomcat-net-02 --net mynet tomcat
58484f314037ab2452675be2f5d1f89b93180be129885a3d3d8b46d3a6641542


```

使用`docker network inspect mynet`查看网络详情![image-20240522221102374](C:\Users\cedric\AppData\Roaming\Typora\typora-user-images\image-20240522221102374.png)

此时测试 ping 连接时，`docker exec -it tomcat-net-01 ping tomcat-net-02` 可以 ping 通，不需要 --link。

> 自定义网络的docker可以帮助维护好对应的关系
>
> 好处：不同的集群使用不同的网络，保证集群是安全的。



## 网络连通

```shell
docker network connect     # Connect a container to a network

[root@iZbp1ibhafma1zroo3wos1Z ~]# docker network connect --help

Usage:  docker network connect [OPTIONS] NETWORK CONTAINER

Connect a container to a network

Options:
      --alias strings           Add network-scoped alias for the container
      --driver-opt strings      driver options for the network
      --ip string               IPv4 address (e.g., "172.30.100.104")
      --ip6 string              IPv6 address (e.g., "2001:db8::33")
      --link list               Add link to another container
      --link-local-ip strings   Add a link-local address for the container

```

测试打通：

```shell
[root@iZbp1ibhafma1zroo3wos1Z ~]# docker network connect mynet tomcat01
[root@iZbp1ibhafma1zroo3wos1Z ~]# docker network inspect mynet

# 连通后将tomcat01加入mynet网络下
```

![image-20240522222423897](C:\Users\cedric\AppData\Roaming\Typora\typora-user-images\image-20240522222423897.png)

```shell
# 也就是 一个容器 两个IP个地址
```



![image-20240522222712533](C:\Users\cedric\AppData\Roaming\Typora\typora-user-images\image-20240522222712533.png)



> 此时 tomcat01 可以直接使用名字 ping 通 mynet 下的容器
