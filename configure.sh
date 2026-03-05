#!/bin/bash

make clean

root=/home/dev/openresty-openspec
cd $root


./configure                       \
            --prefix=/usr/local/home/dev/openresty-openspec \
            --with-cc-opt="-O0" \
            --without-mail_pop3_module \
            --without-mail_imap_module \
            --without-mail_smtp_module \
            --with-pcre                \
            --with-http_realip_module  \
            --with-debug               \
            -j8
