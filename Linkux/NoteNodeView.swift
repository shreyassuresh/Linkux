import SwiftUI

struct NoteNodeView: View {
    let note: Note
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(note.title ?? "Untitled")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            if let content = note.content, !content.isEmpty {
                Text(content)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(8)
        .frame(width: 120, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isSelected ? Color.blue : Color.gray.opacity(0.3),
                    lineWidth: isSelected ? 2 : 1
                )
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct LinkView: View {
    let from: CGPoint
    let to: CGPoint
    let strength: Double
    
    var body: some View {
        Path { path in
            path.move(to: from)
            
            let controlPoint1 = CGPoint(
                x: from.x + (to.x - from.x) * 0.3,
                y: from.y
            )
            let controlPoint2 = CGPoint(
                x: from.x + (to.x - from.x) * 0.7,
                y: to.y
            )
            
            path.addCurve(to: to, control1: controlPoint1, control2: controlPoint2)
        }
        .stroke(
            Color.blue.opacity(0.6),
            style: StrokeStyle(
                lineWidth: CGFloat(strength * 2),
                lineCap: .round,
                dash: strength < 0.5 ? [5, 5] : []
            )
        )
    }
}