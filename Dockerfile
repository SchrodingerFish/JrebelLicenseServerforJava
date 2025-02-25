# 第一步：构建阶段，基于 JDK 镜像
FROM openjdk:8-slim AS builder

# 定义工作目录
WORKDIR /app

# 复制 Gradle 构建所需文件
COPY gradlew gradlew.bat build.gradle settings.gradle /app/
COPY gradle /app/gradle
COPY src /app/src

# 为 gradlew 添加执行权限
RUN chmod +x gradlew

# 构建项目，生成 JAR 文件
RUN ./gradlew clean build -x test

# 第二步：运行时阶段，基于更小的 JRE 镜像
FROM openjdk:8-jre-slim

# 定义工作目录
WORKDIR /app

# 环境变量，可以设置使用端口
ENV PORT=8081

# 将构建生成的 JAR 文件复制到运行镜像中
COPY --from=builder /app/build/libs/JrebelBrainsLicenseServerforJava-1.0-SNAPSHOT-all.jar /app/app.jar

# 暴露运行端口
EXPOSE ${PORT}

# 设置容器启动命令
CMD ["java", "-jar", "/app/app.jar", "-p", "${PORT}"]
