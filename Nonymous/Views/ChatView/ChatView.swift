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
        VStack {
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(Array(chatVM.messages.enumerated()), id: \.element) { index, message in
                            MessageView(message: message)
                                .id(index)
                        }
                        .onChange(of: chatVM.messages, initial: false) { oldValue, newValue in
                            scrollView.scrollTo(chatVM.messages.count - 1, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack {
                TextField("Hello there", text: $text, axis: .vertical)
                    .padding()
                
                ZStack {
                    Button {
                        if text.count >= 1 {
                            chatVM.sendMessage(text: text) { success in
                                if success {
                                    
                                } else {
                                    print("Error sending message")
                                }
                            }
                            
                            text = ""
                        }
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
                .padding(.top)
                .shadow(radius: 2)
            }
            .background(.gray.opacity(0.10))
        }
    }
    
}

#Preview {
    ChatView()
}


















// ARCHIVE:
/*
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
 NavigationView {
 ZStack {
 Color.theme.background.ignoresSafeArea()
 
 VStack {
 ScrollView {
 VStack {
 ForEach(chatVM.messages) { message in
 MessageView(message: message)
 }
 }
 }
 
 HStack {
 TextField("Hello there", text: $text, axis: .vertical)
 .padding()
 .bold()
 
 Button {
 if text.count >= 1 {
 chatVM.sendMessage(text: text) { success in
 if success {
 
 } else {
 print("Error sending message")
 }
 }
 text = ""
 }
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
 .navigationTitle("Chatroom")
 .navigationBarTitleDisplayMode(.inline)
 .toolbar {
 ToolbarItem(placement: .topBarTrailing) {
 Button {
 do {
 try AuthManager.shared.signOut()
 
 } catch {
 print("Error signing out")
 }
 } label: {
 Text("sign out")
 .foregroundStyle(Color.theme.accent)
 }
 }
 }
 }
 }
 }
 
 #Preview {
 ChatView()
 }
 
 */
