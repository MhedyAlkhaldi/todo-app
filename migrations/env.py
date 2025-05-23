from logging.config import fileConfig
from sqlalchemy import engine_from_config
from sqlalchemy import pool
from app import db
from alembic import context
import os
from dotenv import load_dotenv

# تحميل متغيرات البيئة
load_dotenv()

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = db.metadata

def get_url():
    # الأفضلية لمتغير البيئة DATABASE_URL
    if os.getenv("DATABASE_URL"):
        return os.getenv("DATABASE_URL").replace("postgres://", "postgresql://", 1)
    return config.get_main_option("sqlalchemy.url")

def run_migrations_offline():
    url = get_url()
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online():
    connectable = engine_from_config(
        {"sqlalchemy.url": get_url()},  # استخدام الرابط من .env
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(
            connection=connection, 
            target_metadata=target_metadata
        )
        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()