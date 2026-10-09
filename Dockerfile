# FROM nginx:1.13.3-alpine
# COPY /nginx/default.conf /etc/nginx/conf.d/
# RUN rm -rf /usr/share/nginx/html/*
# COPY dist/shop/ /usr/share/nginx/html/

FROM httpd:latest
RUN rm -rf /usr/local/apache2/htdocs/*
COPY dist/shop/ /usr/local/apache2/htdocs/