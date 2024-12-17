//
//  MemoryGameScreen.swift
//  BallsTest
//
//  Created by muser on 04.12.2024.
//

import SwiftUI

struct MemoryGameScreen: View {
    @ObservedObject private var viewModel: MemoryGameViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: MemoryGameViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(viewModel.currentLevelText)
                        .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                        .font(.system(size: 24, weight: .black, design: .default))
                        .multilineTextAlignment(.center)
                        .textCase(.uppercase)
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
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                    ForEach(0 ..< 16) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.gridCells[index].color)
                        //                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .frame(height: 80)
                            .overlay(
                                Group {
                                    if let ballImage = viewModel.gridCells[index].ballImage {
                                        Image(ballImage)
                                            .resizable()
                                            .scaledToFit()
                                            .padding(8)
                                    }
                                }
                            )
                            .onTapGesture {
                                if viewModel.selectedBallIndex != nil {
                                    viewModel.handleCellTap(at: index)
                                    if viewModel.placedBalls == viewModel.requiredBalls {
                                        viewModel.checkSequence()
                                    }
                                }
                            }
                    }
                }
                .padding()
                .background(AngularGradient(colors: [.init(red: 157/255, green: 87/255, blue: 107/255).opacity(0.7), .init(red: 238/255, green: 125/255, blue: 150/255).opacity(0.7)], center: .bottom))
                .cornerRadius(32)
                .shadow(color: .blue, radius: 4, x: 0, y: 0)
                .cornerRadius(12)
                
                Spacer()
                
                HStack(spacing: 16) {
                    ForEach(viewModel.availableBalls.indices, id: \.self) { index in
                        Image("\(viewModel.availableBalls[index])")
                            .resizable()
                            .scaledToFit()
                            .overlay(
                                Circle()
                                    .stroke(viewModel.selectedBallIndex == index ? Color.white : Color.clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                viewModel.selectBall(at: index)
                            }
                    }
                }
                .padding()
                Spacer()
                Button {
                    viewModel.startGame()
                } label: {
                    Text("reset game")
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
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack {
                    Rectangle()
                        .foregroundColor(.black)
                        .ignoresSafeArea()
                    
                    Image(.memoryGameBackground)
                        .resizable()
                        .ignoresSafeArea()
                        .blur(radius: 4)
                }
            )
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.startGame()
                }
            })
            
            if viewModel.gameWin {
                GameOverScreen(viewModel: .init(text: "you win!!!")) {
                    dismiss()
                }
            }
            
            if viewModel.gameLose {
                GameOverScreen(viewModel: .init(text: "You missed something.")) {
                    viewModel.gameLose = false
                    viewModel.startGame()
                }
            }
        }
        .animation(.easeInOut, value: viewModel.gameWin)
        .animation(.easeInOut, value: viewModel.gameLose)
    }
}

#Preview {
    MemoryGameScreen(viewModel: .init(currentLevel: 1, currentLevelText: "hard"))
}
