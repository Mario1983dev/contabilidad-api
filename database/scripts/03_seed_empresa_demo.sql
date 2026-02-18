-- 03_seed_empresa_demo.sql
-- ============================================================

INSERT INTO empresas (rut, razon_social, nombre_fantasia, giro, activo, created_at)
VALUES ('11111111-1', 'Empresa Demo', 'Empresa Demo', 'Servicios', 1, NOW());

SET @empresa_id := LAST_INSERT_ID();
