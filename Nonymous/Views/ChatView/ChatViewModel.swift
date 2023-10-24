//
//  ChatViewModel.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/16/23.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages = [Message]()
    
    @Published var mockData = [
        Message(userID: "123", text: "How's everyong doing?", photoURL: "", createdAt: Date()),
        Message(userID: "232", text: "Doing good, but could be beter. Thanks for asking!", photoURL: "", createdAt: Date()),
        Message(userID: "921", text: "What's the plan tonight???", photoURL: "", createdAt: Date()),
        Message(userID: "583", text: "Idk I'm trying to find out myself...", photoURL: "", createdAt: Date()),
        Message(userID: "582", text: "Let's hoop at 7 at the park then go to David's crib after", photoURL: "", createdAt: Date()),
        Message(userID: "921", text: "Bet. That sounds like a plan to me", photoURL: "", createdAt: Date()),
        Message(userID: "583", text: "i got ya'll but someone bring a 12 pack and we'll be ight", photoURL: "", createdAt: Date())
    ]
    
    func sendMessage(text: String) {
        print(text)
    }
}
