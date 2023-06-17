import express from 'express';
import cors from 'cors';
import HelloController from "./controllers/hello-controller.js";
import UserController from "./users/users-controller.js";
import ReviewsController from "./controllers/reviews/reviews-controller.js";
import session from "express-session";
import AuthController from "./users/auth-controller.js";
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

app.use((req, res, next) => {
    console.log('Session ID:', req.sessionID);
    next();
});

app.use((req, res, next) => {
    console.log('Session data:', req.session);
    next();
});

app.use(express.json());
ReviewsController(app);
HelloController(app)
UserController(app)
AuthController(app);
app.listen(process.env.PORT || 4000);
