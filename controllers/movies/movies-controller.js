import * as moviesDao from "./movies-dao.js";


const updateMovie = async (req, res) => {
    const id = req.params.id
    const status = await moviesDao.updateMovie(id, req.body);
    res.json(status);
};

const deleteMovie = async (req, res) => {
    const id = req.params.id
    const status = await moviesDao.deleteMovie(id);
    res.json(status);
};

// might be problem that server doesn't return movie
const createMovie = async (req, res) => {
    let movie = tMDBToDBFormat(req.body)
    const status = await moviesDao.createMovie(movie);
    if (status == -1) {
        res.sendStatus(409)
    } else {
        res.json(status)
    }
};

const findAllMovies = async (req, res) => {
    const movies = await moviesDao.getAllMovies();
    if (movies.length === 0) {
        res.JSON(null)
    } else if (movies) {
        res.json(movies)
    } else {
        res.sendStatus(404)
    }
};

const findMoviesByTitle = async (req, res) => {
    const title = req.params.title
    const movies = await moviesDao.getMoviesByTitle(title);
    if (movies.length === 0) {
        res.json(null)
    } else if (movies) {
        res.json(movies)
    } else {
        res.sendStatus(404)
    }
};

const findSpecificMovie = async (req, res) => {
    console.log("FIND SPECIFIC MOVIE")
    const id = req.params.id
    const movie = await moviesDao.getMovie(id);
    if (movie) {
        res.json(movie)
    } else {
        res.sendStatus(404)
    }
};

// const getFavMovies = async (req, res) => {
//     const user = req.params.username
//     const movies = await moviesDao.getNumFavorites(user);
//     if (movies) {
//         res.json(movies)
//     } else {
//         res.sendStatus(404)
//     }
// };


/* Update this so movie matches format of API being pulled from
 * Currently
 */
const tMDBToDBFormat = (tMDBMovie) => {
    console.log("THE POSTER PATH IS " + tMDBMovie.poster_path)
    const PHOTO_URL = 'https://image.tmdb.org/t/p/w440_and_h660_face';
    return {
        title: tMDBMovie.title,
        summary: tMDBMovie.overview,
        release: tMDBMovie.release_date,
        photo: `${PHOTO_URL}${tMDBMovie.poster_path}`,
        genres: tMDBMovie.genres
    }
}

const MoviesController = (app) => {
    app.post("/api/movies/", createMovie);
    app.get("/api/movies/", findAllMovies);
    app.get("/api/movies/:id", findSpecificMovie);
    // app.get("/api/movies/favorites/:username", getFavMovies);
    app.get("/api/movies/search/:title", findMoviesByTitle);
    app.put("/api/movies/:id", updateMovie);
    app.delete("/api/movies/:id", deleteMovie);
};
export default MoviesController;