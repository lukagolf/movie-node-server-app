import mongoose from "mongoose";
import savedMoviesSchema from "./saved-movies-schema.js";

const savedMoviesModel = mongoose.model("SavedMoviesModel", savedMoviesSchema);

export default savedMoviesModel;