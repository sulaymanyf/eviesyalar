# 使用 Ruby 基础镜像，构建 Jekyll 静态站点
FROM ruby:3.2-alpine AS builder

# 安装系统依赖
RUN apk add --no-cache build-base gcc g++ make nodejs npm git

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器
COPY . .

# 删除旧的 Gemfile.lock 文件
RUN rm -f Gemfile.lock

# 安装指定版本的 Bundler 和 Jekyll
RUN gem install bundler -v 2.4.19 && gem install jekyll -v 4.3.4

# 安装项目依赖
RUN bundle install --retry 3 --verbose

# 构建静态网站
RUN jekyll build

# 使用 Nginx 提供静态文件
FROM nginx:alpine

# 将 Jekyll 构建的静态文件复制到 Nginx 默认目录
COPY --from=builder /app/_site /usr/share/nginx/html

# 暴露端口 80（Nginx 默认端口）
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]