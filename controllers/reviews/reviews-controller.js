import * as reviewsDao from './reviews-dao.js'

const createReview = async (req, res) => {
    const newReview = req.body;
    // Ensure the required fields are provided
    if (!newReview.movie_id || !newReview.critic_id || !newReview.title || !newReview.rating || !newReview.review_text) {
        res.status(400).json({ message: 'Missing required fields.' });
        return;
    }
    if (!newReview.date_reviewed) {
        newReview.date_reviewed = new Date().toISOString().slice(0, 19).replace('T', ' ')
    }
    try {
        let insertedReview = await reviewsDao.createReview(newReview);
        insertedReview = {...insertedReview[0], likes: [], dislikes: []}
        res.json(insertedReview);
    } catch (error) {
        console.log(error)
        res.sendStatus(409)
    }
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

const likeReview = async (req, res) => {
    const {username, rid} = req.params
    const status = await reviewsDao.likeReview(rid, username)
    res.json(status)
}

const unlikeReview = async (req, res) => {
    const {username, rid} = req.params
    const status = await reviewsDao.unlikeReview(rid, username)
    res.json(status)
}


const dislikeReview = async (req, res) => {
    const {username, rid} = req.params
    const status = await reviewsDao.dislikeReview(rid, username)
    res.json(status)
}

const undislikeReview = async (req, res) => {
    const {username, rid} = req.params
    const status = await reviewsDao.undislikeReview(rid, username)
    res.json(status)
}


export default (app) => {
    app.post('/api/reviews',createReview);
    app.get('/api/reviews', findReviews);
    app.get('/api/reviews/findCriticReviews/:username', findCriticReviews);
    app.get('/api/reviews/findMovieReviews/:movieId', findMovieReviews);
    app.put('/api/reviews/:rid', updateReview);
    app.put('/api/reviews/like/:rid/:username', likeReview);
    app.put('/api/reviews/dislike/:rid/:username', dislikeReview);
    app.put('/api/reviews/unlike/:rid/:username', unlikeReview);
    app.put('/api/reviews/undislike/:rid/:username', undislikeReview);
    app.delete('/api/reviews/:rid', deleteReview);
}
