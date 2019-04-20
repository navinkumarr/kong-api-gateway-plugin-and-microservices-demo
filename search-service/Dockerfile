FROM openjdk:8-jdk-alpine
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN /app/gradlew build
ENTRYPOINT ["/app/gradlew","bootRun"]
