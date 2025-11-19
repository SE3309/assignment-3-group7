USE 3309assignment3;

-- Task 6 Part 1 - Insert Modification
INSERT INTO pantry_items (pantryUsersId, pantryItemName, quantity, expieryDate)
SELECT 
    mp.mealPlanUserId AS pantryUsersId,
    ri.ingredientName AS pantryItemName,
    1 AS quantity,
    DATE_ADD(CURDATE(), INTERVAL 10 DAY) AS expieryDate
FROM mealplan mp
JOIN mealplan_recipies mr 
    ON mp.mealPlanId = mr.mealPlanId 
   AND mp.mealPlanUserId = mr.mealPlanUserId
JOIN recipe_ingredients ri 
    ON mr.recipeId = ri.recipeId
WHERE NOT EXISTS (
    SELECT 1 
    FROM pantry_items p 
    WHERE p.pantryUsersId = mp.mealPlanUserId
      AND p.pantryItemName = ri.ingredientName
);
-- Task 6 Part 2 - Update Modification
SET SQL_SAFE_UPDATES = 0;


UPDATE recipe
SET recipecol1 = 'Long Recipe'
WHERE cookTimeMin > 60;


-- Task 6 Part 3 - Delete Modification (ayat)
DELETE FROM pantry_items
WHERE expieryDate < CURDATE();
