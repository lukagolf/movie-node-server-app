import callProcedure from "../../db/nodejs-connect/call-sql-procedure.js"

export const findMovieGenres = async () => {
  let genres = await callProcedure('get_all_genres')
  genres = genres.map(g => g.genre_name)
  return genres;
}