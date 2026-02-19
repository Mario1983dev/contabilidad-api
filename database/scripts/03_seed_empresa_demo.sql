-- 03_seed_empresa_demo.sql
-- ============================================================
-- Crea una OFICINA DEMO + EMPRESA DEMO
-- Variables: @oficina_id, @empresa_id
-- ============================================================

-- Oficina demo
INSERT INTO oficina_contable (codigo, nombre, estado, created_at)
VALUES ('ofi001', 'Oficina Demo', 'ACTIVA', NOW());

SET @oficina_id := LAST_INSERT_ID();

-- Empresa demo (dentro de la oficina demo)
INSERT INTO empresas (oficina_id, rut, razon_social, nombre_fantasia, giro, activo, created_at)
VALUES (@oficina_id, '11111111-1', 'Empresa Demo', 'Empresa Demo', 'Servicios', 1, NOW());

SET @empresa_id := LAST_INSERT_ID();
