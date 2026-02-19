-- run_all_mysqlclient.sql
-- Ejecuta TODO en orden usando el cliente mysql (o MySQL Shell en modo SQL).
-- Ejemplo:
--   mysql -u root -p < run_all_mysqlclient.sql
SOURCE 00_reset_db.sql;
SOURCE 01_tables.sql;
SOURCE 02_seed_plan_base.sql;
SOURCE 03_seed_empresa_demo.sql;
SOURCE 04_copy_plan_to_empresa.sql;
SOURCE 05_seed_admin_user.sql;
SOURCE 06_verify.sql;
