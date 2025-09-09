# Используем официальный образ Postgres
FROM postgres:16  

# Устанавливаем переменные среды (пароль админа, имя БД)
ENV POSTGRES_USER=postgres  
ENV POSTGRES_PASSWORD=pass  
ENV POSTGRES_DB=postgres  

# Копируем дамп в директорию initdb (Postgres автоматически исполнит при первом запуске)
COPY dump.sql /docker-entrypoint-initdb.d/

# Опционально: Копируем кастомные схемы, если нужно
# COPY schemas.sql /docker-entrypoint-initdb.d/

# Экспортируйте порт 5432 (стандартный для Postgres)
EXPOSE 5432
