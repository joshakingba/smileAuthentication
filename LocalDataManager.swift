//
//  LocalDataManager.swift
//  Smile Authentication
//
//  Created by Josh Akingba on 13/02/2024.
//

import Foundation

class LocalDataManager {
    static let shared = LocalDataManager()
    
    private init() {}
    
    // Function to register a new user locally
    func register(username: String, email: String, password: String) -> Bool {
        // Check if user already exists
        if UserDefaults.standard.string(forKey: "username") != nil {
            // User already exists, registration failed
            return false
        }
        
        // Validate password criteria
        if password.count < 8 || !password.contains(where: \.isNumber) {
            return false // Password does not meet criteria
        }
        
        // Save user data to UserDefaults
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.synchronize()
        
        return true // Registration successful
    }
    
    // Function to authenticate a user locally
    func login(username: String, password: String) -> Bool {
        // Retrieve saved user data from UserDefaults
        guard let savedUsername = UserDefaults.standard.string(forKey: "username"),
              let savedPassword = UserDefaults.standard.string(forKey: "password") else {
            // User not found, login failed
            return false
        }
        
        // Check if username and password match
        if username == savedUsername && password == savedPassword {
            return true // Login successful
        } else {
            return false // Login failed
        }
    }
}
