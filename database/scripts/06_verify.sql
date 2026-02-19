-- 06_verify.sql
-- ============================================================

SELECT 'OFICINAS' AS seccion, id, codigo, nombre, estado FROM oficina_contable;

SELECT 'EMPRESA DEMO' AS seccion, e.id, e.oficina_id, o.codigo AS oficina_codigo, e.rut, e.razon_social
FROM empresas e
JOIN oficina_contable o ON o.id = e.oficina_id;

SELECT 'USUARIOS' AS seccion, id, oficina_id, username, email, rol, activo FROM usuarios ORDER BY id;

SELECT 'VINCULO EMPRESA_USUARIOS' AS seccion, empresa_id, usuario_id, activo FROM empresa_usuarios;

SELECT 'PLAN BASE (cantidad)' AS seccion, COUNT(*) AS total FROM plan_cuentas_base;

SELECT 'PLAN EMPRESA DEMO (cantidad)' AS seccion, COUNT(*) AS total
FROM plan_cuentas WHERE empresa_id = @empresa_id;
