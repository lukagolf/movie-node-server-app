DROP DATABASE IF EXISTS moviesite;
CREATE DATABASE moviesite;
USE moviesite;

CREATE TABLE movies (
	movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    release_date DATE,
    summary VARCHAR(5000) NOT NULL,
    photo_url VARCHAR(1000),
    UNIQUE(title, release_date)
);
CREATE TABLE genres (
	genre_name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE movie_has_genre (
	movie_id INT,
    genre_name VARCHAR(50),
    PRIMARY KEY (movie_id, genre_name),
    CONSTRAINT FOREIGN KEY movie_w_genre_fk (movie_id) REFERENCES
		movies (movie_id) ON UPDATE RESTRICT
						  ON DELETE CASCADE,
	CONSTRAINT FOREIGN KEY genre_of_movie_fk (genre_name) REFERENCES
		genres (genre_name) ON UPDATE CASCADE
							ON DELETE CASCADE
);

CREATE TABLE users (
    username VARCHAR(64) PRIMARY KEY,
    pword VARCHAR(64) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role1 ENUM ('Admin', 'Viewer', 'Critic') NOT NULL,
    role2 ENUM ('Admin', 'Viewer', 'Critic'),
    firstname VARCHAR(64) NOT NULL,
    lastname VARCHAR(64) NOT NULL,
    CONSTRAINT unique_roles CHECK (role1 != role2)
);

CREATE TABLE user_follows_user (
	follower_id VARCHAR(64),
    followed_id VARCHAR(64),
    PRIMARY KEY(follower_id, followed_id),
    CONSTRAINT FOREIGN KEY follower_fk (follower_id) REFERENCES 
		users (username) ON UPDATE RESTRICT
						ON DELETE CASCADE,
	CONSTRAINT FOREIGN KEY follower_fk (followed_id) REFERENCES 
	users (username) ON UPDATE RESTRICT
					ON DELETE CASCADE
);

CREATE TABLE user_favorites_movie (
	username VARCHAR(64),
    movie_id INT,
    PRIMARY KEY(username, movie_id),
    CONSTRAINT FOREIGN KEY favoriting_user_fk (username) REFERENCES
		users (username) ON UPDATE RESTRICT
						ON DELETE CASCADE,
	CONSTRAINT FOREIGN KEY favorited_movie_fk (movie_id) REFERENCES
	    movies (movie_id) ON UPDATE RESTRICT
					      ON DELETE CASCADE
);

CREATE TABLE reviews (
	rev_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    movie_id INT NOT NULL,
    review_text VARCHAR(10000),
    date_reviewed DATETIME NOT NULL,
    rating INT NOT NULL,
    critic_id VARCHAR(64) NOT NULL,
    CONSTRAINT FOREIGN KEY reviewed_movie_fk (movie_id) REFERENCES
		movies (movie_id) ON UPDATE RESTRICT
					      ON DELETE CASCADE,
	CONSTRAINT FOREIGN KEY reviewer_fk (critic_id) REFERENCES
	users (username) ON UPDATE RESTRICT
					ON DELETE CASCADE
);

CREATE TABLE user_likes_review (
	username VARCHAR(64),
    rev_id INT,
    PRIMARY KEY (username, rev_id),
    CONSTRAINT FOREIGN KEY liking_user_fk (username) REFERENCES
		users (username) ON UPDATE RESTRICT
					    ON DELETE CASCADE,
	CONSTRAINT FOREIGN KEY liked_review_fk (rev_id) REFERENCES
		reviews (rev_id) ON UPDATE RESTRICT
					    ON DELETE CASCADE
);

CREATE TABLE user_dislikes_review (
	username VARCHAR(64),
    rev_id INT,
    PRIMARY KEY (username, rev_id),
    CONSTRAINT FOREIGN KEY disliking_user_fk (username) REFERENCES
		users (username) ON UPDATE RESTRICT
					    ON DELETE CASCADE,
	CONSTRAINT FOREIGN KEY disliked_review_fk (rev_id) REFERENCES
		reviews (rev_id) ON UPDATE RESTRICT
					 	 ON DELETE CASCADE
);

CREATE TABLE reports (
	rep_id INT AUTO_INCREMENT PRIMARY KEY,
    category ENUM('Unwanted commercial content or spam', 
				  'Illegal content', 
                  'Harassment or bullying', 
                  'Unmarked spoilers', 
                  'Misinformation',
                  'Other') NOT NULL,
	date_submitted DATETIME NOT NULL,
    submitter_id VARCHAR(64) NOT NULL,
    admin_id VARCHAR(64),
    rev_id INT NOT NULL,
    is_resolved BOOL DEFAULT FALSE,
    report_text VARCHAR(500),
    CONSTRAINT FOREIGN KEY report_submitter_fk (submitter_id) REFERENCES
		users (username) ON UPDATE RESTRICT
					ON DELETE NO ACTION,
	CONSTRAINT FOREIGN KEY report_reviewer_fk (admin_id) REFERENCES 
		users (username) ON UPDATE RESTRICT
						 ON DELETE RESTRICT,
    CONSTRAINT FOREIGN KEY review_reported_fk (rev_id) REFERENCES 
		reviews (rev_id) ON UPDATE RESTRICT
						 ON DELETE CASCADE
);