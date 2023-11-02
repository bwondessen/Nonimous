//
//  ChatViewModel.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/16/23.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages = [Message]()
    
    var subscribers: Set<AnyCancellable> = []
    
    @Published var mockData = [
        Message(userUid: "123", text: "How's everyong doing?", photoURL: "", createdAt: Date()),
        Message(userUid: "232", text: "Doing good, but could be beter. Thanks for asking!", photoURL: "", createdAt: Date()),
        Message(userUid: "921", text: "What's the plan tonight???", photoURL: "", createdAt: Date()),
        Message(userUid: "583", text: "Idk I'm trying to find out myself...", photoURL: "", createdAt: Date()),
        Message(userUid: "582", text: "Let's hoop at 7 at the park then go to David's crib after", photoURL: "", createdAt: Date()),
        Message(userUid: "921", text: "Bet. That sounds like a plan to me", photoURL: "", createdAt: Date()),
        Message(userUid: "583", text: "I'll be there", photoURL: "", createdAt: Date()),
        Message(userUid: "123", text: "Same", photoURL: "", createdAt: Date()),
        Message(userUid: "232", text: "Try to be on time ya'll...", photoURL: "", createdAt: Date())
    ]
    
    init() {
        DatabaseManager.shared.fetchMessages { [weak self] result in
            switch result {
            case .success(let msgs):
                self?.messages = msgs
            case .failure(let error):
                print(error)
            }
        }
        
        subscribeToMessagePublisher()
    }
    
    func sendMessage(text: String, completion: @escaping (Bool) -> Void) {
        guard let user = AuthManager.shared.getCurrentUser() else {
            return
        }
        
        let msg = Message(userUid: user.uid, text: text, photoURL: user.photoURL, createdAt: Date())
        
        DatabaseManager.shared.sendMessageToDatabase(message: msg) { [weak self] success in
            if success {
                self?.messages.append(msg)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func refresh() {
        self.messages = messages
    }
    
    private func subscribeToMessagePublisher() {
        DatabaseManager.shared.messagesPublisher.receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] messages in
                self?.messages = messages
            }
            .store(in: &subscribers)
    }
}
