import * as moviesDao from "./movies-dao.js";


const updateMovie = async (req, res) => {
    let movie = tMDBToDBFormat(req.body)
    const id = req.params.id
    const newMovie = await moviesDao.updateMovie(id, movie);
    if (newMovie == -1) {
        res.sendStatus(409)
    } else {
        res.json(newMovie)
    }
};

const deleteMovie = async (req, res) => {
    const id = req.params.id
    const status = await moviesDao.deleteMovie(id);
    res.json(status);
};

const createMovie = async (req, res) => {
    console.log("MOVIE TO CREATE " + JSON.stringify(req.body))
    let movie = tMDBToDBFormat(req.body)
    console.log("MOVIE TO CREATE " + JSON.stringify(movie))
    const newMovie = await moviesDao.createMovie(movie);
    if (newMovie == -1) {
        res.sendStatus(409)
    } else {
        res.json(newMovie)
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
    const id = req.params.id
    const movie = await moviesDao.getMovie(id);
    if (movie) {
        res.json(movie)
    } else {
        res.sendStatus(404)
    }
};

/* Update this so movie matches format of API being pulled from
 * Currently
 */
const tMDBToDBFormat = (tMDBMovie) => {
    return {
        title: tMDBMovie.title,
        summary: tMDBMovie.overview,
        release: tMDBMovie.release_date,
        photo: tMDBMovie.poster_path,
        genres: tMDBMovie.genres
    }
}

const MoviesController = (app) => {
    app.post("/api/movies/", createMovie);
    app.get("/api/movies/", findAllMovies);
    app.get("/api/movies/:id", findSpecificMovie);
    app.get("/api/movies/search/:title", findMoviesByTitle);
    app.put("/api/movies/:id", updateMovie);
    app.delete("/api/movies/:id", deleteMovie);
};
export default MoviesController;