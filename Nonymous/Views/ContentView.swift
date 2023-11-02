//
//  ContentView.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/11/23.
//

import SwiftUI

struct ContentView: View {
    @State var showSignIn: Bool
    
    init(showSignIn: Bool = true) {
        self.showSignIn = AuthManager.shared.getCurrentUser() == nil
    }
    
    var body: some View {
        if showSignIn {
            SignInView(showSignIn: $showSignIn)
        } else {
            NavigationView {
                ZStack {
                    ChatView()
                }
                .navigationTitle("Nonymous")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            do {
                                try AuthManager.shared.signOut()
                                showSignIn = true
                            } catch {
                                print("Error signing out")
                            }
                        } label: {
                            Text("Sign out")
                                .foregroundStyle(Color.theme.accent)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}







// ARCHIVE:
/*
 import SwiftUI

 struct ContentView: View {
     @State var showSignIn: Bool = true
     
     var body: some View {
         TabView {
             ChatView()
                 .tabItem {
                     Image(systemName: "bubble.left.and.bubble.right")
                         .fullScreenCover(isPresented: $showSignIn) { // Placing might be an issue later
                             SignInView(showSignIn: $showSignIn)
                         }
                 }
         }
         .onAppear {
             showSignIn = AuthManager.shared.getCurrentUser() == nil
         }
     }
 }

 #Preview {
     ContentView()
 }
 */
