#Stage 1
FROM node:20 AS builder
RUN mkdir -p /opt/server
# RUN groupadd expense && \
#     useradd -aG expense expense && \
#     mkdir -p /opt/server && \
#     chown -R expense:expense /opt/server
WORKDIR /opt/server
COPY /node/*.js .
COPY /node/package.json .
RUN npm install


#Stage-2
FROM node:alpine
ENV DB_HOST="mysql"
RUN groupadd -S expense && \
    useradd -S expense -G expense && \
    mkdir -p /opt/server && \
    chown -R expense:expense /opt/server
WORKDIR /opt/server
COPY --from=builder /opt/server /opt/server
USER expense
EXPOSE 8080
CMD ["node", "index.js"]