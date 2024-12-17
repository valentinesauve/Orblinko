//
//  MemoryGameViewModel.swift
//  BallsTest
//
//  Created by muser on 04.12.2024.
//

import Foundation
import SwiftUI

class MemoryGameViewModel: ObservableObject {
    @Published var gridCells: [GridCell] = Array(repeating: GridCell(), count: 16)
    @Published var availableBalls: [Color] = [.red, .blue, .green, .yellow, .cyan, .pink]
    @Published var isGameActive = false
    @Published var selectedBallIndex: Int? = nil
    @Published var placedBalls = 0
    @Published var gameWin: Bool = false
    @Published var gameLose: Bool = false
    @Published var currentLevel: Int
    @Published var currentLevelText: String
    
    private var sequence: [(position: Int, color: Color)] = []
    private var showingSequenceIndex = 0
    private var usedPositions: Set<Int> = []
    
    init(currentLevel: Int, currentLevelText: String) {
        self.currentLevel = currentLevel
        self.currentLevelText = currentLevelText
    }
    
    struct GridCell {
        var color: Color = .purple.opacity(0.7)
        var ballImage: String? = nil
        var selectedBall: Color? = nil
    }
    
    var requiredBalls: Int {
        switch currentLevel {
        case 1: return 5
        case 2: return 10
        case 3: return 16
        default: return 5
        }
    }
    
    func getBallImageName(for color: Color) -> String {
        switch color {
        case .red: return "red"
        case .blue: return "blue"
        case .green: return "green"
        case .yellow: return "yellow"
        case .cyan: return "cyan"
        case .pink: return "pink"
        default: return ""
        }
    }
    
    func startGame() {
        isGameActive = true
        sequence = []
        showingSequenceIndex = 0
        selectedBallIndex = nil
        usedPositions = []
        placedBalls = 0
        gameWin = false
        gameLose = false
        resetGrid()
        generateSequence()
        showSequence()
    }
    
    private func resetGrid() {
        gridCells = Array(repeating: GridCell(), count: 16)
    }
    
    private func generateSequence() {
         sequence = []
         usedPositions = []
         
         for _ in 0 ..< requiredBalls {
             var position: Int
             repeat {
                 position = Int.random(in: 0 ..< 16)
             } while usedPositions.contains(position)
             
             usedPositions.insert(position)
             sequence.append((position: position, color: availableBalls.randomElement()!))
         }
     }
    
    private func showSequence() {
        guard showingSequenceIndex < sequence.count else {
            isGameActive = false
            return
        }
        
        let item = sequence[showingSequenceIndex]
        gridCells[item.position].ballImage = getBallImageName(for: item.color)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.gridCells[item.position].ballImage = nil
            self.showingSequenceIndex += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showSequence()
            }
        }
    }
    
    func selectBall(at index: Int) {
        selectedBallIndex = index
    }
    
    func handleCellTap(at index: Int) {
        guard !isGameActive,
              let selectedIndex = selectedBallIndex,
              gridCells[index].selectedBall == nil,
              placedBalls < requiredBalls else { return }
        
        let selectedColor = availableBalls[selectedIndex]
        gridCells[index].selectedBall = selectedColor
        gridCells[index].ballImage = getBallImageName(for: selectedColor)
        selectedBallIndex = nil
        placedBalls += 1
    }
    
    func checkSequence() {
        var correct = true
        for (_, item) in sequence.enumerated() {
            if gridCells[item.position].selectedBall != item.color {
                correct = false
                break
            }
        }
        
        if correct {
            gameWin = true
        } else {
            gameLose = true
        }
    }
}

struct CustomGridItem: Identifiable {
    let id: Int
    let color: Color
}
