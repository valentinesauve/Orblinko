//
//  GameOverScreen.swift
//  BallsTest
//
//  Created by muser on 10.12.2024.
//

import SwiftUI

struct GameOverScreen: View {
    @ObservedObject var viewModel: GameOverViewModel
    var onTap: () -> Void
    
    init(viewModel: GameOverViewModel, onTap: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onTap = onTap
    }
    
    var body: some View {
        VStack {
            VStack {
                Text(viewModel.text)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(red: 236/255, green: 250/255, blue: 252/255))
                    .font(.system(size: 42, weight: .black, design: .default))
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 36)
                    .padding(.bottom, 36)
            }
            .background(Color(red: 23/255, green: 23/255, blue: 61/255, opacity: 0.4))
            .cornerRadius(42)
        }
        .padding(.horizontal, 44)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 3, y: 7)
        .background(Color.clear)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    GameOverScreen(viewModel: .init(text: ""), onTap: {})
}
