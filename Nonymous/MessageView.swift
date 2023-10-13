//
//  MessageView.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/12/23.
//

import SwiftUI

struct Message: Decodable {
    let userID: String
    let text: String
    let photoURL: String
    let createdAt: Date
}

struct MessageView: View {
    var message: Message
    var isFromCurrentUser: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .frame(maxHeight: 24)
            
            HStack {
                Text(message.text)
                    .padding()
            }
            .frame(maxWidth: 260, alignment: .leading)
            .background(.gray.opacity(0.20))
            .cornerRadius(20)
        }
    }
}

#Preview {
    MessageView(message: Message(userID: "123", text: "this is a message", photoURL: "photo URL", createdAt: Date()))
}
