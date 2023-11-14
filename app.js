import express from 'express';
import callProcedure from './call-sql-procedure.js'
import cors from 'cors';
import UserController from "./controllers/users/users-controller.js";
import ReviewsController from "./controllers/reviews/reviews-controller.js";
import session from "express-session";
import AuthController from "./controllers/users/auth-controller.js";
import { config as dotenvConfig } from 'dotenv';

dotenvConfig();
const app = express();

/* 
 * first: npm install mysql
 *
 * NOTE:In order to get this to work, you may need to run the 
 * following two queries in MySQL:
 * ALTER USER '[YOUR USERNAME]'@'localhost' IDENTIFIED WITH mysql_native_password BY '[YOUR PASSWORD]';
 * flush privileges;
 *
 */


// let args = ['mgb132', 'p', 'e4', 'Viewer', null, 'mel', 'ba']
const results = callProcedure('get_all_users', [],
                               results => console.log(results),
                               error => console.log(error))
app.use(express.json());
ReviewsController(app);
UserController(app)
AuthController(app);
app.listen(process.env.PORT || 4000);
