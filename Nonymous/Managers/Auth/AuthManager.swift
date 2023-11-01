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
import CryptoKit
import AuthenticationServices

struct NonymousUser {
    let uid: String
    let name: String
    let email: String?
    let photoURL: String?
}

enum AppleSinInError: Error {
    case unableToGrabTopVC
    case authSignInError
    case appleIDTokenError
}

enum GoogleSinInError: Error {
    case unableToGrabTopVC
    case signInPresentationError
    case authSignInError
}

final class AuthManager: NSObject {
    static let shared = AuthManager()
    
    let auth = Auth.auth()
    
    // Sign in with Apple nonce
    private var currentNonce: String?
    private var completionHandler: ((Result<NonymousUser, AppleSinInError>) -> Void)? = nil
    
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
    
    func signInWithApple(completion: @escaping (Result<NonymousUser, AppleSinInError>) -> Void) {
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        guard let topVC = UIApplication.getTopViewController() else {
            completion(.failure(.unableToGrabTopVC))
            return
        }
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
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

// MARK: Sign in with Apple helpers

extension AuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor(frame: .zero)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce, let completionHandler = completionHandler else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken, let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to fetch identity token")
                completionHandler(.failure(.appleIDTokenError))
                return
            }
            
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                guard let authResult = authResult, error == nil else {
                    completionHandler(.failure(.appleIDTokenError))
                    return
                }
                
                let user = NonymousUser(uid: authResult.user.uid, name: authResult.user.displayName ?? "Unknown", email: authResult.user.email, photoURL: authResult.user.photoURL?.absoluteString)
                completionHandler(.success(user))
            }
        }
    }

      func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
      }
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
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
