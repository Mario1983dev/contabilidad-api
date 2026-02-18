import express from "express";
import cors from "cors";
import mysql from "mysql2/promise";
import dotenv from "dotenv";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
});

app.get("/api/health", async (req, res) => {
  const [rows] = await pool.query("SELECT 1 as ok");
  res.json({ ok: true, db: rows[0]?.ok === 1 });
});

app.get("/api/empresas", async (req, res) => {
  const [rows] = await pool.query(
    "SELECT id, razon_social FROM empresas ORDER BY razon_social"
  );
  res.json(rows);
});

app.post("/api/auth/login", async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password)
      return res.status(400).json({ error: "Datos incompletos" });

    // Buscar usuario
    const [users] = await pool.query(
      `SELECT id, username, rol
       FROM usuarios
       WHERE username=? AND password=? AND activo=1`,
      [username, password]
    );

    if (users.length === 0)
      return res.status(401).json({ error: "Credenciales incorrectas" });

    const user = users[0];

    // Empresas asociadas al usuario
    const [empresas] = await pool.query(
      `SELECT e.id, e.razon_social
       FROM empresas e
       JOIN empresa_usuarios eu ON eu.empresa_id = e.id
       WHERE eu.usuario_id = ?`,
      [user.id]
    );

    res.json({
      ok: true,
      user,
      empresas,
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error servidor" });
  }
});


app.listen(process.env.PORT || 3000, () => {
  console.log(`API lista en http://localhost:${process.env.PORT || 3000}`);
});
