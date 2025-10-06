# Railway Configuration for VegN-Bio Backend

## Environment Variables Required

Add these environment variables in your Railway project settings:

```
SPRING_DATASOURCE_URL=${{Postgres.DATABASE_URL}}
SPRING_DATASOURCE_USERNAME=${{Postgres.USERNAME}}
SPRING_DATASOURCE_PASSWORD=${{Postgres.PASSWORD}}
JWT_SECRET=your-super-secret-jwt-key-here-make-it-long-and-random
SPRING_PROFILES_ACTIVE=production
```

## Database Setup

1. Add PostgreSQL service to your Railway project
2. Railway will automatically provide the DATABASE_URL
3. The application will use Flyway migrations to set up the database schema

## Build Configuration

- Java Version: 21
- Build Command: `mvn clean package -DskipTests`
- Start Command: `java -jar target/api-0.0.1-SNAPSHOT.jar`
- Port: 8080 (automatically detected by Railway)
