import * as genresDao from './genres-dao.js'

const findAllGenres = async (req, res) => {
  const response = await genresDao.findMovieGenres();
  res.json(response);
}

const GenresController = (app) => {
  app.get("/api/genres/", findAllGenres);
};
export default GenresController;