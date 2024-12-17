//
//  CollectorLvlListingViewModel.swift
//  BallsTest
//
//  Created by muser on 07.12.2024.
//

import Foundation

final class CollectorLvlListingViewModel: ObservableObject {
    @Published var items: [ListingItemViewModel]
    
    init(items: [ListingItemViewModel]) {
        self.items = items
    }
    
    func reloadData() {
//        let gameStorage: GameDomainModelStorage = .init()
//
//        let levelItems: [ItemViewModel] = gameStorage.read().compactMap { makeCellViewModel(for: $0) }
//
//        items = levelItems
    }
    
//    func makeCellViewModel(
//        for model: GameDomainModel
//    ) -> ItemViewModel? {
//
//        let ballsArray = model.levels.map { ballsList in
//            Array(ballsList.ballsList.map { $0.ball })
//        }
//
//        return .init(
//            id: model.id.uuidString,
//            level: model.level,
//            balls: Array(ballsArray),
//            isResolved: model.isResolved,
//            moveСounter: model.moveСounter
//        )
//    }
}
