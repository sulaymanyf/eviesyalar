# 构建阶段
FROM ruby:3.2-alpine AS builder

RUN apk add --no-cache build-base git nodejs npm

WORKDIR /app
COPY . .

# 安装依赖并构建
RUN gem install bundler -v 2.4.19 && bundle install --retry 3 && jekyll build

# 生产阶段
FROM nginx:alpine

# 只复制构建结果
COPY --from=builder /app/_site /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]