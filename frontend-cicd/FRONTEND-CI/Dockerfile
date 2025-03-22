# FROM nginx:1.26.3-alpine
# EXPOSE 80
# RUN rm -rf /usr/share/nginx/html/*

# COPY code/ /usr/share/nginx/html/

# RUN rm -rf /etc/nginx/nginx.conf
# RUN rm -rf /etc/nginx/conf.d/default.conf

# COPY nginx.conf /etc/nginx/nginx.conf

# COPY expense.conf /etc/nginx/default.d/expense.conf

# CMD ["nginx", "-g", "daemon off;"]



# FROM nginx:1.26.3-alpine

# # Remove default HTML files
# RUN rm -rf /usr/share/nginx/html/*

# # Copy application code to Nginx's web root
# COPY code /usr/share/nginx/html/

# RUN rm -rf /etc/nginx/nginx.conf
# RUN rm -rf /etc/nginx/conf.d

# # Copy custom Nginx configuration
# COPY nginx.conf /etc/nginx/nginx.conf

# # Copy expense.conf to the correct Nginx configuration directory
# COPY expense.conf /etc/nginx/default.d/expense.conf

# # USER nginx

# # Start Nginx in foreground mode
# CMD ["nginx", "-g", "daemon off;"]


#After Best practices
# FROM nginx:stable-alpine3.20

# # Remove default HTML files
# RUN rm -rf /usr/share/nginx/html/*

# RUN rm -rf /etc/nginx/nginx.conf && \
#     rm -rf /etc/nginx/conf.d

# # Copy application code to Nginx's web root
# COPY code /usr/share/nginx/html/ && \
#     nginx.conf /etc/nginx/nginx.conf/ && \
#     expense.conf /etc/nginx/default.d/expense.conf/


# RUN mkdir -p /var/cache/nginx/client_temp && \
#     mkdir -p /var/cache/nginx/proxy_temp && \
#     mkdir -p /var/cache/nginx/fastcgi_temp && \
#     mkdir -p /var/cache/nginx/uwsgi_temp && \
#     mkdir -p /var/cache/nginx/scgi_temp && \
#     chown -R nginx:nginx /var/cache/nginx && \
#     chown -R nginx:nginx /etc/nginx/ && \
#     chmod -R 755 /etc/nginx/ && \
#     chown -R nginx:nginx /var/log/nginx && \
#     mkdir -p /etc/nginx/ssl/ && \
#     chown -R nginx:nginx /etc/nginx/ssl/ && \
#     chmod -R 755 /etc/nginx/ssl/ && \
#     touch /var/run/nginx.pid && \
#     chown -R nginx:nginx /var/run/nginx.pid /run/nginx.pid


# USER nginx

# # Start Nginx in foreground mode
# CMD ["nginx", "-g", "daemon off;"]



# Use stable NGINX with Alpine-based image
FROM nginx:stable-alpine3.20
# FROM nginx:1.26.3-alpine
# FROM nginx

# Remove default HTML files and configurations
RUN rm -rf /usr/share/nginx/html/* && \
    rm -rf /etc/nginx/nginx.conf && \
    rm -rf /etc/nginx/conf.d/*

# Copy application files, configurations, and SSL files in one command
COPY code /usr/share/nginx/html/ 
COPY nginx.conf /etc/nginx/nginx.conf
COPY expense.conf /etc/nginx/default.d/expense.conf

# Set up Nginx cache and permissions in one layer
RUN mkdir -p /var/cache/nginx/{client_temp,proxy_temp,fastcgi_temp,uwsgi_temp,scgi_temp} && \
    chown -R nginx:nginx /var/cache/nginx /etc/nginx /var/log/nginx && \
    chmod -R 755 /etc/nginx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown nginx:nginx /var/run/nginx.pid

USER nginx

# Start Nginx in foreground mode
CMD ["nginx", "-g", "daemon off;"]
