import requests
import random
import unicodedata
from datetime import datetime, timedelta
from typing import List, Dict, Any

# -----------------------------
# CONFIG
# -----------------------------

NUM_USERS = 300
NUM_INGREDIENTS = 2000
NUM_RECIPES_TOTAL = 3000
NUM_RECIPES_FROM_API = 400

OPENFOODFACTS_SEARCH_URL = "https://world.openfoodfacts.org/cgi/search.pl"

# -----------------------------
# HELPERS
# -----------------------------

def sql_escape(s: str) -> str:
    return s.replace("'", "''")

def safe_int(value, default=0) -> int:
    try:
        if value is None:
            return default
        return int(round(float(value)))
    except:
        return default

def normalize_name(s: str) -> str:
    """Normalize product names for duplicate detection."""
    # Remove accents (é→e, ç→c, etc.)
    s = unicodedata.normalize("NFKD", s)
    s = "".join(c for c in s if not unicodedata.combining(c))

    # lowercase
    s = s.lower()

    # Remove punctuation
    for ch in ["'", '"', "-", "_", ".", ",", "(", ")", "/", "\\", "*", ":"]:
        s = s.replace(ch, " ")

    # Collapse extra spaces
    s = " ".join(s.split())

    return s.strip()

# -----------------------------
# FETCH INGREDIENTS
# -----------------------------

def fetch_openfoodfacts_products(max_items: int) -> List[Dict[str, Any]]:
    collected = []
    page = 1
    page_size = 100
    seen_names = set()

    print(f"Fetching up to {max_items} products...")

    while len(collected) < max_items:
        params = {
            "action": "process",
            "page_size": page_size,
            "page": page,
            "json": 1,
            "fields": (
                "product_name,brands,categories,"
                "energy-kcal_100g,proteins_100g,carbohydrates_100g,fat_100g"
            )
        }

        resp = requests.get(OPENFOODFACTS_SEARCH_URL, params=params, timeout=20)
        data = resp.json()
        products = data.get("products", [])

        if not products:
            print("No more API results.")
            break

        for p in products:
            name = p.get("product_name") or p.get("brands")
            if not name:
                continue

            # Strong duplicate filtering
            normalized = normalize_name(name)
            if normalized in seen_names:
                continue
            seen_names.add(normalized)

            nutr = p
            kcal = safe_int(nutr.get("energy-kcal_100g"))
            prot = safe_int(nutr.get("proteins_100g"))
            carbs = safe_int(nutr.get("carbohydrates_100g"))
            fat = safe_int(nutr.get("fat_100g"))

            # Skip cases where all nutrients = zero, they are useless
            if kcal == 0 and prot == 0 and carbs == 0 and fat == 0:
                continue

            categories = p.get("categories") or ""
            first_cat = categories.split(",")[0].strip() if categories else "Unknown"

            collected.append({
                "name": name.strip(),
                "category": first_cat if first_cat else "Unknown",
                "calories": kcal,
                "protein": prot,
                "carbs": carbs,
                "fats": fat
            })

            if len(collected) >= max_items:
                break

        print(f"Collected {len(collected)} so far...")
        page += 1

    print(f"Final ingredient count: {len(collected)}")
    return collected

# -----------------------------
# GENERATE USERS
# -----------------------------

def generate_users(n: int):
    first_names = [
        "Mohammad","Sara","Ali","Fatima","Omar","Aisha","Liam","Noah","Emma",
        "Sophia","Lucas","Mia","James","Olivia","Amir","Chen","Mei","Raj",
        "Simran","Diego","Maria","Youssef","Layla","Hassan"
    ]
    last_names = [
        "Khan","Patel","Smith","Chen","Nguyen","Garcia","Brown",
        "Hassan","Singh","Ali","Hammad","Lee","Lopez","Santos","Kim",
        "Wang","Hernandez","Ivanov"
    ]

    users = []
    base_date = datetime(2025,1,1)

    for user_id in range(1, n+1):
        fn = random.choice(first_names)
        ln = random.choice(last_names)
        email = f"user{user_id}@mealapp.com"
        start = base_date + timedelta(days=random.randint(0,120))

        users.append({
            "userId": user_id,
            "firstName": fn,
            "lastName": ln,
            "email": email,
            "startDate": start.strftime("%Y-%m-%d"),
            "dailyCalories": random.randint(1500,3500),
            "dailyProtein": random.randint(50,200),
            "dailyCarbs": random.randint(100,400),
            "dailyFat": random.randint(40,120)
        })

    return users

# -----------------------------
# GENERATE RECIPES
# -----------------------------

def generate_recipes(ingredients):
    recipes = []
    recipe_id = 1

    # API recipes
    for item in ingredients[:NUM_RECIPES_FROM_API]:
        nm = item["name"]
        recipes.append({
            "recipeId": recipe_id,
            "name": nm[:100],
            "instructions": f"Prepared meal based on {nm}.",
            "cookTime": random.randint(5,60),
            "tag": "api_meal"
        })
        recipe_id += 1

    # Synthetic recipes
    while recipe_id <= NUM_RECIPES_TOTAL:
        ing1 = random.choice(ingredients)
        ing2 = random.choice(ingredients)
        ing3 = random.choice(ingredients)

        rec_name = (
            f"{ing1['name'].split()[0]} "
            f"{ing2['name'].split()[0]} "
            f"{ing3['name'].split()[0]} Bowl"
        )[:100]

        recipes.append({
            "recipeId": recipe_id,
            "name": rec_name,
            "instructions": f"Combine {ing1['name']}, {ing2['name']}, {ing3['name']}. Cook until done.",
            "cookTime": random.randint(10,45),
            "tag": random.choice(["high_protein","quick","vegan","mealprep","lowcarb"])
        })
        recipe_id += 1

    return recipes

# -----------------------------
# WRITE SQL
# -----------------------------

def write_users_sql(users, filename="users_generated.sql"):
    with open(filename,"w",encoding="utf-8") as f:
        f.write("-- Auto-generated users\n\n")
        for u in users:
            f.write(
                "INSERT INTO site_user "
                "(userId, firstName, lastName, email, startDate, endDate, dailyCalories, dailyProtein, dailyCarbs, dailyFat) VALUES "
                f"({u['userId']}, '{sql_escape(u['firstName'])}', '{sql_escape(u['lastName'])}', "
                f"'{sql_escape(u['email'])}', '{u['startDate']}', NULL, "
                f"{u['dailyCalories']}, {u['dailyProtein']}, {u['dailyCarbs']}, {u['dailyFat']}"
                ");\n"
            )
    print("✔ users_generated.sql written.")

def write_ingredients_sql(ingredients, filename="ingredients_generated.sql"):
    with open(filename,"w",encoding="utf-8") as f:
        f.write("-- Auto-generated ingredients\n\n")
        for item in ingredients:
            f.write(
                "INSERT INTO ingredients "
                "(ingredientName, category, measurementUnit, unitShorthand, calories, protein, carbs, fats) VALUES "
                f"('{sql_escape(item['name'][:100])}', '{sql_escape(item['category'][:100])}', "
                "'100 grams', 'g', "
                f"{item['calories']}, {item['protein']}, {item['carbs']}, {item['fats']}"
                ");\n"
            )
    print("✔ ingredients_generated.sql written.")

def write_recipes_sql(recipes, filename="recipes_generated.sql"):
    with open(filename,"w",encoding="utf-8") as f:
        f.write("-- Auto-generated recipes\n\n")
        for r in recipes:
            f.write(
                "INSERT INTO recipe "
                "(recipeId, name, recipecol, cookTimeMin, recipecol1) VALUES "
                f"({r['recipeId']}, '{sql_escape(r['name'])}', "
                f"'{sql_escape(r['instructions'])}', {r['cookTime']}, '{sql_escape(r['tag'])}'"
                ");\n"
            )
    print("✔ recipes_generated.sql written.")

# -----------------------------
# MAIN
# -----------------------------

def main():
    users = generate_users(NUM_USERS)
    write_users_sql(users)

    ingredients = fetch_openfoodfacts_products(NUM_INGREDIENTS)
    write_ingredients_sql(ingredients)

    recipes = generate_recipes(ingredients)
    write_recipes_sql(recipes)

    print("\n🎉 Done. Generated:")
    print(" - users_generated.sql")
    print(" - ingredients_generated.sql")
    print(" - recipes_generated.sql")

if __name__ == "__main__":
    main()
