# 使用 Ruby 基础镜像
FROM ruby:3.2-alpine

# 安装系统依赖
RUN apk add --no-cache build-base gcc g++ make nodejs npm

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器
COPY . .

# 安装特定版本的 Jekyll 和 Bundler
RUN gem install bundler jekyll -v 4.3.4

# 安装项目依赖
RUN bundle install

# 构建 Jekyll 静态文件
RUN jekyll build

# 使用 Nginx 作为 Web 服务器
FROM nginx:alpine

# 将 Jekyll 构建的静态文件复制到 Nginx 默认目录
COPY --from=0 /app/_site /usr/share/nginx/html