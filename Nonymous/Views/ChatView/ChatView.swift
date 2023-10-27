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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(chatVM.messages) { message in
                        MessageView(message: message)
                    }
                }
            }
            
            HStack {
                TextField("Hello there", text: $text, axis: .vertical)
                    .padding()
                
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
