FROM adoptopenjdk:16-jre-hotspot
WORKDIR /opt/app
COPY build/libs/*.jar employees.jar
CMD ["java", "-jar", "employees.jar"]