//
//  PrismSwiftUIApp.swift
//  PrismSwiftUI
//
//  Created by Erik Bautista on 9/16/21.
//

import SwiftUI

@main
struct PrismUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowToolbarStyle(.unified)
        .windowStyle(.titleBar)
        .commands {
            SidebarCommands()
        }
    }
}
