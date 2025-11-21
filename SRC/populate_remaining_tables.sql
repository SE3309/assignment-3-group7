USE 3309assignment3;

------------------------------------------------------------
-- 1) MEALPLANS (50 rows)
------------------------------------------------------------
INSERT INTO mealplan (
  mealPlanId, mealPlanName, mealPlanUserId, startDate, endDate
)
WITH RECURSIVE seq_mp AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM seq_mp WHERE n < 50
)
SELECT
  n AS mealPlanId,
  CONCAT('Meal Plan ', n) AS mealPlanName,
  ((n - 1) % 300) + 1 AS mealPlanUserId,
  DATE_ADD('2025-03-01', INTERVAL n DAY) AS startDate,
  DATE_ADD('2025-03-01', INTERVAL n + 7 DAY) AS endDate
FROM seq_mp;


------------------------------------------------------------
-- 2) MEALPLAN_RECIPIES (150 rows)
------------------------------------------------------------
INSERT INTO mealplan_recipies (
  mealPlanId, recipeId
)
WITH RECURSIVE seq_mp AS (
  SELECT 1 AS mealPlanId
  UNION ALL
  SELECT mealPlanId + 1 FROM seq_mp WHERE mealPlanId < 50
),
three AS (
  SELECT 1 AS k UNION ALL SELECT 2 UNION ALL SELECT 3
)
SELECT
  m.mealPlanId,
  ((m.mealPlanId - 1) * 3 + k)  -- recipe IDs 1..150
FROM seq_mp m
CROSS JOIN three;


------------------------------------------------------------
-- 3) RECIPE_INGREDIENTS (300 rows)
------------------------------------------------------------
INSERT INTO recipe_ingredients (
  recipeId, ingredientName, quantity
)
WITH RECURSIVE seq_ri AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM seq_ri WHERE n < 300
)
SELECT
  ((n - 1) % 3000) + 1 AS recipeId,
  CASE ((n - 1) % 10)
    WHEN 0 THEN '0% fat Greek yoghurt'
    WHEN 1 THEN '03.06.2024 DEU101H 0?:14 4'
    WHEN 2 THEN '10 Fish Fingers Omega 3'
    WHEN 3 THEN '10 Pains au lait frais sans sucres ajoutés 350g'
    WHEN 4 THEN '10 potato waffles'
    WHEN 5 THEN '10 Tortillas Trigo'
    WHEN 6 THEN '100% cacao puro natural'
    WHEN 7 THEN '100% mie'
    WHEN 8 THEN '100% mie complet 500g'
    WHEN 9 THEN '10dh'
  END AS ingredientName,
  50 + (n % 200) AS quantity
FROM seq_ri;


------------------------------------------------------------
-- 4) PANTRY_ITEMS (50 rows)
------------------------------------------------------------
INSERT INTO pantry_items (
  pantryUsersId, pantryItemName, quantity, expieryDate
)
WITH RECURSIVE seq_p AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM seq_p WHERE n < 50
)
SELECT
  n AS pantryUsersId,
  CASE ((n - 1) % 10)
    WHEN 0 THEN '0% fat Greek yoghurt'
    WHEN 1 THEN '03.06.2024 DEU101H 0?:14 4'
    WHEN 2 THEN '10 Fish Fingers Omega 3'
    WHEN 3 THEN '10 Pains au lait frais sans sucres ajoutés 350g'
    WHEN 4 THEN '10 potato waffles'
    WHEN 5 THEN '10 Tortillas Trigo'
    WHEN 6 THEN '100% cacao puro natural'
    WHEN 7 THEN '100% mie'
    WHEN 8 THEN '100% mie complet 500g'
    WHEN 9 THEN '10dh'
  END AS pantryItemName,
  100 + (n * 3) AS quantity,
  DATE_ADD('2025-06-01', INTERVAL n DAY) AS expieryDate
FROM seq_p;


------------------------------------------------------------
-- 5) MEALPLAN_SHOPPING_LIST_ITEMS (50 rows)
------------------------------------------------------------
INSERT INTO mealplan_shopping_list_items (
  mealPlanId, ingredientName, quantity
)
WITH RECURSIVE seq_s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM seq_s WHERE n < 50
)
SELECT
  n AS mealPlanId,
  CASE ((n - 1) % 10)
    WHEN 0 THEN '0% fat Greek yoghurt'
    WHEN 1 THEN '03.06.2024 DEU101H 0?:14 4'
    WHEN 2 THEN '10 Fish Fingers Omega 3'
    WHEN 3 THEN '10 Pains au lait frais sans sucres ajoutés 350g'
    WHEN 4 THEN '10 potato waffles'
    WHEN 5 THEN '10 Tortillas Trigo'
    WHEN 6 THEN '100% cacao puro natural'
    WHEN 7 THEN '100% mie'
    WHEN 8 THEN '100% mie complet 500g'
    WHEN 9 THEN '10dh'
  END AS ingredientName,
  CONCAT(10 + (n % 5), ' units') AS quantity
FROM seq_s;


------------------------------------------------------------
-- 6) DIETARY_RESTRICTIONS (15 rows)
------------------------------------------------------------
INSERT INTO dietary_restrictions (userId, dietaryLabel) VALUES
(1,  'Halal'),
(2,  'Vegan'),
(3,  'Vegetarian'),
(4,  'Gluten-Free'),
(5,  'Lactose-Free'),
(6,  'Keto'),
(7,  'Pescatarian'),
(8,  'Low-Sodium'),
(9,  'Nut-Free'),
(10, 'Low-FODMAP'),
(11, 'Diabetic-Friendly'),
(12, 'High-Protein'),
(13, 'Low-Carb'),
(14, 'Mediterranean'),
(15, 'Dairy-Free');


------------------------------------------------------------
-- 7) INGREDIENT_SUBSTITUTE (15 rows)
------------------------------------------------------------
INSERT INTO ingredient_substitute (
  mealPlanId, originalIngredient, substituteIngredient, quantity
) VALUES
(1,  '0% fat Greek yoghurt', '100% mie', 100),
(2,  '10 Fish Fingers Omega 3', '10 potato waffles', 150),
(3,  '10 Tortillas Trigo', '100% cacao puro natural', 50),
(4,  '100% mie complet 500g', '100% mie', 75),
(5,  '10dh', '0% fat Greek yoghurt', 80),
(6,  '03.06.2024 DEU101H 0?:14 4', '10 Pains au lait frais sans sucres ajoutés 350g', 120),
(7,  '10 Pains au lait frais sans sucres ajoutés 350g', '10 potato waffles', 110),
(8,  '10 Fish Fingers Omega 3', '10 Tortillas Trigo', 130),
(9,  '100% cacao puro natural', '0% fat Greek yoghurt', 60),
(10, '10 potato waffles', '10 Tortillas Trigo', 140),
(11, '10dh', '100% mie complet 500g', 90),
(12, '100% mie', '100% mie complet 500g', 95),
(13, '03.06.2024 DEU101H 0?:14 4', '10dh', 70),
(14, '10 Pains au lait frais sans sucres ajoutés 350g', '100% cacao puro natural', 65),
(15, '10 Tortillas Trigo', '10 Fish Fingers Omega 3', 85);


------------------------------------------------------------
-- 8) RECIPE_TAGS (50 rows)
------------------------------------------------------------
INSERT INTO recipe_tags (taggedRecipeId, tag) VALUES
(1,'high_protein'),(2,'quick'),(3,'vegan'),(4,'low_carb'),(5,'mealprep'),
(6,'gluten_free'),(7,'high_fiber'),(8,'kid_friendly'),(9,'breakfast'),(10,'lunch'),
(11,'dinner'),(12,'snack'),(13,'post_workout'),(14,'pre_workout'),(15,'low_fat'),
(16,'high_carb'),(17,'bulk'),(18,'cutting'),(19,'comfort_food'),(20,'one_pot'),
(21,'no_cook'),(22,'spicy'),(23,'mild'),(24,'sweet'),(25,'savory'),
(26,'30_min'),(27,'15_min'),(28,'slow_cooker'),(29,'air_fryer'),(30,'family_style'),
(31,'budget'),(32,'high_calorie'),(33,'low_calorie'),(34,'no_dairy'),(35,'no_eggs'),
(36,'no_nuts'),(37,'no_gluten'),(38,'macro_friendly'),(39,'student_friendly'),(40,'office_lunch'),
(41,'meal_prep_sunday'),(42,'date_night'),(43,'party_food'),(44,'holiday'),(45,'summer'),
(46,'winter'),(47,'comfort'),(48,'light'),(49,'protein_bowl'),(50,'carb_load');


------------------------------------------------------------
-- 9) USER_ALLERGIES (30 rows)
------------------------------------------------------------
INSERT INTO user_allergies (userId, allergy) VALUES
(1,'Peanuts'),(2,'Shellfish'),(3,'Dairy'),(4,'Gluten'),(5,'Eggs'),
(6,'Soy'),(7,'Tree Nuts'),(8,'Sesame'),(9,'Fish'),(10,'Mustard'),
(11,'Sulphites'),(12,'Lupin'),(13,'Celery'),(14,'Wheat'),(15,'Kiwi'),
(16,'Strawberries'),(17,'Banana'),(18,'Apple'),(19,'Tomato'),(20,'Garlic'),
(21,'Onion'),(22,'Chocolate'),(23,'Citrus'),(24,'Corn'),(25,'Oats'),
(26,'Barley'),(27,'Rye'),(28,'Cashews'),(29,'Hazelnuts'),(30,'Almonds');
