import express from 'express';
import cors from 'cors';
import UserController from "./controllers/users/users-controller.js";
import ReviewsController from "./controllers/reviews/reviews-controller.js";
import session from "express-session";
import AuthController from "./controllers/users/auth-controller.js";
import mongoose from "mongoose";
import SavedMoviesController from './controllers/saved-movies/saved-movies-controller.js';

const CONNECTION_STRING = process.env.DB_CONNECTION_STRING || 'mongodb://127.0.0.1:27017/movie';
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
UserController(app)
AuthController(app);
SavedMoviesController(app);
app.listen(process.env.PORT || 4000);