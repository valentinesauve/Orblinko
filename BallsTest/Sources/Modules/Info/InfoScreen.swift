//
//  InfoScreen.swift
//  BallsTest
//
//  Created by muser on 08.12.2024.
//

import SwiftUI

struct InfoScreen: View {
    @ObservedObject var viewModel: InfoViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
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
            VStack {
                ScrollView {
                    Image(viewModel.image)
                        .resizable()
                        .scaledToFill()
                    Text(viewModel.text)
                        .textCase(.uppercase)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 1, x: 1, y: 1)
                        .padding(16)
                }

                .scrollIndicators(.hidden)
            }
            .background(
                Color.init(red: 136 / 255, green: 145 / 255, blue: 204 / 255, opacity: 0.78)
            )
            .cornerRadius(24)
            .padding(.vertical, 32)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                Rectangle()
                    .foregroundColor(.black)
                    .ignoresSafeArea()
                
                Image(.settingsBackground)
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 4)
            }
        )
    }
}

#Preview {
    InfoScreen(viewModel: .init(id: "1", image: .memoryGame, text: "sdlbhsadnajlshfkjsdfjkgdhsjflaskdjaskldasjdklasl"))
}
