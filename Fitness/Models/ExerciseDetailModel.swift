import Foundation

struct ExerciseDetailModel: Decodable, Identifiable, Hashable {
    var id: String { exerciseId }
    let exerciseId: String
    let name: String
    let imageUrl: String
    let imageUrls: ImageURLs
    let equipments: [String]
    let bodyParts: [String]
    let exerciseType: String
    let targetMuscles: [String]
    let secondaryMuscles: [String]
    let videoUrl: String
    let keywords: [String]
    let overview: String
    let instructions: [String]
    let exerciseTips: [String]
    let variations: [String]
    let relatedExerciseIds: [String]
}

struct ImageURLs: Decodable, Hashable {
    let p360: String
    let p480: String
    let p720: String
    let p1080: String

    enum CodingKeys: String, CodingKey {
        case p360 = "360p"
        case p480 = "480p"
        case p720 = "720p"
        case p1080 = "1080p"
    }
}

struct ExerciseDetailResponse: Decodable {
    let data: ExerciseDetailModel
}
