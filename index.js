import express from "express";
import cors from "cors";
import mysql from "mysql2/promise";
import dotenv from "dotenv";
import jwt from "jsonwebtoken";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// ============================
// 🔐 Middleware JWT
// ============================
function auth(req, res, next) {
  const header = req.headers.authorization || "";
  const token = header.startsWith("Bearer ") ? header.slice(7) : null;

  if (!token) return res.status(401).json({ error: "Falta token" });

  try {
    req.user = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch {
    return res.status(401).json({ error: "Token inválido" });
  }
}

// ============================
// 🗄️ Conexión MySQL
// ============================
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
});

// ============================
// 🧪 Health DB
// ============================
app.get("/api/health", async (req, res) => {
  const [rows] = await pool.query("SELECT 1 as ok");
  res.json({ ok: true, db: rows[0]?.ok === 1 });
});

// ============================
// 🔐 LOGIN (JWT)
// ============================
app.post("/api/auth/login", async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password)
      return res.status(400).json({ error: "Datos incompletos" });

    const [users] = await pool.query(
      `SELECT id, username, rol
       FROM usuarios
       WHERE username=? AND password=? AND activo=1
       LIMIT 1`,
      [username, password]
    );

    if (users.length === 0)
      return res.status(401).json({ error: "Credenciales incorrectas" });

    const user = users[0];

    const payload = {
      userId: user.id,
      username: user.username,
      rol: user.rol,
    };

    const accessToken = jwt.sign(payload, process.env.JWT_SECRET, {
      expiresIn: process.env.JWT_EXPIRES_IN || "30m",
    });

    res.json({
      ok: true,
      accessToken,
      user: payload,
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error servidor" });
  }
});

// ============================
// 🔐 VALIDAR TOKEN
// ============================
app.get("/api/auth/me", auth, (req, res) => {
  res.json({ ok: true, user: req.user });
});

// ============================
// 🔐 EMPRESAS PROTEGIDAS
// ============================
app.get("/api/empresas", auth, async (req, res) => {
  const userId = req.user.userId;

  const [rows] = await pool.query(
    `SELECT e.id, e.razon_social
     FROM empresas e
     JOIN empresa_usuarios eu ON eu.empresa_id = e.id
     WHERE eu.usuario_id = ?
     ORDER BY e.razon_social`,
    [userId]
  );

  res.json(rows);
});

// ============================
// 🔎 Health simple
// ============================
app.get("/health", (req, res) => {
  res.json({ status: "ok", message: "API funcionando" });
});

// ============================
// 🚀 Start server
// ============================
app.listen(process.env.PORT || 3000, () => {
  console.log(`API lista en http://localhost:${process.env.PORT || 3000}`);
});
