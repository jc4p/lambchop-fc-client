//
//  MediaViewer.swift
//  LambchopCast
//
//  Created by Kasra Rahjerdi on 4/10/25.
//

import SwiftUI
import AVKit

// Full-screen image viewer
struct ImageViewer: View {
    let imageURL: URL
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    
    var body: some View {
        ZStack {
            CyberpunkTheme.background.ignoresSafeArea()
            
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle()
                            .fill(CyberpunkTheme.darkBackground)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        VStack(spacing: 20) {
                            CyberpunkProgress()
                            
                            Text("LOADING_IMAGE::...")
                                .font(.system(.caption, design: .monospaced))
                                .tracking(2)
                                .neonText(CyberpunkTheme.secondary)
                        }
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    offset = CGSize(
                                        width: lastOffset.width + gesture.translation.width,
                                        height: lastOffset.height + gesture.translation.height
                                    )
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let delta = value / lastScale
                                    lastScale = value
                                    scale *= delta
                                }
                                .onEnded { _ in
                                    lastScale = 1.0
                                }
                        )
                        .onTapGesture(count: 2) {
                            withAnimation(CyberpunkTheme.standardAnimation) {
                                if scale > 1.0 {
                                    scale = 1.0
                                    offset = .zero
                                    lastOffset = .zero
                                } else {
                                    scale = 2.0
                                }
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(CyberpunkTheme.primary.opacity(0.3), lineWidth: 1)
                                .blendMode(.screen)
                        )
                case .failure:
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .neonText(CyberpunkTheme.accent)
                        
                        Text("Failed to load image")
                            .font(.system(.body, design: .monospaced))
                            .neonText(CyberpunkTheme.secondary)
                    }
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title2)
                            .foregroundColor(CyberpunkTheme.primary)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.7))
                                    .overlay(
                                        Circle()
                                            .stroke(CyberpunkTheme.primary.opacity(0.7), lineWidth: 1)
                                            .shadow(color: CyberpunkTheme.primary.opacity(0.5), radius: 3)
                                    )
                            )
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .gesture(TapGesture().onEnded { _ in
            if scale == 1.0 {
                dismiss()
            }
        })
    }
}

// Video player view
struct VideoPlayerView: View {
    let videoURL: URL
    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack {
            CyberpunkTheme.background.ignoresSafeArea()
            
            if let player = player {
                AVKit.VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .overlay(
                        Rectangle()
                            .stroke(CyberpunkTheme.primary.opacity(0.3), lineWidth: 1)
                            .ignoresSafeArea()
                    )
            } else {
                ZStack {
                    Rectangle()
                        .fill(CyberpunkTheme.darkBackground)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack(spacing: 20) {
                        CyberpunkProgress()
                        
                        Text("LOADING_VIDEO::...")
                            .font(.system(.caption, design: .monospaced))
                            .tracking(2)
                            .neonText(CyberpunkTheme.secondary)
                    }
                }
            }
            
            // Video Controls Overlay
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title2)
                            .foregroundColor(CyberpunkTheme.primary)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.7))
                                    .overlay(
                                        Circle()
                                            .stroke(CyberpunkTheme.primary.opacity(0.7), lineWidth: 1)
                                            .shadow(color: CyberpunkTheme.primary.opacity(0.5), radius: 3)
                                    )
                            )
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .onAppear {
            player = AVPlayer(url: videoURL)
            player?.play()
        }
        .onDisappear {
            player?.pause()
        }
    }
}

// Link preview for embedded URLs
struct LinkPreview: View {
    let url: URL
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var imageURL: URL?
    
    var body: some View {
        Link(destination: url) {
            HStack {
                Image(systemName: "link.circle.fill")
                    .font(.title2)
                    .foregroundColor(CyberpunkTheme.secondary)
                    .shadow(color: CyberpunkTheme.secondary.opacity(0.7), radius: 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(url.host ?? "")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(CyberpunkTheme.accent)
                    
                    Text(url.path)
                        .font(.system(.caption2, design: .monospaced))
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .foregroundColor(CyberpunkTheme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.right.square.fill")
                    .foregroundColor(CyberpunkTheme.primary.opacity(0.8))
                    .shadow(color: CyberpunkTheme.primary.opacity(0.5), radius: 1)
            }
            .padding()
            .background(CyberpunkTheme.darkBackground)
            .overlay(
                RoundedRectangle(cornerRadius: CyberpunkTheme.cornerRadius)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                CyberpunkTheme.secondary.opacity(0.7),
                                CyberpunkTheme.primary.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: CyberpunkTheme.borderWidth
                    )
            )
            .cornerRadius(CyberpunkTheme.cornerRadius)
        }
    }
}