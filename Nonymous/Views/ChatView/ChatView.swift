//
//  ChatView.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/12/23.
//

import SwiftUI

struct ChatView: View {
    @StateObject var chatVM = ChatViewModel()
    @State var text: String = ""
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack {
                        ForEach(chatVM.mockData) { message in
                            MessageView(message: message)
                        }
                    }
                }
                
                HStack {
                    TextField("Hello there", text: $text, axis: .vertical)
                        .padding()
                        .bold()
                    
                    Button {
                        chatVM.sendMessage(text: text)
                        text = ""
                    } label: {
                        Text("Send")
                            .padding()
                            .background(Color.theme.accent)
                            .foregroundColor(.white)
                            .bold()
                            .cornerRadius(50)
                            .padding(.trailing)
                    }
                }
                .background(.gray.opacity(0.10))
            }
        }
    }
}

#Preview {
    ChatView()
}
