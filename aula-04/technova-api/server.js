const express = require("express");
const os = require("os");

const app = express();
const PORT = 3000;

app.use(express.json());

app.get("/", (req, res) => {
  res.json({
    message: "TechNova API - Aula 04 Multi-AZ",
    status: "running",
    hostname: os.hostname(),
    environment: "AWS EC2"
  });
});

app.get("/health", (req, res) => {
  res.json({
    status: "healthy",
    service: "technova-api",
    timestamp: new Date().toISOString()
  });
});

app.get("/orders", (req, res) => {
  res.json({
    orders: [
      { id: 1, product: "Notebook Pro", status: "delivered" },
      { id: 2, product: "Monitor 4K", status: "processing" },
      { id: 3, product: "Teclado Mecânico", status: "shipped" }
    ]
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`TechNova API rodando na porta ${PORT}`);
});
