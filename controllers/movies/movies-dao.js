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
export const updateMovie = (id, { title, release, summary, photo }) =>
        callProcedure('update_movie', [id, title, release, summary, photo])

export const createMovie = async ({ title, release, summary, photo, genres }) => {
    try {
        const movie = await callProcedure('add_movie', [title, release, summary, photo])
        for (const genre of genres) {
            callProcedure('give_movie_genre', [movie[0].movie_id, genre])
        }
    } catch (error) {
        return -1;
    }
}

export const deleteMovie = (id) => callProcedure('delete_movie', [id])

const getDetailedMovies = (movies) => {
    const promises = movies.map((movie) => addMovieDetails(movie, movie.movie_id))
    return Promise.all(promises)
}

const addMovieDetails = async (movie, id) => {
    let favorites = await fav.getMovieFavorites(id)
    favorites = favorites.map(f => f.username)
    let genres = await callProcedure('get_movie_genres', [id])
    genres = genres.map(g => g.genre_name)
    return {...movie, favorites, genres}
}