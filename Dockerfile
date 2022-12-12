FROM centos:7.9.2009
MAINTAINER lejianwen <84855512@qq.com>
RUN yum -y install epel-release gcc gcc-c++ automake autoconf libtool make zlib zlib-devel openssl openssl-devel pcre pcre-devel
RUN curl -L $downurl -o /nginx.tar.gz
ENV downurl http://nginx.org/download/nginx-1.20.2.tar.gz
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
    && sed -i '/pid        logs\/nginx.pid;/adaemon off;' /data/apps/nginx/conf/nginx.conf
RUN ln -s /data/apps/nginx/sbin/nginx /bin/nginx
CMD ["nginx"]