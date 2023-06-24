import express from 'express';
import cors from 'cors';
import UserController from "./controllers/users/users-controller.js";
import ReviewsController from "./controllers/reviews/reviews-controller.js";
import session from "express-session";
import AuthController from "./controllers/users/auth-controller.js";
import mongoose from "mongoose";
import MongoStore from "connect-mongo";
import { config as dotenvConfig } from 'dotenv';

dotenvConfig();

const CONNECTION_STRING = process.env.DB_CONNECTION_STRING /* || 'mongodb://127.0.0.1:27017/movie'; */ // now everything is remote
mongoose.connect(CONNECTION_STRING);

const app = express();

app.use(
    cors({
        credentials: true,
        origin: "http://localhost:3000",
    })
);

app.use(
    session({
        secret: "any string",
        resave: false,
        saveUninitialized: true,
        rolling: true,
        cookie: {
            sameSite: 'none', // the important part
            secure: false, // the important part, changed for local testing
            maxAge: 24 * 60 * 60 * 1000, // 1 day
        },
        store: MongoStore.create({
            mongoUrl: CONNECTION_STRING,
            ttl: 14 * 24 * 60 * 60 // = 14 days. Default
        })
    })
);

app.use(express.json());
ReviewsController(app);
UserController(app)
AuthController(app);
app.listen(process.env.PORT || 4000);