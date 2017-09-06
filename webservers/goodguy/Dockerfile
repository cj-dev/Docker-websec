FROM nginx

COPY index.html /usr/share/nginx/html/index.html
RUN mkdir /etc/nginx/ssl
COPY etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY etc/nginx/ssl/ /etc/nginx/ssl/

CMD ["nginx", "-g", "daemon off;"]
