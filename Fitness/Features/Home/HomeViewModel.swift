import SwiftUI
import Combine


@MainActor final class HomeViewModel: ObservableObject {
    @Published var exercises: [ExerciseModel] = []
    @Published var isLoading: Bool = false
    @Published var alertItem: AlertItem?
    
    
    @Published var exerciseId: ExerciseDetailModel?

    
    func getExercises() {
        isLoading = true
        Task {
            do {
                exercises = try await ExerciseNetworkManager.shared.getExercises()
                isLoading = false
            } catch {
                alertItem = AlertContext.invalidResponse
                isLoading = false
            }
        }
    }
    
    
    func getExerciseById(id: String) {
        isLoading = true
        Task {
            do {
                exerciseId = try await ExerciseNetworkManager.shared.getExerciseById(id: id)
                isLoading = false
            } catch {
                alertItem = AlertContext.invalidResponse
                isLoading = false
            }
        }
    }
    
    
}


