import express from 'express';
import cors from 'cors';
import UserController from "./controllers/users/users-controller.js";
import ReviewsController from "./controllers/reviews/reviews-controller.js";
import ReportsController from "./controllers/reports/reports-controller.js";
import MoviesController from "./controllers/movies/movies-controller.js";
import session from "express-session";
import AuthController from "./controllers/users/auth-controller.js";
import { config as dotenvConfig } from 'dotenv';

dotenvConfig();
const app = express();

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
ReportsController(app);
MoviesController(app);
app.listen(process.env.PORT || 4000);
