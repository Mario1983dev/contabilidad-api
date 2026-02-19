# Scripts SQL - Contabilidad (Multi-Oficina)

## Modelo (resumen)
- MASTER_ADMIN (global) crea y administra OFICINAS CONTABLES
- Cada oficina contable tiene sus empresas y usuarios
- Formato de usuario recomendado: `admin@<codigo_oficina>` (ej: `admin@ofi001`)

## Orden recomendado
1. 00_reset_db.sql (DROP + CREATE + USE)
2. 01_tables.sql
3. 02_seed_plan_base.sql
4. 03_seed_empresa_demo.sql
5. 04_copy_plan_to_empresa.sql
6. 05_seed_admin_user.sql
7. 06_verify.sql

## Ejecución rápida (cliente mysql)
```bash
mysql -u root -p < run_all_mysqlclient.sql
```

## Datos demo creados
- Oficina demo: codigo `ofi001`
- Empresa demo: rut `11111111-1`
- Usuario master: `master` / `master`
- Admin oficina: `admin@ofi001` / `admin`
