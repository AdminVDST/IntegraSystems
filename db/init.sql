-- БД исторических данных: записи не удаляются, только добавляются и обновляются.
-- Имена колонок совпадают с полями CMS, чтобы n8n сопоставлял их автоматически.
CREATE TABLE IF NOT EXISTS spares (
    "spareCode"        TEXT PRIMARY KEY,
    "spareName"        TEXT,
    "spareDescription" TEXT,
    "spareType"        TEXT,
    "spareStatus"      TEXT,
    "price"            TEXT,
    "quantity"         INTEGER,
    "updatedAt"        TEXT,
    "firstSeenAt"      TIMESTAMPTZ NOT NULL DEFAULT now()
);
