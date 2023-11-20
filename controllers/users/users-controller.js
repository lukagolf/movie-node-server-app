import * as usersDao from "./users-dao.js";

const UserController = (app) => {
    app.get('/api/users', findAllUsers);
    app.get('/api/users/:username', findUser);
    // app.get('/api/users/favorites/:movieid', getFavoritingUsers)
    app.post('/api/users', createUser);
    app.delete('/api/users/:username', deleteUser);
    app.put('/api/users/:username', updateUser);
}

const updateUser = async (req, res) => {
    const id = req.params.username;
    const status = await usersDao.updateUser(username, req.body);
    req.session["currentUser"] = user;
    res.json(status);
};

const deleteUser = async (req, res) => {
    const id = req.params.id;
    const status = await usersDao.deleteUser(id);
    res.json(status);
};

const createUser = async (req, res) => {
    const newUser = await usersDao.createUser(req.body);
    res.json(newUser);
};

const findAllUsers = async (req, res) => {
    const username = req.query.username;
    const password = req.query.password;
    if (username && password) {
        const user = await usersDao.findUserByCredentials(username, password);
        if (user) {
            res.json(user);
        } else {
            res.sendStatus(404);
        }
    } else if (username) {
        const user = await usersDao.findUserByUsername(username);
        if (user) {
            res.json(user);
        } else {
            res.sendStatus(404);
        }
    } else {
        const users = await usersDao.findAllUsers();
        res.json(users);
    }
};

const findUser = async (req, res) => {
    const username = req.params.username;
    let user = await usersDao.findUserByUsername(username)
    if (user) {
        console.log("RETURNING FROM CONTROLLER: " + JSON.stringify(user))
        res.json(user);
    } else {
        res.sendStatus(404);
    }
};

// const getFavoritingUsers = async (req, res) => {
//     const movie = req.params.movieid;
//     let users = await usersDao.favoritingUsers(username)
//     if (users) {
//         res.json(users);
//     } else {
//         res.sendStatus(404);
//     }
// };

export default UserController