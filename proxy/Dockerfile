FROM nginx:1.17-alpine

ENV DASHBOARD_HOST=localhost
ENV DASHBOARD_PORT=81
ENV BACKEND_HOST=localhost
ENV BACKEND_PORT=8000
ENV STATIC_HOST=localhost
ENV STATIC_PORT=82

COPY docker-entrypoint.sh /

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf.template

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]