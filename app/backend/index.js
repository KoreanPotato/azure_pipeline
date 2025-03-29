const express = require("express");
const cors = require("cors");
const path = require("path");
const router = require("./routes/mainRoute")


const app = express();
const PORT = 3001;

app.use(cors()); // использую cors, так как бек и фронт на разных портах
app.use(express.json()); // парсим JSON из body


app.use("/api", router);

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
