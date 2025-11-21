CREATE TABLE site_user (
  userId INT NOT NULL,
  firstName VARCHAR(100) NOT NULL,
  lastName VARCHAR(100),
  email VARCHAR(100),
  startDate DATETIME,
  endDate DATETIME,
  dailyCalories INT,
  dailyProtein INT,
  dailyCarbs INT,
  dailyFat INT,
  PRIMARY KEY (userId),
  UNIQUE (email),
  CHECK (email IS NULL OR email LIKE '%@%')
);
DESCRIBE site_user;

CREATE TABLE ingredients (
  ingredientName VARCHAR(100) NOT NULL,
  category VARCHAR(100),
  measurementUnit VARCHAR(100) NOT NULL,
  unitShorthand VARCHAR(100),
  calories INT NOT NULL,
  protein INT NOT NULL,
  carbs INT NOT NULL,
  fats INT NOT NULL,
  PRIMARY KEY (ingredientName)
);
DESCRIBE ingredients;

CREATE TABLE mealplan (
  mealPlanId INT NOT NULL,
  mealPlanName VARCHAR(100) NOT NULL,
  mealPlanUserId INT NOT NULL,
  startDate DATETIME NOT NULL,
  endDate DATETIME NOT NULL,
  PRIMARY KEY (mealPlanId, mealPlanUserId),
  FOREIGN KEY (mealPlanUserId) REFERENCES 3309assignment3.site_user(userId)
);
DESCRIBE mealplan;

CREATE TABLE recipe (
  recipeId INT NOT NULL,
  name VARCHAR(100),
  recipecol TEXT NOT NULL,
  cookTimeMin INT NOT NULL,
  recipecol1 VARCHAR(100),
  PRIMARY KEY (recipeId)
);
DESCRIBE recipe;

CREATE TABLE dietary_restrictions (
  userId INT NOT NULL,
  dietaryLabel VARCHAR(100) NOT NULL,
  PRIMARY KEY (userId, dietaryLabel),
  FOREIGN KEY (userId) REFERENCES 3309assignment3.site_user(userId)
);
DESCRIBE dietary_restrictions;

CREATE TABLE ingredient_substitute (
  mealPlanId INT NOT NULL,
  originalIngredient VARCHAR(100) NOT NULL,
  substituteIngredient VARCHAR(100) NOT NULL,
  quantity INT NOT NULL,
  PRIMARY KEY (mealPlanId, originalIngredient, substituteIngredient),
  FOREIGN KEY (mealPlanId) REFERENCES 3309assignment3.mealplan(mealPlanId),
  FOREIGN KEY (originalIngredient) REFERENCES 3309assignment3.ingredients(ingredientName),
  FOREIGN KEY (substituteIngredient) REFERENCES 3309assignment3.ingredients(ingredientName)
);
DESCRIBE ingredient_substitute;


CREATE TABLE mealplan_recipies (
  mealPlanId INT NOT NULL,
  recipeId INT NOT NULL,
  PRIMARY KEY (mealPlanId, recipeId),
  FOREIGN KEY (mealPlanId) REFERENCES 3309assignment3.mealplan(mealPlanId),
  FOREIGN KEY (recipeId) REFERENCES 3309assignment3.recipe(recipeId)
);
DESCRIBE mealplan_recipies;

CREATE TABLE mealplan_shopping_list_items (
  mealPlanId INT NOT NULL,
  ingredientName VARCHAR(100) NOT NULL,
  quantity VARCHAR(100),
  PRIMARY KEY (mealPlanId, ingredientName),
  FOREIGN KEY (mealPlanId) REFERENCES 3309assignment3.mealplan(mealPlanId)
);
DESCRIBE mealplan_shopping_list_items;

CREATE TABLE pantry_items (
  pantryUsersId INT NOT NULL,
  pantryItemName VARCHAR(100) NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  expieryDate DATETIME,
  PRIMARY KEY (pantryUsersId, pantryItemName),
  FOREIGN KEY (pantryItemName) REFERENCES 3309assignment3.ingredients(ingredientName),
  FOREIGN KEY (pantryUsersId) REFERENCES 3309assignment3.site_user(userId)
);
DESCRIBE pantry_items;


CREATE TABLE recipe_ingredients (
  recipeId INT NOT NULL,
  ingredientName VARCHAR(100) NOT NULL,
  quantity INT NOT NULL,
  PRIMARY KEY (recipeId, ingredientName),
  FOREIGN KEY (ingredientName) REFERENCES 3309assignment3.ingredients(ingredientName),
  FOREIGN KEY (recipeId) REFERENCES 3309assignment3.recipe(recipeId)
);
DESCRIBE recipe_ingredients;

CREATE TABLE recipe_tags (
  taggedRecipeId INT NOT NULL,
  tag VARCHAR(100) NOT NULL,
  PRIMARY KEY (taggedRecipeId),
  FOREIGN KEY (taggedRecipeId) REFERENCES 3309assignment3.recipe(recipeId)
);
DESCRIBE recipe_tags;



CREATE TABLE user_allergies (
  userId INT NOT NULL,
  allergy VARCHAR(100) NOT NULL,
  PRIMARY KEY (userId, allergy),
  CONSTRAINT allergies_userId FOREIGN KEY (userId) REFERENCES site_user(userId)
);
DESCRIBE user_allergies;


