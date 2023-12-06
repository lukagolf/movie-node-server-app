import callProcedure from "../../db/nodejs-connect/call-sql-procedure.js"
import * as fav from "../favorite-info/favorites-dao.js"

export const getAllMovies = async () => {
    const movies = await callProcedure('get_all_movies', []);
    return getDetailedMovies(movies);
}

export const getMovie = async (id) => {
    let movie = await callProcedure('get_movie', [id])
    movie = addMovieDetails(movie[0], movie[0].movie_id)
    return movie;
}

export const getMoviesByTitle = async (title) => {
    const movies = await callProcedure('get_movies_by_title', [title])
    return getDetailedMovies(movies);
}

// need to iron out logic
export const updateMovie = async (id, { title, release, summary, photo, genres }) => {
    console.log("Update movie got " + summary + " " + release + " " + photo)
    try {
        let movie = await callProcedure('update_movie', [id, title, release, summary, photo])
        callProcedure('remove_movie_genres', [id])
        for (const genre of genres) {
            callProcedure('give_movie_genre', [movie[0].movie_id, genre])
        }
        movie = {...movie[0], genres}
        return movie
    } catch (error) {
        console.error(error)
        return -1
    }
}

export const createMovie = async ({ title, release, summary, photo, genres }) => {
    try {
        const movie = await callProcedure('add_movie', [title, release, summary, photo])
        for (const genre of genres) {
            callProcedure('give_movie_genre', [movie[0].movie_id, genre])
        }
        return movie
    } catch (error) {
        console.error(error)
        return -1;
    }
}

export const deleteMovie = (id) => callProcedure('delete_movie', [id])

const getDetailedMovies = async (movies) => {
    const promises = movies.map((movie) => addMovieDetails(movie, movie.movie_id))
    const detailedMovies = await Promise.allSettled(promises)
    return detailedMovies
        .filter(promise => promise.status === 'fulfilled')
        .map(result => result.value)

}

const addMovieDetails = async (movie, id) => {
    let favorites = await fav.getMovieFavorites(id)
    favorites = favorites.map(f => f.username)
    let genres
    try {
        genres = await callProcedure('get_movie_genres', [id])
    } catch (error) {
        console.error(error)
    }
    genres = genres.map(g => g.genre_name)
    return {...movie, favorites, genres}
}