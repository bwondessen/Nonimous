//
//  AuthManager.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/17/23.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

struct NonymousUser {
    let uid: String
    let name: String
    let email: String?
    let photoURL: String?
}

enum GoogleSinInError: Error {
    case unableToGrabTopVC
    case signInPresentationError
    case authSignInError
}

final class AuthManager {
    static let shared = AuthManager()
    
    let auth = Auth.auth()
    
    func getNonymousUser () -> NonymousUser? {
        guard let user = auth.currentUser else {
            return nil
        }
        
        let nonymousUser = NonymousUser(uid: user.uid, name: user.displayName ?? "Unknown", email: user.email, photoURL: user.photoURL? .absoluteString)
        return nonymousUser
    }
    
    func getCurrentUser() -> NonymousUser? {
        guard let authUser = auth.currentUser else {
            return nil
        }
        
        return NonymousUser(uid: authUser.uid, name: authUser.displayName ?? "Uknown", email: authUser.email, photoURL: authUser.photoURL?.absoluteString)
    }
    
    func signInWithGoogle(completion: @escaping (Result<NonymousUser, GoogleSinInError>) -> Void ) {
        let clientID = "220753385945-sc5g8ut1pskolo7q0rcsfiuhm8t8g14d.apps.googleusercontent.com"
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let topVC = UIApplication.getTopViewController() else {
            completion(.failure(.unableToGrabTopVC))
            return
        }
        
        
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { [unowned self] result, error in
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                  error == nil
            else {
                completion(.failure(.signInPresentationError))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            auth.signIn(with: credential) { result, error in
                guard let result = result, error == nil else {
                    completion(.failure(.authSignInError))
                    return
                }
                
                let user = NonymousUser(uid: result.user.uid, name: result.user.displayName ?? "Unknown", email: result.user.email, photoURL: result.user.photoURL?.absoluteString)
                completion(.success(user))
            }
        }
    }
    
    func signOut() throws {
        try auth.signOut()
    }
}

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
