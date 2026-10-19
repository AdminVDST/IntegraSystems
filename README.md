# IntegraSystems

Интеграционное приложение для курса «Интеграция систем»: синхронизация деталей
из CMS в БД исторических данных (PostgreSQL) и выгрузка CSV в Report API.
Логика целиком собрана из стандартных узлов n8n, без узлов с кодом.

## Схема

```
Запустить синхронизацию          ручной запуск
  → CMS: загрузить все детали     GET /cms/spares, Basic Auth, все страницы по 10
  → БД истории: сохранить детали  upsert в таблицу spares по spareCode (ничего не удаляется)
  → Report API: получить токен    POST /auth/token
  → БД истории: выбрать все детали  все записи, включая пропавшие из CMS
  → Сформировать CSV-отчёт        UTF-8, разделитель «;», без заголовка
  → Report API: загрузить CSV     POST /report/csv, Bearer-токен, в ответе оценка
```

## Запуск

1. Установите Docker Desktop.
2. Скопируйте `.env.example` в `.env` и заполните:
   - `STAND_LOGIN`, `STAND_PASSWORD` — логин и пароль от стенда преподавателя;
   - `N8N_ENCRYPTION_KEY` — любая длинная случайная строка.
3. Запустите:
   ```
   docker compose up -d
   ```
4. Откройте http://localhost:5678, создайте учётную запись владельца n8n.
5. Откройте workflow «Синхронизация деталей…» и нажмите **Execute workflow**.
   Запускайте вручную при каждой синхронизации; обязательно хотя бы раз в каждом периоде.

При первом запуске сервис `n8n-setup` сам загружает в n8n подключение к БД и workflow.
Повторно он ничего не перезаписывает. Чтобы импортировать заново, удалите тома:
`docker compose down -v` (это удалит и данные БД).

## Проверка

- Данные в БД: `docker compose exec history-db psql -U integration -d history -c "select count(*) from spares;"`
- Оценка: `GET http://77.67.89.207:8080/students/{studentId}/results`

## Файлы

- `docker-compose.yml` — PostgreSQL (`history-db`), n8n и одноразовый импорт (`n8n-setup`)
- `db/init.sql` — таблица `spares`
- `n8n/workflow.json` — workflow
- `n8n/credentials.json` — подключение n8n к локальной БД (только локальный пароль, без учётных данных стенда)
- `.env` — логин и пароль от стенда, в git не попадает
