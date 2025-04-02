DROP DATABASE IF EXISTS reThread;
CREATE DATABASE reThread;
USE reThread;

CREATE TABLE Location (
    location_id int PRIMARY KEY NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    zip VARCHAR(20),
    university VARCHAR(100)
);

CREATE TABLE Demographic (
    demographic_id int PRIMARY KEY NOT NULL,
    age VARCHAR(50),
    gender VARCHAR(20),
    location_id INT REFERENCES Location(location_id)
);

CREATE TABLE User (
    user_id int PRIMARY KEY NOT NULL,
    name VARCHAR(100),
    role VARCHAR(50),
    location_id INT REFERENCES Location(location_id),
    demographic_id INT REFERENCES Demographic(demographic_id)
);


CREATE TABLE `Group` (
    group_id int PRIMARY KEY NOT NULL,
    created_by INT REFERENCES User(user_id) ON DELETE SET NULL,
    name VARCHAR(100),
    type VARCHAR(50)
);

CREATE TABLE Tag (
    tag_id int PRIMARY KEY NOt NULL,
    tag_name VARCHAR(100)
);

CREATE TABLE Listing (
    listing_id int PRIMARY KEY NOT NULL,
    title VARCHAR(255),
    description TEXT,
    price DECIMAL(10,2),
    `condition` VARCHAR(100),
    brand VARCHAR(100),
    size VARCHAR(10),
    material VARCHAR(100),
    color VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    seller_id INT REFERENCES User(user_id) ON DELETE CASCADE,
    group_id INT REFERENCES `Group`(group_id)
);

CREATE TABLE SearchQuery (
    query_id SERIAL PRIMARY KEY,
    keyword VARCHAR(255),
    user_id INT REFERENCES User(user_id) ON DELETE CASCADE,
    location_id INT REFERENCES Location(location_id),
    group_id INT REFERENCES `Group`(group_id),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Transaction (
    transaction_id int PRIMARY KEY NOT NULL,
    listing_id INT REFERENCES Listing(listing_id),
    method VARCHAR(50),
    buyer_id INT REFERENCES User(user_id),
    seller_id INT REFERENCES User(user_id),
    status VARCHAR(50),
    payment VARCHAR(50),
    price DECIMAL(10,2),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Review (
    review_id int PRIMARY KEY NOT NULL,
    reviewer_id INT REFERENCES User(user_id),
    reviewee_id INT REFERENCES User(user_id),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rating INT
);

CREATE TABLE Verification (
    verification_id int PRIMARY KEY NOT NULL,
    user_id INT REFERENCES User(user_id) ON DELETE CASCADE,
    method VARCHAR(100),
    status VARCHAR(50),
    verified_at TIMESTAMP
);

CREATE TABLE FlaggedContent (
    flag_id int PRIMARY KEY NOT NULL,
    content_type VARCHAR(50),
    content_id INT,
    flagged_by INT REFERENCES User(user_id),
    reason TEXT,
    severity VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Dispute (
    dispute_id int PRIMARY KEY NOT NULL,
    seller_id INT REFERENCES User(user_id),
    buyer_id INT REFERENCES User(user_id),
    listing_id INT REFERENCES Listing(listing_id),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolution TEXT
);

CREATE TABLE UserGroup (
    user_id INT REFERENCES User(user_id) ON DELETE CASCADE,
    group_id INT REFERENCES `Group`(group_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, group_id)
);

CREATE TABLE ListingPhoto (
    photo_id int PRIMARY KEY NOT NULL,
    listing_id INT REFERENCES Listing(listing_id) ON DELETE CASCADE,
    tag_label VARCHAR(100),
    url TEXT
);

CREATE TABLE ListingTag (
    listing_id INT REFERENCES Listing(listing_id) ON DELETE CASCADE,
    tag_id INT REFERENCES Tag(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (listing_id, tag_id)
);

CREATE TABLE SavedItems (
    user_id INT REFERENCES User(user_id) ON DELETE CASCADE,
    list_id INT REFERENCES Listing(listing_id) ON DELETE CASCADE,
    saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, list_id)
);

CREATE TABLE CartItem (
    user_id INT REFERENCES User(user_id) ON DELETE CASCADE,
    list_id INT REFERENCES Listing(listing_id) ON DELETE CASCADE,
    quantity INT,
    added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, list_id)
);

CREATE TABLE PriceHistory (
    listing_id INT REFERENCES Listing(listing_id) ON DELETE CASCADE,
    price DECIMAL(10,2),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ListingAnalytics (
    listing_id INT PRIMARY KEY REFERENCES Listing(listing_id) ON DELETE CASCADE,
    views INT DEFAULT 0,
    shares INT DEFAULT 0,
    saves INT DEFAULT 0
);

CREATE TABLE Message (
    message_id int PRIMARY KEY NOT NULL,
    sender_id INT REFERENCES User(user_id),
    recipient_id INT REFERENCES User(user_id),
    listing_id INT REFERENCES Listing(listing_id),
    content TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE TrendReport (
    report_id int PRIMARY KEY NOT NULL,
    exported_format VARCHAR(20),
    title VARCHAR(255),
    summary TEXT,
    filters JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT REFERENCES User(user_id)
);

CREATE TABLE SearchTrend (
    search_trend_id int PRIMARY KEY NOT NULL,
    usage_count INT,
    trend_date DATE,
    location_id INT REFERENCES Location(location_id),
    group_id INT REFERENCES `Group`(group_id),
    keyword VARCHAR(255)
);

CREATE TABLE TagTrend (
    tag_trend_id int PRIMARY KEY NOT NULL,
    usage_count INT,
    trend_date DATE,
    location_id INT REFERENCES Location(location_id),
    group_id INT REFERENCES `Group`(group_id),
    tag_id INT REFERENCES Tag(tag_id)
);
