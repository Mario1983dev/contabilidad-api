-- 05_seed_admin_user.sql
-- ============================================================
-- Crea:
-- 1) Usuario MASTER_ADMIN (global, oficina_id = NULL)
-- 2) Usuario ADMIN_OFICINA para la oficina demo (admin@ofi001)
-- Vincula admin de oficina a la empresa demo
-- Requiere: @oficina_id y @empresa_id creados en 03_seed_empresa_demo.sql
-- ============================================================

-- 1) MASTER_ADMIN (fijo del sistema)
INSERT INTO usuarios (oficina_id, username, email, password, rol, activo, created_at)
VALUES (NULL, 'master', 'master@system.local', 'master', 'MASTER_ADMIN', 1, NOW());

-- 2) ADMIN_OFICINA (para la oficina demo)
INSERT INTO usuarios (oficina_id, username, email, password, rol, activo, created_at)
VALUES (@oficina_id, 'admin@ofi001', 'admin@ofi001.local', 'admin', 'ADMIN_OFICINA', 1, NOW());

SET @user_id := LAST_INSERT_ID();

-- Vincular admin@ofi001 a la empresa demo (para operar módulos dentro de esa empresa)
INSERT INTO empresa_usuarios (empresa_id, usuario_id, activo, created_at)
VALUES (@empresa_id, @user_id, 1, NOW());
