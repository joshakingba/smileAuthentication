//
//  AuthService.swift
//  Smile Authentication
//
//  Created by Josh Akingba on 12/02/2024.
//

import Foundation
import LocalAuthentication

class AuthService {
    private let localDataManager = LocalDataManager.shared
    
    // Function to register a new user
    func register(username: String, email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        // Call the register method of LocalDataManager
        let success = localDataManager.register(username: username, email: email, password: password)
        if success {
            completion(true, nil) // Pass true if registration succeeds
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Registration failed. Ensure password is at least 8 characters long and contains at least one number."])
            completion(false, error) // Pass false and an error
        }
    }
    
    // Function to authenticate a user
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        // Call the login method of LocalDataManager
        let success = localDataManager.login(username: username, password: password)
        completion(success, nil) // Pass true if login succeeds, otherwise pass false and an error
    }
    
    // Function to authenticate using biometric (Touch ID or Face ID)
    func authenticateWithBiometric(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Perform biometric authentication
            let reason = "Authenticate with your biometric"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil) // Pass true if biometric authentication succeeds
                    } else {
                        completion(false, authenticationError) // Pass false and an error if biometric authentication fails
                    }
                }
            }
        } else {
            // Biometric authentication is not available, handle accordingly
            completion(false, error) // Pass false and an error
        }
    }
}
