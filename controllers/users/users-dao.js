import callProcedure from "../../db/nodejs-connect/call-sql-procedure.js"
import * as favorites from "../favorite-info/favorites-dao.js"

export const findAllUsers = () => callProcedure('get_all_users', [])

export const findUserByUsername =  async (username) => { 
    try {
        let user = await callProcedure('get_by_username', [username]);
        user = await addExtraUserFields(user[0], username)
        return user;
    } catch (error) {
        console.log(error)
    }
}

// will need to pass like 7 params instead, destructuring syntax
export const createUser = ({
    username,
    password,
    email,
    firstName,
    lastName,
    roles
}) => {
    const role1 = roles[0]
    const role2 = roles[1]
    callProcedure('add_user', [
        username,
        password,
        email,
        role1,
        role2,
        firstName,
        lastName
      ]
    )
    return findUserByUsername(username);
}

// will need to pass like 7 params instead, destructuring syntax
export const updateUser = (u_name, {
    username,
    password,
    email,
    firstName,
    lastName,
    roles
}) => {
    const role1 = roles[0]
    const role2 = roles[1]
    callProcedure('update_user', [
        username,
        password,
        email,
        role1,
        role2,
        firstName,
        lastName
    ])
    return findUserByUsername(username);
};

export const deleteUser = (username) => callProcedure('delete_user', [username]);

export const getUserFollows = (username) => callProcedure('get_following', [username]);

export const getUserFollowers = (username) => callProcedure('get_followers', [username]);

export const findUserByCredentials = async (username, password) => {
    try {
        let user = await callProcedure('get_by_login', [username, password])
        console.log("LOGIN DAO GOT " + JSON.stringify(user))
        user = await addExtraUserFields(user[0], username)
        console.log("LOGIN DAO IS RETURNING" + JSON.stringify(user))
        return user;
    } catch (error) {
        console.log(error)
    }
}

export const addFollow = (follower, followee) => callProcedure('follows_user', [follower, followee])

export const unFollow = (follower, followee) => callProcedure('unfollow_user', [follower, followee])

// Adds fields that frontend is expecting to user object
const addExtraUserFields = async (user, username) => {
    const savedMovies = await favorites.getFavMovies(username);
    const followedCritics = await callProcedure('get_following', [username]); 
    console.log("RETRIEVED USER: " + JSON.stringify(user))
    user = {...user, followedCritics, savedMovies, "roles": [user.role1, user.role2]}
    return user;
}