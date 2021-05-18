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