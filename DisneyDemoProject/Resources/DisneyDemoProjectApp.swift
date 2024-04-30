//
//  DisneyDemoProjectApp.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 26/04/2024.
//

import SwiftUI

@main
struct DisneyDemoProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            DisneyCharactersView()
        }
    }
}
