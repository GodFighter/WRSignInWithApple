//
//  WRSignInWithApple.swift
//  Pods
//
//  Created by 项辉 on 2020/7/15.
//

import UIKit
import WRKeychain
import AuthenticationServices

private var _WRSignInWithApple_AppId = ""

extension WRKeychainItem {
    static var currentUserIdentifier: String {
        do {
            let identifier = try WRKeychainItem(service: _WRSignInWithApple_AppId, account: "userIdentifier").readItem()
            return identifier
        } catch {
            return ""
        }
    }
    
    static func DeleteUserIdentifierFromKeychain() {
        do {
            try WRKeychainItem(service: _WRSignInWithApple_AppId, account: "userIdentifier").deleteItem()
        } catch  {
            debugPrint("Unable to delete userIdentifier from keychain")
        }
    }
    
    static func saveUserIdentifier(_ userIdentifier: String) {
        do {
            try WRKeychainItem(service: _WRSignInWithApple_AppId, account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            debugPrint("Unable to save userIdentifier to keychain.")
        }
    }
    
}

public class WRSignInWithApple: NSObject
{
    enum ErrorCode: Int
    {
        case unknown            = 1000
        case cancel             = 1001
        case invalidResponse    = 1002
        case notHandled         = 1003
        case failed             = 1004
    }
    
    
    public static var success: ((_ id: String, _ info: [String: Any?]) -> ())?
    public static var failed: ((Error) -> ())?

    private static let shared: WRSignInWithApple = WRSignInWithApple()

    @available(iOS 13.0, *)
    public static func Setup(_ appId: String? = nil) {
        guard let appID = appId, appID.count > 0 else {
            _WRSignInWithApple_AppId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
            return
        }
        _WRSignInWithApple_AppId = appID
    }
    
    @available(iOS 13.0, *)
    public static func Check(completion: @escaping (Bool) -> Void)
    {
        let appleIDProvider = ASAuthorizationAppleIDProvider()

        appleIDProvider.getCredentialState(forUserID: WRKeychainItem.currentUserIdentifier)
        { (credentialState, error) in
            switch credentialState
            {
            case .authorized: DispatchQueue.main.async { completion(true) }
            case .revoked, .notFound: DispatchQueue.main.async { completion(false) }
            default:
                break
            }
        }
    }

    @available(iOS 13.0, *)
    public static func SignIn()
    {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
//        let passwordProvider = ASAuthorizationPasswordProvider()
//        let passwordRequest = passwordProvider.createRequest()
//        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = WRSignInWithApple.shared
        authorizationController.performRequests()
    }
    
    @available(iOS 13.0, *)
    public static func SignOut()
    {
        WRKeychainItem.DeleteUserIdentifierFromKeychain()
    }

}

//MARK:-
fileprivate typealias AuthorizationControllerDelegate = WRSignInWithApple
extension AuthorizationControllerDelegate: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        switch authorization.credential
        {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            WRKeychainItem.saveUserIdentifier(appleIDCredential.user)
            DispatchQueue.main.async
                {
                    
                    WRSignInWithApple.success?(appleIDCredential.user, [
                        "email" : appleIDCredential.email,
                        "fullName" : appleIDCredential.fullName,
                        "authorizationCode" : appleIDCredential.authorizationCode,
                        "identityToken" : appleIDCredential.identityToken,
                        "realUserStatus" : appleIDCredential.realUserStatus
                    ])
            }
            break
        case let passwordCredential as ASPasswordCredential:
            DispatchQueue.main.async
                {
                    WRSignInWithApple.success?(passwordCredential.user, ["password" : passwordCredential.password])
            }
            break
        default:
            DispatchQueue.main.async
                {
                    WRSignInWithApple.failed?(NSError.init(domain: "unkonwn", code: ErrorCode.unknown.rawValue, userInfo: nil))
            }
        }
    }
    
    @available(iOS 13.0, *)
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        let error = error as NSError
        DispatchQueue.main.async
            {
                WRSignInWithApple.failed?(error)
        }
    }
}

