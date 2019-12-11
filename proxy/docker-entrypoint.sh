#!/usr/bin/env sh
set -eu

envsubst '${DASHBOARD_HOST} ${DASHBOARD_PORT} ${BACKEND_HOST} ${BACKEND_PORT} ${STATIC_HOST} ${STATIC_PORT}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

cat /etc/nginx/conf.d/default.conf

exec "$@"