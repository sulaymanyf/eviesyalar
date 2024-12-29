# 构建阶段
FROM ruby:3.2-alpine AS builder

# 安装构建所需的工具
RUN apk add --no-cache build-base git nodejs npm

WORKDIR /app
COPY . .

# 安装 Bundler 版本并安装依赖
RUN gem install bundler -v 2.5.10 --no-document && bundle install --jobs 2 --retry 5

# 运行 Jekyll 构建生成 _site 目录
RUN bundle exec jekyll build

# 生产阶段
FROM nginx:alpine



# 只复制构建结果
COPY --from=builder /app/_site /usr/share/nginx/html

EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]