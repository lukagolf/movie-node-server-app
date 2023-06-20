import savedMoviesModel from "./saved-movies-model.js";

export const findSavedMovies = (uid) => savedMoviesModel.find({userId: uid});
export const createSavedMovie = (userAndMovie) => savedMoviesModel.create(userAndMovie);
export const deleteSavedMovie = (userAndMovie) => savedMoviesModel.deleteOne(userAndMovie);