
import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var store = EmojiThemeStore()
    
    var body: some Scene {
        WindowGroup {
            EmojiThemeChooser(viewModel: store)
        }
    }
}

