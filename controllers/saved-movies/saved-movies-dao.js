import savedMoviesModel from "./saved-movies-model.js";

export const findSavedMovies = (uid) => savedMoviesModel.find({userId: uid});
export const createSavedMovie = (movie) => savedMoviesModel.create(movie);
export const deleteSavedMovie = (mid) => savedMoviesModel.deleteOne({id: mid});