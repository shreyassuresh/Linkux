import SwiftUI

struct NoteEditorView: View {
    let note: Note
    let onSave: (String, String) -> Void
    
    @State private var title: String
    @State private var content: String
    @Environment(\.dismiss) private var dismiss
    
    init(note: Note, onSave: @escaping (String, String) -> Void) {
        self.note = note
        self.onSave = onSave
        _title = State(initialValue: note.title ?? "")
        _content = State(initialValue: note.content ?? "")
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Note Title", text: $title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextEditor(text: $content)
                    .font(.body)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(title, content)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct SuggestionsPanel: View {
    let suggestions: [(Note, Double)]
    let onAccept: (Note, Double) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("AI Suggestions")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Dismiss") {
                    onDismiss()
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            ForEach(Array(suggestions.prefix(3).enumerated()), id: \.offset) { index, suggestion in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(suggestion.0.title ?? "Untitled")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("Similarity: \(Int(suggestion.1 * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Link") {
                        onAccept(suggestion.0, suggestion.1)
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                }
                .padding(12)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding()
    }
}