//
//  CollectorLvlListingScreen.swift
//  BallsTest
//
//  Created by muser on 07.12.2024.
//

import SwiftUI

struct CollectorLvlListingScreen: View {
    // MARK: - Setup
    @ObservedObject private var viewModel: CollectorLvlListingViewModel
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: CollectorLvlListingViewModel, path: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self._path = path
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    path.append(Router.info(.init(id: "collector", image: .collectorGame, text: "Game Concept:\n\nA mathematical puzzle game where the player must fill a grid with numbers, respecting the conditions of row and column sums.\n\nGame board:\n\n- A 5x5 grid\n\n- On the edges of the grid are numbers:\n\n- To the right and left are the target amounts for the rows\n\n- Top and bottom - target sums for columns.\n\nRules of the game\n\n- The player must fill the empty cells with numbers.\n\n- The sum of the numbers in each row must equal the number on the edges of the row.\n\n- The sum of the numbers in each column must equal the number at the top and bottom of the column.")))
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
                            path.append(Router.collectorGame(item))
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
    CollectorLvlListingScreen(viewModel: .init(items: []), path: .constant(.init()))
}
