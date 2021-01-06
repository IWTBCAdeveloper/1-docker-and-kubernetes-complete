FROM node:12-alpine as builder

WORKDIR "/app"

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

###################################################

FROM nginx

# EXPOSE 80 có nghĩa là container này cần phải có 1 port được map với port 80
# mặc định trên máy của chúng ta khi config thế này thì nó cũng không tự động set cho chúng ta
# nhưng khi deploy lên AWS elastic beanstalk, thì nó sẽ nhìn vào Dockerfile và tìm kiếm EXPOSE
# sau đó nó sẽ tự động map và mọi incoming traffic sẽ đi vào container trên elastic beanstalk
# qua cổng này
EXPOSE 80

COPY --from=builder /app/build /usr/share/nginx/html