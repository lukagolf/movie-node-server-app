import mongoose from 'mongoose';
const schema = mongoose.Schema({
    movieId: String, // will be imported from the movie database
    username: String,
    title: String,
    rating: Number,
    description: String,
}, { collection: 'reviews' });
export default schema;