import SwiftUI
import AVKit


struct FlowChips: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: width, height: y + rowHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x: CGFloat = bounds.minX, y: CGFloat = bounds.minY, rowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

struct RelatedExerciseCard: View {
    let exerciseId: String
    let accent: Color
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let details = viewModel.exerciseId {
                    AsyncImage(url: URL(string: details.imageUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        default:
                            Color(.tertiarySystemBackground)
                        }
                    }
                } else {
                    Color(.tertiarySystemBackground)
                    ProgressView()
                }
            }
            .frame(width: 140, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(viewModel.exerciseId?.name ?? "Loading…")
                .font(.caption.weight(.semibold))
                .lineLimit(2)
                .frame(width: 140, alignment: .leading)
        }
        .task {
            viewModel.getExerciseById(id: exerciseId)
        }
    }
}

struct ExerciseDetails: View {
    @StateObject var viewModel = HomeViewModel()
    let exerciseId: String
    private let accent = Color(red: 0.0, green: 0.72, blue: 0.66)
    
    private func sectionHeader(text: String) -> some View {
        Text(text)
            .font(.system(.title3, design: .rounded, weight: .bold))
    }
    
    @ViewBuilder
    private func muscleChips(details: ExerciseDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(text: "Muscles Worked")
            FlowChips {
                ForEach(details.targetMuscles, id: \.self) { muscle in
                    chip(text: muscle, filled: true)
                }
                ForEach(details.secondaryMuscles, id: \.self) { muscle in
                    chip(text: muscle, filled: false)
                }
            }
        }
    }
    
    private func chip(text: String, filled: Bool) -> some View {
        Text(text.capitalized)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(filled ? accent : Color(.secondarySystemBackground))
            .foregroundStyle(filled ? .white : .primary)
            .clipShape(Capsule())
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let details = viewModel.exerciseId {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        ZStack(alignment: .bottomLeading) {
                            AsyncImage(url: URL(string: details.imageUrls.p1080)) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().scaledToFill()
                                default:
                                    Rectangle().fill(Color(.secondarySystemBackground))
                                }
                            }
                            .frame(height: 340)
                            .clipped()
                            
                            LinearGradient(colors: [.clear, .black.opacity(0.75)], startPoint: .center, endPoint: .bottom)
                                .frame(height: 340)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Label(details.exerciseType.capitalized, systemImage: "bolt.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(accent)
                                
                                Text(details.name)
                                    .font(.system(.title, design: .rounded, weight: .bold))
                                    .foregroundStyle(.white)
                                
                                Text(details.equipments.map { $0.capitalized }.joined(separator: " · "))
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            .padding(20)
                        }
                        
                        VStack (alignment: .leading, spacing: 20) {
                            if let url = URL(string: details.videoUrl) {
                                VStack(alignment: .leading, spacing: 10) {
                                    sectionHeader(text: "Watch The Form")
                                    VideoPlayer(player: AVPlayer(url: url))
                                        .frame(height: 210)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }
                            muscleChips(details: details)
                            VStack(alignment: .leading, spacing: 10) {
                                sectionHeader(text: "Overview")
                                Text(details.overview)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .lineSpacing(4)
                            }
                            VStack(alignment: .leading, spacing: 16) {
                                sectionHeader(text: "How To Do It")
                                VStack(alignment: .leading, spacing: 18) {
                                    ForEach(Array(details.instructions.enumerated()), id: \.offset) { index, step in
                                        HStack(alignment: .top, spacing: 14) {
                                            Text("\(index + 1)")
                                                .font(.subheadline.weight(.bold))
                                                .foregroundStyle(.white)
                                                .frame(width: 26, height: 26)
                                                .background(accent)
                                                .clipShape(Circle())
                                            Text(step)
                                                .font(.body)
                                        }
                                    }
                                }
                            }
                            if !details.exerciseTips.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    sectionHeader(text: "Coaching Tips")
                                    VStack(alignment: .leading, spacing: 12) {
                                        ForEach(details.exerciseTips, id: \.self) { tip in
                                            HStack(alignment: .top, spacing: 10) {
                                                Image(systemName: "lightbulb.fill")
                                                    .foregroundStyle(accent)
                                                    .font(.footnote)
                                                    .padding(.top, 2)
                                                Text(tip)
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                    }
                                    .padding(16)
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }
                            if !details.variations.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    sectionHeader(text: "Variations")
                                    ForEach(details.variations, id: \.self) { variation in
                                        HStack(alignment: .top, spacing: 10) {
                                            Circle()
                                                .fill(Color(.tertiaryLabel))
                                                .frame(width: 5, height: 5)
                                                .padding(.top, 8)
                                            Text(variation)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                            //                            if !details.relatedExerciseIds.isEmpty {
                            //                                VStack(alignment: .leading, spacing: 12) {
                            //                                    sectionHeader(text: "You Might Also Try")
                            //
                            //                                    ScrollView(.horizontal, showsIndicators: false) {
                            //                                        HStack(spacing: 14) {
                            //                                            ForEach(details.relatedExerciseIds, id: \.self) { relatedId in
                            //                                                NavigationLink(value: relatedId) {
                            //                                                    RelatedExerciseCard(exerciseId: relatedId, accent: accent)
                            //                                                }
                            //                                                .buttonStyle(.plain)
                            //                                            }
                            //                                        }
                            //                                        .padding(.trailing, 20)
                            //                                    }
                            //                                }
                            //                                .padding(.horizontal, -20)
                            //                                .padding(.horizontal, 20)
                            //                            }
                            if !details.relatedExerciseIds.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    sectionHeader(text: "You Might Also Try")
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 14) {
                                            ForEach(details.relatedExerciseIds, id: \.self) { relatedId in
                                                
                                                NavigationLink {
                                                    ExerciseDetails(
                                                        exerciseId: relatedId
                                                    )
                                                } label: {
                                                    RelatedExerciseCard(
                                                        exerciseId: relatedId,
                                                        accent: accent
                                                    )
                                                }
                                                .buttonStyle(.plain)
                                            }
                                        }
                                        .padding(.trailing, 20)
                                    }
                                }
                                .padding(.horizontal, -20)
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding()
                    }
                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea(edges: .top)
                
            }
        }
        .task {
            viewModel.getExerciseById(id: exerciseId)
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
}

#Preview {
    NavigationStack {
        ExerciseDetails(
            exerciseId: "exr_41n2hsVHu7B1MTdr"
        )
        .navigationDestination(for: String.self) { exerciseId in
            //            ExerciseDetails(exerciseId: exerciseId)
            Text("New Page")
        }
    }
}


