//
//  MessageView.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    var message: Message
    
    var body: some View {
        if message.isFromCurrentSender() {
            HStack {
                HStack {
                    Text(message.text)
                        .foregroundStyle(.white)
                        .bold()
                        .padding()
                        .background(Color.theme.SendersBubbleBackground)
                        .cornerRadius(20)
                }
                .frame(maxWidth: 260, alignment: .trailing)
                .shadow(radius: 1.5)
                
                if let photoURL = message.fetchPhotoURL() {
                    WebImage(url: photoURL)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 40, maxHeight: 40)
                        .cornerRadius(20)
                } else {
                    Image("profilePic")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 40, maxHeight: 40)
                        .cornerRadius(20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing)
        } else {
            HStack { 
                if let photoURL = message.fetchPhotoURL() {
                    WebImage(url: photoURL)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 40, maxHeight: 40)
                        .cornerRadius(20)
                } else {
                    Image("profilePic")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 40, maxHeight: 40)
                        .cornerRadius(20)
                }
                
                HStack {
                    Text(message.text)
                        .bold()
                        .padding()
                        .background(Color.theme.othersBubbleBackground)
                        .cornerRadius(20)
                }
                .frame(maxWidth: 260, alignment: .trailing)
                .shadow(radius: 1.5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        }
    }
}

#Preview {
    MessageView(message: Message(userUid: "123", text: "this is a message", photoURL: "photo URL", createdAt: Date()))
}
