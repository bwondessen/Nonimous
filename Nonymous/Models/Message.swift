//
//  Message.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/13/23.
//

import Foundation

struct Message: Decodable, Identifiable, Equatable, Hashable {
    enum MessageError: Error {
        case noPhotoURL
    }
    
    let id = UUID()
    let userUid: String
    let text: String
    let photoURL: String?
    let createdAt: Date
    
    func isFromCurrentSender() -> Bool {
        guard let currentUser = AuthManager.shared.getCurrentUser() else {
            return false
        }
        
        if currentUser.uid == userUid {
            return true
        } else {
            return false
        }
    }
    
    func fetchPhotoURL() -> URL? {
        guard let photoURLString = photoURL, let url = URL(string: photoURLString) else {
            return nil
        }
        
        return url
    }
}
