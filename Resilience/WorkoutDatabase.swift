import Foundation

class WorkoutDatabase {
    static let shared = WorkoutDatabase()
    
    var exercises: [Exercise] = [
        // --- CHEST ---
        Exercise(id: UUID(), exerciseName: "Barbell Bench Press", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400", primaryMuscleGroup: "Chest", secondaryMuscles: "Triceps, Shoulders", requiredEquipment: "Barbell"),
        Exercise(id: UUID(), exerciseName: "Incline Dumbbell Press", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1581009146145-b5ef03a7403f?w=400", primaryMuscleGroup: "Chest", secondaryMuscles: "Shoulders", requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Cable Chest Fly", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1590487988256-9ed24133863e?w=400", primaryMuscleGroup: "Chest", secondaryMuscles: nil, requiredEquipment: "Cables"),
        Exercise(id: UUID(), exerciseName: "Weighted Dips", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1598575435274-abc77a12af5b?w=400", primaryMuscleGroup: "Chest", secondaryMuscles: "Triceps", requiredEquipment: "Dip Bar"),
        Exercise(id: UUID(), exerciseName: "Pushups", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1598971639058-aba3c3995646?w=400", primaryMuscleGroup: "Chest", secondaryMuscles: "Core", requiredEquipment: "Bodyweight"),
        Exercise(id: UUID(), exerciseName: "Decline Bench Press", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400", primaryMuscleGroup: "Chest", secondaryMuscles: "Triceps", requiredEquipment: "Barbell"),
        Exercise(id: UUID(), exerciseName: "Pec Deck Machine", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=400", primaryMuscleGroup: "Chest", secondaryMuscles: nil, requiredEquipment: "Machine"),
        Exercise(id: UUID(), exerciseName: "Dumbbell Pullover", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1599058917232-d750c201ee92?w=400", primaryMuscleGroup: "Chest", secondaryMuscles: "Lats", requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Diamond Pushups", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400", primaryMuscleGroup: "Chest", secondaryMuscles: "Triceps", requiredEquipment: "Bodyweight"),
        Exercise(id: UUID(), exerciseName: "Chest Press Machine", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1534367507873-d2b7e2495b27?w=400", primaryMuscleGroup: "Chest", secondaryMuscles: "Shoulders", requiredEquipment: "Machine"),

        // --- BACK ---
        Exercise(id: UUID(), exerciseName: "Deadlift", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1532029837206-abbe2b7620e3?w=400", primaryMuscleGroup: "Back", secondaryMuscles: "Legs, Core", requiredEquipment: "Barbell"),
        Exercise(id: UUID(), exerciseName: "Pullups", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1598575435274-abc77a12af5b?w=400", primaryMuscleGroup: "Back", secondaryMuscles: "Biceps", requiredEquipment: "Pullup Bar"),
        Exercise(id: UUID(), exerciseName: "Bent Over Barbell Row", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=400", primaryMuscleGroup: "Back", secondaryMuscles: "Rear Delts", requiredEquipment: "Barbell"),
        Exercise(id: UUID(), exerciseName: "Lat Pulldown", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1590487988256-9ed24133863e?w=400", primaryMuscleGroup: "Back", secondaryMuscles: "Biceps", requiredEquipment: "Machine"),
        Exercise(id: UUID(), exerciseName: "Seated Cable Row", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=400", primaryMuscleGroup: "Back", secondaryMuscles: "Biceps", requiredEquipment: "Cables"),
        Exercise(id: UUID(), exerciseName: "Single Arm Dumbbell Row", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1581009146145-b5ef03a7403f?w=400", primaryMuscleGroup: "Back", secondaryMuscles: nil, requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "T-Bar Row", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1599058917232-d750c201ee92?w=400", primaryMuscleGroup: "Back", secondaryMuscles: nil, requiredEquipment: "Barbell"),
        Exercise(id: UUID(), exerciseName: "Back Extensions", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1574673163345-424a18055c1e?w=400", primaryMuscleGroup: "Back", secondaryMuscles: "Glutes", requiredEquipment: "Bench"),
        Exercise(id: UUID(), exerciseName: "Face Pulls", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1534367507873-d2b7e2495b27?w=400", primaryMuscleGroup: "Back", secondaryMuscles: "Rear Delts, Shoulders", requiredEquipment: "Cables"),
        Exercise(id: UUID(), exerciseName: "Chin-ups", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1598971639058-aba3c3995646?w=400", primaryMuscleGroup: "Back", secondaryMuscles: "Biceps", requiredEquipment: "Pullup Bar"),

        // --- SHOULDERS ---
        Exercise(id: UUID(), exerciseName: "Overhead Press", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=400", primaryMuscleGroup: "Shoulders", secondaryMuscles: "Triceps", requiredEquipment: "Barbell"),
        Exercise(id: UUID(), exerciseName: "Lateral Raises", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1581009146145-b5ef03a7403f?w=400", primaryMuscleGroup: "Shoulders", secondaryMuscles: nil, requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Arnold Press", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1590487988256-9ed24133863e?w=400", primaryMuscleGroup: "Shoulders", secondaryMuscles: "Triceps", requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Front Raises", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400", primaryMuscleGroup: "Shoulders", secondaryMuscles: nil, requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Reverse Pec Deck", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1534367507873-d2b7e2495b27?w=400", primaryMuscleGroup: "Shoulders", secondaryMuscles: "Rear Delts", requiredEquipment: "Machine"),
        Exercise(id: UUID(), exerciseName: "Upright Row", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1532029837206-abbe2b7620e3?w=400", primaryMuscleGroup: "Shoulders", secondaryMuscles: "Traps", requiredEquipment: "Barbell"),
        Exercise(id: UUID(), exerciseName: "Face Pulls", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1599058917232-d750c201ee92?w=400", primaryMuscleGroup: "Shoulders", secondaryMuscles: "Rear Delts", requiredEquipment: "Cables"),
        Exercise(id: UUID(), exerciseName: "Shrugs", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1574673163345-424a18055c1e?w=400", primaryMuscleGroup: "Shoulders", secondaryMuscles: "Traps", requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Battle Ropes", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1598971639058-aba3c3995646?w=400", primaryMuscleGroup: "Shoulders", secondaryMuscles: "Core, Endurance", requiredEquipment: "Ropes"),
        Exercise(id: UUID(), exerciseName: "Handstand Pushups", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400", primaryMuscleGroup: "Shoulders", secondaryMuscles: "Core, Triceps", requiredEquipment: "Bodyweight"),

        // --- ARMS ---
        Exercise(id: UUID(), exerciseName: "Barbell Curls", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1581009146145-b5ef03a7403f?w=400", primaryMuscleGroup: "Arms", secondaryMuscles: "Biceps", requiredEquipment: "Barbell"),
        Exercise(id: UUID(), exerciseName: "Tricep Pushdowns", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1590487988256-9ed24133863e?w=400", primaryMuscleGroup: "Arms", secondaryMuscles: "Triceps", requiredEquipment: "Cables"),
        Exercise(id: UUID(), exerciseName: "Hammer Curls", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400", primaryMuscleGroup: "Arms", secondaryMuscles: "Forearms", requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Skull Crushers", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1534367507873-d2b7e2495b27?w=400", primaryMuscleGroup: "Arms", secondaryMuscles: "Triceps", requiredEquipment: "Barbell"),
        Exercise(id: UUID(), exerciseName: "Preacher Curls", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1532029837206-abbe2b7620e3?w=400", primaryMuscleGroup: "Arms", secondaryMuscles: "Biceps", requiredEquipment: "Machine"),
        Exercise(id: UUID(), exerciseName: "Dips", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1599058917232-d750c201ee92?w=400", primaryMuscleGroup: "Arms", secondaryMuscles: "Chest, Triceps", requiredEquipment: "Bodyweight"),
        Exercise(id: UUID(), exerciseName: "Concentration Curls", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1574673163345-424a18055c1e?w=400", primaryMuscleGroup: "Arms", secondaryMuscles: "Biceps", requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Overhead Tricep Extension", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1598971639058-aba3c3995646?w=400", primaryMuscleGroup: "Arms", secondaryMuscles: "Triceps", requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Wrist Curls", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400", primaryMuscleGroup: "Arms", secondaryMuscles: "Forearms", requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Cable Bicep Curls", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=400", primaryMuscleGroup: "Arms", secondaryMuscles: "Biceps", requiredEquipment: "Cables"),

        // --- CORE ---
        Exercise(id: UUID(), exerciseName: "Plank", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400", primaryMuscleGroup: "Core", secondaryMuscles: "Shoulders", requiredEquipment: "Bodyweight"),
        Exercise(id: UUID(), exerciseName: "Hanging Leg Raises", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1534367507873-d2b7e2495b27?w=400", primaryMuscleGroup: "Core", secondaryMuscles: "Abs", requiredEquipment: "Pullup Bar"),
        Exercise(id: UUID(), exerciseName: "Russian Twists", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1532029837206-abbe2b7620e3?w=400", primaryMuscleGroup: "Core", secondaryMuscles: "Obliques", requiredEquipment: "Weight"),
        Exercise(id: UUID(), exerciseName: "Cable Woodchoppers", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1599058917232-d750c201ee92?w=400", primaryMuscleGroup: "Core", secondaryMuscles: "Obliques", requiredEquipment: "Cables"),
        Exercise(id: UUID(), exerciseName: "Bicycle Crunches", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1574673163345-424a18055c1e?w=400", primaryMuscleGroup: "Core", secondaryMuscles: "Abs", requiredEquipment: "Bodyweight"),
        Exercise(id: UUID(), exerciseName: "Ab Wheel Rollouts", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1598971639058-aba3c3995646?w=400", primaryMuscleGroup: "Core", secondaryMuscles: "Back", requiredEquipment: "Ab Wheel"),
        Exercise(id: UUID(), exerciseName: "Dead Bugs", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400", primaryMuscleGroup: "Core", secondaryMuscles: "Coordination", requiredEquipment: "Bodyweight"),
        Exercise(id: UUID(), exerciseName: "Side Plank", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=400", primaryMuscleGroup: "Core", secondaryMuscles: "Obliques", requiredEquipment: "Bodyweight"),
        Exercise(id: UUID(), exerciseName: "Dragon Flags", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1581009146145-b5ef03a7403f?w=400", primaryMuscleGroup: "Core", secondaryMuscles: "Full Body", requiredEquipment: "Bench"),
        Exercise(id: UUID(), exerciseName: "Bird Dog", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1590487988256-9ed24133863e?w=400", primaryMuscleGroup: "Core", secondaryMuscles: "Stability", requiredEquipment: "Bodyweight"),

        // --- LEGS ---
        Exercise(id: UUID(), exerciseName: "Barbell Back Squat", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400", primaryMuscleGroup: "Legs", secondaryMuscles: "Core, Glutes", requiredEquipment: "Barbell"),
        Exercise(id: UUID(), exerciseName: "Bulgarian Split Squats", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1598575435274-abc77a12af5b?w=400", primaryMuscleGroup: "Legs", secondaryMuscles: "Glutes", requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Leg Press", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1532029837206-abbe2b7620e3?w=400", primaryMuscleGroup: "Legs", secondaryMuscles: "Quads", requiredEquipment: "Machine"),
        Exercise(id: UUID(), exerciseName: "Leg Extensions", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=400", primaryMuscleGroup: "Legs", secondaryMuscles: nil, requiredEquipment: "Machine"),
        Exercise(id: UUID(), exerciseName: "Lying Leg Curls", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1581009146145-b5ef03a7403f?w=400", primaryMuscleGroup: "Legs", secondaryMuscles: "Hamstrings", requiredEquipment: "Machine"),
        Exercise(id: UUID(), exerciseName: "Romanian Deadlift", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1590487988256-9ed24133863e?w=400", primaryMuscleGroup: "Legs", secondaryMuscles: "Hamstrings, Glutes", requiredEquipment: "Barbell"),
        Exercise(id: UUID(), exerciseName: "Calf Raises", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400", primaryMuscleGroup: "Legs", secondaryMuscles: "Calves", requiredEquipment: "Step"),
        Exercise(id: UUID(), exerciseName: "Lunges", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1534367507873-d2b7e2495b27?w=400", primaryMuscleGroup: "Legs", secondaryMuscles: "Glutes", requiredEquipment: "Dumbbells"),
        Exercise(id: UUID(), exerciseName: "Box Jumps", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1599058917232-d750c201ee92?w=400", primaryMuscleGroup: "Legs", secondaryMuscles: "Explosiveness", requiredEquipment: "Plyo Box"),
        Exercise(id: UUID(), exerciseName: "Hip Thrusts", videoUrl: nil, thumbnailUrl: "https://images.unsplash.com/photo-1574673163345-424a18055c1e?w=400", primaryMuscleGroup: "Legs", secondaryMuscles: "Glutes", requiredEquipment: "Barbell")
    ]
}
