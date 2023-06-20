import mongoose from "mongoose";

const schema = mongoose.Schema({
  userId: String,
  id: Number,
  genre_ids: Array,
  original_language: String,
  original_title: String,
  overview: String,
  popularity: Number,
  backdrop_path: String,
  poster_path: String,
  release_date: String,
  title: String,
  video: Boolean,
  vote_average: Number,
  vote_count: Number,
  adult: Boolean
}, {collection: 'savedMovies'});
export default schema;