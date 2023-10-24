//
//  Message.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/13/23.
//

import Foundation

struct Message: Decodable, Identifiable {
    let id = UUID()
    let userID: String
    let text: String
    let photoURL: String
    let createdAt: Date
    
    func isFromCurrentSender() -> Bool {
        return true
    }
}
