import * as savedMoviesDao from './saved-movies-dao.js';

const createSavedMovie = async (req, res) => {
    const userAndMovie = req.body;
    console.log(req.body);
    const movies = await savedMoviesDao.findSavedMovies(userAndMovie.userId);

    if (!movies.find((savedMovie) => savedMovie.userId === userAndMovie.userId && savedMovie.id === userAndMovie.id)) {
      const insertedMovie = await savedMoviesDao.createSavedMovie(userAndMovie);
      res.json(insertedMovie);
    } else {
      res.sendStatus(403);
    }
}

const deleteSavedMovie = async (req, res) => {
    const userAndMovie = req.body;
    const status = await savedMoviesDao.deleteSavedMovie(userAndMovie);
    res.json(status);
}

const findAllSavedMovies = async (req, res) => {
    const userId = req.params.uid;
    const movies = await savedMoviesDao.findSavedMovies(userId);
    const userMovies = movies.filter(movie => movie.userId === userId);
    res.json(userMovies);
}

// const findSavedMovieById = async (req, res) => {
//     const mid = req.params.mid;
//     const movies = await savedMoviesDao.findSavedMovies();
//     const movie = movies.find(movie => movie.id === mid);
//     res.json(movie);
// }

export default (app)=> {
    app.post('/api/saved-movies', createSavedMovie);
    app.delete('/api/saved-movies', deleteSavedMovie);
    app.get('/api/saved-movies/:uid', findAllSavedMovies);
    // app.get('/api/saved-movies/:mid', findSavedMovieById);
}