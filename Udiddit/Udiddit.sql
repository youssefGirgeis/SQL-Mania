
CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(25) NOT NULL,
    last_login TIMESTAMP,
    CONSTRAINT "non_empty_username" CHECK (LENGTH(TRIM(user_name)) > 0),
    CONSTRAINT "unique_usernames" UNIQUE (user_name)
);

CREATE TABLE topics (
    id SERIAL PRIMARY KEY,
    topic_name VARCHAR(30) NOT NULL,
    description VARCHAR(500),
    CONSTRAINT "non_empty_topic_name" CHECK (LENGTH(TRIM(topic_name)) > 0),
    CONSTRAINT "unique_topic_name" UNIQUE (topic_name)
);

CREATE INDEX topic_index ON topics(topic_name);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    post_title VARCHAR(100) NOT NULL,
    url VARCHAR(4000),
    text_content TEXT,
    date_posted TIMESTAMP,
    topic_id INTEGER REFERENCES topics ON DELETE CASCADE,
    user_id INTEGER REFERENCES users ON DELETE SET NULL,
    CONSTRAINT "non_empty_title" CHECK (LENGTH(TRIM(post_title)) > 0),
    CONSTRAINT "url_or_text_content" CHECK (
        (LENGTH(TRIM(url)) > 0 AND LENGTH(TRIM(text_content)) = 0)
        OR 
        (LENGTH(TRIM(url)) = 0 AND LENGTH(TRIM(text_content)) > 0)
    )
);

CREATE INDEX url_index ON posts(url);
CREATE INDEX title_index ON posts(post_title);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    text_content TEXT NOT NULL,
    date_posted TIMESTAMP,
    post_id INTEGER REFERENCES posts ON DELETE CASCADE,
    user_id INTEGER REFERENCES users ON DELETE SET NULL,
    top_comment_id INTEGER REFERENCES comments ON DELETE CASCADE
    CONSTRAINT "non_empty_comment" CHECK (LENGTH(TRIM(text_content)) > 0)
);

CREATE INDEX text_content_index ON comments(text_content);

CREATE TABLE votes (
    id SERIAL PRIMARY KEY,
    vote SMALLINT,
    user_id INTEGER REFERENCES users ON DELETE SET NULL,
    post_id INTEGER REFERENCES posts ON DELETE CASCADE,
    CONSTRAINT "vote_valid_value" CHECK (vote = 1 OR vote = -1),
    CONSTRAINT "user_vote_once" UNIQUE (user_id, post_id)
);
---------------------------------------
INSERT INTO users (user_name)
    SELECT DISTINCT username 
    FROM bad_posts
    UNION 
    SELECT DISTINCT username
    FROM bad_comments
    UNION 
    SELECT DISTINCT regexp_split_to_table(downvotes, ',')
    FROM bad_posts
    UNION
    SELECT DISTINCT regexp_split_to_table(upvotes, ',')
    FROM bad_posts;
-------------------------------------
INSERT INTO topics (topic_name)
    SELECT DISTINCT topic 
        FROM bad_posts;
-------------------------------------
INSERT INTO posts 
(
    post_title,
    text_content,
    url,
    topic_id,
    user_id
)
SELECT 
    LEFT(bp.title, 100),
    bp.url,
    bp.text_content, 
    t.id, 
    u.id
FROM users u
JOIN bad_posts bp  
ON bp.username = u.user_name
JOIN topics t 
ON bp.topic = t.topic_name;
---------------------------------------
INSERT INTO comments (post_id, user_id, text_content)
    SELECT
        p.id,
        u.id,
        bc.text_content
    FROM bad_comments bc 
    JOIN users u 
    ON u.user_name = bc.username
    JOIN posts p
    ON p.id = bc.post_id;

--------------------------------------------

INSERT INTO votes (post_id,user_id,vote)
SELECT 
    t1.id,
    u.id,
    1
FROM ( SELECT id, regexp_split_to_table(upvotes,',') as username 
      FROM bad_posts) t1
JOIN users u 
ON u.user_name = t1.username
JOIN posts p
ON t1.id = p.id;

INSERT INTO votes (post_id,user_id,vote)
SELECT 
    t2.id,
    u.id,
    -1
FROM ( SELECT id, regexp_split_to_table(downvotes,',') as username        
       FROM bad_posts) t2
JOIN users u 
ON u.user_name = t2.username
JOIN posts p 
ON t2.id = p.id;