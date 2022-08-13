FROM openjdk:17-alpine
ARG JAR_FILE
COPY target/eshop-0.0.1-SNAPSHOT.jar /eshop-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/eshop-0.0.1-SNAPSHOT.jar","-web -webAllowOthers -tcp -tcpAllowOthers -browser"]