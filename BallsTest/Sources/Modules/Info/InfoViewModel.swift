//
//  InfoViewModel.swift
//  BallsTest
//
//  Created by muser on 08.12.2024.
//

import Foundation
import SwiftUI

final class InfoViewModel: ObservableObject, Hashable {
    @Published var id: String
    @Published var image: ImageResource
    @Published var text: String
    
    init(id: String, image: ImageResource, text: String) {
        self.id = id
        self.image = image
        self.text = text
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: InfoViewModel, rhs: InfoViewModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.image == rhs.image &&
            lhs.text == rhs.text
    }
}
