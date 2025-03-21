# Run SonarQube with Postgres DB
```
docker run -d --name sonarqube \
-p 9000:9000 \
-e SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonar \
-e SONAR_JDBC_USERNAME=sonar \
-e SONAR_JDBC_PASSWORD=sonar \
-v sonarqube_data:/opt/sonarqube/data \
-v sonarqube_extensions:/opt/sonarqube/extensions \
-v sonarqube_logs:/opt/sonarqube/logs \
sonarqube:lts
```