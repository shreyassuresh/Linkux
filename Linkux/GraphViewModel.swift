//import SwiftUI
//import CoreData
//import Combine
//
//class GraphViewModel: ObservableObject {
//    @Published var notes: [Note] = []
//    @Published var links: [NoteLink] = []
//    @Published var selectedNote: Note?
//    @Published var suggestedLinks: [(Note, Double)] = []
//    @Published var offset = CGSize.zero
//    @Published var scale: CGFloat = 1.0
//    
//    private let context: NSManagedObjectContext
//    private let mlService = MLService.shared
//    private var cancellables = Set<AnyCancellable>()
//    
//    init(context: NSManagedObjectContext) {
//        self.context = context
//        fetchNotes()
//        fetchLinks()
//    }
//    
//    func fetchNotes() {
//        let request: NSFetchRequest<Note> = Note.fetchRequest()
//        do {
//            notes = try context.fetch(request)
//        } catch {
//            print("Error fetching notes: \(error)")
//        }
//    }
//    
//    func fetchLinks() {
//        let request: NSFetchRequest<NoteLink> = NoteLink.fetchRequest()
//        do {
//            links = try context.fetch(request)
//        } catch {
//            print("Error fetching links: \(error)")
//        }
//    }
//    
//    func createNote(at position: CGPoint) {
//        let note = Note(context: context)
//        note.id = UUID()
//        note.title = "New Note"
//        note.content = ""
//        note.x = Double(position.x)
//        note.y = Double(position.y)
//        note.createdAt = Date()
//        
//        saveContext()
//        fetchNotes()
//    }
//    
//    func updateNote(_ note: Note, title: String, content: String) {
//        note.title = title
//        note.content = content
//        
//        saveContext()
//        
//        // Generate AI suggestions when content changes
//        if !content.isEmpty {
//            suggestedLinks = mlService.suggestLinks(for: note, among: notes)
//        }
//    }
//    
//    func createLink(from: Note, to: Note, strength: Double = 1.0) {
//        let link = NoteLink(context: context)
//        link.id = UUID()
//        link.fromNote = from
//        link.toNote = to
//        link.strength = strength
//        link.createdAt = Date()
//        
//        saveContext()
//        fetchLinks()
//    }
//    
//    func moveNote(_ note: Note, to position: CGPoint) {
//        note.x = Double(position.x)
//        note.y = Double(position.y)
//        saveContext()
//    }
//    
//    func deleteNote(_ note: Note) {
//        context.delete(note)
//        saveContext()
//        fetchNotes()
//        fetchLinks()
//    }
//    
//    private func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context: \(error)")
//        }
//    }
//}
import SwiftUI
import CoreData
import Combine

final class GraphViewModel: ObservableObject {

    @Published var notes: [Note] = []
    @Published var links: [NoteLink] = []
    @Published var selectedNote: Note?
    @Published var suggestedLinks: [LinkSuggestion] = []

    @Published var offset: CGSize = .zero
    @Published var scale: CGFloat = 1.0

    private let context: NSManagedObjectContext
    private let mlService = MLService.shared

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchNotes()
        fetchLinks()
    }

    // MARK: - Fetching

    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            notes = try context.fetch(request)
        } catch {
            print("Error fetching notes:", error)
        }
    }

    func fetchLinks() {
        let request: NSFetchRequest<NoteLink> = NoteLink.fetchRequest()
        do {
            links = try context.fetch(request)
        } catch {
            print("Error fetching links:", error)
        }
    }

    // MARK: - Notes

    func createNote(at position: CGPoint) {
        let note = Note(context: context)
        note.id = UUID()
        note.title = "New Note"
        note.content = ""
        note.x = Double(position.x)
        note.y = Double(position.y)
        note.createdAt = Date()

        saveContext()
        fetchNotes()
    }

    func updateNote(_ note: Note, title: String, content: String) {
        note.title = title
        note.content = content

        saveContext()

        if !content.isEmpty {
            suggestedLinks = mlService
                .suggestLinks(for: note, among: notes)
                .map { LinkSuggestion(note: $0.0, strength: $0.1) }
        }
    }

    func moveNote(_ note: Note, to position: CGPoint) {
        note.x = Double(position.x)
        note.y = Double(position.y)
        saveContext()
    }

    func deleteNote(_ note: Note) {
        context.delete(note)
        saveContext()
        fetchNotes()
        fetchLinks()
    }

    // MARK: - Links

    func createLink(from: Note, to: Note, strength: Double = 1.0) {
        let link = NoteLink(context: context)
        link.id = UUID()
        link.fromNote = from
        link.toNote = to
        link.strength = strength
        link.createdAt = Date()

        saveContext()
        fetchLinks()
    }

    // MARK: - Save

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context:", error)
        }
    }
}
