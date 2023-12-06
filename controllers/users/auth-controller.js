import * as usersDao from "./users-dao.js";

const AuthController = (app) => {
    const register = async (req, res) => {
        const newUser = await usersDao.createUser(req.body);
        console.log("newUser is" + newUser)
        if (newUser == -1) {
            console.log("GOT -1")
            res.sendStatus(403)
        } else {
            req.session["currentUser"] = newUser;
            res.json(newUser)
        }
    };


    const login = async (req, res) => {
        const username = req.body.username;
        const password = req.body.password;
        if (username && password) {
            console.log("LOGIN: going to fetch user")
            let user = await usersDao.findUserByCredentials(username, password);
            console.log("USER IS " + JSON.stringify(user))
            if (user) {
                req.session["currentUser"] = user;
                res.json(user);
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