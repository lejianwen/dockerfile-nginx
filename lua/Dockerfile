FROM centos
MAINTAINER lejianwen <84855512@qq.com>
RUN yum -y install epel-release gcc gcc-c++ automake autoconf libtool make zlib zlib-devel openssl openssl-devel pcre pcre-devel

ENV downurl http://nginx.org/download/nginx-1.17.1.tar.gz
ENV luaurl http://luajit.org/download/LuaJIT-2.0.5.tar.gz
ENV lua_ngx_url https://github.com/openresty/lua-nginx-module/archive/v0.10.13.tar.gz
ENV ngx_devel_kit_url https://github.com/simplresty/ngx_devel_kit/archive/v0.3.1rc1.tar.gz
ENV LUAJIT_LIB /usr/local/lib
ENV LUAJIT_INC /usr/local/include/luajit-2.0

RUN curl -L $downurl -o /nginx.tar.gz \
    && curl -L $luaurl -o /LuaJIT.tar.gz \
    && curl -L $lua_ngx_url -o /lua-nginx-module.tar.gz \
    && curl -L $ngx_devel_kit_url -o /ngx_devel_kit.tar.gz

RUN useradd -u 1000 www -s /sbin/nologin  \
    && mkdir /data/src -p && cd /data/src \
    && mv /LuaJIT.tar.gz ./ \
    && mv /lua-nginx-module.tar.gz ./ \
    && mv /ngx_devel_kit.tar.gz ./ \
    && mv /nginx.tar.gz ./ \
    && mkdir LuaJIT && mkdir lua-nginx-module && mkdir ngx_devel_kit && mkdir nginx \
    && tar -zxf LuaJIT.tar.gz -C ./LuaJIT --strip-components 1 \
    && tar -zxf lua-nginx-module.tar.gz  -C ./lua-nginx-module --strip-components 1 \
    && tar -zxf ngx_devel_kit.tar.gz  -C ./ngx_devel_kit --strip-components 1 \
    && tar -zxf nginx.tar.gz -C ./nginx --strip-components 1 \
    && cd LuaJIT && make && make install \
    && cd ../ \
    && cd nginx \
    && ./configure --user=www \
       --group=www --prefix=/data/apps/nginx \
       --with-http_stub_status_module \
       --with-http_ssl_module \
       --with-http_flv_module \
       --with-http_gzip_static_module \
       --with-http_realip_module \
       --with-http_v2_module \
       --add-module=../lua-nginx-module \
       --add-module=../ngx_devel_kit  \
       --with-ld-opt="-Wl,-rpath,$LUAJIT_LIB" \
    && make -j24  && make install \
    && cd / && rm /data/src -rf \
    && sed -i 's/\#user  nobody;/user www www;/' /data/apps/nginx/conf/nginx.conf \
    && sed -i 's/\#pid        logs\/nginx.pid;/pid        logs\/nginx.pid;/' /data/apps/nginx/conf/nginx.conf \
    && sed -i '/pid        logs\/nginx.pid;/adaemon off;' /data/apps/nginx/conf/nginx.conf
CMD ["/data/apps/nginx/sbin/nginx"]