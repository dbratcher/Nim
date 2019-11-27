//
//  ContentView.swift
//  RustNim
//
//  Created by Drew Bratcher on 11/26/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import SwiftUI

let nimFont = Font.custom("MarkerFelt-Thin", size: 20.0)

struct MainMenuView: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("The Game Of")
                    .font(nimFont)
                Text("Nim")
                    .font(nimFont)
            }
            
            Button(action: {
                
            }) {
                Text("1 Player Game")
                    .font(nimFont)
            }
            Button(action: {
                
            }) {
                Text("2 Player Game")
                    .font(nimFont)
            }
            Button(action: {
                
            }) {
                Text("Settings")
                    .font(nimFont)
            }
            Button(action: {
                
            }) {
                Text("Help")
                    .font(nimFont)
            }
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
