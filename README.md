# reader

## 介绍

官方Github仓库: https://github.com/hectorqin/reader

本镜像增加了PUID，PGID，Umask设置

## 部署

### docker-cli

```
# 自用版(建议修改映射端口)
docker run -d \
    --restart=always \
    --name=reader \
    -e "SPRING_PROFILES_ACTIVE=prod" \
    -e PUID=1000 \
    -e PGID=1000 \
    -e UMASK=022 \
    -v $(pwd)/logs:/logs \
    -v $(pwd)/storage:/storage \
    -p 8080:8080 \
    ddsderek/reader:latest
    # ddsderek/reader:openj9-latest

# 多用户版 使用环境变量(建议修改映射端口)
docker run -d \
    --restart=always \
    --name=reader \
    -e "SPRING_PROFILES_ACTIVE=prod" \
    -e "READER_APP_SECURE=true" \
    -e "READER_APP_SECUREKEY=管理密码" \
    -e "READER_APP_INVITECODE=注册邀请码" \
    -e PUID=1000 \
    -e PGID=1000 \
    -e UMASK=022 \
    -v $(pwd)/logs:/logs \
    -v $(pwd)/storage:/storage \
    -p 8080:8080 \
    ddsderek/reader:latest
    # ddsderek/reader:openj9-latest
```

### docker-compose

```
version: '3.1'
services:
# reader 在线阅读
# 公开服务器(服务器位于日本)：[https://reader.nxnow.top](https://reader.nxnow.top) 测试账号/密码分别为guest/guest123，也可自行创建账号添加书源，不定期删除长期未登录账号(2周)
# 阅读官方书源 : [https://legado.pages.dev](https://legado.pages.dev) 或者 [http://legado.git.llc](https://legado.pages.dev) 点击打开连接，添加远程书源即可
# 公众号汇总 : [https://mp.weixin.qq.com/s/5t8nfSnRfHjJNAvT76fA_A](https://mp.weixin.qq.com/s/5t8nfSnRfHjJNAvT76fA_A)
# 手动更新方式 : docker-compose pull && docker-compose up -d
  reader:
    image: ddsderek/reader:latest
    #image: ddsderek/reader:openj9-latest #docker镜像，arm64架构或小内存机器优先使用此镜像.启用需删除上一行
    container_name: reader #容器名 可自行修改
    restart: always
    ports:
      - 4396:8080 #4396端口映射可自行修改
    networks:
      - share_net
    volumes:
      - /home/reader/logs:/logs #log映射目录 /home/reader/logs 映射目录可自行修改
      - /home/reader/storage:/storage #数据映射目录 /home/reader/storage 映射目录可自行修改
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - READER_APP_USERLIMIT=50 #用户上限,默认50
      - READER_APP_USERBOOKLIMIT=200 #用户书籍上限,默认200
      - READER_APP_CACHECHAPTERCONTENT=true #开启缓存章节内容 V2.0
      # 如果启用远程webview，需要取消注释下面的 remote-webview 服务
      # - READER_APP_REMOTEWEBVIEWAPI=http://remote-webview:8050 #开启远程webview
      # 下面都是多用户模式配置
      - READER_APP_SECURE=true #开启登录鉴权，开启后将支持多用户模式
      - READER_APP_SECUREKEY=adminpwd  #管理员密码  建议修改
      - READER_APP_INVITECODE=registercode #注册邀请码 建议修改,如不需要可注释或删除
      # 文件权限设置
      - PUID=1000
      - PGID=1000
      - UMASK=022
  # remote-webview:
  #   image: hectorqin/remote-webview
  #   container_name: remote-webview #容器名 可自行修改
  #   restart: always
  #   ports:
  #     - 8050:8050
  #   networks:
  #     - share_net
# 自动更新docker镜像
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    restart: always
    # 环境变量,设置为上海时区
    environment:
        - TZ=Asia/Shanghai
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: reader watchtower --cleanup --schedule "0 0 4 * * *"
    networks:
      - share_net
    # 仅更新reader与watchtower容器,如需其他自行添加 '容器名' ,如:reader watchtower nginx
    # --cleanup 更新后清理旧版本镜像
    # --schedule 自动检测更新 crontab定时(限定6位crontab) 此处代表凌晨4点整
networks:
  share_net:
    driver: bridge
```
