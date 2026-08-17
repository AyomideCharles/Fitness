import Foundation


//struct ExerciseModel: Decodable, Identifiable {
//    var id: String { exerciseId }
//    let exerciseId: String
//    let name: String
//    let gifUrl: String
//    let bodyParts: [String]
//    let equipments: [String]
//    let targetMuscles: [String]
//    let secondaryMuscles: [String]
//    let instructions: [String]
//}

struct ExerciseModel: Decodable, Identifiable, Hashable {
    var id: String { exerciseId }
    let exerciseId: String
    let name: String
    let imageUrl: String?
    let gifUrl: String?
    let bodyParts: [String]
    let equipments: [String]
    let exerciseType: String?
    let targetMuscles: [String]
    let secondaryMuscles: [String]
    let keywords: [String]?
    let instructions: [String]?
}

struct ExerciseResponse: Decodable {
    let data: [ExerciseModel]
}

struct MockData {
    static let exerciseData = ExerciseModel (
        exerciseId: "exr_preview",
        name: "Bench Press",
        imageUrl: "https://cdn.exercisedb.dev/media/w/images/qkXo99D6UI.jpg",
        gifUrl: "https://cdn.exercisedb.dev/media/w/images/qkXo99D6UI.jpg",
        bodyParts: ["CHEST"],
        equipments: ["BARBELL"],
        exerciseType: "STRENGTH",
        targetMuscles: ["PECTORALIS MAJOR"],
        secondaryMuscles: ["TRICEPS", "DELTOIDS"],
        keywords: ["Chest workout", "Barbell exercise"],
        instructions: ["String"]
    )
}




