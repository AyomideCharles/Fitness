//import Foundation
//
//final class ExerciseNetworkManager {
//    static let shared = ExerciseNetworkManager()
//    private let baseURL = "https://oss.exercisedb.dev/api/v1/exercises"
//    private init() {}
//    
////    https://oss.exercisedb.dev/api/v1/exercises
//    
//    
//    func getExercises() async throws -> [ExerciseModel] {
//        guard let url = URL(string: baseURL) else {
//            throw ApiError.invalidURL
//        }
//        
//        let (data, _) = try await URLSession.shared.data(from: url)
//        do {
//            let decoder = JSONDecoder()
//            let response = try decoder.decode(ExerciseResponse.self, from: data) 
//            return response.data
//        } catch {
//            throw ApiError.decodingFailed
//        }
//    }
//}



import Foundation

final class ExerciseNetworkManager {
    static let shared = ExerciseNetworkManager()
    private let baseURL = "https://edb-with-videos-and-images-by-ascendapi.p.rapidapi.com"
    private let apiKey = "a976377ab1msha346881280778a9p121340jsne6ccef267106"
    private let apiHost = "edb-with-videos-and-images-by-ascendapi.p.rapidapi.com"
    private init() {}

    func getExercises() async throws -> [ExerciseModel] {
        guard let url = URL(string: "\(baseURL)/api/v1/exercises") else {
            throw ApiError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiHost, forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")

        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ExerciseResponse.self, from: data)
            return response.data
        } catch {
            throw ApiError.decodingFailed
        }
    }
    
    
    func getExerciseById(id: String) async throws -> ExerciseDetailModel {
        guard let url = URL(string: "\(baseURL)/api/v1/exercises/\(id)") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiHost, forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ExerciseDetailResponse.self, from: data)
            return response.data
        } catch {
            throw ApiError.decodingFailed
        }
    }
}
