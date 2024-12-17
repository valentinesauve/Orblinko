//
//  GameOverViewModel.swift
//  BallsTest
//
//  Created by muser on 10.12.2024.
//

import Foundation

final class GameOverViewModel: ObservableObject {
    @Published var text: String
 
    init(text: String) {
        self.text = text
    }
}
