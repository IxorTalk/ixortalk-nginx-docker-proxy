#!/bin/sh
#
# The MIT License (MIT)
#
# Copyright (c) 2016-present IxorTalk CVBA
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# Exit on non-zero return values
set -e

IXORTALK_NGINX_PROFILE=${IXORTALK_NGINX_PROFILE:="dev"}
IXORTALK_NGINX_SUFFIX=${IXORTALK_NGINX_SUFFIX:=""}
IXORTALK_CONFIG_SERVER_LABEL=${IXORTALK_CONFIG_SERVER_LABEL:="master"}
IXORTALK_CONFIG_SERVER_URL=${IXORTALK_CONFIG_SERVER_URL:="http://ixortalk-config-server:8899/config"}

rm -fr /etc/nginx/conf.d/default.conf

# nginx.conf
if [[ -z "${IXORTALK_NGINX_SUFFIX}" ]] ; then
    CONF_URL=${IXORTALK_CONFIG_SERVER_URL}/ixortalk.nginx/${IXORTALK_NGINX_PROFILE}/${IXORTALK_CONFIG_SERVER_LABEL}/ixortalk-proxy.conf
else
    CONF_URL=${IXORTALK_CONFIG_SERVER_URL}/ixortalk.nginx/${IXORTALK_NGINX_PROFILE}/${IXORTALK_CONFIG_SERVER_LABEL}/ixortalk-proxy-${IXORTALK_NGINX_SUFFIX}.conf
fi
echo "Fetching configuration from ${CONF_URL}"
wget ${CONF_URL} -O /etc/nginx/conf.d/ixortalk-proxy.conf

# .htpasswd
if [ "${IXORTALK_NGINX_ENABLE_BASIC_AUTH}" = true ] ; then
    PASSWD_URL=${IXORTALK_CONFIG_SERVER_URL}/ixortalk.nginx/${IXORTALK_NGINX_PROFILE}/${IXORTALK_CONFIG_SERVER_LABEL}/.htpasswd
    echo "Fetching .htpasswd from ${PASSWD_URL}"
    wget ${PASSWD_URL} -O /etc/nginx/.htpasswd
fi

nginx -g 'daemon off;'
