import * as usersDao from "./users-dao.js";

const UserController = (app) => {
    app.get('/api/users', findAllUsers);
    app.get('/api/users/:username', findUser);
    // app.get('/api/users/favorites/:movieid', getFavoritingUsers)
    app.post('/api/users/register', createUser);
    app.put('/api/users/save/:username/:movie_id', saveMovie);
    app.put('/api/users/unsave/:username/:movie_id', unsaveMovie);
    app.put('/api/users/:username', updateUser);
    app.delete('/api/users/:username', deleteUser)
    app.get('/api/users/follows/:username', getFollowedCritics)
    app.get('/api/users/followers/:username', getFollowers)
    app.post('/api/users/follows/:viewer/:critic', addFollow)
    app.delete('/api/users/follows/:viewer/:critic', removeFollow)
}

const getFollowedCritics = async (req, res) => {
    console.log("Get followed request")
    const { username } = req.params
    const followedCritics = await usersDao.getUserFollows(username)
    console.log("Returning " + JSON.stringify(followedCritics))
    res.json(followedCritics)
}

const getFollowers = async (req, res) => {
    const { username } = req.params
    const followers = await usersDao.getUserFollowers(username)
    res.json(followers)
}

const addFollow = async (req, res) => {
    const { viewer, critic } = req.params
    const status = await usersDao.addFollow(viewer, critic)
    res.json(status)
}

const removeFollow = async (req, res) => {
    const { viewer, critic } = req.params
    console.log("Critic is " + critic)
    const status = await usersDao.unFollow(viewer, critic)
    res.json(status)
}


const saveMovie = async (req, res) => {
    const { username, movie_id } = req.params
    const status = usersDao.saveMovie(username, movie_id)
    res.json(status)
}

const unsaveMovie = async (req, res) => {
    const { username, movie_id } = req.params
    const status = usersDao.unsaveMovie(username, movie_id)
    res.json(status)
}

const updateUser = async (req, res) => {
    const username = req.params.username;
    const user = await usersDao.updateUser(username, req.body);
    req.session["currentUser"] = user;
    res.json(user);
};

const deleteUser = async (req, res) => {
    const id = req.params.username;
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