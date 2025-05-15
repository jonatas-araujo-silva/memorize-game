# 🧠 Emoji Memory Game – SwiftUI Project

This project is a SwiftUI-based implementation of the classic Memory Game, designed to showcase modern Swift development practices and a clean MVVM architecture.

---

## 🚀 Key Highlights

### 🧱 Declarative UI with SwiftUI
- Built entirely with SwiftUI, using `LazyVGrid`, `ZStack`, and composable views.
- Demonstrates responsive UI layout and reactive design patterns.

### 🧠 State Management
- Uses `@State` for UI state and a scalable structure prepared for `@ObservedObject` and `@EnvironmentObject`.
- Demonstrates how UI components update reactively based on game logic changes.

### 🧰 Swift Proficiency
- **Structs & Classes**: Clear separation of data (`Card` struct) and logic (`EmojiMemoryGame` class).
- **Generics**: `MemoryGame<CardContent>` is implemented generically to support reusable game logic.
- **Protocols**: Uses `Equatable` for card comparison, ensuring correctness and reusability.
- **Closures**: Used effectively in view builders and model initialization.

### 🧩 MVVM Architecture
- `MemoryGame` = **Model**  
- `EmojiMemoryGame` = **ViewModel** (`ObservableObject`)  
- `EmojiMemoryGameView` = **View**
- Clean separation of concerns, supporting scalability and unit testing.

### 👆 Handling User Interaction
- Taps on cards are handled through a `cardClicked(card:)` method, which updates the model and automatically reflects in the UI.

### 📁 Code Organization & Modularity
- Organized into reusable components and separate files.
- Easy to extend with themes, scoring, animations, or settings.

---

## 🎞️ Animations & Gestures
- Card flipping and matching are enhanced with smooth **SwiftUI animations** (`withAnimation`), adding visual feedback to user actions.
- Interactive **tap gestures** (`.onTapGesture`) make the game feel dynamic and responsive.
- Animations are integrated in a way that respects state-driven UI updates, keeping logic and presentation in sync.
