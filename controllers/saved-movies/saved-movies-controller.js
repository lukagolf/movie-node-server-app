import * as savedMoviesDao from './saved-movies-dao.js';

const createSavedMovie = async (req, res) => {
    const movie = req.body;
    const insertedMovie = await savedMoviesDao.createSavedMovie(movie);
    res.json(insertedMovie); // movie
}

const deleteSavedMovie = async (req, res) => {
    const mid = req.params.mid;
    const status = await savedMoviesDao.deleteSavedMovie(mid);
    res.json(status);
}

const findAllSavedMovies = async (req, res) => {
    const movies = await savedMoviesDao.findSavedMovies();
    res.json(movies);
}

const findSavedMovieById = async (req, res) => {
    const mid = req.params.mid;
    const movies = await savedMoviesDao.findSavedMovies();
    const movie = movies.find(movie => movie.mid === mid);
    res.json(movie);
}

export default (app)=> {
    app.post('/api/saved-movies', createSavedMovie);
    app.delete('/api/saved-movies/:mid', deleteSavedMovie);
    app.get('/api/saved-movies', findAllSavedMovies);
    app.get('/api/saved-movies/:mid', findSavedMovieById);
}