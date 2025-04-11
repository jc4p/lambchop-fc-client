//
//  ContentView.swift
//  LambchopCast
//
//  Created by Kasra Rahjerdi on 4/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = FeedViewModel()
    @State private var isLoading = false
    
    private var showErrorAlert: Binding<Bool> {
        Binding<Bool>(
            get: { viewModel.error != nil },
            set: { if !$0 { viewModel.error = nil } }
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CyberpunkTheme.darkBackground
                    .ignoresSafeArea()
                
                VStack {
                    // Cyberpunk header
                    HStack {
                        Text("〔LAMBCH0P_CAST〕")
                            .font(.system(.title, design: .monospaced))
                            .fontWeight(.bold)
                            .neonText(CyberpunkTheme.accent)
                            .padding(.leading)
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(CyberpunkTheme.background.opacity(0.8))
                
                    // Content list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.casts) { cast in
                                CastRow(cast: cast)
                                    .padding(.horizontal)
                                    .onAppear {
                                        if cast == viewModel.casts.last && !isLoading {
                                            loadMoreContent()
                                        }
                                    }
                            }
                            
                            if isLoading {
                                HStack {
                                    Spacer()
                                    CyberpunkProgress()
                                        .padding()
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        await refresh()
                    }
                }
                
                // Empty state overlay
                if viewModel.casts.isEmpty && !isLoading {
                    VStack {
                        Image(systemName: "network.slash")
                            .font(.system(size: 60))
                            .neonText(CyberpunkTheme.primary)
                            .padding()
                        
                        Text("N0 DATA AVAILABLE")
                            .font(.system(.title2, design: .monospaced))
                            .fontWeight(.bold)
                            .neonText(CyberpunkTheme.primary)
                        
                        Text("PULL D0WN T0 SYNC")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(CyberpunkTheme.textSecondary)
                            .padding()
                    }
                    .padding()
                    .cyberpunkCard()
                    .padding()
                }
            }
        }
        .preferredColorScheme(.dark)
        .task {
            await loadInitialContent()
        }
        .alert(
            "SYS::ERR0R",
            isPresented: showErrorAlert,
            actions: {
                Button("REINITIALIZE") {
                    viewModel.error = nil
                }
            },
            message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown system failure")
                    .font(.system(.body, design: .monospaced))
            }
        )
    }
    
    private func loadInitialContent() async {
        isLoading = true
        await viewModel.fetchFeed(cursor: nil)
        isLoading = false
    }
    
    private func loadMoreContent() {
        guard !isLoading, let nextCursor = viewModel.nextCursor else { return }
        
        isLoading = true
        Task {
            await viewModel.fetchFeed(cursor: nextCursor)
            isLoading = false
        }
    }
    
    private func refresh() async {
        await viewModel.resetAndFetchFeed()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Cast.self, Profile.self, Embed.self, Channel.self, Reaction.self, Reply.self, EmbeddedCast.self], inMemory: true)
}
