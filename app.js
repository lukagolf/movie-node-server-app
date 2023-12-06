import express from 'express';
import cors from 'cors';
import UserController from "./controllers/users/users-controller.js";
import ReviewsController from "./controllers/reviews/reviews-controller.js";
import ReportsController from "./controllers/reports/reports-controller.js";
import MoviesController from "./controllers/movies/movies-controller.js";
import GenresController from './controllers/genres/genres-controller.js';
import session from "express-session";
import AuthController from "./controllers/users/auth-controller.js";
import { config as dotenvConfig } from 'dotenv';
import MySQLSession from 'express-mysql-session'

dotenvConfig();
const app = express();

const MySQLStore = MySQLSession(session);

const options = {
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: 'root',
    database: 'moviesite',
    clearExpired: true,
    checkExpirationInterval: 900000, // How frequently expired sessions will be cleared in ms.
    expiration: 86400000, // Max age of valid session in ms.
};

const sessionStore = new MySQLStore(options);


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
        store: sessionStore
    })
);

app.use(express.json());
ReviewsController(app);
UserController(app)
AuthController(app);
ReportsController(app);
GenresController(app);
MoviesController(app);
app.listen(process.env.PORT || 4000);
