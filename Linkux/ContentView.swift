import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var graphViewModel: GraphViewModel
    @State private var showingNoteEditor = false
    @State private var editingNote: Note?
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        _graphViewModel = StateObject(wrappedValue: GraphViewModel(context: context))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Infinite Canvas Background
                Color.black.opacity(0.05)
                    .ignoresSafeArea()
                    .onTapGesture { location in
                        let canvasPoint = screenToCanvas(location, in: geometry)
                        graphViewModel.createNote(at: canvasPoint)
                    }
                
                // Graph Content
                ZStack {
                    // Links
                    ForEach(graphViewModel.links, id: \.id) { link in
                        if let from = link.fromNote, let to = link.toNote {
                            LinkView(
                                from: CGPoint(x: from.x, y: from.y),
                                to: CGPoint(x: to.x, y: to.y),
                                strength: link.strength
                            )
                        }
                    }
                    
                    // Notes
                    ForEach(graphViewModel.notes, id: \.id) { note in
                        NoteNodeView(
                            note: note,
                            isSelected: graphViewModel.selectedNote == note
                        )
                        .position(x: note.x, y: note.y)
                        .onTapGesture {
                            graphViewModel.selectedNote = note
                            editingNote = note
                            showingNoteEditor = true
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newPosition = CGPoint(
                                        x: note.x + value.translation.x,
                                        y: note.y + value.translation.y
                                    )
                                    graphViewModel.moveNote(note, to: newPosition)
                                }
                        )
                    }
                }
                .scaleEffect(graphViewModel.scale)
                .offset(graphViewModel.offset)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                graphViewModel.scale = value
                            },
                        DragGesture()
                            .onChanged { value in
                                graphViewModel.offset = value.translation
                            }
                    )
                )
                
                // AI Suggestions Panel
                if !graphViewModel.suggestedLinks.isEmpty {
                    VStack {
                        Spacer()
                        SuggestionsPanel(
                            suggestions: graphViewModel.suggestedLinks,
                            onAccept: { suggestion in
                                if let selectedNote = graphViewModel.selectedNote {
                                    graphViewModel.createLink(
                                        from: selectedNote,
                                        to: suggestion.0,
                                        strength: suggestion.1
                                    )
                                }
                                graphViewModel.suggestedLinks.removeAll()
                            },
                            onDismiss: {
                                graphViewModel.suggestedLinks.removeAll()
                            }
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $showingNoteEditor) {
            if let note = editingNote {
                NoteEditorView(
                    note: note,
                    onSave: { title, content in
                        graphViewModel.updateNote(note, title: title, content: content)
                    }
                )
            }
        }
    }
    
    private func screenToCanvas(_ point: CGPoint, in geometry: GeometryProxy) -> CGPoint {
        let adjustedPoint = CGPoint(
            x: (point.x - graphViewModel.offset.x) / graphViewModel.scale,
            y: (point.y - graphViewModel.offset.y) / graphViewModel.scale
        )
        return adjustedPoint
    }
}