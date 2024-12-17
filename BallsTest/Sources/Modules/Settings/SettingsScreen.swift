//
//  SettingsScreen.swift
//  BallsTest
//
//  Created by muser on 07.12.2024.
//

import SwiftUI
import WebKit
import StoreKit

struct SettingsScreen: View {
    @Binding private var path: NavigationPath
    @EnvironmentObject var audioManager: AudioManager
    @State private var isMusicEnabled = true
    @State private var isPresentWebView = false
    @Environment(\.dismiss) var dismiss
    
    init(path: Binding<NavigationPath>) {
        self._path = path
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
            Toggle(isOn: $audioManager.isMusicEnabled) {
                Text("music")
                    .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                    .font(.system(size: 28, weight: .black, design: .default))
                    .multilineTextAlignment(.center)
                    .textCase(.uppercase)
            }
            .padding()
            .onChange(of: audioManager.isMusicEnabled) { newValue in
                if newValue {
                    audioManager.play()
                } else {
                    audioManager.stop()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(32)
            .background(AngularGradient(colors: [.init(red: 157/255, green: 87/255, blue: 107/255).opacity(0.7), .init(red: 238/255, green: 125/255, blue: 150/255).opacity(0.7)], center: .bottom))
            .cornerRadius(24)
            .shadow(color: .blue, radius: 4, x: 0, y: 0)
            Spacer()
            Button {
                requestAppReview()
            } label: {
                Text("rate app")
                    .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                    .font(.system(size: 28, weight: .black, design: .default))
                    .multilineTextAlignment(.center)
                    .textCase(.uppercase)
            }
            .frame(maxWidth: .infinity)
            .padding(32)
            .background(AngularGradient(colors: [.init(red: 157/255, green: 87/255, blue: 107/255).opacity(0.7), .init(red: 238/255, green: 125/255, blue: 150/255).opacity(0.7)], center: .bottom))
            .cornerRadius(24)
            .shadow(color: .blue, radius: 4, x: 0, y: 0)
            Spacer()
            Button {
                isPresentWebView = true
            } label: {
                Text("privacy policy")
                    .foregroundStyle(Color.init(red: 202/255, green: 215/255, blue: 255/255))
                    .font(.system(size: 28, weight: .black, design: .default))
                    .multilineTextAlignment(.center)
                    .textCase(.uppercase)
            }
            .frame(maxWidth: .infinity)
            .padding(32)
            .background(AngularGradient(colors: [.init(red: 157/255, green: 87/255, blue: 107/255).opacity(0.7), .init(red: 238/255, green: 125/255, blue: 150/255).opacity(0.7)], center: .bottom))
            .cornerRadius(24)
            .shadow(color: .blue, radius: 4, x: 0, y: 0)
            .sheet(isPresented: $isPresentWebView) {
                NavigationStack {
                    WebViewPrivacy(url: URL(string: "https://OrblinkoLogical.cfd/com.OrblinkoLogical/Valentine_Sauve/privacy")!)
                        .ignoresSafeArea()
                        .navigationTitle("Privacy Policy")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            Spacer()
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
    
    func requestAppReview() {
       if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
           SKStoreReviewController.requestReview(in: scene)
       }
   }
}

#Preview {
    SettingsScreen(path: .constant(.init()))
}


struct WebViewPrivacy: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
