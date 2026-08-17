import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
//    let exerciseId: String
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.exercises, id: \.id) { exercise in
                                NavigationLink(value: exercise) {
                                    HStack {
                                        AsyncImage(url: URL(string: exercise.imageUrl ?? "")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 100, height: 65)
                                        .clipped()
                                        .cornerRadius(8)
                                        
                                        Text(exercise.name)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                                Divider()
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle("Exercises")
            .navigationDestination(for: ExerciseModel.self) { exercise in
                ExerciseDetails(exerciseId: exercise.exerciseId)
            }
        }
        .task {
            viewModel.getExercises()
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}

#Preview {
    HomeView()
}

