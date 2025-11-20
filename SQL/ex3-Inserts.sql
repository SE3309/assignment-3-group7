USE 3309assignment3;
-- Task 3 -> Three Unique Inserts (Tristan Beley) 

-- Basic Insert 
INSERT INTO site_user (
	userId, firstName, lastName, email, startDate, endDate,
    dailyCalories, dailyProtein, dailyCarbs, dailyFat
)
VALUES(
 1, 'Tristan', 'Beley', 'tbeley@uwo.ca', NOW(), NULL, 2500, 150, 300, 80
 );

-- Insert...SELECT (Complex Insert) With some 'Copy' Elements
INSERT INTO site_user(
userId, firstName, lastName, email, startDate, endDate,
    dailyCalories, dailyProtein, dailyCarbs, dailyFat
)
SELECT
	userId + 1000 AS userID, -- Shitfs ID so no conflict
	CONCAT(firstName, '_copy'), -- add suffix to name
    lastName,
    CONCAT('copy_', email), -- modified email
    NOW(),-- new start date
    NULL,
    dailyCalories,
    dailyProtein,
    dailyCarbs,
    dailyFat
FROM site_user
WHERE userId = 1; -- uses the original row I inserted 

-- Randomized Value Insert
INSERT INTO site_user(
userId, firstName, lastName, email, startDate, endDate,
    dailyCalories, dailyProtein, dailyCarbs, dailyFat
)
VALUES(
	FLOOR(rand()*10000), -- random userID between 0 and 10,000
    'RobotT',
    'RobotBeley',
    CONCAT('autoemail', FLOOR(rand() * 1000), '@example.com'),
    NOW(),     
    NULL,
    1700 + FLOOR(rand() * 1800),  -- calories between 1700–3500
    80 + FLOOR(rand() * 120),     -- protein between 80–200
    150 + FLOOR(rand() * 200),   -- carbs between 150–350
    40 + FLOOR(rand() * 40)      -- fats between 40–80
);

SELECT * FROM site_user;
    
