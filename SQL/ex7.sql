-- View 1:
-- drop view incase it already exists
DROP VIEW IF EXISTS user_mealplans;
CREATE VIEW user_mealplans AS
SELECT 
    u.userId,
    u.firstName,
    u.lastName,
    mp.mealPlanId,
    mp.mealPlanName,
    mp.startDate,
    mp.endDate
FROM site_user u
JOIN mealplan mp 
	ON u.userId = mp.mealPlanUserId;

-- demonstration for screenshot:
SELECT * FROM user_mealplans;


-- View 2
DROP VIEW IF EXISTS recipe_ingredient_details;

CREATE VIEW recipe_ingredient_details AS
SELECT 
    r.recipeId,
    r.name AS recipeName,
    ri.ingredientName,
    ri.quantity
FROM recipe r
JOIN recipe_ingredients ri 
    ON r.recipeId = ri.recipeId;
    
-- demonstration for screenshot:
    SELECT * FROM recipe_ingredient_details;



