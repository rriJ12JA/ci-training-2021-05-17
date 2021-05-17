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

