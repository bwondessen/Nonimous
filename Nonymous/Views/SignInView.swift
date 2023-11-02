//
//  SignInView.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/16/23.
//

import SwiftUI

struct SignInView: View {
    @Binding var showSignIn: Bool
    
    var body: some View {
        VStack(spacing: 60) {
            Image("nature")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 400, maxHeight: 450, alignment: .top)
                .clipped()
            
            Text("Welcome, Please Sign In")
                .font(.largeTitle)
                .frame(maxWidth: 300)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 20) {
                Button {
                    AuthManager.shared.signInWithApple { result in
                        switch result {
                        case .success:
                            showSignIn = false
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Text("Sign in with Apple")
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .foregroundColor(.primary)
                                .frame(width: 300)
                        }
                }
                
                Button {
                    AuthManager.shared.signInWithGoogle { result in
                        switch result {
                        case .success(_):
                            showSignIn = false
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Text("Sign in with Google")
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .foregroundColor(.primary)
                                .frame(width: 300)
                        }
                }
            }
            .foregroundColor(.primary)
            .bold()
            
            Spacer()
            
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    SignInView(showSignIn: .constant(true))
}
