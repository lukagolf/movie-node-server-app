import callProcedure from "../../db/nodejs-connect/call-sql-procedure.js"

export const findCriticReviews = async (criticUsername) => {
    let reviews = await callProcedure('get_critic_reviews', [criticUsername])
    reviews = await addLikesDislikes(reviews)
    return reviews
}
    
export const findMovieReviews = async (mid) => {
    let reviews = await callProcedure('get_movie_reviews', [mid])
    console.log("After sql call, reviews is " + JSON.stringify(reviews))
    reviews = await addLikesDislikes(reviews)
    return reviews
}

export const createReview = (
    {
        title,
        movie_id,
        review_text,
        date_reviewed,
        rating,
        critic_id
    }
) => callProcedure('add_review', [
    title,
    movie_id,
    review_text,
    date_reviewed,
    rating,
    critic_id
])
export const deleteReview = (rid) => reviewsModel.deleteOne({ _id: rid });

// add "date updated" field if time
export const updateReview = (
    {
        rev_id,
        title,
        movie_id,
        review_text,
        date_reviewed,
        rating,
        critic_id
    }
) => callProcedure('update_review', [
    rev_id,
    title,
    movie_id,
    review_text,
    date_reviewed,
    rating,
    critic_id
])

/* adds attributes to review object for likes and dislikes */
const addLikesDislikes = async (reviews) => {
    let n = reviews.length
    for (let i = 0; i < n; i++) {
        let likes = await getReviewLikes(reviews[i].rev_id)
        likes = likes.map(like => like.username)
        let dislikes = await getReviewDisLikes(reviews[i].rev_id)
        dislikes = dislikes.map(dislike => dislike.username)
        reviews[i] = {...reviews[i], likes, dislikes}
    }
    return reviews;
}

export const getReviewLikes = (rev_id) => callProcedure('get_review_likes', [rev_id])

export const getReviewDisLikes = (rev_id) => callProcedure('get_review_dislikes', [rev_id])

export const getReviewByCriticMovie = (rev_id) => callProcedure('get_review_by_id', [rev_id])

export const likeReview = (rev_id, username) => callProcedure('like_review', [username, rev_id])

export const dislikeReview = (rev_id, username) => callProcedure('dislike_review', [username, rev_id])

export const unlikeReview = (rev_id, username) => callProcedure('unlike_review', [username, rev_id])

export const undislikeReview = (rev_id, username) => callProcedure('undislike_review', [username, rev_id])



/* Needed SQL: 
- Get reviews by movie
- Get reviews by critic 
- Get review likes
- Get review dislikes
- get users' liked/disliked reviews?
*/