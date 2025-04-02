DROP DATABASE IF EXISTS reThread;
CREATE DATABASE reThread;
USE reThread;

DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Transaction;
DROP TABLE IF EXISTS SavedItems;
DROP TABLE IF EXISTS ListingTag;
DROP TABLE IF EXISTS Tag;
DROP TABLE IF EXISTS ListingPhoto;
DROP TABLE IF EXISTS ListingAnalytics;
DROP TABLE IF EXISTS Listing;
DROP TABLE IF EXISTS 'Group';
DROP TABLE IF EXISTS UserGroup;
DROP TABLE IF EXISTS Verification;
DROP TABLE IF EXISTS Dispute;
DROP TABLE IF EXISTS FlaggedContent;
DROP TABLE IF EXISTS PriceHistory;
DROP TABLE IF EXISTS SearchQuery;
DROP TABLE IF EXISTS SearchTrend;
DROP TABLE IF EXISTS TagTrend;
DROP TABLE IF EXISTS TrendReport;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Demographic;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS CartItem;

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
    tag_name VARCHAR(100) UNIQUE
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
    title VARCHAR(255) UNIQUE,
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

-- Sample data
-- Location
INSERT INTO Location VALUES (1, 'New York City', 'NY', '10012', 'NYU');
INSERT INTO Location VALUES (2, 'Boston', 'MA', '02115', 'Northeastern');

-- Demographic
INSERT INTO Demographic VALUES (10, '22', 'female', 1);
INSERT INTO Demographic VALUES (11, '25', 'male', 2);

-- User
INSERT INTO User VALUES (123, 'Samantha', 'Shopper', 1, 10);
INSERT INTO User VALUES (456, 'Fark Montenot', 'Analyst', 1, 10);
INSERT INTO User VALUES (777, 'Ashley Admin', 'Admin', 1, 10);
INSERT INTO User VALUES (789, 'Buyer Bob', 'Buyer', 1, 10);

-- Group
INSERT INTO `Group` VALUES (324, 777, 'Emo', 'Style');

-- Tag
INSERT INTO Tag VALUES (1, 'professional');
INSERT INTO Tag VALUES (2, 'trendy');
INSERT INTO Tag VALUES (3, 'vintage');

-- Listing
INSERT INTO Listing (listing_id, title, description, price, `condition`, brand, size, material, color, seller_id, group_id)
VALUES (456, 'Lululemon Align Pants', 'Lorem ipsum dolor sit amet', 25.00, 'Like New', 'Lululemon', '6', 'Luon Blend', 'Navy', 123, 324);

-- ListingTag
INSERT INTO ListingTag VALUES (456, 1);
INSERT INTO ListingTag VALUES (456, 2);

-- SavedItems
INSERT INTO SavedItems VALUES (123, 456, '2025-04-02 01:55:21');

-- ListingPhoto
INSERT INTO ListingPhoto VALUES (1, 456, 'pants', 'https://rethread.com/imgs/listing456-1.jpg');

-- ListingAnalytics
INSERT INTO ListingAnalytics VALUES (456, 10, 2, 5);

-- Message
INSERT INTO Message VALUES (1, 789, 123, 456, 'Hi! I have a question about this item.', '2025-04-02 01:55:21');

-- Review
INSERT INTO Review VALUES (1, 123, 789, 'Rude but responsive buyer.', '2025-04-02 01:55:21', 4);

-- TrendReport
INSERT INTO TrendReport VALUES (
  100, 'CSV', 'Cherry Red Gains Momentum Among Young Shoppers',
  'Sample summary here', '{"tag": "cherry red"}', '2025-04-02 01:55:21', 456
);

-- PriceHistory
INSERT INTO PriceHistory VALUES (456, 25.00, '2025-04-02 01:55:21');
INSERT INTO PriceHistory VALUES (456, 28.00, '2025-04-02 01:55:21');

-- SearchQuery
INSERT INTO SearchQuery (keyword, user_id, location_id, group_id) VALUES ('lululemon pants', 123, 1, 324);

-- SearchTrend
INSERT INTO SearchTrend VALUES (1, 100, CURRENT_DATE, 1, 324, 'lululemon');

-- TagTrend
INSERT INTO TagTrend VALUES (1, 75, CURRENT_DATE, 1, 324, 1);
