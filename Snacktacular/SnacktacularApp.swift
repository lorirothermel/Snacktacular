//
//  SnacktacularApp.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 9/23/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
      
  }  // func application
}  // class AppDelegate


@main
struct SnacktacularApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var spotVM = SpotViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(spotVM)
        }  // WindowGroup
        
    }  // some Scene
    
}  // struct SnacktacularApp
