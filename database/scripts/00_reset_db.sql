-- 00_reset_db.sql
DROP DATABASE IF EXISTS contabilidad;
CREATE DATABASE contabilidad CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE contabilidad;

SET SQL_SAFE_UPDATES = 0;
