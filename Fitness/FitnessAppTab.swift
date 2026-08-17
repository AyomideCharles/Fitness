import SwiftUI

struct FitnessAppTab: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab("Workoutl", systemImage: "dumbbell.fill") {
                Text("Text")
            }
            Tab("Profile", systemImage: "person.crop.circle") {
                Text("Profile")
            }
        }    }
}

#Preview {
    FitnessAppTab()
}
