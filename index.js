const express = require("express");
// const { MongoClient, ServerApiVersion } = require("mongodb");
// const dotenv = require("dotenv");
// dotenv.config();

const app = express();
const port = 3000;

// const client = new MongoClient(process.env.MONGODB_URI);

// client.on("error", (error) => {
//   console.error("MongoDB connection error:", error);
// });

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.get("/api", async (req, res) => {
  try {
    // const db = client.db("pingHer");
    // const collection = db.collection("pinger");
    // collection.find({}).toArray(function (err, result) {
    //   if (err) throw err;
    //   console.log(result);
    //   res.send(result);
    // });
    return res.send(["https://hangman-db4p.onrender.com"]);
  } catch (error) {
    console.log(error);
    res.send(error);
  }
});

app.listen(port, async () => {
  //   await client.connect();
  //   client.on("connectionReady", () => {
  //     console.log("MongoDB connected!");
  //   });
  console.log(`Example app listening at http://localhost:${port}`);
});
