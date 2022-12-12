FROM centos:7.9.2009 as base
MAINTAINER lejianwen <84855512@qq.com>
RUN yum -y install epel-release gcc gcc-c++ automake autoconf libtool make zlib zlib-devel openssl openssl-devel pcre pcre-devel

ENV downurl http://nginx.org/download/nginx-1.20.2.tar.gz
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

FROM base as builder
MAINTAINER lejianwen <84855512@qq.com>
WORKDIR /rootfs
RUN mkdir -p lib64
RUN cp /lib64/libdl.so.2 ./lib64 \
    && cp /lib64/libpthread.so.0 ./lib64 \
    && cp /lib64/libcrypt.so.1 ./lib64 \
    && cp /lib64/libpcre.so.1 ./lib64 \
    && cp /lib64/libssl.so.10 ./lib64 \
    && cp /lib64/libcrypto.so.10 ./lib64 \
    && cp /lib64/libz.so.1 ./lib64 \
    && cp /lib64/libc.so.6 ./lib64 \
    && cp /lib64/ld-linux-x86-64.so.2 ./lib64 \
    && cp /lib64/libfreebl3.so ./lib64 \
    && cp /lib64/libgssapi_krb5.so.2 ./lib64 \
    && cp /lib64/libkrb5.so.3 ./lib64 \
    && cp /lib64/libcom_err.so.2 ./lib64 \
    && cp /lib64/libk5crypto.so.3 ./lib64 \
    && cp /lib64/libkrb5support.so.0 ./lib64 \
    && cp /lib64/libkeyutils.so.1 ./lib64 \
    && cp /lib64/libresolv.so.2 ./lib64 \
    && cp /lib64/libselinux.so.1 ./lib64 \
    && cp /lib64/libnss_files.so.2 ./lib64 \
    && cp /lib64/libnss_dns.so.2 ./lib64 \
    && cp /lib64/libnss_myhostname.so.2 ./lib64 \
    && cp /lib64/libm.so.6 ./lib64 \
    && cp /lib64/libgcc_s.so.1 ./lib64

FROM busybox
MAINTAINER lejianwen <84855512@qq.com>

RUN echo www:x:1000:1000:www:/:/bin/sh >> etc/passwd \
        && echo www:x:1000: >> etc/group
RUN mkdir /lib \
    && ln -s /lib /lib64 \
    && mkdir /data && touch /etc/resolv.conf

COPY --from=builder /etc/nsswitch.conf /etc/nsswitch.conf
COPY --from=builder /etc/pki /etc/pki
COPY --from=builder /rootfs/lib64/* /lib64/
COPY --from=builder /usr/local/lib/libluajit-5.1.so.2 /usr/local/lib/libluajit-5.1.so.2
COPY --from=builder /data/ /data/

CMD ["/data/apps/nginx/sbin/nginx"]