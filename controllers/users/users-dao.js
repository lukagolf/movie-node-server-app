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
export const createUser = async ({
    username,
    password,
    email,
    firstName,
    lastName,
    roles
}) => {
    const role1 = roles[0]
    const role2 = roles[1]
    try {
        let user = await callProcedure('add_user', [
            username,
            password,
            email,
            role1,
            role2,
            firstName,
            lastName
        ]
        )
    } catch (error) {
        return -1;
    }
    return findUserByUsername(username);
}

// will need to pass like 7 params instead, destructuring syntax
export const updateUser = async (u_name, {
    username,
    pword,
    email,
    firstname,
    lastname,
    roles
}) => {
    let role1 = roles[0]
    const role2 = roles[1]
    if (!role1) {
        role1 = role2
        role2 = null
    }
    try {
        let user = await callProcedure('update_user', [
            u_name,
            username,
            pword,
            email,
            role1,
            role2,
            firstname,
            lastname
        ])
    } catch (error) {
        return -1
    }
    return findUserByUsername(username);
};

export const deleteUser = (username) => {
    console.log("going to delete user with " + username)
    callProcedure('delete_user', [username]);
}

// for critics a user is following
export const getUserFollows = async (username) => {
    const following = await callProcedure('get_following', [username]);
    return following.map(critic => critic.followed_id)
}

// for viewers following a critic
export const getUserFollowers = async (username) => {
    const followers = await callProcedure('get_followers', [username]);
    return followers.map(viewer => viewer.follower_id)
}

export const findUserByCredentials = async (username, password) => {
    try {
        let user = await callProcedure('get_by_login', [username, password])
        user = await addExtraUserFields(user[0], username)
        return user;
    } catch (error) {
        console.log(error)
    }
}

export const addFollow = (follower, followee) => callProcedure('follows_user', [follower, followee])

export const unFollow = (follower, followee) => callProcedure('unfollow_user', [follower, followee])

export const saveMovie = (username, movie_id) => callProcedure('favorite_movie', [username, movie_id])

export const unsaveMovie = (username, movie_id) => callProcedure('unfavorite_movie', [username, movie_id])


// Adds fields that frontend is expecting to user object
const addExtraUserFields = async (user, username) => {
    const savedMovies = await favorites.getFavMovies(username);
    const followedCritics = await callProcedure('get_following', [username]); 
    user = {...user, followedCritics, savedMovies, "roles": [user.role1, user.role2]}
    return user;
}