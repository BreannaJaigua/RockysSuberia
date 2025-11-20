//
//  StartMenuView.swift
//  RockysSuberia
//
//  Created by Andrea Alave on 11/20/25.
//

import SwiftUI

struct StartMenuView: View {

    var onStart: () -> Void

    var body: some View {
        ZStack {
            Color("MenuBackgroundColor").ignoresSafeArea()

            VStack(spacing: 40) {
                Image("RockysSuberiaIcon")
                    .resizable()
                    .scaledToFit()
                Text("Rocky's Suberia")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.yellow)
                    .shadow(radius: 10)

                VStack(spacing: 20) {
                    Button(action: onStart) {
                        Text("Start Game")
                            .font(.title2.bold())
                            .padding()
                            .frame(maxWidth: 250)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }

                    .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
}

#Preview {
    StartMenuView(onStart: { })
}
