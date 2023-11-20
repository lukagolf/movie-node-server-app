import * as usersDao from "./users-dao.js";

const AuthController = (app) => {
    const register = async (req, res) => {
        console.log(req.body);
        try {
            await usersDao.createUser(req.body);
            const newUser = await usersDao.findUserByUsername(req.body.username)
            req.session["currentUser"] = newUser;
            res.json(newUser);
        } catch (error) {
            res.sendStatus(403)
        }
    };


    const login = async (req, res) => {
        const username = req.body.username;
        const password = req.body.password;
        if (username && password) {
            console.log("LOGIN: going to fetch user")
            const user = await usersDao.findUserByCredentials(username, password);
            console.log("USER IS " + JSON.stringify(user))
            if (user) {
                req.session["currentUser"] = user;
                res.json(user[0]);
            } else {
                res.sendStatus(403);
            }
        } else {
            res.sendStatus(403);
        }
    };


    const profile = (req, res) => {
        const currentUser = req.session["currentUser"];
        if (!currentUser) {
            res.sendStatus(404);
            return;
        }
        res.json(currentUser);
    };

    const logout = async (req, res) => {
        delete req.session
        res.sendStatus(200);
    };

    app.post("/api/users/register", register);
    app.post("/api/users/login", login);
    app.post("/api/users/profile", profile);
    app.post("/api/users/logout", logout);
};
export default AuthController;