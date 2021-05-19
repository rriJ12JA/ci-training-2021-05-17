# CI/CD oktatás

```shell
cd \

mkdir training
cd training

git clone https://github.com/Training360/ci-training-2021-05-17

cd ci-training-2021-05-17\hello-gradle

gradlew hello
```

```shell
git pull

gradlew bootRun
```

Elérhető a `http://localhost:8080/swagger-ui.html` címen.

```shell
gradlew build
```

Ennek hatására létrejön a `/build/libs/*.jar`. És ezt el lehet indítani
a következő paranccsal: `java -jar employees-0.0.1-SNAPSHOT.jar`

```shell
gradlew dependencyUpdates
```

## Jacoco

```shell
gradlew clean build
```

Nyisd meg a `\build\reports\jacoco\test\html\index.html` állományt!

## Docker

Parancssor Futtatás rendszergazdaként

```shell
net localgroup docker-users OKTATAS\T360-v5-DEAC-o /add
docker version
docker run hello-world
```

Közben kellett egy kilép/belép

## Docker alapozó

```shell
docker version
docker run hello-world
docker run -p 8080:80 nginx
docker run -d -p 8080:80 nginx
docker ps
docker stop 517e15770697
docker run -d -p 8080:80 --name my-nginx nginx
docker stop my-nginx
docker ps -a
docker start my-nginx
docker logs -f my-nginx
docker stop my-nginx
docker rm my-nginx

docker images
docker rmi nginx

docker exec -it my-nginx bash
```


## Adatbázis indítása integrációs tesztekhez

```shell
docker run 
  -d
  -e MYSQL_DATABASE=employees 
  -e MYSQL_USER=employees 
  -e MYSQL_PASSWORD=employees 
  -e MYSQL_ALLOW_EMPTY_PASSWORD=yes
  -p 3306:3306 
  --name employees-mariadb 
  mariadb
```

## Integrációs tesztek futtatása

* Módosítottuk a `build.gradle` állományt

```shell
gradlew 
  -Pspring.datasource.url=jdbc:mariadb://localhost/employees 
  -Pspring.datasource.username=employees  
  -Pspring.datasource.password=employees 
  clean integrationTest

docker exec -it employees-mariadb mysql employees

select * from employees;
```

## Futtatás a Hub-ról

```shell
docker run -p 8080:8080 --name tr360-employee training360/employees-ci20210518
docker stop tr360-employee
```

JAR fájl létrehozása: `gradlew assemble`

```
docker build -t employees .
docker run -p 8080:8080 --name my-employee employees
```

```shell
set DOCKER_BUILDKIT=0
set COMPOSE_DOCKER_CLI_BUILD=0
```

## Hálózat

```shell
docker network create employees-net

docker run 
  -d
  -e MYSQL_DATABASE=employees 
  -e MYSQL_USER=employees 
  -e MYSQL_PASSWORD=employees 
  -e MYSQL_ALLOW_EMPTY_PASSWORD=yes
  -p 3307:3306 
  --name employees-app-mariadb 
  --network employees-net
  mariadb

docker run 
  -e SPRING_DATASOURCE_URL=jdbc:mariadb://employees-app-mariadb/employees
  -e SPRING_DATASOURCE_USERNAME=employees
  -e SPRING_DATASOURCE_PASSWORD=employees
  --network employees-net
  --name employees-app
  -p 8081:8080 
  employees

docker exec -it employees-app-mariadb mysql employees

docker network inspect employees-net
```

## E2E teszt futtatása

Az `integrationtest` könyvtárban a következő parancsot:

```shell
docker-compose up --abort-on-container-exit
```

A `.docker/config.json` fájl törlése.

## Docker futtatás Gradle-ből

```shell
gradlew dockerRun
gradlew dockerRunStatus
gradlew dockerStop
```

## Jenkins

```shell
docker build -t employees-jenkins --file Dockerfile.jenkins .
docker network create jenkins
docker run 
  --detach 
  --network jenkins 
  --volume jenkins-data:/var/jenkins_home 
  --volume /var/run/docker.sock:/var/run/docker.sock 
  --publish 8090:8080 
  --name employees-jenkins 
  employees-jenkins
docker exec -it employees-jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Hozzáférés a host Dockerjéhez:

```shell
docker exec --user root -it employees-jenkins chmod 777 /var/run/docker.sock
```

## SonarQube

```shell
docker run --name employees-sonarqube --detach 
  --network jenkins 
  --publish 9000:9000 
  sonarqube:lts

gradlew test assemble sonarqube
```

## Nexus

```shell
docker run --name nexus --detach
  --network jenkins
  --publish 8091:8081
   --publish 8092:8082
  --volume nexus-data:/nexus-data
  sonatype/nexus3

gradlew assemble publish

_
```

