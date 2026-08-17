import SwiftUI


struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidResponse =  AlertItem(title: Text("Invalid response"), message: Text("Response received is invalid"), dismissButton: .default(Text("OK")))
}

