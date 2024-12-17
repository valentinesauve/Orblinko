//
//  CollectorGameScreen.swift
//  BallsTest
//
//  Created by muser on 04.12.2024.
//

import SwiftUI

struct CollectorGameScreen: View {
    @ObservedObject private var viewModel: CollectorGameViewModel
    @State private var selectedNumber: Int?
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: CollectorGameViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(viewModel.levelText)
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
                GridView(grid: viewModel.grid,
                        targetSums: viewModel.targetSums,
                        onCellTap: handleCellTap)

                NumberSelectionView(availableNumbers: viewModel.level < 3 ? Array(1...5) : Array(5...9),
                                  selectedNumber: $selectedNumber)
                
                ControlPanelView(undosLeft: viewModel.undosLeft,
                               onUndo: viewModel.undoLastMove,
                               onReset: viewModel.setupLevel)
                .padding(.bottom, 80)
            }
            
            if viewModel.gameState == .win {
                GameOverScreen(viewModel: .init(text: "you win!!!")) {
                    dismiss()
                }
            } else if viewModel.gameState == .lose {
                GameOverScreen(viewModel: .init(text: "You missed something.")) {
                    viewModel.setupLevel()
                }
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                Rectangle()
                    .foregroundColor(.black)
                    .ignoresSafeArea()
                
                Image(.collectorGameBackground)
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 4)
            }
        )
    }
    
    private func handleCellTap(at position: Position) {
        guard let number = selectedNumber else { return }
        viewModel.placeNumber(at: position, number: number)
        selectedNumber = nil
    }
}

extension CollectorGameScreen {
    func handleRestart() {
        viewModel.handleRestart()
        selectedNumber = nil
    }
    
    func handleNextLevel() {
        viewModel.handleNextLevel()
        selectedNumber = nil
    }
}

#Preview {
    CollectorGameScreen(viewModel: .init(level: 2, levelText: "hard"))
}

struct GameHeaderView: View {
    let level: Int
    let score: Int
    let moves: Int
    
    var body: some View {
        HStack {
            Text("Уровень: \(level)")
                .font(.headline)
            Spacer()
            Text("Ходов: \(moves)")
                .font(.headline)
        }
        .padding()
        .background(Color.blue.opacity(0.4))
    }
}

struct GridView: View {
    let grid: [[Cell]]
    let targetSums: [Int]
    let onCellTap: (Position) -> Void
    
    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                Spacer()
                ForEach(0..<grid[0].count, id: \.self) { column in
                    Text("\(targetSums[column])")
                        .frame(width: 56, height: 30)
                        .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .textCase(.uppercase)
                    Spacer()
                }
//                Spacer()
//                    .frame(width: 0)
            }
            ForEach(0..<grid.count, id: \.self) { row in
                HStack(spacing: 2) {
                    Text("\(targetSums[row])")
                        .frame(width: 30)
                        .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .textCase(.uppercase)
                    
                    ForEach(0..<grid[row].count, id: \.self) { column in
                        CellView(cell: grid[row][column])
                            .onTapGesture {
                                onCellTap(Position(row: row, column: column))
                            }
                    }
                    Text("\(targetSums[row])")
                        .frame(width: 30)
                        .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .textCase(.uppercase)
                }
            }
            
            HStack(spacing: 2) {
                Spacer()
                ForEach(0..<grid[0].count, id: \.self) { column in
                    Text("\(targetSums[column])")
                        .frame(width: 56, height: 30)
                        .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .textCase(.uppercase)
                    Spacer()
                }
//                Spacer()
//                    .frame(width: 0)
            }
        }
    }
}

struct CellView: View {
    let cell: Cell
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
            
            if let number = cell.number {
                Text("\(number)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            
            if cell.multiplier > 1 {
                Text("×\(cell.multiplier)")
                    .font(.caption)
                    .foregroundColor(.yellow)
                    .fontWeight(.bold)
                    .position(x: 40, y: 10)
            }
        }
    }
    
    private var backgroundColor: Color {
        if cell.isLocked {
            return .gray.opacity(0.8)
        } else if cell.isMirror {
            return .purple.opacity(0.7)
        }
        return .blue.opacity(0.6)
    }
}

struct NumberSelectionView: View {
    let availableNumbers: [Int]
    @Binding var selectedNumber: Int?
    
    var body: some View {
        HStack {
            ForEach(availableNumbers, id: \.self) { number in
                Button(action: {
                    if selectedNumber == number {
                        selectedNumber = nil
                    } else {
                        selectedNumber = number
                    }
                }) {
                    ZStack {
                        Image(selectedNumber == number ? .green : .blue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 38)
                        Text("\(number)")
                            .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                            .font(.system(size: 22, weight: .black, design: .default))
                            .multilineTextAlignment(.center)
                            .textCase(.uppercase)
                    }
                }
            }
        }
        .padding()
    }
}

struct ControlPanelView: View {
    let undosLeft: Int
    let onUndo: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onUndo) {
                HStack {
                    Image(systemName: "arrow.uturn.backward")
                        .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                        .font(.system(size: 18, weight: .black, design: .default))
                    Text("cancel (\(undosLeft))")
                        .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                        .font(.system(size: 18, weight: .black, design: .default))
                        .multilineTextAlignment(.center)
                        .textCase(.uppercase)
                }
                .disabled(undosLeft == 0)
            }
            
            Spacer()
            
            Button(action: onReset) {
                Text("reset")
                    .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                    .font(.system(size: 18, weight: .black, design: .default))
                    .multilineTextAlignment(.center)
                    .textCase(.uppercase)
            }
        }
        .padding()
    }
}

struct GameOverView: View {
    let stars: Int
    let score: Int
    let onRestart: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        VStack {
            Text("Уровень завершен!")
                .font(.title)
            
            HStack {
                ForEach(0..<3) { index in
                    Image(systemName: index < stars ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
            
            Text("Очки: \(score)")
                .font(.headline)
            
            HStack {
                Button(action: onRestart) {
                    Text("Повторить")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: onNext) {
                    Text("Следующий")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}
