# Linkux - AI-Assisted Knowledge Graphs

**WWDC Student Challenge 2024 Submission**

Linkux is a visual thinking workspace that combines knowledge graphs with on-device Core ML intelligence to help users discover meaningful connections between their ideas.

## 🧠 Core Features

### Visual Knowledge Graph
- **Infinite Canvas**: Pan, zoom, and navigate through your ideas
- **Draggable Note Nodes**: Position notes spatially to reflect relationships
- **Curved Animated Links**: Beautiful connections between related concepts
- **Focus Mode**: Zoom into specific areas of your graph

### AI-Powered Intelligence (Core ML)
- **Semantic Similarity**: Analyzes note content using text embeddings
- **Smart Link Suggestions**: AI suggests connections based on content similarity
- **Link Strength Visualization**: Different line styles show relationship strength
- **Privacy-First**: All ML processing happens on-device

### Obsidian-Style Notes
- **Rich Text Editing**: Full-featured note editor
- **Backlinks**: Automatic bidirectional linking
- **Manual Linking**: Create explicit connections between notes
- **Contextual Navigation**: Jump between connected notes

## 🏗️ Architecture

```
Linkux/
├── LinkuxApp.swift          # Main app entry point with Core Data setup
├── ContentView.swift        # Main canvas view with infinite scrolling
├── MLService.swift          # Core ML text embeddings and similarity
├── GraphViewModel.swift     # MVVM state management for the graph
├── NoteNodeView.swift       # Visual note components and link rendering
├── NoteEditorView.swift     # Note editing interface and AI suggestions
└── DataModel.xcdatamodeld   # Core Data schema for notes and links
```

## 🎯 WWDC Narrative

**"Linkux augments human thinking by helping users see connections they might otherwise miss — without compromising privacy."**

### Key Differentiators from Obsidian:
- ✅ **Visual Canvas**: Spatial arrangement of ideas
- ✅ **Apple Pencil Support**: Natural input for iPad users
- ✅ **AI Link Suggestions**: Core ML-powered connection discovery
- ✅ **On-Device Intelligence**: Privacy-first approach
- ✅ **Spatial Clustering**: Visual organization of related concepts

## 🚀 Getting Started

1. Open `Linkux.xcodeproj` in Xcode 15+
2. Build and run on iOS 17+ device or simulator
3. Tap anywhere on the canvas to create a new note
4. Edit notes by tapping on them
5. Watch as AI suggests connections between related notes
6. Drag notes to organize them spatially
7. Use pinch gestures to zoom and pan around the canvas

## 🧩 Core ML Integration

The app uses Apple's Natural Language framework for text embeddings:
- **Lightweight**: Uses built-in sentence embeddings
- **Fast**: Real-time similarity calculations
- **Private**: No data leaves the device
- **Accurate**: Semantic understanding of note content

## 📱 Platform Support

- **iOS 17.0+**
- **iPadOS 17.0+** (optimized for Apple Pencil)
- **iPhone and iPad** universal app

## 🎨 Design Philosophy

- **Human-in-the-Loop AI**: Suggestions, not automation
- **Calm Interface**: Minimal, distraction-free design
- **Spatial Thinking**: Leverage human spatial memory
- **Privacy-First**: All processing happens locally

---

*Built with SwiftUI, Core Data, and Core ML for WWDC Student Challenge 2024*