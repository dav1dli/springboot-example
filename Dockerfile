FROM openjdk
RUN adduser default -u 1001 -g 0 -d /opt/app -m -s /sbin/nologin
USER default
COPY ./target/HelloWorld-0.0.1-SNAPSHOT.jar /opt/app/HelloWorld-0.0.1-SNAPSHOT.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/opt/app/HelloWorld-0.0.1-SNAPSHOT.jar"]
