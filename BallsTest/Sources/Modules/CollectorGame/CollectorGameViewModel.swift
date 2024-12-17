//
//  CollectorGameViewModel.swift
//  BallsTest
//
//  Created by muser on 04.12.2024.
//

import Foundation
import SwiftUI

struct Position: Equatable {
    let row: Int
    let column: Int
}

struct Cell: Equatable {
    var number: Int?
    var multiplier: Int = 1
    var isLocked: Bool = false
    var isMirror: Bool = false
    var mirrorPosition: Position?
}

enum GameMode {
    case campaign
    case daily
    case timeAttack
    case constructor
}

enum GameState {
    case playing
    case win
    case lose
}

class CollectorGameViewModel: ObservableObject {
    @Published var grid: [[Cell]]
    @Published var targetSums: [Int]
    @Published var undosLeft: Int = 3
    @Published var comboMultiplier: Int = 1
    @Published var gameState: GameState = .playing
    @Published var gameMode: GameMode = .campaign
    @Published var level: Int
    @Published var levelText: String
    
    private var moveHistory: [(Position, Int)] = []
    let gridSize: Int
    
    private var numberPools: [[Int]] = [
        [1, 2, 3],
        [1, 2, 3, 4, 5],
        [2, 3, 4, 5, 6],
        [3, 4, 5, 6, 7, 8, 9]
    ]
    
    init(level: Int, levelText: String, gridSize: Int = 5) {
        self.level = level
        self.levelText = levelText
        self.gridSize = gridSize
        self.grid = Array(repeating: Array(repeating: Cell(), count: gridSize), count: gridSize)
        self.targetSums = Array(repeating: 0, count: gridSize)
        setupLevel()
    }
    
    func setupLevel() {
        grid = Array(repeating: Array(repeating: Cell(), count: gridSize), count: gridSize)
        let difficulty: Difficulty
        switch level {
        case 1:
            difficulty = .easy
        case 2:
            difficulty = .medium
        case 3:
            difficulty = .hard
        default:
            difficulty = .expert
        }
        targetSums = generateTargetSums(difficulty: difficulty)
        gameState = .playing
    }
    
    func clearCell(at position: Position) {
        if grid[position.row][position.column].number != nil {
            grid[position.row][position.column].number = nil
            
            if grid[position.row][position.column].isMirror,
               let mirrorPos = grid[position.row][position.column].mirrorPosition {
                grid[mirrorPos.row][mirrorPos.column].number = nil
            }
        }
    }
    
    func checkWinCondition() -> Bool {
        for row in 0..<gridSize {
            let rowSum = calculateRowSum(row)
            if rowSum != targetSums[row] {
                return false
            }
        }
        
        for col in 0..<gridSize {
            let colSum = calculateColumnSum(col)
            if colSum != targetSums[col] {
                return false
            }
        }
        
        return true
    }
    
    private func calculateRowSum(_ row: Int) -> Int {
        grid[row].reduce(0) { sum, cell in
            sum + (cell.number ?? 0) * cell.multiplier
        }
    }
    
    private func calculateColumnSum(_ col: Int) -> Int {
        grid.reduce(0) { sum, row in
            sum + (row[col].number ?? 0) * row[col].multiplier
        }
    }
    
    private func generateTargetSums(difficulty: Difficulty) -> [Int] {
        var sums: [Int] = []
        let baseRange: ClosedRange<Int>
        
        switch difficulty {
            case .easy: baseRange = 10...15
            case .medium: baseRange = 15...25
            case .hard: baseRange = 20...30
            case .expert: baseRange = 25...35
        }
        
        for _ in 0..<gridSize {
            sums.append(Int.random(in: baseRange))
        }
        return sums
    }
    
    func undoLastMove() {
        guard undosLeft > 0, let lastMove = moveHistory.popLast() else { return }
        undosLeft -= 1
        clearCell(at: lastMove.0)
    }

    private func isGridFull() -> Bool {
        for row in grid {
            for cell in row {
                if cell.number == nil {
                    return false
                }
            }
        }
        return true
    }
    
    private func checkGameConditions() {
        if isGridFull() {
            for row in 0..<gridSize {
                if calculateRowSum(row) != targetSums[row] {
                    gameState = .lose
                    handleGameOver()
                    return
                }
            }
            
            for col in 0..<gridSize {
                if calculateColumnSum(col) != targetSums[col] {
                    gameState = .lose
                    handleGameOver()
                    return
                }
            }
            
            gameState = .win
            handleLevelComplete()
        }
    }
    
    func placeNumber(at position: Position, number: Int) {
        guard grid[position.row][position.column].number == nil,
              !grid[position.row][position.column].isLocked else { return }
        
        moveHistory.append((position, number))
        updateGrid(at: position, with: number)
        checkGameConditions()
    }
    
    private func updateGrid(at position: Position, with number: Int) {
        grid[position.row][position.column].number = number
        
        if grid[position.row][position.column].isMirror,
           let mirrorPos = grid[position.row][position.column].mirrorPosition {
            grid[mirrorPos.row][mirrorPos.column].number = number
        }
    }
    
    func handleLevelComplete() {
        gameState = .win
    }
    
    func handleGameOver() {
        gameState = .lose
    }
    
    func handleNextLevel() {
        level += 1
        setupLevel()
        gameState = .playing
        undosLeft = 3
    }
    
    func handleRestart() {
        setupLevel()
        gameState = .playing
        undosLeft = 3
    }
}

enum Difficulty {
    case easy
    case medium
    case hard
    case expert
}


