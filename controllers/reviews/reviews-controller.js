import posts from "./reviews.js";
let reviews = posts;

const createReview = (req, res) => {
    const newReview = req.body;
    newReview._id = (new Date()).getTime() + '';
    newReview.reviews = 0;
    newReview.reviewed = false;
    reviews.push(newReview);
    res.json(newReview);
}

const findReviews = (req, res) => {
    res.json(reviews);
}

const updateReview = (req, res) => {
    const reviewId = req.params.rid;
    const updates = req.body;
    const reviewIndex = reviews.findIndex((r) => r._id === reviewId)
    reviews[reviewIndex] = {...reviews[reviewIndex], ...updates};
    res.sendStatus(200);
}

const deleteReview = (req, res) => {
    const reviewIdToDelete = req.params.rid;
    reviews = reviews.filter((r) =>
        r._id !== reviewIdToDelete);
    res.sendStatus(200);
}

export default (app) => {
    app.post('/api/reviews', createReview);
    app.get('/api/reviews', findReviews);
    app.put('/api/reviews/:rid', updateReview);
    app.delete('/api/reviews/:rid', deleteReview);
}
