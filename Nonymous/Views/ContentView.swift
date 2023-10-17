//
//  ContentView.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right")
                }
        }
    }
}

#Preview {
    ContentView()
}
