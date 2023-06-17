import savedMoviesModel from "./saved-movies-model.js";

export const findSavedMovies = () => savedMoviesModel.find();
export const createSavedMovie = (movie) => savedMoviesModel.create(movie);
export const deleteSavedMovie = (mid) => savedMoviesModel.deleteOne({id: mid});