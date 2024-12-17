//
//  MainSceen.swift
//  BallsTest
//
//  Created by muser on 07.12.2024.
//

import SwiftUI

struct MainScreen: View {
    @StateObject private var audioManager = AudioManager()
    @State private var path: NavigationPath = .init()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 24)
                Spacer()
                HStack(spacing: 12) {
                    VStack(spacing: 16) {
                        Button {
                            path.append(Router.memoryLevelListing)
                        } label: {
                            Image(.memoryGame)
                                .resizable()
                                .scaledToFit()
                        }
                        .cornerRadius(24)
                        .shadow(color: .black, radius: 5, x: 0, y: 0)
                        Text("Memoria")
                            .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                            .font(.system(size: 16, weight: .black, design: .default))
                            .multilineTextAlignment(.center)
                            .textCase(.uppercase)
                    }
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button {
                            path.append(Router.collectorLevelListing)
                        } label: {
                            Image(.collectorGame)
                                .resizable()
                                .scaledToFit()
                        }
                        .cornerRadius(24)
                        .shadow(color: .black, radius: 5, x: 0, y: 0)
                        Text("Gatherer")
                            .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                            .font(.system(size: 16, weight: .black, design: .default))
                            .multilineTextAlignment(.center)
                            .textCase(.uppercase)
                    }
                }
                Spacer()
                Button {
                    path.append(Router.settings)
                } label: {
                    Text("settings")
                        .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                        .font(.system(size: 28, weight: .black, design: .default))
                        .multilineTextAlignment(.center)
                        .textCase(.uppercase)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(AngularGradient(colors: [.init(red: 157/255, green: 87/255, blue: 107/255).opacity(0.7), .init(red: 238/255, green: 125/255, blue: 150/255).opacity(0.7)], center: .bottom))
                .cornerRadius(24)
                .shadow(color: .blue, radius: 4, x: 0, y: 0)
                .padding(.bottom, 12)
                
                Button {
                    path.append(Router.info(.init(id: "collectorMain", image: .collectorGame, text: "Gatherer\n\nGame Concept:\n\nA mathematical puzzle game where the player must fill a grid with numbers, respecting the conditions of row and column sums.\n\nGame board:\n\n- A 5x5 grid\n\n- On the edges of the grid are numbers:\n\n- To the right and left are the target amounts for the rows\n\n- Top and bottom - target sums for columns.\n\nRules of the game\n\n- The player must fill the empty cells with numbers.\n\n- The sum of the numbers in each row must equal the number on the edges of the row.\n\n- The sum of the numbers in each column must equal the number at the top and bottom of the column.\n\nMemoria\n\nGame concept:\n\nThe game is aimed at training the player's memory and attentiveness by memorising the sequence of balls appearing on the playing field.\n\nGame mechanics:\n\n- When you start the game, a grid-shaped playing field opens up\n\n- Depending on the chosen difficulty level, a certain number of balls of different colours appear alternately in random cells of the field.\n\n- Balls appear one by one in random cells of the field\n\n- After demonstrating the sequence, all balls disappear.\n\n- The player's task is to reproduce the exact sequence of appearance of the balls by clicking on the corresponding cells.\n\nRules:\n\n- The player must click on the cells strictly in the order in which the balls appear.\n\n- If a cell is selected correctly, a ball appears in it.\n\n- Victory is counted if the whole sequence is exactly reproduced.")))
                } label: {
                    Text("information")
                        .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                        .font(.system(size: 28, weight: .black, design: .default))
                        .multilineTextAlignment(.center)
                        .textCase(.uppercase)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(AngularGradient(colors: [.init(red: 157/255, green: 87/255, blue: 107/255).opacity(0.7), .init(red: 238/255, green: 125/255, blue: 150/255).opacity(0.7)], center: .bottom))
                .cornerRadius(24)
                .shadow(color: .blue, radius: 4, x: 0, y: 0)
                .padding(.bottom, 24)
            }
            .navigationDestination(for: Router.self) { router in
                switch router {
                case .settings:
                    SettingsScreen(path: $path)
                        .navigationBarBackButtonHidden(true)
                case .memoryLevelListing:
                    MemoryLvlListingScreen(viewModel: .init(items: [
                        .init(id: "1", level: 1, levelText: "easy"),
                        .init(id: "2", level: 2, levelText: "medium"),
                        .init(id: "3", level: 3, levelText: "hard")
                    ]), path: $path)
                        .navigationBarBackButtonHidden(true)
                case .memoryGame(let item):
                    MemoryGameScreen(viewModel: .init(currentLevel: item.level, currentLevelText: item.levelText))
                        .navigationBarBackButtonHidden(true)
                case .collectorLevelListing:
                    CollectorLvlListingScreen(viewModel: .init(items: [
                        .init(id: "1", level: 1, levelText: "easy"),
                        .init(id: "2", level: 2, levelText: "medium"),
                        .init(id: "3", level: 3, levelText: "hard")
                    ]), path: $path)
                        .navigationBarBackButtonHidden(true)
                case .collectorGame(let item):
                    CollectorGameScreen(viewModel: .init(level: item.level, levelText: item.levelText))
                        .navigationBarBackButtonHidden(true)
                case .info(let item):
                    InfoScreen(viewModel: item)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack {
                    Rectangle()
                        .foregroundColor(.black)
                        .ignoresSafeArea()
                    
                    Image(.mainBackground)
                        .resizable()
                        .ignoresSafeArea()
                        .blur(radius: 4)
                }
            )
            .onAppear {
                if audioManager.isMusicEnabled {
                    audioManager.play()
                }
            }
        }
        .environmentObject(audioManager)
    }
}


#Preview {
    MainScreen()
}


enum Router: Hashable {
    case memoryLevelListing
    case memoryGame(ListingItemViewModel)
    case settings
    case collectorLevelListing
    case collectorGame(ListingItemViewModel)
    case info(InfoViewModel)
}
