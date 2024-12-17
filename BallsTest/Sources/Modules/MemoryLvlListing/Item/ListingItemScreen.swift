//
//  ListingItemScreen.swift
//  BallsTest
//
//  Created by muser on 08.12.2024.
//

import SwiftUI

struct ListingItemScreen: View {
    // MARK: - Setup
    @ObservedObject private var viewModel: ListingItemViewModel
    var onTap: ((ListingItemViewModel) -> Void)?
    
    init(viewModel: ListingItemViewModel, onTap: ((ListingItemViewModel) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onTap = onTap
    }
    
    var body: some View {
        Text("\(viewModel.levelText)")
            .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
            .font(.system(size: 22, weight: .black, design: .default))
            .multilineTextAlignment(.center)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 32)
            .background(AngularGradient(colors: [.init(red: 157/255, green: 87/255, blue: 107/255).opacity(0.7), .init(red: 238/255, green: 125/255, blue: 150/255).opacity(0.7)], center: .bottom))
            .cornerRadius(32)
            .shadow(color: .blue, radius: 4, x: 0, y: 0)
            .onTapGesture {
                onTap?(viewModel)
            }
    }
}

#Preview {
    ListingItemScreen(viewModel: .init(id: "1", level: 1, levelText: ""))
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding(24)
}
