//
//  MemoryLvlListingScreen.swift
//  BallsTest
//
//  Created by muser on 07.12.2024.
//

import SwiftUI

struct MemoryLvlListingScreen: View {
    // MARK: - Setup
    @ObservedObject private var viewModel: MemoryLvlListingViewModel
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: MemoryLvlListingViewModel, path: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self._path = path
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    path.append(Router.info(.init(id: "memory", image: .memoryGame, text: "Game concept:\n\nThe game is aimed at training the player's memory and attentiveness by memorising the sequence of balls appearing on the playing field.\n\nGame mechanics:\n\n- When you start the game, a grid-shaped playing field opens up\n\n- Depending on the chosen difficulty level, a certain number of balls of different colours appear alternately in random cells of the field.\n\n- Balls appear one by one in random cells of the field\n\n- After demonstrating the sequence, all balls disappear.\n\n- The player's task is to reproduce the exact sequence of appearance of the balls by clicking on the corresponding cells.\n\nRules:\n\n- The player must click on the cells strictly in the order in which the balls appear.\n\n- If a cell is selected correctly, a ball appears in it.\n\n- Victory is counted if the whole sequence is exactly reproduced.")))
                } label: {
                    Image(.info)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 60, height: 60)
                .shadow(color: .black, radius: 1, x: 0, y: 1)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(.close)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 60, height: 60)
                .shadow(color: .black, radius: 1, x: 0, y: 1)
            }
            Spacer()
                VStack {
                    ForEach(viewModel.items, id: \.self) { item in
                        ListingItemScreen(viewModel: item) { _ in
                            path.append(Router.memoryGame(item))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 42)
                    }
                }
            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                Rectangle()
                    .foregroundColor(.black)
                    .ignoresSafeArea()
                
                Image(.settingsBackground)
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 4)
            }
        )
    }
}

#Preview {
    MemoryLvlListingScreen(viewModel: .init(items: [
        .init(id: "1", level: 1, levelText: "easy"),
        .init(id: "2", level: 2, levelText: "medium"),
        .init(id: "3", level: 3, levelText: "hard")
    ]), path: .constant(.init()))
}
