FROM centos:7.9.2009 as base
MAINTAINER lejianwen <84855512@qq.com>
ENV downurl http://nginx.org/download/nginx-1.20.2.tar.gz
RUN yum -y install epel-release gcc gcc-c++ automake autoconf libtool make zlib zlib-devel openssl openssl-devel pcre pcre-devel
RUN curl -L $downurl -o /nginx.tar.gz
RUN useradd -u 1000 www -s /sbin/nologin  \
    && mkdir /data/src -p && cd /data/src && mv /nginx.tar.gz ./ \
    && mkdir nginx && tar -zxf nginx.tar.gz -C ./nginx --strip-components 1 && cd nginx \
    && ./configure --user=www \
       --group=www --prefix=/data/apps/nginx \
       --with-http_stub_status_module \
       --with-http_ssl_module \
       --with-http_flv_module \
       --with-http_gzip_static_module \
       --with-http_realip_module \
       --with-http_v2_module \
    && make -j24  && make install \
    && cd / && rm /data/src -rf \
    && sed -i 's/\#user  nobody;/user www www;/' /data/apps/nginx/conf/nginx.conf \
    && sed -i 's/\#pid        logs\/nginx.pid;/pid        logs\/nginx.pid;/' /data/apps/nginx/conf/nginx.conf \
    && sed -i '/pid        logs\/nginx.pid;/daemon off;' /data/apps/nginx/conf/nginx.conf

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
    && cp /lib64/libnss_myhostname.so.2 ./lib64

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
COPY --from=builder /data/ /data/
RUN ln -s /data/apps/nginx/sbin/nginx /bin/nginx
CMD ["nginx"]