import callProcedure from "../../db/nodejs-connect/call-sql-procedure.js"

export const findCriticReviews = async (criticUsername) => {
    let reviews = await callProcedure('get_critic_reviews', [criticUsername])
    reviews = await addLikesDislikes(reviews)
    return reviews
}
    
export const findMovieReviews = async (mid) => {
    let reviews = await callProcedure('get_movie_reviews', [mid])
    console.log("After sql call, reviews is " + reviews)
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
        category,
        title,
        movie_id,
        review_text,
        date_reviewed,
        rating,
        critic_id
    }
) => callProcedure('update_review', [
    rev_id,
    category,
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
        let dislikes = await getReviewDisikes(reviews[i].rev_id)
        reviews[i] = {...reviews[i], likes, dislikes}
    }
}

export const getReviewLikes = (rev_id) => callProcedure('get_review_likes', [rev_id])

export const getReviewDisLikes = (rev_id) => callProcedure('get_review_dislikes', [rev_id])


/* Needed SQL: 
- Get reviews by movie
- Get reviews by critic 
- Get review likes
- Get review dislikes
- get users' liked/disliked reviews?
*/