import * as reviewsDao from './reviews-dao.js'

// const createReview = async (req, res) => {
//     const newReview = req.body;
//     console.log(newReview);
//     newReview.movieId = '';
//     newReview.username = '';
//     newReview.title = '';
//     newReview.rating = 0;
//     newReview.description = '';

//     const insertedReview = await reviewsDao.createReview(newReview);
//     res.json(insertedReview);
// }
const createReview = async (req, res) => {
    const newReview = req.body;
    console.log(newReview);

    // Ensure the required fields are provided
    if (!newReview.movieId || !newReview.username || !newReview.title || !newReview.rating || !newReview.description) {
        res.status(400).json({ message: 'Missing required fields.' });
        return;
    }

    const insertedReview = await reviewsDao.createReview(newReview);
    res.json(insertedReview);
}


const findReviews = async (req, res) => {
    const reviews = await reviewsDao.findReviews();
    res.json(reviews);
}

const findCriticReviews = async (req, res) => {
    const criticUsername = req.params.username;
    const reviews = await reviewsDao.findCriticReviews(criticUsername);
    res.json(reviews);
}

const findMovieReviews = async (req, res) => {
    const mid = req.params.movieId;
    const reviews = await reviewsDao.findMovieReviews(mid);
    res.json(reviews);
}

const updateReview = async (req, res) => {
    const reviewIdToUpdate = req.params.rid;
    const updates = req.body;
    const status = await reviewsDao.updateReview(reviewIdToUpdate, updates);
    res.json(status);
}

const deleteReview = async (req, res) => {
    const reviewIdToDelete = req.params.rid;
    const status = await reviewsDao.deleteReview(reviewIdToDelete);
    res.json(status);
}

export default (app) => {
    app.post('/api/reviews', createReview);
    app.get('/api/reviews', findReviews);
    app.get('/api/reviews/findCriticReviews/:username', findCriticReviews);
    app.get('/api/reviews/findMovieReviews/:movieId', findMovieReviews);
    app.put('/api/reviews/:rid', updateReview);
    app.delete('/api/reviews/:rid', deleteReview);
}
