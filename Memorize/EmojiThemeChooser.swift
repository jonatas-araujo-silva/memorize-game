
import SwiftUI

struct EmojiThemeChooser: View {
    @ObservedObject var viewModel: EmojiThemeStore
    @State private var showThemeEditor = false
    
    // MARK: - Body
    
    var body: some View {
        navigationSplitView
            .sheet(isPresented: $showThemeEditor, onDismiss: {
                if let index = viewModel.selectedThemeIndex,
                   let gameViewModel = gameViewModels[viewModel.themes[index].id] {
                    gameViewModel.updateTheme(to: viewModel.themes[index])
                }
                viewModel.unselectTheme()
            }) {
                if let index = viewModel.selectedThemeIndex {
                    EmojiThemeEditor(theme: $viewModel.themes[index])
                }
            }
    }
    
    // MARK: - Navigation
    
    @State private var splitViewVisibility: NavigationSplitViewVisibility = .all
    @State private var selectedGameThemeId: EmojiTheme.ID?
    
    var navigationSplitView: some View {
        NavigationSplitView(columnVisibility: $splitViewVisibility) {
            themeList
        } detail: {
            if let themeId = selectedGameThemeId {
                gameView(for: themeId)
            } else {
                Text("Select a theme to play")
            }
        }
        .onChange(of: selectedGameThemeId) {
            if let selectedGameThemeId {
                splitViewVisibility = .detailOnly
                initializeGameViewModel(for: selectedGameThemeId)
            }
        }
    }
    
    private func initializeGameViewModel(for themeId: EmojiTheme.ID) {
        if let index = viewModel.themes.firstIndex(
            where: { $0.id == selectedGameThemeId }
        ), !gameViewModels.keys.contains(themeId) {
            gameViewModels[themeId] = EmojiMemoryGame(
                theme: viewModel.themes[index]
            )
        }
        
        if let gameViewModel = gameViewModels[themeId] {
            gameViewModel.makeSureAllCardsAreDealtIfAnyAreDealt()
        }
    }
    
    // MARK: - Theme Menu
    
    private var themeList: some View {
        List(viewModel.themes, selection: $selectedGameThemeId) { theme in
            NavigationLink(value: theme.id) {
                menuContent(for: theme)
                    .tag(theme)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        deleteThemeSwipeActionButton(for: theme)
                        editThemeSwipeActionButton(for: theme)
                    }
            }
        }
        .navigationTitle("Themes")
        .toolbar {
            newThemeButton
        }
    }

    private func menuContent(for theme: EmojiTheme) -> some View {
        HStack {
            VStack {
                Image(systemName: theme.icon)
                    .foregroundColor(theme.color)
                    .font(.title)
                    .frame(width: Constants.iconSize, height: Constants.iconSize)
                Text("\(theme.nPairs) pairs")
                    .font(.caption)
            }
            VStack(alignment: .leading) {
                Text(theme.name)
                    .font(.title)
                Text(theme.emojis)
                    .font(.title3)
                    .lineLimit(1)
            }
            .padding()
        }
    }
    
    // MARK: - Game
    
    @State var gameViewModels = [EmojiTheme.ID: EmojiMemoryGame]()
    
    @ViewBuilder
    private func gameView(for themeId: EmojiTheme.ID) -> some View {
        if let gameViewModel = gameViewModels[themeId] {
            EmojiMemoryGameView(viewModel: gameViewModel)
                .navigationTitle(gameViewModel.name)
        } else if let index = viewModel.themes.firstIndex(where: { $0.id == themeId }) {
            EmojiMemoryGameView(
                viewModel: EmojiMemoryGame(theme: viewModel.themes[index])
            )
            .navigationTitle(viewModel.themes[index].name)
        }
    }
    
    // MARK: - Buttons
    
    private var newThemeButton: some View {
        Button(action: {
            withAnimation {
                viewModel.newTheme()
            }
        }) {
            HStack {
                Image(systemName: "plus")
                Text("Add Theme")
            }
        }
    }
    
    private func deleteThemeSwipeActionButton(for theme: EmojiTheme) -> some View {
        Button(role: .destructive) {
            withAnimation {
                viewModel.remove(theme)
            }
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    private func editThemeSwipeActionButton(for theme: EmojiTheme) -> some View {
        Button {
            viewModel.select(theme)
            showThemeEditor = true
        } label: {
            Label("Edit", systemImage: "pencil")
        }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let iconSize: CGFloat = 36
    }
}

#Preview {
    EmojiThemeChooser(viewModel: EmojiThemeStore())
}
