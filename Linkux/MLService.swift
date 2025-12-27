import Foundation
import CoreML
import NaturalLanguage

class MLService: ObservableObject {
    static let shared = MLService()
    
    private let embedding = NLEmbedding.sentenceEmbedding(for: .english)
    private let similarityThreshold: Double = 0.7
    
    private init() {}
    
    func getEmbedding(for text: String) -> [Double]? {
        guard let embedding = embedding else { return nil }
        return embedding.vector(for: text)
    }
    
    func calculateSimilarity(between text1: String, and text2: String) -> Double {
        guard let vector1 = getEmbedding(for: text1),
              let vector2 = getEmbedding(for: text2) else { return 0.0 }
        
        return cosineSimilarity(vector1, vector2)
    }
    
    func suggestLinks(for note: Note, among notes: [Note]) -> [(Note, Double)] {
        guard let noteText = note.content else { return [] }
        
        return notes.compactMap { otherNote in
            guard otherNote != note,
                  let otherText = otherNote.content else { return nil }
            
            let similarity = calculateSimilarity(between: noteText, and: otherText)
            return similarity > similarityThreshold ? (otherNote, similarity) : nil
        }.sorted { $0.1 > $1.1 }
    }
    
    private func cosineSimilarity(_ a: [Double], _ b: [Double]) -> Double {
        guard a.count == b.count else { return 0.0 }
        
        let dotProduct = zip(a, b).map(*).reduce(0, +)
        let magnitudeA = sqrt(a.map { $0 * $0 }.reduce(0, +))
        let magnitudeB = sqrt(b.map { $0 * $0 }.reduce(0, +))
        
        guard magnitudeA > 0 && magnitudeB > 0 else { return 0.0 }
        return dotProduct / (magnitudeA * magnitudeB)
    }
}