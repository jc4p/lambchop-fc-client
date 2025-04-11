//
//  LambchopCastApp.swift
//  LambchopCast
//
//  Created by Kasra Rahjerdi on 4/10/25.
//

import SwiftUI
import SwiftData

@main
struct LambchopCastApp: App {
    @State private var showLaunchScreen = true
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Cast.self,
            Profile.self,
            Embed.self,
            Channel.self,
            Reaction.self,
            Reply.self,
            EmbeddedCast.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .modelContainer(sharedModelContainer)
                
                if showLaunchScreen {
                    LaunchScreen()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showLaunchScreen = false
                    }
                }
            }
        }
    }
}
