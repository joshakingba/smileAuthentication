//
//  ContentView.swift
//  Smile Authentication
//
//  Created by Josh Akingba on 15/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var loginUsername = ""
    @State private var loginPassword = ""
    @State private var isShowingRegistration = false
    @State private var isShowingLogin = false
    @State private var isShowing2FA = false
    @State private var biometricAuthResult = false // Used to simulate biometric authentication result

    var authService = AuthService() // Create an instance of AuthService

    var body: some View {
        VStack {
            if isShowingRegistration {
                // Registration Page
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Register") {
                    // Implement registration logic here
                    if password == confirmPassword {
                        authService.register(username: username, email: email, password: password) { success, error in
                            if success {
                                // Navigate to login page after successful registration
                                isShowingRegistration = false
                                isShowingLogin = true
                            } else {
                                // Handle registration error
                                print("Registration failed: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        }
                    } else {
                        print("Passwords do not match")
                    }
                }
                .padding()
            } else if isShowingLogin {
                // Login Page
                TextField("Username/Email", text: $loginUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $loginPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Login") {
                    // Implement login logic here
                    authService.login(username: loginUsername, password: loginPassword) { success, error in
                        if success {
                            // Navigate to 2FA page after successful login
                            isShowingLogin = false
                            isShowing2FA = true
                        } else {
                            // Handle login error
                            print("Login failed: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
                .padding()
            } else if isShowing2FA {
                // 2FA Page with Biometric Authentication
                Text("Please verify your identity")
                Button("Use Biometric") {
                    // Trigger biometric authentication
                    authService.authenticateWithBiometric { success, error in
                        if success {
                            // Biometric authentication successful
                            biometricAuthResult = true
                        } else {
                            // Biometric authentication failed
                            biometricAuthResult = false
                            print("Biometric authentication failed: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
                .padding()
                if biometricAuthResult {
                    Text("Biometric authentication successful!")
                }
            } else {
                // Welcome Page
                Text("Welcome to Smile Authentication")
                Button("Register") {
                    isShowingRegistration = true
                }
                .padding()
                Button("Login") {
                    isShowingLogin = true
                }
                .padding()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
