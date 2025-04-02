USE reThread;

-- persona 1 shopper sally
-- 1.1
SELECT l.*
FROM ListingTag lt
JOIN Listing l ON l.listing_id = lt.listing_id
JOIN Tag t ON lt.tag_id = t.tag_id
WHERE t.tag_name = 'professional';

-- 1.2
INSERT INTO Location (location_id, city, state, zip, university)
VALUES (02, 'New York City', 'NY', 10012, 'NYU');

INSERT Into Demographic (demographic_id, age, gender, location_id)
VALUES (30, 22, 'female', 01);

INSERT INTO User (user_id, name, role, location_id, demographic_id)
VALUES (123, 'Samantha', 'Shopper', 545, 20);

INSERT INTO SavedItems (user_id, list_id, saved_at)
VALUES (123, 456, CURRENT_TIMESTAMP);


-- 1.3
SELECT listing_id, brand
FROM Listing
WHERE listing_id = 456;

-- 1.4
SELECT u.user_id, u.name
FROM User u
JOIN Location l ON u.location_id = l.location_id
WHERE l.city = 'Alkaline' AND l.state = 'OH';

-- 1.5
INSERT INTO Message (message_id, sender_id, recipient_id, listing_id, content)
VALUES (123, 789, 456, 'Hi! I have a question about this item.', CURRENT_TIMESTAMP);




-- Persona 2: Trend Analyst- Fark Montenot

-- 2.1: Real-Time Listings for Trend Monitoring
SELECT *
FROM Listing
WHERE timestamp >= CURRENT_DATE - INTERVAL 7 DAY;

-- 2.2: Log a Trend Report Entry
INSERT INTO TrendReport (report_id, exported_format, title, summary, filters, created_at, created_by)
VALUES (
    100, -- Fark's user_id
    'CSV',
    'Cherry Red Gains Momentum Among Young Shopped',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    '{"tag": "cherry red", "age_range": "18-24", "location": "urban"}',
    CURRENT_TIMESTAMP,
    'PDF'
);

-- 2.3: Listing Price Volatility
SELECT
    listing_id,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    (MAX(price) - MIN(price)) AS price_range
FROM PriceHistory
GROUP BY listing_id
ORDER BY price_range DESC;


-- 2.4: Search Query Trends by Demographic and Time
SELECT
    d.age,
    d.gender,
    d.location_id,
    EXTRACT(MONTH FROM sq.timestamp) AS search_month,
    COUNT(*) AS search_count
FROM SearchQuery sq
JOIN User u ON sq.user_id = u.user_id
JOIN Demographic d ON u.demographic_id = d.demographic_id
GROUP BY d.age, d.gender, d.location_id, search_month
ORDER BY search_month, search_count DESC;

-- 2.5: Most Frequent Tags in Recent Listings
SELECT
    t.tag_name,
    COUNT(*) AS usage_count
FROM ListingTag lt
JOIN Tag t ON lt.tag_id = t.tag_id
JOIN Listing l ON lt.listing_id = l.listing_id
WHERE l.timestamp >= CURRENT_DATE - INTERVAL 30 DAY
GROUP BY t.tag_name
ORDER BY usage_count DESC;

-- 2.6: Top Trending Keywords from Search Data
SELECT
    keyword,
    SUM(usage_count) AS total_usage
FROM SearchTrend
WHERE trend_date >= CURRENT_DATE - INTERVAL 30 DAY
GROUP BY keyword
ORDER BY total_usage DESC
LIMIT 10;

-- Persona 3: Seller Samantha
-- 3.1: Show seller listings to interested users (tag + group targeting)
SELECT l.*
FROM Listing l
JOIN ListingTag lt ON l.listing_id = lt.listing_id
JOIN Tag t ON lt.tag_id = t.tag_id
JOIN User u ON u.location_id = (SELECT location_id FROM User WHERE user_id = 123)
WHERE l.seller_id = 123
  AND t.tag_name IN ('trendy', 'professional', 'vintage');

-- 3.2: Secure payment record (successful transactions for this seller)
SELECT t.transaction_id, t.price, t.status, t.timestamp, u.name AS buyer_name
FROM Transaction t
JOIN User u ON t.buyer_id = u.user_id
WHERE t.seller_id = 123 AND t.status = 'completed';

-- 3.3: Communicate with buyers (inbox for seller)
SELECT m.message_id, u.name AS buyer_name, m.content, m.timestamp
FROM Message m
JOIN User u ON m.sender_id = u.user_id
WHERE m.recipient_id = 123
ORDER BY m.timestamp DESC;

-- 3.4: Upload images for listings
INSERT INTO ListingPhoto (photo_id, listing_id, tag_label, url)
VALUES (001, 456, 'pants', 'https://rethread.com/imgs/listing456-1.jpg');

-- 3.5: Rate a buyer after a transaction
INSERT INTO Review (review_id, reviewer_id, reviewee_id, comment, created_at, rating)
VALUES (123, 789, 3, 'Rude but responsive buyer.', CURRENT_TIMESTAMP, 4);

-- 3.6: Add listing with full clothing details ---
INSERT INTO Listing (listing_id, title, description, price, `condition`, brand, size, material, color, seller_id, group_id)
VALUES (
        456,
    'Lululemon Align Pants',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    25.00,
    'Like New',
    'Lululemon',
    '6',
    'Luon Blend',
    'Navy',
    CURRENT_TIMESTAMP,
    123
);

-- 3.7: View listing analytics summary
SELECT l.title, la.views, la.saves, la.shares
FROM Listing l
JOIN ListingAnalytics la ON l.listing_id = la.listing_id
WHERE l.seller_id = 123
ORDER BY la.views DESC;

-- Persona 4: Administrator Ashley
-- 4.1: Monitor buyer/seller messages for positive interactions
SELECT
    m.message_id,
    m.listing_id,
    m.content,
    m.timestamp,
    sender.user_id AS sender_id,
    sender.role AS sender_role,
    recipient.user_id AS recipient_id,
    recipient.role AS recipient_role
FROM Message m
JOIN User sender ON m.sender_id = sender.user_id
JOIN User recipient ON m.recipient_id = recipient.user_id
ORDER BY m.timestamp DESC
LIMIT 50;

-- 4.2: Track seller activity and sale history
SELECT
    u.user_id,
    u.role,
    l.listing_id,
    l.title,
    l.timestamp,
    t.transaction_id,
    t.status,
    t.timestamp
FROM User u
JOIN Listing l ON u.user_id = l.seller_id
LEFT JOIN Transaction t ON l.listing_id = t.listing_id
WHERE u.role = 'seller'
ORDER BY t.timestamp DESC;

-- 4.3: View all flagged content for review and moderation
SELECT
    f.flag_id,
    f.content_type,
    f.content_id,
    f.reason,
    f.severity,
    f.created_at,
    u.user_id AS flagged_by
FROM FlaggedContent f
JOIN User u ON f.flagged_by = u.user_id
ORDER BY f.severity DESC, f.created_at DESC;

-- 4.4: View all user verifications and their status
SELECT
    v.verification_id,
    v.user_id,
    v.method,
    v.status,
    v.verified_at
FROM Verification v
ORDER BY v.status, v.verified_at DESC;

-- 4.5: Monitor buyer/seller reviews to detect problematic users ---
SELECT
    r.review_id,
    r.reviewer_id,
    r.reviewee_id,
    r.rating,
    r.comment,
    r.created_at
FROM Review r
WHERE r.rating <= 2
ORDER BY r.created_at DESC;

-- 4.6: Create a new style-based group for community engagement
INSERT INTO `Group`(group_id, created_by, name, type)
VALUES (
    324,
    123,  -- Ashley's user_id
    'Emo',
    'Style');
