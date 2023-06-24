import posts from "./movies.js";
let movies = posts;

const findMovies = (res) => {
    res.json(movies);
}

export default (app) => {
    app.get('/api/search', findMovies);
}
