FROM alpine/git as clone
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
ARG GH_TOKEN
WORKDIR /app
RUN git clone https://$GH_TOKEN@github.com/yildiz-online/retro-updater-config-builder.git

FROM moussavdb/build-java:17 as build
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
WORKDIR /app
COPY --from=clone /app/retro-updater-config-builder /app
RUN mvn package -s ../build-resources/settings.xml -DskipTests -Pbuild-assembly

FROM moussavdb/runtime-java
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
EXPOSE 10301
WORKDIR /app
COPY --from=build /app/target/updater-config-builder-assembly.jar /app
CMD ["java", "-jar", "updater-config-builder-assembly.jar"]
