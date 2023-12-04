import callProcedure from "../../db/nodejs-connect/call-sql-procedure.js"

// get list of users who favorited the specified movie
export const getMovieFavorites = (movieid) => callProcedure('get_favoriting_users', [movieid])

// get list of a user's favorite movies
export const getFavMovies = (username) => callProcedure('get_favorite_movies', [username])