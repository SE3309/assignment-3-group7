USE 3309assignment3;

-- basic query: returns users consuming more than 2000 calories
SELECT userId, firstName, lastName, email
FROM site_user
WHERE dailyCalories > 2000;

-- using join between 2 tables: finding all meal plans and users who own them
SELECT mp.mealPlanId, mp.mealPlanName, su.firstName, su.lastName
FROM mealplan mp
JOIN site_user su ON mp.mealPlanUserId = su.userId
WHERE mp.mealPlanId <= 10;

-- multi-table JOIN: shows meal plans with their recipes
SELECT mp.mealPlanId, mr.recipeId, r.name AS recipeName
FROM mealplan mp
JOIN mealplan_recipies mr ON mp.mealPlanId = mr.mealPlanId
JOIN recipe r ON mr.recipeId = r.recipeId
ORDER BY mp.mealPlanId, mr.recipeId;


-- subquery in WHERE: finds users with at least 1 dietary restriction
SELECT userId, firstName, lastName
FROM site_user
WHERE userId IN (
    SELECT userId
    FROM dietary_restrictions
);

-- includes EXISTS clause and join: finds recipes that have an ingredient found in any pantry
SELECT r.recipeId, r.name
FROM recipe r
WHERE EXISTS (
    SELECT 1
    FROM recipe_ingredients ri
    JOIN pantry_items p ON ri.ingredientName = p.pantryItemName
    WHERE ri.recipeId = r.recipeId
);

-- includes GROUP BY + HAVING: finds ingredients with calories on average > 300
SELECT category, AVG(calories) AS avg_calories
FROM ingredients
GROUP BY category
HAVING AVG(calories) > 300;

-- correlated subquery and multi-relation: finds users whose mealplans include recipes with many ingredients
SELECT DISTINCT su.userId, su.firstName, su.lastName
FROM site_user su
JOIN mealplan mp ON mp.mealPlanUserId = su.userId
JOIN mealplan_recipies mr ON mr.mealPlanId = mp.mealPlanId
WHERE mr.recipeId IN (
    SELECT ri.recipeId
    FROM recipe_ingredients ri
    GROUP BY ri.recipeId
    HAVING COUNT(*) >
       (
           SELECT COUNT(*)
           FROM recipe_ingredients ri2
           WHERE ri2.recipeId = ri.recipeId
		) / 2
);
