import Foundation

class RecipeDatabase {
    static let shared = RecipeDatabase()
    
    let recipes: [RecipeModel] = [
        RecipeModel(
            title: "Tuscan Sun Poached Egg Toast",
            description: "A gourmet breakfast staple featuring artisanal sourdough, creamy Hass avocados, and a perfectly poached egg with a silken yolk.",
            image: "https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=800",
            time: "15 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1 thick slice of high-quality sourdough bread",
                "1/2 ripe Hass avocado, pitted and peeled",
                "1 farm-fresh large organic egg",
                "1 tsp fresh lemon juice (for the avocado)",
                "1/4 tsp crushed Aleppo pepper or chili flakes",
                "Maldon sea salt and freshly cracked black pepper",
                "1 tsp white distilled vinegar (for the poaching water)",
                "A handful of microgreens or fresh arugula for garnish",
                "A drizzle of extra virgin olive oil"
            ],
            instructions: [
                "**The Water Preparation**: Fill a medium saucepan about two-thirds full of filtered water. Bring it to a gentle simmer (not a rolling boil). Stir in the white vinegar—this helps the egg whites coagulate quickly without creating thin wisps.",
                "**The Egg Technique**: Crack your cold egg into a fine-mesh sieve over a small bowl to drain away the watery part of the white (this ensures a neat shape). Gently slide the egg from the sieve into an individual ramekin.",
                "**Poaching**: Use a spoon to create a very gentle whirlpool in the simmering water. Carefully drop the egg into the center. Set a timer for 3 minutes for a perfectly runny yolk, or 4 minutes for a jammy consistency. Do not crowd the pan.",
                "**Toasting**: While the egg is poaching, toast your sourdough in an oven or toaster until the edges are deep golden brown and the center remains slightly airy.",
                "**The Creamy Base**: In a small bowl, roughly mash the avocado with lemon juice, a pinch of sea salt, and a crack of black pepper. You want some texture, so avoid making it a smooth purée.",
                "**Assembly**: Spread the avocado mash generously over the warm toast. Use a slotted spoon to lift the poached egg from the water, dabbing the bottom with a paper towel to remove excess liquid. Place carefully atop the avocado.",
                "**Finishing Touches**: Season the egg with Maldon salt and Aleppo pepper. Crown with a few sprigs of microgreens and a final thin drizzle of olive oil. Serve immediately while the toast is warm and the yolk is liquid gold."
            ],
            nutrition: NutritionInfo(calories: 320, protein: 12, carbs: 28, fat: 18, fiber: 8, sugar: 2, sodium: 380),
            tags: ["Vegetarian", "High Fiber", "Gourmet"]
        ),
        
        RecipeModel(
            title: "Pan-Seared Atlantic Salmon & Asparagus",
            description: "Crispy-skinned salmon fillets pan-seared to perfection, served with garlic-infused asparagus and a zest of citrus.",
            image: "https://images.unsplash.com/photo-1467003909585-2f8a7270028d?w=800",
            time: "25 min",
            servings: "2",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "2 fresh Atlantic salmon fillets (approx 6oz each), skin-on",
                "1 lb young asparagus spears, woody ends trimmed",
                "3 tbsp cold unsalted butter, cubed",
                "3 cloves organic garlic, smashed and peeled",
                "1 organic lemon (half sliced, half juiced)",
                "1 tbsp grape seed oil (high smoke point)",
                "2 sprigs fresh dill",
                "Kosher salt and coarse black pepper"
            ],
            instructions: [
                "**Preparation**: Pat the salmon fillets completely dry with paper towels. This is the secret to crispy skin! Season both sides liberally with kosher salt and pepper.",
                "**The Sear**: Heat the grape seed oil in a heavy-bottomed stainless steel or cast-iron skillet over medium-high heat. Wait until the oil is shimmering but not smoking.",
                "**Cooking the Fish**: Place the salmon fillets in the pan, skin-side down. Press down gently with a spatula for 10 seconds to ensure even contact. Allow to cook undisturbed for 5-6 minutes until the skin is golden and crispy and the flesh has cooked about halfway up.",
                "**The Flip**: Carefully flip the fillets. Immediately add the butter, smashed garlic, and dill sprigs to the pan. Tilting the pan, use a spoon to continuously baste the salmon with the foaming garlic butter for the final 2 minutes of cooking.",
                "**Resting**: Move the salmon to a warm plate and pour the remaining pan juices over them. Let rest while you finish the vegetables.",
                "**The Asparagus**: In the same pan (keep the flavorful butter!), add the asparagus. Sauté for 3-5 minutes, tossing regularly, until they are bright green and slightly charred but still have a snap.",
                "**Serving**: Plate the asparagus first, then nestle the salmon alongside. Squeeze the fresh lemon juice over the fish and garnish with charred lemon slices. The butter should be slightly nutty and aromatic."
            ],
            nutrition: NutritionInfo(calories: 520, protein: 38, carbs: 6, fat: 34, fiber: 4, sugar: 1, sodium: 450),
            tags: ["Keto", "High Protein", "Gluten Free"]
        ),
        
        RecipeModel(
            title: "Mediterranean Quinoa Zest Bowl",
            description: "A vibrant, refreshing plant-based bowl bursting with colors, textures, and Mediterranean aromatics.",
            image: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800",
            time: "20 min",
            servings: "2",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "1 cup white or tri-color quinoa",
                "1/2 cup organic chickpeas, roasted with cumin",
                "2 cups baby spinach leaves",
                "1/2 English cucumber, quartered and sliced",
                "1/2 cup heirloom cherry tomatoes, halved",
                "2 tbsp brined Kalamata olives, pitted",
                "3 tbsp sheep's milk feta cheese, crumbled",
                "Dressing: 2 tbsp EVOO, 1 tbsp champagne vinegar, 1 tsp Dijon mustard, dried oregano"
            ],
            instructions: [
                "**Quinoa Foundation**: Rinse quinoa thoroughly in a fine-mesh strainer. Combine with 2 cups water in a pot, bring to a boil, then cover and simmer for 15 minutes. Fluff with a fork and let cool slightly to keep the spinach from wilting.",
                "**Chickpea Prep**: Toss chickpeas with a touch of olive oil and cumin. If you have time, roast them at 400°F for 10 minutes for extra crunch, otherwise use them fresh.",
                "**The Emulsion**: In a small mason jar, combine the extra virgin olive oil, champagne vinegar, Dijon mustard, and a pinch of dried oregano. Shake vigorously until the dressing is creamy and fully emulsified.",
                "**The Build**: In two large wide bowls, create a bed of baby spinach. Layer the fluffy quinoa in the center, then arrange the cucumber, tomatoes, and chickpeas in distinct sections around the perimeter.",
                "**Finishing**: Scatter the Kalamata olives and crumbled feta over the top. Drizzle the dressing evenly over each bowl just before serving to maintain the crispness of the vegetables."
            ],
            nutrition: NutritionInfo(calories: 410, protein: 15, carbs: 48, fat: 16, fiber: 10, sugar: 4, sodium: 620),
            tags: ["Vegetarian", "Meal Prep", "High Fiber"]
        ),
        
        RecipeModel(
            title: "Midnight Berry Protein Elixir",
            description: "A restorative, antioxidant-rich smoothie designed for post-workout recovery or a nutrient-dense snack.",
            image: "https://images.unsplash.com/photo-1553530979-7ee52a2670c4?w=800",
            time: "5 min",
            servings: "1",
            difficulty: "Easy",
            category: "Snacks",
            ingredients: [
                "1 cup frozen wild blueberries (higher antioxidant content)",
                "1/2 organic frozen banana (for creaminess)",
                "1 scoop (30g) grass-fed whey or pea protein isolate",
                "1.5 cups unsweetened cashew or almond milk",
                "1 tbsp raw almond butter",
                "1 tsp hemp seeds",
                "A pinch of Ceylon cinnamon"
            ],
            instructions: [
                "**Order of Operations**: To prevent the protein powder from sticking to the sides, always add your liquid (cashew milk) to the blender base first.",
                "**The Core**: Add the frozen berries and banana. Using frozen fruit eliminates the need for ice, which can dilute the flavor.",
                "**The Boosters**: Add the protein powder, almond butter, and a dash of cinnamon. Cinnamon helps regulate blood sugar response.",
                "**The Blend**: Start the blender on the lowest setting to break up the frozen fruit, then quickly ramp up to high speed. Blend for a full 60 seconds to achieve a velvety, 'elixir-like' consistency.",
                "**Presentation**: Pour into a chilled glass and sprinkle the hemp seeds on top for a subtle nutty crunch and a boost of Omega-3s."
            ],
            nutrition: NutritionInfo(calories: 310, protein: 28, carbs: 24, fat: 11, fiber: 7, sugar: 10, sodium: 180),
            tags: ["High Protein", "Smoothie", "Antioxidant"]
        ),
        
        // --- NEW RECIPES (1-25) ---
        
        RecipeModel(
            title: "Greek Yogurt Honey Parfait",
            description: "A simple yet elegant breakfast featuring thick Greek yogurt, seasonal berries, and a crunchy walnut topping.",
            image: "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800",
            time: "10 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1 cup plain full-fat Greek yogurt",
                "1/2 cup fresh mixed berries (raspberries, blueberries, strawberries)",
                "2 tbsp raw walnut halves, lightly toasted",
                "1 tbsp wild organic honey",
                "1/4 cup artisanal honey-almond granola",
                "A pinch of ground cinnamon",
                "Fresh mint sprig for garnish"
            ],
            instructions: [
                "**Yogurt Preparation**: In a small bowl, whisk the Greek yogurt with a pinch of cinnamon until light and smooth. This breaks up any curds and aerates the yogurt for a more luxurious mouthfeel.",
                "**Toasting the Nuts**: Place the walnut halves in a dry skillet over medium heat. Toast for 2-3 minutes, shaking the pan constantly, until they become fragrant and slightly golden. Let them cool before roughly chopping.",
                "**The Foundation**: Place half of the cinnamon-whisked yogurt into the bottom of a clear glass or parfait jar. Use a spoon to smooth it into an even layer.",
                "**The Fruit & Crunch Layer**: Add half of the fresh berries, followed by a layer of granola and half of the chopped walnuts. This ensures every spoonful has a balance of textures.",
                "**Completion**: Top with the remaining yogurt, then pile the rest of the berries and walnuts on top. Finish with a final scattering of granola for peak crunch.",
                "**The Finishing Shine**: Drizzle the honey in a thin stream over the entire parfait. Garnish with a fresh mint leaf and serve immediately while the granola is at its crispest."
            ],
            nutrition: NutritionInfo(calories: 340, protein: 18, carbs: 32, fat: 14, fiber: 5, sugar: 18, sodium: 80),
            tags: ["Vegetarian", "High Protein", "Quick"]
        ),
        
        RecipeModel(
            title: "Sweet Potato Breakfast Burrito",
            description: "A hearty and nutritious start to your day with roasted sweet potatoes, black beans, and scrambled eggs.",
            image: "https://images.unsplash.com/photo-1547050605-2f129ac7590d?w=800",
            time: "30 min",
            servings: "2",
            difficulty: "Medium",
            category: "Breakfast",
            ingredients: [
                "2 large whole-wheat or flour tortillas",
                "1 medium sweet potato, peeled and diced into 1/2-inch cubes",
                "1/2 cup organic black beans, rinsed and drained",
                "3 large pasture-raised eggs",
                "1/4 cup chunky garden salsa",
                "1/2 ripe Hass avocado, sliced",
                "1/2 tsp ground cumin",
                "1/2 tsp smoked paprika",
                "1 tbsp olive oil",
                "1/4 cup shredded Monterey Jack cheese",
                "Fresh cilantro for garnish"
            ],
            instructions: [
                "**Roasted Sweet Potatoes**: Preheat your oven to 400°F (200°C). Toss the sweet potato cubes with olive oil, cumin, smoked paprika, salt, and pepper on a parchment-lined baking sheet. Roast for 20-25 minutes, tossing halfway through, until edges are caramelized and centers are tender.",
                "**The Black Beans**: While the potatoes are roasting, place the black beans in a small saucepan with a splash of water and a pinch of cumin. Heat over medium-low until warmed through, then set aside.",
                "**Perfect Scramble**: Crack the eggs into a bowl and whisk thoroughly with a splash of milk or water. Heat a non-stick skillet over medium-low heat with a tiny bit of butter or oil. Pour in the eggs and use a silicone spatula to gently fold the curds until they are just set but still glossy.",
                "**Warming the Tortillas**: Quickly warm the tortillas in a dry pan or directly over a low flame for 10-15 seconds per side until pliable and slightly charred.",
                "**The Assembly**: Lay a warm tortilla flat. Place a layer of Monterey Jack cheese in the center, followed by a generous portion of roasted sweet potatoes, black beans, and scrambled eggs.",
                "**The Finish**: Top with avocado slices and a spoonful of salsa. Fold in the sides and roll up tightly. For an extra premium touch, sear the rolled burrito in a hot pan for 30 seconds on each side to seal the seam and melt the cheese completely."
            ],
            nutrition: NutritionInfo(calories: 480, protein: 24, carbs: 58, fat: 20, fiber: 12, sugar: 4, sodium: 550),
            tags: ["High Fiber", "Nutritious", "Hearty"]
        ),
        
        RecipeModel(
            title: "Classic Shakshuka",
            description: "Eggs poached in a savory tomato and bell pepper sauce, spiced with cumin and paprika.",
            image: "https://images.unsplash.com/photo-1590412200988-a436bb7050a4?w=800",
            time: "35 min",
            servings: "2",
            difficulty: "Medium",
            category: "Breakfast",
            ingredients: [
                "4 large organic eggs",
                "1 can (14.5 oz) crushed San Marzano tomatoes",
                "1 red bell pepper, diced small",
                "1 yellow onion, finely chopped",
                "3 cloves garlic, minced",
                "1 tsp ground cumin",
                "1 tsp smoked paprika",
                "1/2 tsp chili powder or harissa paste",
                "2 tbsp extra virgin olive oil",
                "1/4 cup fresh parsley and cilantro, chopped",
                "2 tbsp feta cheese, crumbled (optional)",
                "Warm pita or crusty bread for serving"
            ],
            instructions: [
                "**The Base Aromatics**: Heat the olive oil in a large deep skillet or cast-iron pan over medium heat. Add the chopped onion and bell pepper. Sauté for 8-10 minutes until the onion is translucent and the peppers have softened significantly.",
                "**Blooming the Spices**: Add the minced garlic, cumin, smoked paprika, and chili powder to the pan. Stir constantly for 1-2 minutes until the spices are fragrant and have toasted slightly in the oil.",
                "**Developing the Sauce**: Pour in the crushed tomatoes and stir well to combine. Reduce heat to low and simmer for 15-20 minutes, allowing the sauce to thicken and the flavors to meld. If the sauce becomes too dry, add a splash of water.",
                "**The Poaching**: Use the back of a large spoon to make four small 'wells' in the tomato sauce. Carefully crack one egg into each well. Season the eggs individually with a tiny pinch of salt and pepper.",
                "**Finishing the Eggs**: Cover the skillet with a lid. Cook for 5-8 minutes, or until the egg whites are fully set but the yolks remain liquid and bright yellow. Watch carefully to avoid overcooking the yolks.",
                "**Garnish and Serve**: Remove from heat. Scatter the fresh herbs and crumbled feta over the top. Serve the pan directly at the table with warm pita or thick slices of sourdough to soak up the savory sauce and runny yolks."
            ],
            nutrition: NutritionInfo(calories: 340, protein: 18, carbs: 22, fat: 18, fiber: 6, sugar: 8, sodium: 620),
            tags: ["Vegetarian", "One-Pan", "Mediterranean"]
        ),
        
        RecipeModel(
            title: "Lemon Poppy Seed Pancakes",
            description: "Zesty and fluffy protein pancakes that taste like a treat but fuel your morning.",
            image: "https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=800",
            time: "20 min",
            servings: "2",
            difficulty: "Medium",
            category: "Breakfast",
            ingredients: [
                "1 cup finely ground oat flour",
                "1 scoop (30g) vanilla whey or plant-based protein powder",
                "1 organic lemon, zest and 1 tbsp juice",
                "1 tbsp blue poppy seeds",
                "1 large egg",
                "1/2 cup unsweetened almond or soy milk",
                "1/2 tsp baking powder",
                "1/2 tsp pure vanilla extract",
                "1 tbsp maple syrup (plus extra for serving)",
                "Fresh blueberries for topping"
            ],
            instructions: [
                "**Mixing the Batter**: In a large mixing bowl, whisk together the oat flour, protein powder, poppy seeds, and baking powder. Creating a uniform dry mix prevents lumps in the final batter.",
                "**The Wet Elements**: In a separate bowl, whisk the egg, almond milk, lemon juice, lemon zest, vanilla extract, and maple syrup until fully combined and slightly frothy.",
                "**Uniting the Mix**: Slowly pour the wet ingredients into the dry bowl. Stir gently with a whisk or fork just until the flour is incorporated. Do not over-mix; the batter should be thick but pourable. Let the batter rest for 5 minutes—this allows the oat flour to hydrate for fluffier pancakes.",
                "**Griddle Prep**: Heat a non-stick griddle or large pan over medium-low heat. Lightly coat with a small amount of coconut oil or butter. Wipe away excess so only a thin film remains.",
                "**Cooking Technique**: Pour roughly 1/4 cup of batter per pancake. Cook for 2-3 minutes until the edges look dry and small bubbles form on the surface. Carefully flip and cook for another 1-2 minutes until golden brown on both sides.",
                "**Plating**: Stack the pancakes high. Top with a handful of fresh blueberries, a final dusting of lemon zest, and a light drizzle of warm maple syrup. Serve immediately while warm and fragrant."
            ],
            nutrition: NutritionInfo(calories: 395, protein: 29, carbs: 44, fat: 10, fiber: 6, sugar: 8, sodium: 210),
            tags: ["High Protein", "Zesty", "Healthy Indulgence"]
        ),
        
        RecipeModel(
            title: "Smoked Salmon Bagel",
            description: "The ultimate deli classic: toasted whole wheat bagel with creamy schmear and premium smoked salmon.",
            image: "https://images.unsplash.com/photo-1510431198580-7727c9fa1e3a?w=800",
            time: "10 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1 large sprouted or whole-wheat bagel",
                "3 oz premium thin-sliced smoked Atlantic salmon (Nova style)",
                "2 tbsp whipped cream cheese (low-fat or regular)",
                "1 tsp non-pareil capers, drained",
                "2 paper-thin rings of red onion",
                "1/2 tsp fresh dill sprigs",
                "A squeeze of fresh lemon wedge",
                "Freshly cracked black pepper"
            ],
            instructions: [
                "**The Bagel Toast**: Slice your bagel perfectly down the middle. Toast until the edges are deep golden and the inner surface has a slight crispiness but the core remains chewy. Warm bagels are essential for the cream cheese to spread beautifully.",
                "**The Schmear**: Spread exactly one tablespoon of cream cheese generously over each toasted half. Use a butter knife to create a smooth, even layer from edge to edge.",
                "**Layering the Salmon**: Gently drape the smoked salmon slices over the cream cheese on both halves. Create small 'ribbons' or folds with the salmon to add height and a better textural experience.",
                "**The Garnishes**: Lay the red onion rings on top of the salmon. Scatter the capers evenly over the bagel. If the onion is too pungent, you can soak the slices in ice water for 5 minutes before using.",
                "**Flavor Accents**: Sprinkle the fresh dill sprigs and a generous amount of freshly cracked black pepper. Avoid adding salt, as the salmon and capers are naturally savory.",
                "**Final Touch**: Finish with a bright squeeze of lemon over the salmon to cut through the richness of the cream cheese. Close the bagel or serve it open-faced for a truly premium aesthetic."
            ],
            nutrition: NutritionInfo(calories: 440, protein: 26, carbs: 48, fat: 14, fiber: 7, sugar: 4, sodium: 850),
            tags: ["Omega-3", "Classic", "High Protein"]
        ),
        
        RecipeModel(
            title: "Coconut Mango Chia Pudding",
            description: "Tropical and refreshing, this chia pudding is perfect for a grab-and-go morning.",
            image: "https://images.unsplash.com/photo-1516746875771-46487e834633?w=800",
            time: "10 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "3 tbsp organic black or white chia seeds",
                "1 cup unsweetened light coconut milk or almond-coconut blend",
                "1/2 cup fresh diced Kensington Pride or Manila mango",
                "1 tbsp unsweetened toasted coconut flakes",
                "1 tsp pure maple syrup or agave",
                "1/4 tsp pure vanilla bean extract"
            ],
            instructions: [
                "**Combining the Base**: In a medium glass jar or airtight container, combine the chia seeds, coconut milk, maple syrup, and vanilla extract. Use a whisk or fork to stir vigorously for 1 full minute to ensure the seeds don't clump at the bottom.",
                "**The Initial Soak**: Let the mixture sit at room temperature for about 10 minutes. Stir it once more after this time—this second stir is the secret to a perfectly smooth pudding without large lumps of seeds.",
                "**Hydration**: Secure the lid and place the jar in the refrigerator. Let it set for at least 4 hours, though overnight is ideal for the creamiest, most custard-like consistency.",
                "**Preparing the Fruit**: While the pudding sets, dice your fresh mango into uniform 1/2-inch cubes. If the mango is extremely ripe, you can mash a small portion of it to swirl into the pudding.",
                "**Toasting the Garnish**: In a small dry pan over low heat, toast the coconut flakes for 1-2 minutes until the edges are golden brown. Watch them carefully as they burn quickly.",
                "**Assembling**: Give the pudding a final stir. Top with a generous mound of fresh mango cubes and scatter the toasted coconut flakes over the top. The contrast of the cool, creamy pudding and the tropical fruit is the highlight of this dish."
            ],
            nutrition: NutritionInfo(calories: 360, protein: 8, carbs: 42, fat: 18, fiber: 14, sugar: 12, sodium: 60),
            tags: ["Vegan", "Gluten-Free", "Meal Prep"]
        ),
        
        RecipeModel(
            title: "Mediterranean Omelet",
            description: "A flavor-packed omelet with spinach, feta cheese, and savory Kalamata olives.",
            image: "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800",
            time: "15 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "3 large pasture-raised eggs",
                "1 cup fresh organic baby spinach",
                "2 tbsp crumbled Greek feta cheese",
                "5-6 Kalamata olives, pitted and sliced",
                "1 tsp extra virgin olive oil",
                "1 tbsp chopped sun-dried tomatoes (in oil)",
                "A pinch of dried oregano"
            ],
            instructions: [
                "**Egg Preparation**: Crack the eggs into a small bowl. Add a tiny splash of water (this creates steam for fluffier eggs) and dried oregano. Whisk until the whites and yolks are completely integrated and no streaks remain.",
                "**Wilting the Greens**: Heat the olive oil in a medium non-stick skillet over medium-low heat. Add the baby spinach and sun-dried tomatoes. Sauté for 1-2 minutes until the spinach is just wilted and the tomatoes are fragrant.",
                "**The Omelet Base**: Pour the whisked eggs over the vegetables. Use a silicone spatula to gently push the cooked edges toward the center, tilting the pan to let the raw egg fill the gaps. Do this for about 1 minute until the bottom is set but the top is still slightly moist.",
                "**The Filling**: Sprinkle the sliced Kalamata olives and the crumbled feta cheese evenly over one half of the omelet. Do not overstuff, or the omelet will tear when folding.",
                "**The Fold**: Carefully slide the spatula under the 'empty' half of the omelet and fold it over the filling. Turn the heat down to the lowest setting and cover the pan with a lid for 30 seconds to help the feta soften.",
                "**Serving**: Gently slide the omelet onto a warm plate. Garnish with a final pinch of fresh herbs if desired. The center should be tender and the feta slightly creamy against the salty olives and bright tomatoes."
            ],
            nutrition: NutritionInfo(calories: 330, protein: 21, carbs: 6, fat: 26, fiber: 2, sugar: 2, sodium: 580),
            tags: ["Low Carb", "Keto", "High Protein"]
        ),
        
        RecipeModel(
            title: "Grilled Chicken Caesar Wrap",
            description: "Savory grilled chicken, crisp romaine, and Caesar dressing wrapped in a spinach tortilla.",
            image: "https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=800",
            time: "20 min",
            servings: "1",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "1 large spinach or whole-wheat tortilla",
                "5 oz organic chicken breast, grilled and sliced",
                "1.5 cups crisp romaine lettuce, coarsely chopped",
                "2 tbsp high-quality Caesar dressing",
                "1 tbsp aged Parmesan cheese, shaved or grated",
                "1 tbsp seasoned croutons, lightly crushed (optional)",
                "Black pepper to taste"
            ],
            instructions: [
                "**Preparing the Protein**: If not already cooked, season the chicken breast with salt, pepper, and a touch of garlic powder. Grill for 6-7 minutes per side over medium-high heat until the internal temperature reaches 165°F. Let it rest for 5 minutes before slicing into thin strips.",
                "**The Salad Base**: In a medium bowl, toss the chopped romaine lettuce with the Caesar dressing, Parmesan cheese, and crushed croutons. Ensure the leaves are evenly coated, but not overly saturated, to prevent the wrap from becoming soggy.",
                "**Warming the Wrap**: Briefly heat the spinach tortilla in a dry pan or microwave for 10 seconds. This makes the tortilla more flexible and less likely to tear during rolling.",
                "**The Build**: Lay the warm tortilla flat. Arrange the sliced chicken breast in a vertical line down the center of the tortilla. Piling the protein first helps create a solid core for the wrap.",
                "**Folding and Rolling**: Heap the dressed Caesar salad on top of the chicken. Fold the bottom edge of the tortilla up over the filling, tuck in the sides, and then roll tightly from the bottom to the top.",
                "**The Finishing Sear**: Place the rolled wrap in a hot dry pan, seam-side down, for 30 seconds. This 'welds' the wrap shut and gives the exterior a subtle, appetizing crunch. Slice diagonally in half and serve immediately."
            ],
            nutrition: NutritionInfo(calories: 430, protein: 36, carbs: 32, fat: 20, fiber: 4, sugar: 3, sodium: 720),
            tags: ["High Protein", "Meal Prep", "Lunch-on-the-go"]
        ),
        
        RecipeModel(
            title: "Quinoa Kale Power Salad",
            description: "A nutrient-dense bowl with fluffy quinoa, massaged kale, and roasted chickpeas.",
            image: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800",
            time: "15 min",
            servings: "2",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "1 cup pre-cooked and chilled white quinoa",
                "2 cups curly or Lacinato kale, stems removed and finely chopped",
                "1/2 cup organic chickpeas, roasted until crispy",
                "1 fresh lemon, juiced",
                "1 tbsp extra virgin olive oil",
                "1 tbsp toasted pumpkin seeds (pepitas)",
                "1/4 tsp sea salt and a pinch of chili flakes"
            ],
            instructions: [
                "**Massaging the Kale**: This is the most crucial step! Place the chopped kale in a large bowl with the olive oil, lemon juice, and sea salt. Use your clean hands to 'massage' the leaves for 2-3 minutes. You'll notice the kale shrinking in volume, becoming darker green and significantly more tender as the cell walls break down.",
                "**Fluffing the Quinoa**: Use a fork to fluff your chilled quinoa, ensuring there are no large clumps. It's important that the quinoa is cool to maintain the crisp texture of the other ingredients.",
                "**Combining Elements**: Add the fluffed quinoa and the roasted chickpeas to the massaged kale bowl. Gently toss with a large spoon to distribute the protein and grains evenly through the greens.",
                "**Adding Texture**: Sprinkle the toasted pumpkin seeds and chili flakes over the top. The pepitas add a necessary crunch and healthy magnesium, while the chili provides a very subtle back-end warmth.",
                "**Resting**: Let the salad sit at room temperature for 10 minutes before serving. This allows the lemon and olive oil to further penetrate the quinoa and chickpeas.",
                "**Serving**: Divide into two large bowls. This salad holds up incredibly well and actually tastes better after a few hours, making it the king of meal-prep lunch options."
            ],
            nutrition: NutritionInfo(calories: 390, protein: 16, carbs: 55, fat: 14, fiber: 12, sugar: 3, sodium: 310),
            tags: ["Vegan", "Superfood", "High Fiber"]
        ),
        
        RecipeModel(
            title: "Pesto Turkey Panini",
            description: "Warm and melty turkey slices with creamy pesto and provolone on artisanal bread.",
            image: "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=800",
            time: "15 min",
            servings: "1",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "2 thick slices of artisanal sourdough or ciabatta bread",
                "4 oz high-quality oven-roasted deli turkey",
                "1 tbsp classic basil pesto (store-bought or homemade)",
                "1 thick slice of sharp provolone cheese",
                "2 thin slices of ripe beefsteak tomato",
                "1 tsp butter or olive oil (for grilling)",
                "A pinch of dried oregano"
            ],
            instructions: [
                "**The Prep**: Lay your bread slices on a clean board. Spread the basil pesto evenly on the inside of both slices. A generous coating of pesto acts as both a flavor booster and a moisture barrier.",
                "**Layering the Filling**: On one slice of bread, layer the deli turkey. Fold the slices of turkey to add volume and ensure even distribution. Top the turkey with the tomato slices and a sprinkle of dried oregano.",
                "**Melt Factor**: Place the provolone cheese directly on top of the tomatoes. The cheese should be touching the top slice of bread once closed to ensure it melts properly and 'glues' the sandwich together.",
                "**Pan Preparation**: Heat a panini press or a heavy cast-iron skillet over medium heat. Lightly butter the exterior of both slices of bread or brush them with olive oil for a cleaner finish.",
                "**The Press**: Place the sandwich in the press or pan. if using a pan, weight the sandwich down with a smaller heavy pan or a clean brick wrapped in foil. Grill for 3-4 minutes per side until the bread is deep golden and the cheese is visibly oozing from the sides.",
                "**Serving**: Remove from heat and let it rest for 60 seconds (this prevents the filling from sliding out when cutting). Slice diagonally to showcase the colorful layers and serve alongside a small side salad or pickles."
            ],
            nutrition: NutritionInfo(calories: 460, protein: 30, carbs: 38, fat: 20, fiber: 3, sugar: 4, sodium: 880),
            tags: ["Warm", "Quick", "Comfort Food"]
        ),
        
        RecipeModel(
            title: "Red Lentil Soup",
            description: "Comforting and filling lentil soup spiced with turmeric and ginger, finished with a squeeze of fresh lime.",
            image: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800",
            time: "35 min",
            servings: "4",
            difficulty: "Medium",
            category: "Lunch",
            ingredients: [
                "1.5 cups organic red lentils, rinsed until water runs clear",
                "1 large yellow onion, finely diced",
                "2 medium carrots, peeled and grated",
                "4 cups low-sodium vegetable broth",
                "1 tbsp fresh ginger, grated",
                "2 cloves garlic, minced",
                "1 tsp ground turmeric",
                "1/2 tsp ground cumin",
                "1 tbsp coconut oil or ghee",
                "Fresh cilantro and lime wedges for serving"
            ],
            instructions: [
                "**The Foundation**: Heat the coconut oil in a large Dutch oven or heavy-bottomed pot over medium heat. Add the diced onion and grated carrots. Sauté for 6-8 minutes, stirring frequently, until the onions are soft and the carrots have released their natural sweetness.",
                "**Blooming Aromatics**: Stir in the grated ginger, minced garlic, turmeric, and cumin. Cook for 1-2 minutes until the spices are highly fragrant and the vegetables are coated in a vibrant yellow hue.",
                "**Simmering the Lentils**: Add the rinsed red lentils to the pot and stir to combine with the aromatics. Pour in the vegetable broth. Increase heat to bring to a gentle boil, then immediately reduce to a low simmer. Cover partially and cook for 20-25 minutes until the lentils have broken down and the soup has thickened.",
                "**Texture Refinement**: For a creamier consistency, use an immersion blender to partially blend the soup (about 4-5 pulses). You want to leave some texture while creating a velvety base.",
                "**Seasoning**: Season with salt and black pepper to taste. Red lentils absorb a lot of salt, so taste carefully.",
                "**Presentation**: Ladle the warm soup into deep bowls. Garnish generously with fresh cilantro and serve with a wedge of lime on the side. The citrus acidity is essential to balance the earthy depth of the lentils."
            ],
            nutrition: NutritionInfo(calories: 240, protein: 14, carbs: 40, fat: 4, fiber: 8, sugar: 4, sodium: 420),
            tags: ["Vegan", "Budget-Friendly", "One-Pot"]
        ),
        
        RecipeModel(
            title: "Shrimp Taco Bowl",
            description: "Zesty blackened shrimp served over a bed of cilantro-lime rice and fresh purple cabbage slaw.",
            image: "https://images.unsplash.com/photo-1534422298391-e4f8c170db06?w=800",
            time: "25 min",
            servings: "2",
            difficulty: "Medium",
            category: "Lunch",
            ingredients: [
                "1/2 lb jumbo shrimp, peeled and deveined",
                "1 cup long-grain basmati rice",
                "1/2 cup roasted corn kernels",
                "1 cup shredded purple cabbage",
                "1/4 cup fresh cilantro, finely chopped",
                "2 fresh limes (one for rice, one for serving)",
                "1 tbsp blackened seasoning (cajun/paprika/garlic)",
                "1 tbsp avocado oil",
                "1/2 ripe avocado, diced"
            ],
            instructions: [
                "**Cilantro-Lime Rice**: Rinse the rice until water is clear. Cook according to package instructions. Once done, fluff with a fork and immediately stir in the juice of one lime, 2 tablespoons of chopped cilantro, and a pinch of salt. Cover to keep warm.",
                "**Shrimp Preparation**: Pat the shrimp completely dry. Toss in a bowl with the blackened seasoning and a touch of oil until every shrimp is evenly coated in spices.",
                "**High-Heat Sear**: Heat avocado oil in a cast-iron skillet over high heat. Once shimmering, add the shrimp in a single layer. Cook for 90 seconds per side until opaque and slightly charred on the edges. Do not overcook!",
                "**Slaw Assembly**: Toss the shredded cabbage with a splash of lime juice and a dash of honey or agave to create a bright, crunchy slaw.",
                "**The Build**: Scoop a base of cilantro-lime rice into two wide bowls. Arrange the blackened shrimp on one side, followed by the roasted corn, cabbage slaw, and diced avocado.",
                "**Finishing**: Garnish with the remaining cilantro and serve with extra lime wedges. For a premium touch, drizzle with a bit of chipotle-lime crema or Greek yogurt mixed with hot sauce."
            ],
            nutrition: NutritionInfo(calories: 480, protein: 34, carbs: 62, fat: 12, fiber: 7, sugar: 4, sodium: 620),
            tags: ["Seafood", "Zesty", "High Protein"]
        ),
        
        RecipeModel(
            title: "Vietnamese Tofu Pho",
            description: "A fragrant and light slow-simmered broth with rice noodles, seared organic tofu, and a garden of fresh herbs.",
            image: "https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800",
            time: "40 min",
            servings: "2",
            difficulty: "Medium",
            category: "Lunch",
            ingredients: [
                "1 block (14 oz) extra-firm organic tofu",
                "8 oz wide flat rice noodles (Pho style)",
                "6 cups high-quality vegetable broth",
                "2 whole star anise and 1 cinnamon stick",
                "2-inch piece fresh ginger, charred and sliced",
                "1 small yellow onion, charred and halved",
                "Fresh Thai basil, bean sprouts, and cilantro",
                "1 red chili, sliced",
                "Lime wedges and Hoisin sauce for serving"
            ],
            instructions: [
                "**The Aromatic Broth**: In a dry pot, toast the star anise and cinnamon stick for 2 minutes. Add the charred ginger and onion, then pour in the vegetable broth. Bring to a boil, then simmer on low for at least 30 minutes to extract the deep spices. Strain the broth before serving.",
                "**Tofu Preparation**: Press the tofu for 15 minutes to remove excess moisture. Slice into 1/2-inch thick planks or cubes. Sear in a non-stick pan with a tiny bit of soy sauce until the exterior is golden and crispy.",
                "**Noodle Technique**: Soak the rice noodles in warm water for 20 minutes, then briefly boil for 1-2 minutes until 'al dente'. Rinse under cold water to prevent sticking.",
                "**Preparation of Garnishes**: Wash the Thai basil, cilantro, and bean sprouts. Slice the chili and lime wedges. Presentation of the herb plate is key to the Pho experience.",
                "**Assembly**: Place a generous amount of noodles in the bottom of a large deep bowl. Arrange the seared tofu on top.",
                "**The Finish**: Pour the piping hot strained broth over the noodles. The heat of the broth will finish cooking the noodles. Serve immediately with the herb plate on the side so diners can customize their aromatics and heat levels."
            ],
            nutrition: NutritionInfo(calories: 340, protein: 20, carbs: 54, fat: 8, fiber: 5, sugar: 6, sodium: 950),
            tags: ["Aromatic", "Plant-Based", "Low Fat"]
        ),
        
        RecipeModel(
            title: "Caprese Salad with Glaze",
            description: "The classic assembly of fresh mozzarella di bufala, vine-ripened beefsteak tomatoes, and a thick balsamic reduction.",
            image: "https://images.unsplash.com/photo-1592417817098-8fd3d9ebc4a5?w=800",
            time: "10 min",
            servings: "2",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "2 large vine-ripened heirloom or beefsteak tomatoes",
                "1 ball (8 oz) fresh mozzarella di bufala or Fior di Latte",
                "1 bunch fresh large-leaf Italian basil",
                "3 tbsp high-quality balsamic glaze (reduction)",
                "2 tbsp cold-pressed extra virgin olive oil",
                "Flaky Maldon sea salt and freshly ground tri-color peppercorns"
            ],
            instructions: [
                "**Tomato Slicing**: Slice the tomatoes into 1/4 inch thick rounds. Use a serrated knife for the cleanest cuts without crushing the delicate fruit.",
                "**Cheese Preparation**: Drain the mozzarella and pat dry with a paper towel. Slice into rounds of equal thickness and diameter to the tomatoes.",
                "**The Arrangement**: On a chilled flat plate, alternate slices of tomato and mozzarella in a circular or linear overlapping pattern.",
                "**Tucking the Basil**: Tuck one whole basil leaf between each 'pairing' of tomato and cheese, ensuring a bright green leaf is visible for every bite.",
                "**Seasoning for Impact**: Sprinkle the flaky sea salt and cracked pepper over the entire assembly. Seasoning the tomatoes directly is key to unlocking their sweetness.",
                "**The Final Drizzle**: Drizzle the extra virgin olive oil first (to allow it to penetrate), then follow with an artistic zigzag of the thick balsamic glaze. Serve immediately while the cheese is cool and the tomatoes are at room temperature."
            ],
            nutrition: NutritionInfo(calories: 310, protein: 14, carbs: 14, fat: 22, fiber: 2, sugar: 8, sodium: 380),
            tags: ["Vegetarian", "No-Cook", "Gluten-Free"]
        ),
        
        RecipeModel(
            title: "Beef and Broccoli Stir-Fry",
            description: "Tender flank steak strips and crisp organic broccoli in a savory, ginger-infused soy glaze.",
            image: "https://images.unsplash.com/photo-1512058560374-140fa39665c0?w=800",
            time: "25 min",
            servings: "2",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "1/2 lb flank steak, sliced very thin against the grain",
                "2 cups fresh broccoli florets",
                "1/4 cup low-sodium soy sauce or tamari",
                "1 tbsp fresh ginger, minced",
                "3 cloves garlic, thinly sliced",
                "1 tbsp avocado oil",
                "1 tsp toasted sesame oil",
                "1 tbsp cornstarch (for velvetting the beef)",
                "Toasted sesame seeds and green onions for garnish"
            ],
            instructions: [
                "**Beef Preparation (Velvetting)**: In a small bowl, toss the sliced beef with 1 tablespoon of soy sauce and the cornstarch. Let it marinate for 10 minutes—this technique ensures the beef stays incredibly tender and develops a silky coating when cooked.",
                "**Stir-Fry Sauce**: Whisk together the remaining soy sauce, sesame oil, ginger, and a splash of water in a small jar.",
                "**High-Heat Searing**: Heat a wok or large heavy skillet over high heat until just starting to smoke. Add half the avocado oil, then the beef in a single layer. Sear for 2 minutes without moving, then toss and cook for 1 more minute. Remove beef from the pan.",
                "**Working the Veggies**: Add the remaining oil to the pan. Toss in the broccoli and garlic with 2 tablespoons of water. Cover with a lid for 60 seconds to steam the broccoli to a bright green, then remove the lid and sauté until the water evaporates.",
                "**The Glaze**: Return the beef to the pan. Pour the sauce over the beef and broccoli. Toss constantly for 1-2 minutes as the sauce thickens and coats everything in a glossy, savory glaze.",
                "**Plating**: Serve immediately over steamed jasmine rice or quinoa. Garnish with a heavy sprinkle of toasted sesame seeds and finely sliced green onions for a restaurant-quality finish."
            ],
            nutrition: NutritionInfo(calories: 410, protein: 36, carbs: 20, fat: 22, fiber: 4, sugar: 4, sodium: 920),
            tags: ["High Protein", "Fast", "Asian-Inspired"]
        ),
        
        RecipeModel(
            title: "Baked Cod with Asparagus",
            description: "Light and flaky Atlantic cod fillets paired with tender-crisp roasted asparagus and preserved lemon.",
            image: "https://images.unsplash.com/photo-1544025162-d76694265947?w=800",
            time: "25 min",
            servings: "2",
            difficulty: "Easy",
            category: "Dinner",
            ingredients: [
                "2 fresh cod fillets (approx 6oz each)",
                "1 bunch fresh young asparagus, woody ends removed",
                "1 organic lemon, half-sliced and half-juiced",
                "2 tbsp cold-pressed olive oil",
                "1 tsp dried Mediterranean oregano",
                "Sea salt and cracked white pepper",
                "Fresh parsley for garnish"
            ],
            instructions: [
                "**Pan Preparation**: Preheat your oven to 400°F (200°C). Line a large rimmed baking sheet with parchment paper to prevent sticking and make cleanup easy.",
                "**Vegetable Seasoning**: Place the asparagus in a single layer on the baking sheet. Drizzle with 1 tablespoon of olive oil, salt, and pepper. Toss with your hands to ensure every spear is lightly coated.",
                "**The Fish**: Pat the cod fillets dry. Place them in the center of the baking sheet, surrounding them with the asparagus. Drizzle the fish with the remaining olive oil and lemon juice.",
                "**Flavor Layering**: Season the cod with oregano, salt, pepper, and place two lemon slices on top of each fillet. This protects the delicate flesh from the direct heat and infuses it with citrus oils.",
                "**The Bake**: Roast in the oven for 12-15 minutes. The asparagus should be tender-crisp and the cod should be opaque and flake easily when tested with a fork.",
                "**Final Touches**: Garnish with freshly chopped parsley and an extra drizzle of finishing oil. This one-pan meal is the epitome of clean, high-protein eating with minimal effort."
            ],
            nutrition: NutritionInfo(calories: 290, protein: 32, carbs: 8, fat: 14, fiber: 4, sugar: 2, sodium: 340),
            tags: ["Low Calorie", "Healthy", "One-Pan"]
        ),
        
        RecipeModel(
            title: "Pasta Carbonara",
            description: "An authentic Roman masterpiece: pasta tossed with golden egg yolks, sharp Pecorino Romano, and crispy Guanciale.",
            image: "https://images.unsplash.com/photo-1612874742237-6526221588e3?w=800",
            time: "20 min",
            servings: "2",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "1/2 lb high-quality bronze-die Spaghetti",
                "3 large egg yolks plus 1 whole egg (at room temperature)",
                "2 oz aged Pecorino Romano, finely grated",
                "4 oz Guanciale (cured pork jowl) or pancetta, diced",
                "2 tsp freshly toasted and cracked black peppercorns",
                "Reservation of pasta cooking water"
            ],
            instructions: [
                "**Pasta Discipline**: Bring a large pot of water to a boil. Salt it generously ('like the sea'). Add the spaghetti and cook until just shy of al dente (about 1-2 minutes less than the package instructions).",
                "**Crisping the Pork**: While the pasta is cooking, place the diced guanciale in a cold large skillet. Turn the heat to medium and cook slowly until the fat has rendered and the pork bits are golden and crispy. Turn off the heat.",
                "**The Creamy Emulsion**: In a small bowl, whisk the egg yolks, whole egg, and grated Pecorino together until it forms a thick paste. Add a few cracks of pepper to this mixture.",
                "**The Marriage**: Once cooked, use tongs to transfer the hot pasta directly from the water into the skillet with the guanciale and its rendered fat. Toss well to coat every strand of pasta.",
                "**The Delicate Fold**: Add 1/4 cup of the hot pasta water to the egg and cheese paste to temper it. Pour the egg mixture over the pasta. Work QUICKLY! Use your tongs to toss and stir the pasta continuously. The residual heat will cook the eggs into a creamy, glossy sauce without scrambling them.",
                "**Serving**: If the sauce is too thick, add more pasta water a tablespoon at a time. Serve immediately in warmed bowls, topped with more Pecorino and extra cracked pepper. Authentic carbonara has no cream; the gloss comes exclusively from the emulsified fat and eggs."
            ],
            nutrition: NutritionInfo(calories: 680, protein: 28, carbs: 72, fat: 38, fiber: 3, sugar: 3, sodium: 980),
            tags: ["Indulgent", "Italian", "Classic"]
        ),
        
        RecipeModel(
            title: "Thai Green Curry",
            description: "A spicy and aromatic coconut milk curry featuring handmade green curry paste, bamboo shoots, and fresh Thai basil.",
            image: "https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=800",
            time: "35 min",
            servings: "3",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "1 can (14 oz) full-fat coconut milk",
                "2 tbsp high-quality Thai green curry paste",
                "1 lb chicken breast, sliced into bite-sized strips",
                "1 small eggplant (Asian or globe), cubed",
                "1/2 cup canned bamboo shoots, rinsed",
                "1 tbsp coconut sugar or palm sugar",
                "1 tbsp fish sauce (adjust for saltiness)",
                "Handful of fresh Thai basil leaves",
                "2 kaffir lime leaves, torn",
                "Steamed jasmine rice for serving"
            ],
            instructions: [
                "**Cracking the Coconut Cream**: Skim off the thick cream from the top of the coconut milk can and add it to a large deep pan or wok over medium-high heat. Cook, stirring constantly, for 3-5 minutes until the cream separates and you see oil droplets forming.",
                "**Frying the Paste**: Add the green curry paste to the separated coconut oil. Fry for 2-3 minutes until the paste is highly fragrant and the oil has turned a translucent green. This bloom is essential for flavor depth.",
                "**Searing the Chicken**: Add the chicken strips to the paste. Stir to coat and cook for 2-3 minutes until the exterior is sealed and infused with the curry spices.",
                "**The Simmer**: Pour in the remaining coconut milk. Add the eggplant cubes, kaffir lime leaves, and bamboo shoots. Bring to a gentle boil, then simmer for 10-12 minutes until the chicken is cooked through and the eggplant is tender.",
                "**Balancing Flavors**: Stir in the coconut sugar and fish sauce. Thai food is all about the balance of sweet, salty, and spicy—taste the sauce and adjust to your preference.",
                "**The Fragrant Finish**: Remove from heat and stir in the majority of the Thai basil leaves. Serve in deep bowls over steamed jasmine rice, garnished with a few remaining basil sprigs and a lime wedge if desired."
            ],
            nutrition: NutritionInfo(calories: 520, protein: 36, carbs: 16, fat: 42, fiber: 5, sugar: 8, sodium: 880),
            tags: ["Spicy", "Authentic", "Thai"]
        ),
        
        RecipeModel(
            title: "Portobello Mushroom Steaks",
            description: "Meaty, savory grilled Portobello mushrooms marinated in balsamic and garlic, served with a velvety potato parsnip mash.",
            image: "https://images.unsplash.com/photo-1596791011503-242555b77ea8?w=800",
            time: "35 min",
            servings: "2",
            difficulty: "Easy",
            category: "Dinner",
            ingredients: [
                "4 large Portobello mushrooms, stems removed and cleaned",
                "1/4 cup aged balsamic vinegar",
                "2 tbsp extra virgin olive oil",
                "3 cloves garlic, smashed and minced",
                "1 tsp fresh rosemary, finely chopped",
                "1 tsp fresh thyme leaves",
                "Sea salt and smoked black pepper",
                "For the mash: 2 large russet potatoes, 1 parsnip, 2 tbsp butter"
            ],
            instructions: [
                "**The Marinade**: In a shallow dish, whisk together the balsamic vinegar, olive oil, garlic, rosemary, and thyme. This marinade will provide the deep, 'umami' flavor that makes the mushrooms taste like steak.",
                "**Infusing the Caps**: Place the Portobello caps in the dish, gill-side up. Spoon the marinade into each cap and let them sit at room temperature for at least 20 minutes (or up to 1 hour).",
                "**Mash Preparation**: While the mushrooms marinate, peel and cube the potatoes and parsnip. Boil in salted water until very tender (about 15 minutes). Drain and mash with butter and a splash of milk until completely smooth.",
                "**Searing the 'Steaks'**: Heat a grill pan or cast-iron skillet over medium-high heat. Place the mushrooms in the pan, gill-side down. Cook for 5 minutes, pressing down with a spatula to ensure even contact. Flip and cook for another 5 minutes, basting with any leftover marinade.",
                "**The Texture Check**: The mushrooms should be tender and juicy throughout with a slightly charred, caramelized exterior.",
                "**Plating**: Divide the mash between two plates. Place two mushroom steaks on top of each mound. Drizzle with the remaining pan juices and garnish with a sprig of fresh rosemary. The earthy mushrooms and sweet parsnip mash create a incredibly satisfying vegetarian main."
            ],
            nutrition: NutritionInfo(calories: 320, protein: 10, carbs: 42, fat: 12, fiber: 9, sugar: 12, sodium: 310),
            tags: ["Vegetarian", "Hearty", "Gourmet"]
        ),
        
        RecipeModel(
            title: "Lemon Herb Roast Chicken",
            description: "Golden-skinned organic chicken thighs slow-roasted with fresh rosemary, thyme, and baby Dutch potatoes.",
            image: "https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=800",
            time: "55 min",
            servings: "4",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "4 large skin-on organic chicken thighs",
                "1 lb baby Dutch yellow potatoes, halved",
                "2 organic lemons (1 sliced into rounds, 1 for juice)",
                "3 sprigs fresh rosemary, 3 sprigs fresh thyme",
                "4 cloves garlic, smashed",
                "3 tbsp extra virgin olive oil",
                "1 tsp smoked paprika",
                "Kosher salt and coarse black pepper"
            ],
            instructions: [
                "**Preparation**: Preheat your oven to 425°F (220°C). Pat the chicken thighs bone-dry with paper towels—this is the only way to achieve truly crispy skin.",
                "**Potato Seasoning**: In a large bowl, toss the halved potatoes with 1 tablespoon of olive oil, salt, pepper, and the smashed garlic cloves. Spread them onto a large rimmed baking sheet.",
                "**Chicken Rub**: Rub the chicken thighs with the remaining olive oil, lemon juice, smoked paprika, salt, and pepper. Ensure the seasoning gets underneath the skin where possible for maximum flavor.",
                "**The Arrangement**: Nestle the chicken thighs among the potatoes on the baking sheet. Tuck the rosemary and thyme sprigs around the chicken, and place the lemon rounds directly on top of the potatoes.",
                "**The Roast**: Place in the center of the oven and roast for 35-45 minutes. The chicken should be golden-brown and crispy, and the internal temperature should reach 175°F (thighs benefit from slightly higher temp than breasts). The potatoes should be tender and browned from the chicken drippings.",
                "**Resting is Key**: Let the chicken rest on the baking sheet for 5-10 minutes after removing from the oven. This allows the juices to redistribute for a moist, succulent result. Serve with the roasted potatoes and the softened lemon rounds."
            ],
            nutrition: NutritionInfo(calories: 580, protein: 42, carbs: 48, fat: 32, fiber: 6, sugar: 4, sodium: 580),
            tags: ["Comfort Food", "Family-Size", "High Protein"]
        ),
        
        RecipeModel(
            title: "Miso Glazed Salmon",
            description: "A silky Atlantic salmon fillet glazed with a sweet and savory white miso paste, served with charred baby bok choy.",
            image: "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800",
            time: "25 min",
            servings: "2",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "2 fresh salmon fillets (approx 6oz each), skin-on",
                "2 tbsp white miso paste (Shiro Miso)",
                "1 tbsp mirin (sweet rice wine)",
                "1 tbsp honey or agave",
                "1 tsp fresh ginger, finely grated",
                "2 heads baby bok choy, halved lengthwise",
                "1 tsp toasted sesame oil",
                "1 green onion, thinly sliced on the bias"
            ],
            instructions: [
                "**The Miso Glaze**: In a small bowl, whisk together the miso paste, mirin, honey, and grated ginger until smooth. The consistency should be thick but spreadable. If it's too thick, add a teaspoon of water.",
                "**Marinating the Fillets**: Pat the salmon bone-dry. Generously brush the miso glaze over the flesh side of the salmon (not the skin). Let it sit for 10-15 minutes—this allows the salt and sugar in the miso to slightly cure the fish, resulting in a better sear.",
                "**The Broiler Method**: Preheat your oven's broiler or set to its highest temperature. Line a baking sheet with foil and lightly oil it. Place the salmon fillets on the sheet, skin-side down.",
                "**Cooking the Fish**: Broil the salmon about 6 inches from the heat source for 6-8 minutes. Watch closely! The sugars in the miso will caramelize and may char slightly—this 'burnt' miso adds incredible depth, but don't let it blacken completely.",
                "**Charring the Bok Choy**: While the salmon broils, heat the sesame oil in a hot skillet. Place the bok choy cut-side down and sear for 2-3 minutes until charred but the leaves are still vibrant green.",
                "**Plating**: Arrange the charred bok choy on a plate and nestle the miso-glazed salmon on top. Garnish with the sliced green onions. The fish should be buttery and flake easily with a rich, savory-sweet crust."
            ],
            nutrition: NutritionInfo(calories: 420, protein: 34, carbs: 12, fat: 26, fiber: 2, sugar: 8, sodium: 850),
            tags: ["High Protein", "Seafood", "Japanese-Inspired"]
        ),
        
        RecipeModel(
            title: "Berry Overnight Oats",
            description: "The ultimate convenience breakfast: sprouted rolled oats slow-soaked in almond milk with a vibrant medley of fresh berries and chia seeds.",
            image: "https://images.unsplash.com/photo-1504113888839-1c8ec7ca1c21?w=800",
            time: "10 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1/2 cup organic sprouted rolled oats",
                "2/3 cup unsweetened vanilla almond milk",
                "1/2 cup fresh mixed berries (blueberries, raspberries)",
                "1 tbsp chia seeds",
                "1 tsp pure maple syrup",
                "1/4 tsp pure vanilla extract",
                "A pinch of sea salt"
            ],
            instructions: [
                "**The Foundation**: In a 12oz glass mason jar, combine the rolled oats, chia seeds, and a pinch of sea salt. The salt is crucial for bringing out the sweetness of the oats and berries.",
                "**Hydration**: Add the almond milk, maple syrup, and vanilla extract to the jar. Use a spoon to stir vigorously, ensuring there are no dry pockets of oats at the bottom and that the chia seeds are evenly distributed.",
                "**The Berry Burst**: Gently fold in half of the mixed berries. Some berries will stay whole, while others may burst slightly, naturally sweetening the liquid.",
                "**Overnight Soak**: Seal the jar tightly and place in the refrigerator for at least 6 hours, or ideally overnight. This allows the oats to fully hydrate and the chia seeds to create a pudding-like consistency.",
                "**Preparation for Serving**: In the morning, give the oats a good stir. If they are too thick, add a small splash of almond milk to loosen the texture.",
                "**The Garnish**: Top with the remaining fresh berries and a small drizzle of maple syrup if desired. These oats are perfect for grab-and-go mornings and provide sustained energy throughout the day."
            ],
            nutrition: NutritionInfo(calories: 320, protein: 12, carbs: 48, fat: 8, fiber: 10, sugar: 8, sodium: 120),
            tags: ["Vegetarian", "Convenient", "Meal Prep"]
        ),
        
        RecipeModel(
            title: "Chickpea 'Tuna' Sandwich",
            description: "A clever and surprisingly realistic plant-based 'tuna' salad using smashed chickpeas, capers, and nori for that signature oceanic flavor.",
            image: "https://images.unsplash.com/photo-1525010614131-0ea52ce1ad6d?w=800",
            time: "15 min",
            servings: "2",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "1 can (15 oz) organic chickpeas, rinsed and drained",
                "2 tbsp vegan aquafaba mayo or premium avocado oil mayo",
                "1 tsp Dijon mustard",
                "1 tsp capers, finely chopped",
                "1 tsp crumbled nori sheets (seaweed flakes)",
                "1 stalk celery, finely diced",
                "1 slice red onion, finely minced",
                "2 thick slices of toasted sprouted grain bread",
                "Fresh sprouts or lettuce"
            ],
            instructions: [
                "**The Base**: Place the chickpeas in a medium bowl. Use a fork or potato masher to smash approximately 3/4 of the chickpeas. You want to leave some whole for texture, but the majority should be flaky, resembling the texture of canned tuna.",
                "**Oceanic Flavor**: Stir in the finely chopped capers and crumbled nori. These two ingredients provide the briny, saline flavor profile that defines a good tuna salad.",
                "**The Bind**: Add the mayo, Dijon mustard, minced red onion, and diced celery. Mix thoroughly until the salad is creamy and well-combined.",
                "**Seasoning**: Season with black pepper and a touch of lemon juice. Avoid adding salt until you've tasted it, as capers and nori are naturally salty.",
                "**Bread Prep**: Toast your sprouted grain bread until light golden brown. This provides a necessary structural contrast to the soft filling.",
                "**Assembly**: Spread a generous amount of the chickpea mixture onto one slice of bread. Top with fresh sprouts or crisp lettuce. Close the sandwich, slice diagonally, and serve with a side of pickles."
            ],
            nutrition: NutritionInfo(calories: 410, protein: 14, carbs: 58, fat: 14, fiber: 12, sugar: 4, sodium: 580),
            tags: ["Vegan", "Creative", "High Fiber"]
        ),
        
        RecipeModel(
            title: "Buffalo Chicken Salad",
            description: "Spicy, tangy buffalo-tossed grilled chicken over a crisp, cooling garden salad with creamy blue cheese crumbles.",
            image: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800",
            time: "20 min",
            servings: "1",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "5 oz organic chicken breast, grilled and sliced",
                "2 tbsp high-quality buffalo hot sauce",
                "3 cups mixed garden greens (romaine, spinach, radicchio)",
                "2 tbsp crumbled Gorgonzola or blue cheese",
                "1/4 cup sliced cucumber and cherry tomatoes",
                "1 tbsp Greek yogurt ranch dressing",
                "Fresh celery leaves for garnish"
            ],
            instructions: [
                "**The Protein**: Slice your pre-cooked or freshly grilled chicken breast into uniform strips. Place them in a small bowl and toss with the buffalo sauce until every piece is glistening and orange.",
                "**Greens Prep**: Wash and spin-dry your mixed greens. It's important they are dry so the dressing doesn't pool at the bottom of the bowl.",
                "**The Base**: Arrange the mixed greens in a wide salad bowl. Scatter the halved cherry tomatoes and cucumber slices over the top.",
                "**Heat Meets Cool**: Place the spicy buffalo chicken directly on top of the greens while still slightly warm. The warmth of the chicken will slightly soften the greens and help the cheese melt.",
                "**Cheese Contrast**: Sprinkle the pungent blue cheese crumbles over the chicken. The richness of the cheese is the perfect foil for the acidity of the buffalo sauce.",
                "**Drizzle and Serve**: Finish with a light drizzle of Greek yogurt ranch. Garnish with a few celery leaves for extra crunch and that 'classic buffalo' flavor profile."
            ],
            nutrition: NutritionInfo(calories: 360, protein: 36, carbs: 10, fat: 20, fiber: 3, sugar: 4, sodium: 820),
            tags: ["Spicy", "High Protein", "Low Carb"]
        ),
        
        RecipeModel(
            title: "Turkey Chili",
            description: "A deeply satisfying and lean chili made with ground turkey, a trio of protein-rich beans, and smoky chipotle peppers.",
            image: "https://images.unsplash.com/photo-1545093149-618ce3bcf49d?w=800",
            time: "45 min",
            servings: "4",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "1 lb lean ground turkey (93/7 blend)",
                "1 can (15 oz) kidney beans, rinsed",
                "1 can (15 oz) black beans, rinsed",
                "1 can (28 oz) crushed fire-roasted tomatoes",
                "1 cup low-sodium chicken broth",
                "1 large onion, diced",
                "2 tbsp chili powder, 1 tsp ground cumin, 1/2 tsp smoked paprika",
                "1 tbsp chipotle in adobo (finely chopped)",
                "Toppings: Greek yogurt, sliced jalapeños, lime"
            ],
            instructions: [
                "**The Searing**: In a large heavy-bottomed pot or Dutch oven, brown the ground turkey over medium-high heat. Break it up into small crumbles with a wooden spoon as it cooks until no pink remains.",
                "**Aromatics**: Add the diced onion to the pot with the turkey. Sauté for 5-6 minutes until the onion is soft and translucent.",
                "**Spice Infusion**: Stir in the chili powder, cumin, smoked paprika, and chipotle. Cook for 2 minutes—toasting the spices in the turkey fat is the secret to a professional-tasting chili.",
                "**Building the Body**: Pour in the fire-roasted tomatoes, chicken broth, and all the rinsed beans. Stir thoroughly to combine all the ingredients.",
                "**The Slow Simmer**: Bring the chili to a gentle boil, then reduce the heat to low. Cover partially and simmer for at least 30 minutes. The longer it simmers, the more the flavors will meld and the thicker the chili will become.",
                "**Final Garnish**: Ladle the hot chili into deep bowls. Top with a dollop of Greek yogurt (a healthier alternative to sour cream) and fresh jalapeño slices for an extra kick."
            ],
            nutrition: NutritionInfo(calories: 340, protein: 32, carbs: 38, fat: 8, fiber: 12, sugar: 6, sodium: 680),
            tags: ["Hearty", "Meal Prep", "High Protein"]
        ),
        
        // --- NEW RECIPES (26-50) ---
        
        RecipeModel(
            title: "Spinach & Feta Frittata",
            description: "A sophisticated, light egg bake featuring fresh garden spinach, tangy Greek feta, and a hint of nutmeg.",
            image: "https://images.unsplash.com/photo-1510629954389-c1e0da47d415?w=800",
            time: "20 min",
            servings: "2",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "5 large pasture-raised eggs",
                "2 cups fresh organic baby spinach",
                "1/4 cup crumbled Greek feta cheese",
                "2 tbsp whole milk or heavy cream",
                "1/4 tsp ground nutmeg",
                "1/2 tbsp butter or olive oil",
                "Freshly cracked black pepper"
            ],
            instructions: [
                "**The Egg Base**: In a medium bowl, whisk the eggs with the milk, nutmeg, and black pepper. Nutmeg is the professional's secret to elevating anything with spinach and eggs.",
                "**Wilting the Spinach**: Heat the butter in a 10-inch oven-proof non-stick skillet over medium heat. Add the spinach and sauté for 1-2 minutes until just wilted. Remove excess liquid from the pan if necessary.",
                "**The Pour**: Pour the whisked egg mixture over the spinach. Use a spatula to ensure the spinach is evenly distributed across the pan.",
                "**The Feta Layer**: Sprinkle the crumbled feta evenly over the eggs. Let the frittata cook undisturbed on the stovetop for about 4-5 minutes, or until the edges are completely set and the bottom is golden.",
                "**Finishing under the Broiler**: Transfer the skillet to the oven broiler for 1-2 minutes until the top is puffed and just starting to brown.",
                "**Serving**: Let the frittata rest for 2 minutes to settle, then slide it onto a board. Cut into wedges and serve with a fresh side of sliced tomatoes or a light arugula salad."
            ],
            nutrition: NutritionInfo(calories: 240, protein: 18, carbs: 4, fat: 18, fiber: 1, sugar: 1, sodium: 410),
            tags: ["High Protein", "Low Carb", "One-Pan"]
        ),
        
        RecipeModel(
            title: "Turkey and Avocado Burger",
            description: "A juicy, lean turkey patty flavored with shallots and herbs, served in a lettuce wrap with ripe avocado.",
            image: "https://images.unsplash.com/photo-1513185158878-8d8c196b8f3a?w=800",
            time: "20 min",
            servings: "2",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "1/2 lb lean ground turkey (93/7 blend)",
                "1 small shallot, very finely minced",
                "1 tbsp fresh parsley, chopped",
                "1 ripe Hass avocado, sliced",
                "4 large heads of Bibb or Butter lettuce (for wraps)",
                "1 tbsp Dijon mustard",
                "1 small tomato, sliced"
            ],
            instructions: [
                "**Patty Composition**: In a mixing bowl, combine the ground turkey, minced shallot, parsley, and a healthy pinch of salt and pepper. Be gentle—overworking the meat will result in a tough burger.",
                "**Forming**: Shape into two thick patties. Create a slight 'thumbprint' indentation in the center of each patty; this prevents the burger from puffing up into a ball while cooking.",
                "**The Sear**: Heat a non-stick skillet over medium-high heat. Cook the patties for 5-6 minutes per side. Since turkey is lean and needs to be fully cooked (165°F), avoid pressing them with a spatula, which squeezes out the precious juices.",
                "**The Wrap Prep**: Wash and carefully dry the large lettuce leaves. Using two leaves per burger provides better structural integrity for your 'bun'.",
                "**Condiments**: Spread a teaspoon of Dijon mustard onto the bottom lettuce leaf. Place the turkey patty on top, followed by a slice of tomato.",
                "**The Finish**: Top with a generous mound of avocado slices. The creamy avocado provides the necessary healthy fat to balance the lean turkey. Wrap the lettuce around the patty and serve immediately with sweet potato fries or a side salad."
            ],
            nutrition: NutritionInfo(calories: 380, protein: 28, carbs: 12, fat: 26, fiber: 7, sugar: 3, sodium: 480),
            tags: ["High Protein", "Low Carb", "Lean-Eating"]
        ),
        
        RecipeModel(
            title: "Protein Waffles",
            description: "Crispy and golden waffles made with oat flour and Greek yogurt for an incredible protein-packed start to your day.",
            image: "https://images.unsplash.com/photo-1573539079551-bceef0c66bc1?w=800",
            time: "15 min",
            servings: "2",
            difficulty: "Medium",
            category: "Breakfast",
            ingredients: [
                "1 cup finely ground oat flour",
                "1 scoop (30g) vanilla whey protein powder",
                "1/2 cup plain non-fat Greek yogurt",
                "1 large egg",
                "1/2 cup almond milk (adjusted for consistency)",
                "1 tsp baking powder",
                "1/2 tsp pure vanilla extract",
                "Fresh berries and zero-sugar syrup for topping"
            ],
            instructions: [
                "**Waffle Iron Prep**: Preheat your waffle iron to its highest setting. A very hot iron is the key to getting a crispy exterior with a protein-heavy batter.",
                "**The Batter**: In a large bowl, whisk together the oat flour, protein powder, and baking powder. Add the egg, Greek yogurt, vanilla extract, and almond milk.",
                "**Consistency Check**: Whisk until smooth. The batter should be thicker than pancake batter but still pourable. Let it sit for 5 minutes—this allows the oat flour to hydrate and the baking powder to activate.",
                "**The Cook**: Lightly coat the waffle iron with non-stick spray. Pour enough batter to cover about 3/4 of the iron surface. Close the lid and cook according to your iron's settings (usually about 3-4 minutes).",
                "**Crisp Factor**: If you want extra crispy waffles, place the finished waffles directly on the oven rack at 200°F (95°C) for 2 minutes while you finish the rest of the batch.",
                "**Presentation**: Stack the waffles high and top with a massive mound of fresh berries. Drizzle with a tiny bit of high-quality syrup or a dollop of extra Greek yogurt for a truly premium breakfast experience."
            ],
            nutrition: NutritionInfo(calories: 340, protein: 29, carbs: 42, fat: 8, fiber: 6, sugar: 4, sodium: 280),
            tags: ["High Protein", "Fitness", "Cheat-Day-Standard"]
        ),
        
        RecipeModel(
            title: "Classic Avocado Toast",
            description: "The gold standard of modern breakfast: thick-cut toasted sourdough with seasoned avocado and a silky poached egg.",
            image: "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800",
            time: "15 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1 thick slice of artisanal sourdough bread",
                "1/2 ripe Hass avocado",
                "1 large fresh organic egg",
                "1/2 tsp Everything Bagel seasoning or red pepper flakes",
                "1 tsp lemon juice",
                "1 tsp high-quality olive oil",
                "Flaky sea salt"
            ],
            instructions: [
                "**The Perfect Poach**: Bring a small pot of water to a very gentle simmer. Add a splash of vinegar. Crack the egg into a small ramekin first. Swirl the water to create a vortex and gently drop the egg in. Poach for exactly 3 minutes until whites are set but the yolk is liquid gold.",
                "**Avocado Mash**: While the egg poaches, scoop the avocado into a small bowl. Add the lemon juice and a pinch of salt. Mash with a fork until desired consistency—leave it slightly chunky for better texture.",
                "**The Toast**: Toast your sourdough until the edges are deeply golden and the surface is crisp. This needs to be a sturdy base for the toppings.",
                "**The Layering**: Spread the avocado mash generously onto the warm toast. Use a spoon to create a small well in the center for the egg.",
                "**The Assembly**: Carefully lift the poached egg with a slotted spoon and place it on the avocado. Drizzle with a tiny bit of olive oil and a sprinkle of flaky sea salt.",
                "**The Finishing Shine**: Sprinkle with red pepper flakes or Everything Bagel seasoning. The first cut into the runny yolk over the creamy avocado is what makes this a premium experience."
            ],
            nutrition: NutritionInfo(calories: 330, protein: 14, carbs: 32, fat: 20, fiber: 8, sugar: 2, sodium: 420),
            tags: ["Healthy Fats", "Trend", "Nutritious"]
        ),
        
        RecipeModel(
            title: "Toasted Muesli",
            description: "A gourmet blend of whole grains, seeds, and dried fruit, served over artisanal coconut yogurt with a hint of cinnamon.",
            image: "https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=800",
            time: "10 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1/2 cup high-quality toasted muesli (with nuts and dried fruit)",
                "1 cup thick-style unsweetened coconut yogurt",
                "1/4 cup fresh pomegranate seeds or sliced strawberries",
                "1 tsp pure maple syrup",
                "A pinch of ground cinnamon",
                "Fresh mint leaves for garnish"
            ],
            instructions: [
                "**Yogurt Base**: Scoop the coconut yogurt into a wide, shallow bowl. Use a spoon to smooth it out into a circular layer with a slight indentation in the center.",
                "**The Crunch**: Pour the toasted muesli into the center of the yogurt. Spreading it this way ensures the muesli stays crispy and doesn't get soggy too quickly.",
                "**Flavor Accents**: Sprinkle the cinnamon over the top of the muesli. The aroma of cinnamon paired with the coconut is one of the best ways to wake up the senses.",
                "**The Fruit Layer**: Scatter the pomegranate seeds or strawberry slices over the muesli. The tartness of the fruit balances the richness of the coconut yogurt.",
                "**The Glaze**: Drizzle the maple syrup in a thin zigzag pattern over the entire bowl.",
                "**Final Touches**: Garnish with a fresh mint leaf. This simple assembly feels incredibly premium and focuses on the high-quality textures of the individual ingredients."
            ],
            nutrition: NutritionInfo(calories: 310, protein: 8, carbs: 46, fat: 14, fiber: 7, sugar: 14, sodium: 60),
            tags: ["Vegan", "Fiber", "Quick-Assembly"]
        ),
        
        RecipeModel(
            title: "Breakfast Quesadilla",
            description: "A handheld breakfast powerhouse filled with fluffy scrambled eggs, protein-rich black beans, and sharp melted cheddar.",
            image: "https://images.unsplash.com/photo-1599974579688-8dbdd335c77f?w=800",
            time: "15 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1 large whole-wheat tortilla",
                "2 large pasture-raised eggs",
                "1/4 cup shredded sharp cheddar or Monterey Jack",
                "1/4 cup organic black beans, rinsed",
                "1 tbsp fresh cilantro, chopped",
                "1 tbsp chunky salsa for dipping",
                "1/2 tsp ground cumin"
            ],
            instructions: [
                "**The Scramble**: Whisk the eggs with a pinch of cumin, salt, and pepper. Heat a non-stick pan over medium heat and scramble the eggs until they are just barely set. Remove from the pan and set aside.",
                "**Tortilla Prep**: Clean the pan and place it back on medium heat. Lay the tortilla flat. Sprinkle half of the cheese over one half of the tortilla.",
                "**The Filling**: Layer the scrambled eggs and black beans over the cheese. Sprinkle the remaining cheese and the fresh cilantro on top of the eggs.",
                "**The Fold**: Fold the empty half of the tortilla over the filling to create a half-moon shape. Press down gently with a spatula to ensure the cheese 'glues' the layers together.",
                "**Crisping**: Cook for 2-3 minutes per side until the tortilla is golden brown and crispy, and the cheese has completely melted.",
                "**Serving**: Slice into three triangles and serve hot with a side of salsa and perhaps a dollop of Greek yogurt or avocado mash."
            ],
            nutrition: NutritionInfo(calories: 410, protein: 24, carbs: 38, fat: 18, fiber: 8, sugar: 3, sodium: 590),
            tags: ["Quick", "Savory", "High Protein"]
        ),
        
        RecipeModel(
            title: "Tofu Scramble",
            description: "A vibrant, nutrient-dense vegan alternative to traditional eggs, seasoned with immune-boosting turmeric and iron-rich kale.",
            image: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800",
            time: "20 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1/2 block (7oz) extra-firm organic tofu, pressed",
                "2 cups fresh organic baby kale or spinach",
                "1/2 tsp ground turmeric",
                "1 tbsp nutritional yeast",
                "1/4 cup diced bell peppers",
                "1 tbsp olive oil",
                "A pinch of black salt (Kala Namak) for an egg-like flavor"
            ],
            instructions: [
                "**Tofu Preparation**: Drain the tofu and wrap it in a clean tea towel. Place a heavy bowl on top for 10 minutes to press out excess moisture. This ensures the tofu gets a better texture when sautéed.",
                "**The Base**: Heat the olive oil in a skillet over medium heat. Add the diced bell peppers and sauté for 3 minutes until softened.",
                "**The Crumble**: Use your hands to crumble the pressed tofu directly into the skillet. You want a variety of 'curd' sizes to mimic real scrambled eggs.",
                "**Seasoning for Color and Flavor**: Sprinkle the turmeric, nutritional yeast, and black salt over the tofu. The turmeric provides the bright yellow color, while the yeast and black salt provide the savory, sulfuric 'egg' taste.",
                "**The Greens**: Add the baby kale to the pan and toss everything together. Sauté for another 3-4 minutes until the kale is wilted and the tofu is heated through.",
                "**Presentation**: Serve immediately on its own or with a side of whole-grain toast. The turmeric-stained tofu and dark green kale make for a beautiful, anti-inflammatory breakfast."
            ],
            nutrition: NutritionInfo(calories: 270, protein: 24, carbs: 14, fat: 14, fiber: 5, sugar: 4, sodium: 320),
            tags: ["Vegan", "High Protein", "Anti-Inflammatory"]
        ),
        
        RecipeModel(
            title: "Peanut Butter Banana Toast",
            description: "The ultimate pre-workout fuel: hearty whole-grain toast with rich, natural peanut butter, fresh banana slices, and a dash of cinnamon.",
            image: "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800",
            time: "5 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1 thick slice of sprouted whole-grain bread",
                "2 tbsp all-natural creamy peanut butter (just peanuts and salt)",
                "1/2 ripe banana, sliced into rounds",
                "1 tsp hemp seeds or chia seeds (for extra omega-3s)",
                "A light dusting of ground cinnamon",
                "A tiny drizzle of honey or agave (optional)"
            ],
            instructions: [
                "**The Toast**: Toast your sprouted grain bread until it is very sturdy and slightly charred at the edges. A strong base is needed to hold the heavy peanut butter and banana.",
                "**The Spread**: Spread the peanut butter evenly across the warm toast. The heat from the toast will help the peanut butter melt slightly, making it easier to spread edge-to-edge.",
                "**Fruit Arrangement**: Layer the banana slices in overlapping rows across the peanut butter. This ensures every single bite has a perfect balance of fruit and nut butter.",
                "**The Power Topper**: Sprinkle the hemp seeds or chia seeds over the banana. These add a subtle crunch and a boost of healthy fats.",
                "**Flavor Finish**: Dust the entire slice with cinnamon. Cinnamon helps regulate blood sugar and adds a delicious warmth to the sweet banana.",
                "**The Final Touch**: If you need a little extra sweetness, add a very thin drizzle of honey. Serve immediately as a fast and effective energy source before activity."
            ],
            nutrition: NutritionInfo(calories: 340, protein: 12, carbs: 42, fat: 18, fiber: 9, sugar: 12, sodium: 180),
            tags: ["Energy", "Simple", "Pre-Workout"]
        ),
        
        RecipeModel(
            title: "Mediterranean Mezze",
            description: "A visually stunning grazing plate featuring creamy artisanal hummus, crispy baked falafel, and a medley of fresh Mediterranean vegetables.",
            image: "https://images.unsplash.com/photo-1541529086526-db283c563270?w=800",
            time: "15 min",
            servings: "1",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "1/4 cup extra-smooth roasted garlic hummus",
                "4 homemade or premium baked falafel balls",
                "1 small Persian cucumber, sliced on the bias",
                "1/4 cup Kalamata olives, pitted",
                "1 whole-wheat pita bread, warmed and sliced",
                "1/2 tbsp extra virgin olive oil",
                "1/4 tsp sumac or paprika for garnish"
            ],
            instructions: [
                "**Hummus Presentation**: Spoon the hummus into a small ramekin or create a swirl directly on the plate. Use the back of a spoon to create a 'track' in the hummus, and drizzle the olive oil into it.",
                "**Falafel Warmth**: If the falafels are pre-made, warm them in a dry skillet for 1-2 minutes per side to regain their crispy exterior. Place them in a cluster on the plate.",
                "**The Fresh Element**: Arrange the sliced cucumbers in an overlapping shingle pattern. Scatter the olives and perhaps a few cherry tomatoes around the plate for color.",
                "**Bread Prep**: Toast the pita bread briefly in a toaster or over a gas flame until warm and pliable. Cut into six triangles and nestle them under the edge of the plate.",
                "**The Finishing Dust**: Sprinkle the sumac or paprika over the hummus. This adds a professional pop of color and a subtle citrusy earthiness.",
                "**Grazing Style**: Serve as a decentralized grazing plate. The beauty of a mezze is the ability to combine different textures and temperatures in every bite."
            ],
            nutrition: NutritionInfo(calories: 440, protein: 16, carbs: 52, fat: 20, fiber: 9, sugar: 4, sodium: 620),
            tags: ["Vegetarian", "Fresh", "Mediterranean"]
        ),
        
        RecipeModel(
            title: "Roasted Vegetable Grain Bowl",
            description: "A nutrient-packed bowl of farro, roasted autumn vegetables, and a creamy lemon-tahini drizzle.",
            image: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800",
            time: "40 min",
            servings: "2",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "1 cup pearled farro or heritage brown rice",
                "1 small butternut squash, cubed",
                "1 bundle organic broccolini, trimmed",
                "2 tbsp tahini (sesame paste)",
                "1 lemon, juiced",
                "1 tbsp maple syrup",
                "1/4 cup pomegranate seeds for garnish",
                "Olive oil and sea salt"
            ],
            instructions: [
                "**Grain Cookery**: Cook the farro in a large pot of boiling salted water until tender but still having a nice 'chew' (about 20-25 minutes). Drain and set aside.",
                "**Sheet Pan Roast**: Preheat oven to 400°F (200°C). Arrange the squash cubes and broccolini on a baking sheet. Drizzle with olive oil and salt. Roast for 20-25 minutes until squash is caramelized and broccolini has charred tips.",
                "**The Tahini Drizzle**: In a small bowl, whisk together the tahini, lemon juice, maple syrup, and 1-2 tablespoons of warm water until it reaches a smooth, pourable consistency.",
                "**Bowl Construction**: Divide the cooked farro into two large bowls. Arrange the roasted squash and broccolini in separate sections over the grain base.",
                "**Adding Texture**: Sprinkle the pomegranate seeds over the top for a burst of color and a tart-sweet crunch.",
                "**Final Touch**: Drizzle the lemon-tahini sauce generously over the entire bowl. This meal is the ultimate balance of complex carbs, healthy fats, and micronutrients."
            ],
            nutrition: NutritionInfo(calories: 460, protein: 14, carbs: 68, fat: 16, fiber: 12, sugar: 12, sodium: 280),
            tags: ["Vegan", "Anti-Inflammatory", "Meal-Prep"]
        ),
        
        RecipeModel(
            title: "Baked Falafel Bowl",
            description: "Crisp-on-the-outside, tender-on-the-inside baked falafels served over a bed of fluffy quinoa with a lemon-tahini elixir.",
            image: "https://images.unsplash.com/photo-1547050605-2f129ac7590d?w=800",
            time: "35 min",
            servings: "2",
            difficulty: "Medium",
            category: "Lunch",
            ingredients: [
                "1.5 cups cooked white quinoa",
                "1 can (15 oz) chickpeas, rinsed and dried very thoroughly",
                "1/2 cup fresh parsley and 1/4 cup fresh cilantro",
                "3 cloves garlic, minced",
                "1 tsp ground cumin, 1 tsp coriander",
                "2 tbsp tahini (sesame paste)",
                "1 lemon, juiced",
                "1/4 cup pickled radishes or red onion"
            ],
            instructions: [
                "**Falafel Base**: In a food processor, pulse the chickpeas, parsley, cilantro, garlic, cumin, and coriander until the mixture is grainy but holds together when pressed. Do not over-process into a paste.",
                "**Forming and Baking**: Form the mixture into 10-12 small balls. Place on a parchment-lined baking sheet and lightly spray with olive oil. Bake at 400°F (200°C) for 20-25 minutes, flipping halfway through until golden brown.",
                "**The Grain Foundation**: While falafels bake, ensure your quinoa is fluffy. If cooking fresh, use a 1:2 ratio of quinoa to water and let it steam for 5 minutes after cooking.",
                "**Dressing Creation**: Whisk the tahini with lemon juice and a splash of warm water until it reaches a smooth, drizzlable consistency. Season with a pinch of sea salt.",
                "**Bowl Assembly**: Divide the quinoa into two bowls. Place 5-6 falafels on top of each. Add the pickled vegetables for acidity and color.",
                "**Final Garnish**: Drizzle the lemon-tahini sauce generously over the falafels and grains. The combination of warm falafel and cold pickles over healthy grains is incredibly satisfying."
            ],
            nutrition: NutritionInfo(calories: 480, protein: 18, carbs: 62, fat: 16, fiber: 12, sugar: 4, sodium: 380),
            tags: ["Vegan", "Baked-Fresh", "High Protein"]
        ),
        
        RecipeModel(
            title: "Zucchini Noodles with Pesto",
            description: "A vibrant, low-carb alternative to pasta featuring fresh 'zoodles' tossed in a rich, basil-walnut pesto.",
            image: "https://images.unsplash.com/photo-1473093226795-af9932fe5856?w=800",
            time: "15 min",
            servings: "2",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "3 medium-sized firm zucchinis, spiralized",
                "1/4 cup high-quality basil pesto (homemade or premium store-bought)",
                "1/2 cup organic cherry tomatoes, halved",
                "1 tbsp pine nuts or chopped walnuts, toasted",
                "1 tbsp freshly grated Parmesan cheese",
                "A squeeze of fresh lemon juice"
            ],
            instructions: [
                "**Spiralizing Technique**: Use a spiralizer or julienne peeler to create long, thin zucchini 'noodles'. Avoid using the seedy center of the zucchini, as it will make the dish too watery.",
                "**Extracting Moisture**: Place the zucchini noodles in a colander and sprinkle with a pinch of salt. Let them sit for 5-10 minutes, then gently squeeze with a clean towel to remove excess liquid. This prevents 'soggy zoodle' syndrome.",
                "**Toasting the Nuts**: In a small dry pan, toast the pine nuts or walnuts over low heat until fragrant and golden. Set aside.",
                "**The Sauté**: Heat a large skillet over medium-high heat. Add the zoodles and halved cherry tomatoes. Sauté for only 2-3 minutes—you want the noodles to be 'al dente', not mushy.",
                "**The Pesto Integration**: Remove the skillet from heat. Add the pesto and a squeeze of lemon juice. Toss gently with tongs until every noodle is evenly coated in the vibrant green sauce.",
                "**Serving**: Divide into two bowls. Garnish with the toasted nuts and a dusting of Parmesan cheese. Serve immediately, as zucchini noodles will release water as they sit."
            ],
            nutrition: NutritionInfo(calories: 240, protein: 6, carbs: 12, fat: 20, fiber: 4, sugar: 6, sodium: 310),
            tags: ["Low Carb", "Vegetarian", "Quick-Prep"]
        ),
        
        RecipeModel(
            title: "Cauliflower Fried Rice",
            description: "A grain-free, nutrient-dense reimagining of the classic Chinese takeout dish, featuring finely riced cauliflower and toasted sesame.",
            image: "https://images.unsplash.com/photo-1512058560374-140fa39665c0?w=800",
            time: "20 min",
            servings: "2",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "1 large head of cauliflower, riced",
                "1 cup frozen peas and carrots blend",
                "2 large eggs, lightly beaten",
                "2 tbsp low-sodium soy sauce or liquid aminos",
                "1 tsp toasted sesame oil",
                "2 cloves garlic, minced",
                "2 green onions, sliced"
            ],
            instructions: [
                "**The Rice Prep**: Pulse cauliflower florets in a food processor until they reach the size of rice grains. Alternatively, use a box grater. Spread the 'rice' on a clean towel and squeeze out any excess moisture—this is critical for preventing mushiness.",
                "**The Scramble**: Heat the sesame oil in a large wok or skillet over medium heat. Pour in the eggs and scramble quickly until just set. Remove eggs from the pan and set aside.",
                "**The Aromatics**: Add a splash more oil to the pan. Sauté the garlic and the white parts of the green onions for 60 seconds until fragrant.",
                "**The High Heat Fry**: Increase heat to high. Add the cauliflower rice and the frozen veggies. Sauté for 5-7 minutes, tossing constantly. You want the cauliflower to soften slightly but still have a distinct 'grain' texture.",
                "**The Finish**: Pour in the soy sauce and add the scrambled eggs back into the pan. Toss for another 1-2 minutes until everything is evenly colored and steaming hot.",
                "**Serving**: Divide into bowls and garnish with the remaining green onion tops. This dish provides all the satisfaction of fried rice with a fraction of the carbs."
            ],
            nutrition: NutritionInfo(calories: 260, protein: 16, carbs: 18, fat: 12, fiber: 6, sugar: 6, sodium: 580),
            tags: ["Low Carb", "Keto", "Fast-Cooking"]
        ),
        
        RecipeModel(
            title: "Chickpea Curry (Chana Masala)",
            description: "A deeply aromatic North Indian classic featuring chickpeas simmered in a spiced tomato and onion gravy.",
            image: "https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800",
            time: "35 min",
            servings: "4",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "2 cans (15 oz each) organic chickpeas, rinsed and drained",
                "2 medium yellow onions, very finely chopped",
                "1 can (14.5 oz) crushed tomatoes or 3 diced roma tomatoes",
                "1 tbsp ginger-garlic paste (or 1-inch ginger/3 cloves garlic minced)",
                "1 tbsp Garam Masala, 1 tsp ground turmeric, 1 tsp ground cumin",
                "1/2 tsp Kashmiri chili powder (for vibrant red color without high heat)",
                "2 tbsp ghee or neutral vegetable oil",
                "Fresh lemon juice and a large handful of cilantro"
            ],
            instructions: [
                "**Developing the Base**: Heat the ghee in a large pot or deep skillet over medium heat. Add the finely chopped onions and sauté for 10-12 minutes. You want them to be a deep golden brown—this 'bhuna' process is where the deep curry flavor comes from.",
                "**The Masala Mix**: Add the ginger-garlic paste and sauté for another 2 minutes. Stir in the turmeric, cumin, and Kashmiri chili powder. If it's too dry, add a tiny splash of water to prevent the spices from burning.",
                "**Tomato Reduction**: Add the crushed tomatoes to the pot. Stir well and cook for 5-7 minutes until the tomatoes soften and you see the oil starting to separate from the sides of the 'masala' paste.",
                "**The Chickpea Simmer**: Add the chickpeas and 1 cup of water. Stir to combine and season with salt. Bring to a boil, then reduce heat and simmer for 15-20 minutes. Use the back of your spoon to crush a small amount of chickpeas—this thickens the gravy beautifully.",
                "**The Finishing Spices**: Stir in the Garam Masala and a squeeze of fresh lemon juice. The Garam Masala is a finishing spice and shouldn't be cooked for too long to preserve its aromatics.",
                "**Presentation**: Garnish with a generous amount of fresh cilantro. Serve hot with buttery Naan bread or fluffy Basmati rice. The flavors will deepen significantly if left to sit for a few hours."
            ],
            nutrition: NutritionInfo(calories: 310, protein: 12, carbs: 46, fat: 10, fiber: 10, sugar: 6, sodium: 580),
            tags: ["Vegan-Option", "Fiber-Rich", "Indian"]
        ),
        
        RecipeModel(
            title: "Sesame Ginger Soba",
            description: "Chilled buckwheat soba noodles tossed in a rich, velvety sesame-ginger emulsion with protein-packed edamame.",
            image: "https://images.unsplash.com/photo-1546549032-95f7259442f7?w=800",
            time: "20 min",
            servings: "2",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "4 oz high-quality Japanese soba noodles (buckwheat)",
                "1 cup shelled edamame, steamed",
                "1 large carrot, julienned into matchsticks",
                "2 tbsp toasted sesame oil",
                "1 tbsp rice vinegar",
                "1 tsp fresh ginger, finely grated",
                "1 tsp black sesame seeds for garnish"
            ],
            instructions: [
                "**The Noodle Boil**: Cook the soba noodles in boiling water for 4-5 minutes (or according to package). Be careful not to overcook, as buckwheat noodles can become mushy very quickly.",
                "**The Cold Shock**: Drain the noodles and immediately plunge them into a bowl of ice water. Scrub them gently with your hands to remove the surface starch. This is the secret to perfect, non-sticky cold soba.",
                "**The Dressing**: In a large bowl, whisk together the sesame oil, rice vinegar, grated ginger, and a small splash of soy sauce. The dressing should be highly aromatic.",
                "**Combining Textures**: Add the chilled noodles, steamed edamame, and carrot matchsticks to the dressing bowl. Toss thoroughly until everything is evenly coated.",
                "**Plating**: Use tongs to twirl the noodles into a neat nest in the center of the plate.",
                "**The Finish**: Sprinkle generously with black sesame seeds. Serve chilled or at room temperature for a refreshing, energy-stabilizing lunch."
            ],
            nutrition: NutritionInfo(calories: 410, protein: 18, carbs: 54, fat: 18, fiber: 8, sugar: 4, sodium: 320),
            tags: ["Vegan", "Japanese-Style", "Complex-Carbs"]
        ),
        
        RecipeModel(
            title: "Beet & Goat Cheese Salad",
            description: "An elegant, visually striking salad of earthy slow-roasted beets, creamy goat cheese, and candied-style walnuts.",
            image: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800",
            time: "15 min",
            servings: "1",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "2 medium beets, roasted and sliced into rounds",
                "2 tbsp crumbly goat cheese (Chevre)",
                "2 cups fresh organic baby arugula",
                "1 tbsp walnuts, lightly toasted",
                "1 tbsp balsamic glaze (thickened balsamic)",
                "1 tsp extra virgin olive oil"
            ],
            instructions: [
                "**Peppery Foundation**: Place the baby arugula in a shallow bowl. Drizzle with the olive oil and a tiny pinch of salt, then toss to coat. This ensures every leaf is seasoned before the toppings go on.",
                "**Beet Arrangement**: Arrange the roasted beet slices in a decorative circle over the arugula. If using multiple colors of beets (like red and golden), alternate them for maximum visual impact.",
                "**Cheese Distribution**: Crumble the goat cheese over the beets. The white cheese against the deep purple/red beets is a classic culinary aesthetic.",
                "**The Nutty Crunch**: Scatter the toasted walnuts over the salad. Toasted nuts have far more depth of flavor than raw ones.",
                "**The Glaze Art**: Drizzle the thick balsamic glaze in a controlled zigzag pattern across the entire plate.",
                "**Serving**: Serve immediately. The contrast between the sweet, earthy beets and the tangy, creamy cheese is timeless."
            ],
            nutrition: NutritionInfo(calories: 320, protein: 10, carbs: 22, fat: 24, fiber: 5, sugar: 14, sodium: 280),
            tags: ["Vegetarian", "Elegant", "Low Calorie"]
        ),
        
        RecipeModel(
            title: "Sweet Potato and Black Bean Tacos",
            description: "A satisfying plant-based taco featuring cumin-roasted sweet potatoes and zesty lime-marinated black beans.",
            image: "https://images.unsplash.com/photo-1512838243191-e81e8f66f1fd?w=800",
            time: "30 min",
            servings: "2",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "2 medium sweet potatoes, diced into 1/2-inch cubes",
                "1 can (15 oz) black beans, rinsed and drained",
                "6 small corn or flour tortillas",
                "1/2 cup crumbled feta or cotija cheese",
                "1/2 cup pickled red onions",
                "1 tbsp olive oil, 1 tsp cumin, 1/2 tsp chili powder",
                "Cilantro and lime for garnish"
            ],
            instructions: [
                "**Roasting the Stars**: Preheat oven to 400°F (200°C). Toss the sweet potato cubes in a bowl with olive oil, cumin, chili powder, and salt. Spread on a baking sheet and roast for 20-25 minutes until the edges are crispy and centers are soft.",
                "**The Bean Prep**: While potatoes roast, place the black beans in a small pot with a splash of water, a squeeze of lime, and a pinch of salt. Warm through over medium heat for 5 minutes.",
                "**Tortilla Char**: For a premium experience, char the tortillas directly over a gas flame for 10-15 seconds per side using tongs. Alternatively, warm in a dry skillet until pliable.",
                "**Pickled Element**: Use store-bought pickled red onions or quickly make your own by soaking sliced onions in lime juice and a pinch of sugar while the potatoes roast.",
                "**Taco Assembly**: Place a generous spoonful of roasted sweet potatoes in each tortilla, followed by a layer of black beans. The contrast of the sweet tubers and savory beans is the heart of the dish.",
                "**The Finish**: Top each taco with crumbled feta (for creaminess), pickled onions (for acidity), and fresh cilantro. Serve with a lime wedge on the side to be squeezed over just before eating."
            ],
            nutrition: NutritionInfo(calories: 410, protein: 12, carbs: 62, fat: 14, fiber: 14, sugar: 6, sodium: 520),
            tags: ["Vegetarian", "High Fiber", "Mexican-Style"]
        ),
        
        RecipeModel(
            title: "Mango Shrimp Rolls",
            description: "Translucent rice paper rolls packed with succulent steamed shrimp, sweet mango, and a refreshing burst of mint and basil.",
            image: "https://images.unsplash.com/photo-1534422298391-e4f8c170db06?w=800",
            time: "25 min",
            servings: "2",
            difficulty: "Medium",
            category: "Lunch",
            ingredients: [
                "6 large circular rice paper sheets",
                "1/2 lb jumbo shrimp, steamed and halved lengthwise",
                "1 ripe mango, julienned into thin strips",
                "1/2 cup fresh mint and Thai basil leaves",
                "1 cup very thin vermicelli rice noodles (cooked)",
                "Peanut dipping sauce for serving"
            ],
            instructions: [
                "**Shrimp Prep**: Ensure your shrimp are cold. Slicing them in half lengthwise makes the rolls lay flatter and looks more professional in the translucent paper.",
                "**The Dip**: Fill a shallow dish with lukewarm water. Submerge one rice paper sheet for about 5-10 seconds until it's just starting to feel pliable but still has some structure. It will continue to soften on your board.",
                "**The Arrangement**: Lay the sheet on a clean damp towel. Place 3 shrimp halves in a row (pink side down) about one-third of the way up. Follow with a small bundle of vermicelli, mango strips, and plenty of herbs.",
                "**The Roll**: Fold the bottom of the paper over the filling, then fold in the sides like a burrito. Roll up tightly. The shrimp should show through the final layer of paper.",
                "**Keeping Fresh**: Place the finished rolls on a plate, ensuring they don't touch each other (they will stick!). Cover with a damp paper towel until ready to serve.",
                "**Serving**: Slice the rolls in half on a sharp bias. Serve with a rich peanut dipping sauce enhanced with a squeeze of lime."
            ],
            nutrition: NutritionInfo(calories: 280, protein: 24, carbs: 42, fat: 4, fiber: 4, sugar: 12, sodium: 420),
            tags: ["Low Calorie", "Fresh", "No-Cook-Option"]
        ),
        
        RecipeModel(
            title: "Ribeye with Chimichurri",
            description: "A perfectly crusty, pan-seared ribeye steak finished with a vibrant, zingy Argentinean-style herb sauce.",
            image: "https://images.unsplash.com/photo-1615865417491-9941019fba00?w=800",
            time: "25 min",
            servings: "2",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "1 lb prime grain-fed ribeye steak (at room temperature)",
                "1 cup fresh flat-leaf parsley, finely chopped",
                "2 cloves garlic, minced to a paste",
                "1/4 cup extra virgin olive oil",
                "1 tbsp red wine vinegar",
                "1/2 tsp red chili flakes",
                "Kosher salt and coarse black pepper"
            ],
            instructions: [
                "**Chimichurri Creation**: In a small bowl, combine the parsley, garlic, olive oil, red wine vinegar, and chili flakes. For the best result, chop the parsley by hand rather than using a processor—this keeps the oil bright and the herbs distinct.",
                "**Steak Tempering**: Pat the ribeye bone-dry on all sides. Season aggressively with salt and pepper. Let the steak sit for at least 30 minutes to reach room temperature; this ensures even cooking.",
                "**The Hard Sear**: Heat a heavy cast-iron skillet over high heat until it's smoking. Add a tiny splash of high-smoke-point oil. Place the steak in and sear for 3-4 minutes per side for medium-rare.",
                "**The Edge**: Use tongs to hold the steak on its side to render and crisp the fat cap.",
                "**The Rest**: Transfer the steak to a board and let it rest for a full 10 minutes. This is non-negotiable for a juicy result.",
                "**Presentation**: Slice the ribeye against the grain into thick ribbons. Spoon the vibrant green chimichurri generously over the warm meat. The acidity of the sauce perfectly cuts through the richness of the ribeye."
            ],
            nutrition: NutritionInfo(calories: 720, protein: 48, carbs: 2, fat: 58, fiber: 1, sugar: 0, sodium: 480),
            tags: ["Indulgent", "High Protein", "Steakhouse-Standard"]
        ),
        
        RecipeModel(
            title: "Butternut Squash Risotto",
            description: "A silky, golden Arborio rice masterpiece featuring slow-roasted butternut squash, fresh sage, and aged Parmesan.",
            image: "https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=800",
            time: "45 min",
            servings: "4",
            difficulty: "Hard",
            category: "Dinner",
            ingredients: [
                "1.5 cups Arborio or Carnaroli rice",
                "2 cups butternut squash, cubed small",
                "5 cups low-sodium chicken or vegetable broth, kept warm",
                "1/2 cup dry white wine (like Pinot Grigio)",
                "3 tbsp butter, 1/2 cup grated Parmesan cheese",
                "6 fresh sage leaves, fried until crispy",
                "1 shallot, finely minced"
            ],
            instructions: [
                "**Roasting the Squash**: Preheat oven to 400°F. Roast the squash cubes with a little oil and salt for 20 minutes until tender. Mash one-third of the squash into a paste and keep the rest whole.",
                "**The Base**: Sauté the shallot in half the butter until translucent. Add the rice and 'toast' it for 2 minutes until the edges are translucent and it smells slightly nutty.",
                "**Deglazing**: Pour in the wine and stir constantly until the liquid is fully absorbed by the rice.",
                "**The Gradual Stir**: Add the warm broth one ladle at a time. Stir almost constantly—this friction releases the starch from the rice, creating the characteristic creaminess of risotto. Do not add more broth until the previous ladle is absorbed.",
                "**Infusing Flavor**: Halfway through cooking, stir in the squash paste. This will turn the entire risotto a beautiful golden-orange color.",
                "**The Finish (Mantecatura)**: Once the rice is al dente, remove from heat. Vigorously stir in the remaining butter, the whole squash cubes, and the Parmesan. Cover for 2 minutes. Serve in shallow bowls topped with a crispy fried sage leaf."
            ],
            nutrition: NutritionInfo(calories: 460, protein: 14, carbs: 68, fat: 16, fiber: 6, sugar: 8, sodium: 580),
            tags: ["Vegetarian-Option", "Gourmet", "Slow-Stirred"]
        ),
        
        RecipeModel(
            title: "Mint Pesto Lamb Chops",
            description: "Tender, succulent lamb rib chops grilled with a sophisticated homemade mint and toasted pine nut pesto.",
            image: "https://images.unsplash.com/photo-1603532648955-039310d9ed75?w=800",
            time: "30 min",
            servings: "2",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "4 to 6 lamb rib chops, trimmed",
                "1 cup fresh organic mint leaves",
                "1/4 cup baby spinach (for structure and color)",
                "2 tbsp toasted pine nuts",
                "1/2 lemon, juiced",
                "1/4 cup high-quality olive oil",
                "1 clove garlic, minced"
            ],
            instructions: [
                "**The Mint Pesto**: In a small processor (or mortar and pestle), combine mint, spinach, pine nuts, garlic, and lemon juice. Pulse while drizzling in the olive oil until it reaches a vibrant green, textured sauce. The spinach ensures the pesto stays bright green and doesn't oxidize too quickly.",
                "**Tempering and Seasoning**: Season the lamb chops generously with coarse salt and pepper. Let them sit at room temperature for 20 minutes.",
                "**The Grill**: Heat a grill pan or outdoor grill to high heat. Sear the lamb chops for approximately 3 minutes per side for a perfect medium-rare (internal temp 135°F). Lamb fat should be rendered and crispy.",
                "**The Rest**: Place the chops on a warm plate and tent loosely with foil. Let them rest for 5 minutes. This is critical for the juices to stay within the meat.",
                "**Service**: Plate the chops, slightly overlapping. Spoon a generous amount of the fresh mint pesto over the center of each chop.",
                "**Garnish**: Scatter a few extra whole mint leaves and toasted pine nuts over the plate. The cooling mint is the ultimate companion to the rich, gamey flavor of the lamb."
            ],
            nutrition: NutritionInfo(calories: 580, protein: 38, carbs: 4, fat: 46, fiber: 2, sugar: 1, sodium: 340),
            tags: ["High Protein", "Gourmet", "Keto-Friendly"]
        ),
        
        RecipeModel(
            title: "Sheet Pan Sausage & Peppers",
            description: "A colorful, incredibly easy 'one-pan' wonder featuring artisanal Italian sausages and blistered sweet peppers.",
            image: "https://images.unsplash.com/photo-1543339308-43e59d6b73a6?w=800",
            time: "30 min",
            servings: "3",
            difficulty: "Easy",
            category: "Dinner",
            ingredients: [
                "4 large high-quality Italian sausages (sweet or hot)",
                "3 large bell peppers (red, orange, yellow), sliced into thick strips",
                "1 large red onion, cut into wedges",
                "2 tbsp extra virgin olive oil",
                "1 tsp dried oregano, 1/2 tsp garlic powder",
                "Fresh parsley for garnish"
            ],
            instructions: [
                "**Oven Prep**: Preheat your oven to 400°F (200°C). Use a large, rimmed baking sheet—the more surface area, the better the roasting (overcrowding causes steaming).",
                "**Vegetable Toss**: Place the peppers and onions directly on the sheet pan. Drizzle with olive oil, oregano, garlic powder, salt, and pepper. Use your hands to toss and coat every piece thoroughly.",
                "**The Sausage Placement**: Nestle the sausages among the vegetables. Prick each sausage once or twice with a fork—this prevents them from bursting and allows the juices to flavor the surrounding vegetables.",
                "**The Roast**: Bake for 25-30 minutes. Halfway through, use tongs to flip the sausages and toss the vegetables to ensure even browning.",
                "**High Heat Finish**: For the last 2 minutes, you can turn on the broiler to get some beautiful dark char marks on the peppers and sausage skins.",
                "**Service**: Serve as is for a low-carb meal, or inside a toasted sub roll with a smear of grainy mustard. Garnish with a heavy handful of fresh chopped parsley."
            ],
            nutrition: NutritionInfo(calories: 450, protein: 26, carbs: 14, fat: 34, fiber: 4, sugar: 8, sodium: 880),
            tags: ["Easy-Clean-Up", "One-Pan", "Hearty"]
        ),
        
        RecipeModel(
            title: "Eggplant Parmesan",
            description: "A lighter, healthier version of the Italian classic: baked (not fried) eggplant slices with marinara and fresh mozzarella.",
            image: "https://images.unsplash.com/photo-1628592102171-ade7163c46a6?w=800",
            time: "45 min",
            servings: "3",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "2 medium eggplants, sliced into 1/2-inch thick rounds",
                "1.5 cups high-quality marinara sauce",
                "1 ball (8 oz) fresh mozzarella, sliced thin or torn",
                "1/2 cup freshly grated Parmesan cheese",
                "1/2 cup panko breadcrumbs mixed with 1 tsp Italian herbs",
                "Fresh basil leaves for garnish",
                "2 tbsp extra virgin olive oil"
            ],
            instructions: [
                "**Salting the Eggplant**: Place eggplant rounds on a paper towel-lined tray. Sprinkle with salt and let sit for 20 minutes to draw out moisture and bitterness. Pat dry thoroughly.",
                "**The Oven 'Fry'**: Preheat oven to 425°F (220°C). Brush both sides of the eggplant rounds with olive oil and press one side into the herbed panko breadcrumbs. Place on a parchment-lined baking sheet and roast for 15-20 minutes until golden and tender.",
                "**Layering the Dish**: In a baking dish, spread a thin layer of marinara sauce. Arrange a layer of the roasted eggplant on top.",
                "**Cheese and Sauce**: Top the eggplant with more marinara, a few slices of mozzarella, and a sprinkle of Parmesan. Repeat the layers until all ingredients are used, ending with cheese on top.",
                "**The Melt**: Reduce oven to 375°F (190°C) and bake the layered dish for 20 minutes until the sauce is bubbling and the cheese is melted and slightly browned.",
                "**Finishing**: Let it rest for 10 minutes (this allows it to hold its shape better when sliced). Garnish with a generous scattering of fresh basil leaves before serving."
            ],
            nutrition: NutritionInfo(calories: 340, protein: 18, carbs: 24, fat: 18, fiber: 9, sugar: 10, sodium: 620),
            tags: ["Vegetarian", "Healthy-Comfort", "Italian-Style"]
        ),
        
        RecipeModel(
            title: "Teriyaki Glazed Tempeh",
            description: "Firm, protein-dense tempeh cubes crispy-seared and glazed in a house-made ginger-maple teriyaki, served with tender broccolini.",
            image: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800",
            time: "25 min",
            servings: "2",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "1 block (8 oz) organic tempeh, cubed into 1-inch pieces",
                "1/4 cup tamari or soy sauce",
                "2 tbsp pure maple syrup",
                "1 tsp fresh ginger, grated",
                "1 bundle organic broccolini, trimmed",
                "1 tbsp avocado oil (high heat)",
                "Toasted sesame seeds for garnish"
            ],
            instructions: [
                "**Tempeh Steam**: Optional but recommended: Steam the tempeh cubes for 10 minutes before cooking. This removes the natural bitterness and allows them to absorb more glaze.",
                "**The Glaze Mix**: In a small jar, whisk together the tamari, maple syrup, and grated ginger. The maple syrup provides a sophisticated sweetness that caramelizes better than white sugar.",
                "**The Sear**: Heat the oil in a large skillet over medium-high heat. Add the tempeh cubes and sear for 3-4 minutes per side until they are golden brown and have a distinct 'crunch' on the edges.",
                "**Veggies in the Pan**: Add the broccolini to the pan with a tiny splash of water. Cover for 2 minutes to steam-cook the greens while the tempeh stays hot.",
                "**The Glazing**: Remove the lid and pour the teriyaki mixture into the pan. Toss constantly as the sauce bubbles and reduces into a thick, glossy glaze that coats every surface of the tempeh and broccolini.",
                "**Presentation**: Divide into bowls over a bed of brown rice or quinoa. Sprinkle with toasted sesame seeds. The fermented depth of the tempeh paired with the zingy glaze is a vegetarian powerhouse."
            ],
            nutrition: NutritionInfo(calories: 380, protein: 26, carbs: 34, fat: 16, fiber: 10, sugar: 12, sodium: 620),
            tags: ["Vegan", "High Protein", "Fermented-Foods"]
        ),
        
        RecipeModel(
            title: "Grilled Lemon Garlic Shrimp",
            description: "Succulent jumbo shrimp marinated in a bright citrus-garlic emulsion and grilled to charred perfection.",
            image: "https://images.unsplash.com/photo-1559742811-82410b451b94?w=800",
            time: "20 min",
            servings: "2",
            difficulty: "Easy",
            category: "Dinner",
            ingredients: [
                "1 lb jumbo shrimp, peeled and deveined (tail on)",
                "3 tbsp extra virgin olive oil",
                "4 cloves garlic, minced very fine",
                "1 lemon, zest and juice",
                "1/2 tsp red chili flakes (optional)",
                "1 tsp dried oregano",
                "Handful of fresh parsley, chopped"
            ],
            instructions: [
                "**The Quick Marinade**: In a large bowl, whisk together the olive oil, garlic, lemon zest, lemon juice, chili flakes, oregano, salt, and pepper. This is a powerful marinade that works very quickly.",
                "**Infusing the Shrimp**: Add the shrimp to the marinade and toss to coat every piece. Let them sit in the refrigerator for exactly 15-20 minutes. Do not marinate for longer, or the acidity in the lemon will start to 'cook' the delicate shrimp.",
                "**Skewer Preparation**: If using a grill, Thread 5-6 shrimp onto each skewer. If using a heavy grill pan, ensure it is preheated until it's smoking hot.",
                "**High-Heat Grilled**: Place the shrimp skewers or single shrimp onto the grill. Cook for 2-3 minutes per side. They are done when they turn opaque and form a tight 'C' shape. Watch for the beautiful char marks.",
                "**The Baste**: During the last minute of cooking, brush any remaining marinade from the bowl over the shrimp for a final burst of flavor.",
                "**Plating**: Serve the shrimp immediately on a warm platter. Garnish with a heavy handful of fresh parsley and a few fresh lemon wedges. These are perfect over a bed of light orzo or simply as they are."
            ],
            nutrition: NutritionInfo(calories: 260, protein: 34, carbs: 4, fat: 12, fiber: 1, sugar: 1, sodium: 420),
            tags: ["Low Carb", "Keto", "High Protein"]
        ),
        
        RecipeModel(
            title: "Thin Crust Truffle Pizza",
            description: "A gourmet, artisanal flatbread-style pizza topped with earthy forest mushrooms, melted buffalo mozzarella, and a decadent final drizzle of white truffle oil.",
            image: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800",
            time: "20 min",
            servings: "2",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "1 ball artisanal pizza dough (or high-quality pre-made flatbread)",
                "1 cup mixed wild mushrooms (cremini, shiitake, oyster), sliced",
                "1/2 cup fresh buffalo mozzarella, torn into pieces",
                "1 tsp high-grade white truffle oil",
                "1 tsp fresh thyme leaves",
                "Semolina flour for dusting"
            ],
            instructions: [
                "**Oven Crank**: Preheat your oven to its absolute highest setting (usually 500-550°F). If you have a pizza stone, place it in the oven 30 minutes prior.",
                "**The Dough Stretch**: On a surface dusted with semolina, stretch the dough as thin as possible without tearing. A thin crust provides the perfect crispy canvas for the rich toppings.",
                "**Mushroom Prep**: Quickly sauté the mushrooms in a hot pan with a tiny bit of butter for 3 minutes before putting them on the pizza. This prevents them from releasing too much water during the bake.",
                "**Topping**: Top the stretched dough with the par-cooked mushrooms, the torn mozzarella, and a sprinkle of fresh thyme.",
                "**The Blistering Bake**: Slide the pizza onto the stone or a hot baking sheet. Bake for 8-10 minutes until the edges are charred and the cheese is bubbling and golden-brown.",
                "**The Truffle Finish**: DO NOT cook the truffle oil. Drizzle it over the pizza the moment it comes out of the oven. The residual heat will release the intense truffle aroma without destroying its delicate flavor."
            ],
            nutrition: NutritionInfo(calories: 510, protein: 20, carbs: 64, fat: 22, fiber: 3, sugar: 4, sodium: 680),
            tags: ["Vegetarian", "Gourmet-Standard", "Treat-Meal"]
        ),
        
        RecipeModel(
            title: "Fiesta Lime Burrito Bowl",
            description: "A vibrant, nutrient-dense feast featuring zesty cilantro-lime brown rice, charred corn, and expertly marinated grilled chicken.",
            image: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800",
            time: "30 min",
            servings: "2",
            difficulty: "Medium",
            category: "Lunch",
            ingredients: [
                "1 cup long-grain brown rice",
                "1/4 cup fresh cilantro, finely chopped",
                "2 fresh limes (1 for juice, 1 for wedges)",
                "2 organic chicken breasts, seasoned with cumin and lime",
                "1 can black beans, rinsed and warmed",
                "1/2 cup corn kernels (charred in a pan)",
                "1/2 ripe avocado, sliced"
            ],
            instructions: [
                "**The Infused Rice**: Cook the brown rice until tender. While still hot, fold in the fresh cilantro, the juice of one lime, and a pinch of salt. This creates a bright, aromatic base for the bowl.",
                "**Chicken Grilling**: Season the chicken breasts with cumin, chili powder, and lime juice. Grill for 6-7 minutes per side until fully cooked but still juicy. Let the chicken rest for 5 minutes before slicing into thin strips.",
                "**The Charred Corn**: Add the corn to a screaming hot dry skillet for 2-3 minutes until you see dark brown char marks. This adds a smoky depth to the bowl.",
                "**The Bean Base**: Heat the black beans with a splash of water and a pinch of cumin until warmed through.",
                "**Building the Bowl**: Start with a generous base of the cilantro-lime rice. Arrange the chicken, beans, and charred corn in separate sections on top. The color contrast is key to a premium presentation.",
                "**The Finishing Touch**: Place the avocado slices in the center and serve with a fresh lime wedge. Add a spoonful of Greek yogurt or fresh salsa if desired for moisture."
            ],
            nutrition: NutritionInfo(calories: 580, protein: 38, carbs: 68, fat: 20, fiber: 14, sugar: 4, sodium: 520),
            tags: ["High Protein", "Mexican-Inspired", "Nutrient-Dense"]
        ),
        
        RecipeModel(
            title: "Blueberry Protein Pancakes",
            description: "Fluffy, high-protein oat pancakes bursting with fresh blueberries and topped with a natural vanilla protein glaze.",
            image: "https://images.unsplash.com/photo-1528207776546-365bb710ee9a?w=800",
            time: "20 min",
            servings: "2",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1 cup rolled oats, blended into flour",
                "2 scoops (60g) vanilla protein powder",
                "1 large egg",
                "1/2 cup Greek yogurt",
                "1/2 cup fresh organic blueberries",
                "1/2 tsp baking powder"
            ],
            instructions: [
                "**The Batter Fusion**: In a blender, combine the oats, protein powder, egg, Greek yogurt, and baking powder. Blend until smooth. Let the batter rest for 5 minutes—this allows the oats to thicken the mixture naturally.",
                "**Folding the Fruit**: Gently fold the fresh blueberries into the thickened batter. Do not overmix, or your pancakes will turn purple!",
                "**The Griddle Step**: Heat a non-stick griddle over medium heat. Use a 1/4 cup measure to pour the batter. Cook until bubbles form on the surface, then flip carefully.",
                "**Golden Standard**: Cook for another 1-2 minutes until both sides are golden brown and the pancakes feel springy to the touch.",
                "**The Glaze (Optional)**: Mix a teaspoon of protein powder with a tiny splash of water to create a high-protein 'icing' to drizzle over the top.",
                "**Presentation**: Stack three pancakes high. Top with extra fresh blueberries and a light dusting of cinnamon. These are far more satiating than traditional flour-based pancakes."
            ],
            nutrition: NutritionInfo(calories: 410, protein: 34, carbs: 48, fat: 10, fiber: 8, sugar: 8, sodium: 310),
            tags: ["High Protein", "Fitness-Focused", "Breakfast-Standard"]
        ),
        
        RecipeModel(
            title: "Ginger Garlic Chicken Stir-fry",
            description: "A lightning-fast, high-protein stir-fry featuring tender chicken strips and a vibrant array of 'al dente' vegetables in a savory ginger emulsion.",
            image: "https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800",
            time: "15 min",
            servings: "2",
            difficulty: "Easy",
            category: "Dinner",
            ingredients: [
                "2 organic chicken breasts, sliced into thin strips",
                "1 small head of broccoli, cut into small florets",
                "2 carrots, sliced into thin rounds",
                "1 bell pepper, sliced into strips",
                "2 tbsp low-sodium soy sauce",
                "1 tbsp fresh ginger, finely grated",
                "2 cloves garlic, minced"
            ],
            instructions: [
                "**The Searing Phase**: Heat a wok or large skillet over high heat until it's nearly smoking. Add a tiny splash of oil, then the chicken. Sear for 3-4 minutes until golden and nearly cooked through. Remove chicken from the pan.",
                "**Vegetable Flash-Cook**: Add the broccoli, carrots, and bell peppers to the hot pan. Add 1 tablespoon of water and cover for 60 seconds to steam them slightly while keeping their snap.",
                "**Aromatic Infusion**: Remove the lid and add the garlic and ginger to the center of the pan. Stir for 30 seconds until the aroma fills the kitchen.",
                "**Glazing**: Return the chicken to the pan and pour in the soy sauce. Toss everything together for 1-2 minutes over high heat.",
                "**The Result**: The sauce should thicken slightly and coat every piece of chicken and vegetable in a savory, aromatic glaze.",
                "**Serving**: Serve immediately on its own for a low-carb dinner or over a bed of jasmine rice. The fresh ginger is the key to this dish's restaurant-quality taste."
            ],
            nutrition: NutritionInfo(calories: 360, protein: 42, carbs: 14, fat: 12, fiber: 6, sugar: 4, sodium: 640),
            tags: ["Low Carb", "Fast-Cooking", "High Protein"]
        ),
        
        RecipeModel(
            title: "Quinoa Stuffed Peppers",
            description: "Vibrant bell peppers packed with a protein-rich blend of quinoa, black beans, and melted pepper jack cheese.",
            image: "https://images.unsplash.com/photo-1563612116625-3012372fccce?w=800",
            time: "45 min",
            servings: "3",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "3 large bell peppers (red, yellow, or orange), tops removed and deseeded",
                "1.5 cups cooked white or tri-color quinoa",
                "1/2 cup organic black beans, rinsed",
                "1/2 cup sweet corn kernels",
                "1 cup chunky fire-roasted salsa",
                "1/2 cup shredded Pepper Jack cheese",
                "1 tsp ground cumin, 1/2 tsp chili powder",
                "Fresh cilantro for garnish"
            ],
            instructions: [
                "**Pepper Pre-Bake**: Preheat your oven to 375°F (190°C). Place the hollowed-out bell peppers upright in a baking dish with 1/4 inch of water at the bottom. Cover with foil and bake for 10 minutes—this ensures the peppers are perfectly tender when the filling is done.",
                "**The Filling Mix**: In a large bowl, combine the cooked quinoa, black beans, corn, fire-roasted salsa, cumin, and chili powder. Stir until all the quinoa is coated in the salsa's moisture.",
                "**Cheese Integration**: Add half of the Pepper Jack cheese to the quinoa mixture. This allows the filling to 'bind' together as the internal cheese melts.",
                "**Stuffing Technique**: Remove the peppers from the oven and carefully drain any water. Spoon the quinoa mixture into each bell pepper, pressing down gently with a spoon to ensure they are packed to the top.",
                "**The Final Bake**: Sprinkle the remaining cheese over the top of each pepper. Return to the oven (uncovered) and bake for another 20-25 minutes. The peppers should be soft and slightly shriveled, and the cheese should be bubbling and golden.",
                "**Serving**: Let them rest for 5 minutes before serving (the filling will be very hot). Garnish with fresh cilantro and perhaps a dollop of Greek yogurt or avocado slices for a complete meal."
            ],
            nutrition: NutritionInfo(calories: 380, protein: 16, carbs: 54, fat: 12, fiber: 11, sugar: 8, sodium: 640),
            tags: ["Vegetarian", "High Fiber", "Colorful"]
        ),
        
        RecipeModel(
            title: "Turkey Avocado Club Wrap",
            description: "A clean, protein-packed wrap featuring slow-roasted turkey breast, creamy Hass avocado, and a crisp garden-fresh crunch.",
            image: "https://images.unsplash.com/photo-1544681280-d25a782adc9b?w=800",
            time: "10 min",
            servings: "1",
            difficulty: "Easy",
            category: "Lunch",
            ingredients: [
                "1 large whole-wheat or spinach-infused tortilla",
                "4 oz high-quality sliced turkey breast (nitrate-free)",
                "1/2 large Hass avocado, sliced",
                "2 crisp romaine lettuce leaves",
                "2 slices beefsteak tomato",
                "1 tsp Greek yogurt spread or Dijon mustard"
            ],
            instructions: [
                "**The Foundation**: Lay the tortilla flat on a clean surface. Spread a thin layer of Greek yogurt spread or Dijon mustard across the center to act as a flavor binder.",
                "**Layering for Stability**: Place the romaine lettuce leaves in the center. This acts as a moisture barrier between the meat/avocado and the tortilla, preventing sogginess.",
                "**Protein & Fats**: Arrange the turkey breast slices over the lettuce, followed by a layer of sliced avocado and tomato. Sprinkle a tiny pinch of salt and pepper over the avocado to make the flavor pop.",
                "**The Tight Wrap**: Fold the left and right sides of the tortilla inward. Starting from the bottom, roll the wrap up tightly, keeping constant pressure to ensure a compact, deli-style result.",
                "**Service**: Slice the wrap diagonally in the center with a very sharp bread knife. This shows off the beautiful cross-section of colors and textures.",
                "**Freshness Note**: Serve immediately for the best texture. The contrast of the creamy avocado and crisp lettuce is the hallmark of a premium club wrap."
            ],
            nutrition: NutritionInfo(calories: 340, protein: 28, carbs: 24, fat: 18, fiber: 9, sugar: 3, sodium: 580),
            tags: ["Quick", "Clean Eating", "On-The-Go"]
        ),
        
        RecipeModel(
            title: "Tropical Green Glow Smoothie",
            description: "A vibrant, nutrient-dense elixir of baby spinach, frozen pineapple, and hydrating coconut water for a natural skin and energy boost.",
            image: "https://images.unsplash.com/photo-1623065422902-30a2ad299dd4?w=800",
            time: "5 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "2 cups packed organic baby spinach",
                "1 cup frozen pineapple chunks (adds natural frostiness)",
                "1.5 cups pure chilled coconut water",
                "1 tbsp chia seeds or hemp seeds",
                "1/2 tsp fresh grated ginger (optional for a zingy kick)"
            ],
            instructions: [
                "**High-Speed Blending**: Place the chilled coconut water in the blender first. Adding liquid first prevents the blades from getting stuck and ensures a smoother vortex.",
                "**The Greens Layer**: Add the spinach and blend on high for 30 seconds before adding anything else. This 'pre-blend' ensures there are zero leafy bits in your final smoothie.",
                "**The Frost**: Add the frozen pineapple chunks. Using frozen fruit instead of ice prevents the smoothie from being watered down while providing a thick, frosty texture.",
                "**The Glow Add-ins**: Add the chia seeds and fresh ginger. These provide the healthy fats and anti-inflammatory properties that give the 'glow' effect.",
                "**Final Emulsion**: Blend on high for another 30 seconds until the color is a vibrant, uniform electric green.",
                "**Presentation**: Pour into a tall chilled glass. For a premium touch, garnish with a tiny pineapple wedge or a stir of extra hemp seeds on top."
            ],
            nutrition: NutritionInfo(calories: 210, protein: 5, carbs: 46, fat: 4, fiber: 8, sugar: 28, sodium: 120),
            tags: ["Vegan", "Refreshing", "Detox-Friendly"]
        ),
        
        RecipeModel(
            title: "Greek Yogurt & Honey Parfait",
            description: "Layered artisanal yogurt with toasted almond granola, fresh macerated berries, and a drizzle of premium Manuka honey.",
            image: "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800",
            time: "5 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1 cup thick, plain Greek yogurt (2% or full fat for creaminess)",
                "1/2 cup high-protein almond granola",
                "1/2 cup mixed fresh berries (raspberries and blueberries)",
                "1 tbsp high-quality honey or agave",
                "A pinch of ground cinnamon"
            ],
            instructions: [
                "**The Yogurt Base**: Start with half of the Greek yogurt at the bottom of a wide glass or bowl. Use a spoon to smooth it flat.",
                "**The Berry Layer**: Place half of the fresh berries on top. Lightly press them into the yogurt so they stay in place.",
                "**Crunch Contrast**: Add half of the granola. The layering prevents the granola from getting soggy before you reach the bottom.",
                "**The Repeat**: Repeat the layers with the remaining yogurt, berries, and granola.",
                "**The Golden Drizzle**: Drizzle the honey in a thin, circular motion over the top layer. The honey will naturally seep down through the granola.",
                "**The Final Hint**: Finish with a tiny dust of cinnamon. Serving in a glass allows the beautiful layers to be visible, making a simple snack feel like a premium dessert."
            ],
            nutrition: NutritionInfo(calories: 320, protein: 22, carbs: 42, fat: 8, fiber: 6, sugar: 18, sodium: 90),
            tags: ["Vegetarian", "High Protein", "Quick-Assembly"]
        ),
        
        RecipeModel(
            title: "Grilled Shrimp Tacos",
            description: "Smoky, chili-rubbed shrimp nestled in warm corn tortillas with a cooling lime-garlic crema and zesty slaw.",
            image: "https://images.unsplash.com/photo-1565299585323-38d6b0865ef4?w=800",
            time: "20 min",
            servings: "2",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "1/2 lb jumbo shrimp, peeled and deveined",
                "1 cup finely shredded red and green cabbage",
                "4 small organic yellow corn tortillas",
                "1/4 cup Greek yogurt or sour cream",
                "1 clove garlic, minced to a paste",
                "1 tbsp lime juice",
                "1 tsp chili powder, 1/2 tsp cumin"
            ],
            instructions: [
                "**Shrimp Seasoning**: Toss the shrimp with chili powder, cumin, and a tiny bit of oil. Let them sit for 5 minutes while you prep the other components.",
                "**The Zesty Slaw**: In a small bowl, toss the shredded cabbage with half of the lime juice and a pinch of salt. This 'quick pickle' method adds a necessary acidic crunch.",
                "**Lime-Garlic Crema**: Whisk together the Greek yogurt, minced garlic, and the remaining lime juice. If it's too thick, add a teaspoon of water until it's a drizzlable consistency.",
                "**The Quick Sear**: Grill the shrimp in a hot pan for 2 minutes per side until they are charred and opaque. Do not overcook!",
                "**Tortilla Char**: Warm the tortillas directly over a gas flame for 5-10 seconds per side until they have slight char marks and become pliable.",
                "**Assembly Philosophy**: Place two tortillas on each plate. Distribute the cabbage slaw, then the shrimp. Drizzle a generous amount of crema and finish with fresh cilantro or a few slices of radish for a gourmet look."
            ],
            nutrition: NutritionInfo(calories: 380, protein: 32, carbs: 38, fat: 14, fiber: 5, sugar: 4, sodium: 540),
            tags: ["Seafood", "Fresh", "High Protein"]
        ),
        
        RecipeModel(
            title: "Acai Power Smoothie Bowl",
            description: "A superfood powerhouse: a thick, velvety acai and berry base topped with nutrient-dense seeds and artisanal nut butter.",
            image: "https://images.unsplash.com/photo-1626074353765-517a681e40be?w=800",
            time: "10 min",
            servings: "1",
            difficulty: "Easy",
            category: "Breakfast",
            ingredients: [
                "1 unsweetened pure acai frozen packet",
                "1 medium frozen banana (for creaminess)",
                "1/4 cup unsweetened almond milk",
                "1 tbsp organic hemp seeds",
                "1 tbsp creamy almond butter",
                "Handful of fresh berries and goji berries"
            ],
            instructions: [
                "**The Master Blend**: Run the acai packet under warm water for 10 seconds to loosen. Place it in a high-speed blender with the frozen banana and almond milk. Blend on the lowest setting, using a tamper if necessary, to create a texture like thick soft-serve ice cream.",
                "**The Pour**: Transfer the thick purple puree into a wide bowl. Smooth the surface with the back of a spoon to create a flat canvas.",
                "**Nutrient Toppings**: Arrange the hemp seeds and goji berries in neat rows or clusters on one side of the bowl. This is where the aesthetic appeal of a smoothie bowl comes from.",
                "**The Fruit Layer**: Scatter the fresh berries in the center. The variety of colors against the deep purple acai is striking.",
                "**The Butter Swirl**: Scoop the almond butter and drizzle it in a thin, elegant line or swirl over the entire bowl.",
                "**Service**: Serve immediately before it starts to melt. This bowl is packed with antioxidants and provides long-lasting energy without the sugar crash."
            ],
            nutrition: NutritionInfo(calories: 440, protein: 12, carbs: 58, fat: 22, fiber: 12, sugar: 18, sodium: 60),
            tags: ["Superfood", "Vegan", "Antioxidant-Rich"]
        ),
        
        RecipeModel(
            title: "Chicken Teriyaki & Broccoli",
            description: "A high-protein classic: tender chicken breast glazed in a reduced ginger-soy reduction, served with vibrant steamed broccolini and nutty brown rice.",
            image: "https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=800",
            time: "25 min",
            servings: "2",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "2 organic chicken breasts, sliced into bite-sized medallions",
                "2 cups fresh broccolini or broccoli florets",
                "1/4 cup low-sodium soy sauce",
                "2 tbsp pure maple syrup or honey",
                "1 tsp fresh grated ginger, 1 clove garlic, minced",
                "1 cup cooked long-grain brown rice"
            ],
            instructions: [
                "**House-made Teriyaki**: In a small saucepan, combine soy sauce, maple syrup, ginger, and garlic. Simmer over low heat for 5-7 minutes until the sauce reduces slightly and becomes thick and glossy.",
                "**The Searing**: High-heat sear the chicken medallions in a very hot pan for 3-4 minutes per side until deeply browned and just cooked through. Remove any excess moisture from the pan.",
                "**The Glaze**: Pour the hot teriyaki reduction over the chicken in the pan. Toss vigorously—the sugar in the syrup will caramelize quickly, creating a sticky, professional glaze.",
                "**Steam Control**: While the chicken glazes, steam the broccoli in a separate steamer basket for exactly 3 minutes. It should be vibrant green and have a slight 'snap'.",
                "**Plating Philosophy**: Create a neat bed of brown rice on the plate. Top with the glazed chicken, ensuring some of the extra sauce runs onto the rice.",
                "**Final Garnish**: Place the steamed broccoli alongside. Sprinkle with a few sesame seeds for a classic look. This is the ultimate meal-prep staple made gourmet."
            ],
            nutrition: NutritionInfo(calories: 480, protein: 42, carbs: 54, fat: 12, fiber: 8, sugar: 14, sodium: 680),
            tags: ["Hearty", "Classic", "High Protein"]
        ),
        
        RecipeModel(
            title: "Twice-Baked Loaded Sweet Potato",
            description: "A nutrient-dense masterpiece: slow-roasted sweet potato fluff mixed with sautéed kale and crispy chickpeas, finished with a velvet tahini elixir.",
            image: "https://images.unsplash.com/photo-1596040033229-a9821ebd05de?w=800",
            time: "50 min",
            servings: "2",
            difficulty: "Medium",
            category: "Dinner",
            ingredients: [
                "2 large organic sweet potatoes",
                "2 cups fresh baby kale, finely chopped",
                "1/2 cup canned chickpeas, roasted until crispy",
                "2 tbsp organic tahini",
                "1 tbsp fresh lemon juice, 1 tsp maple syrup",
                "Pomegranate seeds for garnish (optional)"
            ],
            instructions: [
                "**The Initial Roast**: Scrub the sweet potatoes and prick them with a fork. Bake at 400°F (200°C) for 45-50 minutes until soft to the touch and the skins are starting to pull away.",
                "**The Stuffing Mix**: While potatoes cool slightly, sauté the kale in a pan with a drop of oil and some salt until wilted. In a separate pan, roast the chickpeas with a dash of cumin until they are crunchy.",
                "**The Twice-Baked Prep**: Slice the potatoes lengthwise and carefully scoop out the hot orange flesh into a bowl, leaving a sturdy shell. Mash the flesh with a splash of lemon juice.",
                "**The Merge**: Fold the sautéed kale and half of the crispy chickpeas into the mashed potato. Spoon the mixture back into the skins, piling it high.",
                "**The Final Crisp**: Return the stuffed potatoes to the oven for 5 minutes to heat through and crisp the tops.",
                "**The Garnish Art**: Whisk the tahini with lemon juice, maple syrup, and a splash of water. Drizzle generously over the stuffed potatoes. Top with the remaining crunchy chickpeas and a few pomegranate seeds for a burst of color and sweetness."
            ],
            nutrition: NutritionInfo(calories: 340, protein: 11, carbs: 56, fat: 12, fiber: 14, sugar: 12, sodium: 220),
            tags: ["Vegetarian", "High Fiber", "Nutrient-Dense"]
        ),
    ]
}
