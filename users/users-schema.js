import mongoose from "mongoose";
const usersSchema = new mongoose.Schema({
    username: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    firstName: String,
    lastName: String,
    email: String,
    followedCritics: Array,
    savedMovies: Array,
    roles: { type: [String], enum: ["ADMIN", "CRITIC", "VIEWER"], default: ["VIEWER"] },
}, { collection: "users" });
export default usersSchema;