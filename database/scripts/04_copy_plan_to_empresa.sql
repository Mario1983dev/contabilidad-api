-- 04_copy_plan_to_empresa.sql
-- ============================================================

INSERT INTO plan_cuentas
(empresa_id, codigo, nombre, tipo, nivel, padre_id, es_detalle, permite_mov, activo, created_at)
SELECT
  @empresa_id,
  b.codigo,
  b.nombre,
  b.tipo,
  b.nivel,
  NULL,
  b.es_detalle,
  b.permite_mov,
  b.activo,
  NOW()
FROM plan_cuentas_base b
ORDER BY b.nivel, b.codigo;

-- Armado padre_id usando JOIN (sin subconsultas sobre la misma tabla)
UPDATE plan_cuentas pc
JOIN plan_cuentas_base b
  ON b.codigo = pc.codigo
JOIN plan_cuentas padre
  ON padre.empresa_id = pc.empresa_id
 AND padre.codigo = b.codigo_padre
SET pc.padre_id = padre.id
WHERE pc.empresa_id = @empresa_id
  AND b.codigo_padre IS NOT NULL;
