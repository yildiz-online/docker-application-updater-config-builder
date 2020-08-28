FROM alpine/git as clone
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
ARG GH_TOKEN
WORKDIR /app
RUN git clone https://$GH_TOKEN@github.com/yildiz-online/retro-updater-config-builder.git

FROM moussavdb/build-java-dependencies as build
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
WORKDIR /app
COPY --from=clone /app/retro-updater-config-builder /app
RUN mvn install -s ../build-resources/settings.xml -DskipTests -Pbuild-assembly

FROM moussavdb/runtime-java
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
WORKDIR /app
EXPOSE 10301
RUN cd  /app/target
RUN ls -l
COPY --from=build /app/target/retro-updater-config-builder-assembly.jar /app
CMD ["java -jar retro-updater-config-builder-assembly.jar"]
