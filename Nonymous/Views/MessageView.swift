//
//  MessageView.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/12/23.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            if message.isFromCurrentSender() {
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundStyle(.white)
                            .bold()
                            .padding()
                    }
                    .frame(maxWidth: 260, alignment: .leading)
                    .background(Color.theme.SendersBubbleBackground)
                    .cornerRadius(20)
                    
                    Image(systemName: "person")
                        .frame(maxHeight: 24)
                }
                .frame(maxWidth: 360, alignment: .trailing)
            } else {
                HStack {
                    Image(systemName: "person")
                        .frame(maxHeight: 24)
                    
                    HStack {
                        Text(message.text)
                            .bold()
                            .padding()
                    }
                    .frame(maxWidth: 260, alignment: .leading)
                    .background(Color.theme.othersBubbleBackground)
                    .cornerRadius(20)
                }
                .frame(maxWidth: 360, alignment: .leading)
            }
        }
    }
}

#Preview {
    MessageView(message: Message(userID: "123", text: "this is a message", photoURL: "photo URL", createdAt: Date()))
}
