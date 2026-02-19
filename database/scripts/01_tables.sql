-- 01_tables.sql
-- ============================================================
-- Esquema base con soporte MULTI-OFICINA:
-- MASTER_ADMIN (global) -> oficina_contable -> empresas -> (plan_cuentas, asientos, etc.)
-- ============================================================

-- ========================
-- OFICINAS CONTABLES
-- ========================
CREATE TABLE oficina_contable (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo VARCHAR(50) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA', -- ACTIVA | SUSPENDIDA
  created_at DATETIME NULL,
  updated_at DATETIME NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_oficina_codigo (codigo)
);

-- ========================
-- EMPRESAS (pertenecen a una oficina)
-- ========================
CREATE TABLE empresas (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  oficina_id BIGINT UNSIGNED NOT NULL,
  rut VARCHAR(20) NULL,
  razon_social VARCHAR(200) NULL,
  nombre_fantasia VARCHAR(200) NULL,
  giro VARCHAR(200) NULL,
  direccion VARCHAR(200) NULL,
  comuna VARCHAR(100) NULL,
  ciudad VARCHAR(100) NULL,
  region VARCHAR(100) NULL,
  pais VARCHAR(100) NULL,
  email VARCHAR(150) NULL,
  telefono VARCHAR(50) NULL,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NULL,
  updated_at DATETIME NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_empresas_rut (rut),
  KEY idx_empresas_oficina (oficina_id),
  CONSTRAINT fk_empresas_oficina
    FOREIGN KEY (oficina_id) REFERENCES oficina_contable(id)
);

-- ========================
-- PLAN DE CUENTAS (por empresa)
-- ========================
CREATE TABLE plan_cuentas (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  nivel INT NOT NULL,
  padre_id BIGINT UNSIGNED NULL,
  es_detalle TINYINT(1) NOT NULL DEFAULT 0,
  permite_mov TINYINT(1) NOT NULL DEFAULT 0,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NULL,
  updated_at DATETIME NULL,
  PRIMARY KEY (id),
  KEY idx_plan_emp (empresa_id),
  KEY idx_plan_codigo (codigo),
  CONSTRAINT fk_plan_empresas
    FOREIGN KEY (empresa_id) REFERENCES empresas(id)
);

-- ========================
-- PLAN DE CUENTAS BASE (plantilla)
-- ========================
CREATE TABLE plan_cuentas_base (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo VARCHAR(50) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  nivel INT NOT NULL,
  codigo_padre VARCHAR(50) NULL,
  es_detalle TINYINT(1) NOT NULL DEFAULT 0,
  permite_mov TINYINT(1) NOT NULL DEFAULT 0,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NULL,
  updated_at DATETIME NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_plan_base_codigo (codigo)
);

-- ========================
-- USUARIOS (MASTER_ADMIN global o usuarios por oficina)
-- ========================
CREATE TABLE usuarios (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  oficina_id BIGINT UNSIGNED NULL, -- NULL solo para MASTER_ADMIN
  username VARCHAR(100) NOT NULL,   -- ejemplo: master | admin@ofi001 | usuario@ofi001
  email VARCHAR(150) NOT NULL,
  password VARCHAR(255) NOT NULL,
  rol VARCHAR(50) NOT NULL DEFAULT 'ADMIN', -- MASTER_ADMIN | ADMIN_OFICINA | (otros futuros)
  activo TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NULL,
  updated_at DATETIME NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuarios_email (email),
  UNIQUE KEY uq_usuarios_username (username),
  KEY idx_usuarios_oficina (oficina_id),
  CONSTRAINT fk_usuarios_oficina
    FOREIGN KEY (oficina_id) REFERENCES oficina_contable(id)
);

-- ========================
-- VINCULO EMPRESA <-> USUARIO
-- (Permite que un usuario esté asociado a una o varias empresas)
-- ========================
CREATE TABLE empresa_usuarios (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  usuario_id BIGINT UNSIGNED NOT NULL,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NULL,
  updated_at DATETIME NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_emp_user (empresa_id, usuario_id),
  CONSTRAINT fk_emp_user_empresas
    FOREIGN KEY (empresa_id) REFERENCES empresas(id),
  CONSTRAINT fk_emp_user_usuarios
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- ========================
-- TABLA ASIENTOS
-- ========================
CREATE TABLE asientos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    empresa_id BIGINT UNSIGNED NOT NULL,
    fecha DATE NOT NULL,
    numero INT NOT NULL,
    tipo VARCHAR(50) DEFAULT 'DIARIO',
    glosa VARCHAR(500),
    total_debe DECIMAL(18,2) DEFAULT 0,
    total_haber DECIMAL(18,2) DEFAULT 0,
    usuario_id BIGINT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,

    FOREIGN KEY (empresa_id) REFERENCES empresas(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- ========================
-- TABLA ASIENTO DETALLE
-- ========================
CREATE TABLE asiento_detalle (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    asiento_id BIGINT UNSIGNED NOT NULL,
    cuenta_id BIGINT UNSIGNED NOT NULL,
    glosa VARCHAR(300),
    debe DECIMAL(18,2) DEFAULT 0,
    haber DECIMAL(18,2) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (asiento_id) REFERENCES asientos(id) ON DELETE CASCADE,
    FOREIGN KEY (cuenta_id) REFERENCES plan_cuentas(id)
);
