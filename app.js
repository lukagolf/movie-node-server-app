import express from 'express';
import cors from 'cors';
import HelloController from "./controllers/hello-controller.js";
import UserController from "./users/users-controller.js";
import ReviewsController from "./controllers/reviews/reviews-controller.js";
import session from "express-session";
import AuthController from "./users/auth-controller.js";
import mongoose from "mongoose";
import { config as dotenvConfig } from 'dotenv';

dotenvConfig();

const CONNECTION_STRING = process.env.DB_CONNECTION_STRING /* || 'mongodb://127.0.0.1:27017/movie'; */ // now everything is remote
mongoose.connect(CONNECTION_STRING);

const app = express();
app.use(
    session({
        secret: "any string",
        resave: false,
        saveUninitialized: true,
    })
);
app.use(
    cors({
        credentials: true,
        origin: "http://localhost:3000",
    })
);
app.use(express.json());
ReviewsController(app);
HelloController(app)
UserController(app)
AuthController(app);
app.listen(process.env.PORT || 4000);