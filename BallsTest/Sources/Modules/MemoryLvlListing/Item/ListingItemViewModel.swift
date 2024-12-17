//
//  ListingItemViewModel.swift
//  BallsTest
//
//  Created by muser on 08.12.2024.
//

import Foundation

final class ListingItemViewModel: ObservableObject, Hashable {
    @Published var id: String
    @Published var level: Int
    @Published var levelText: String
    
    init(id: String, level: Int, levelText: String) {
        self.id = id
        self.level = level
        self.levelText = levelText
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ListingItemViewModel, rhs: ListingItemViewModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.level == rhs.level &&
            lhs.levelText == rhs.levelText
    }
}
