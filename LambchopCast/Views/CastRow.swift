//
//  CastRow.swift
//  LambchopCast
//
//  Created by Kasra Rahjerdi on 4/10/25.
//

import SwiftUI
import AVKit

struct CastRow: View {
    let cast: Cast
    
    @State private var selectedImageURL: URL? = nil
    @State private var selectedVideoURL: URL? = nil
    @State private var isImagePresented = false
    @State private var isVideoPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Author header
            HStack(spacing: 12) {
                // Author profile pic with neon border
                AsyncImage(url: URL(string: cast.author?.pfpUrl ?? "")) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(CyberpunkTheme.darkBackground)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .stroke(CyberpunkTheme.primary, lineWidth: 2)
                                    .shadow(color: CyberpunkTheme.primary.opacity(0.8), radius: 3)
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(CyberpunkTheme.secondary, lineWidth: 2)
                                    .shadow(color: CyberpunkTheme.secondary.opacity(0.8), radius: 3)
                            )
                    case .failure:
                        Circle()
                            .fill(CyberpunkTheme.darkBackground)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(CyberpunkTheme.primary.opacity(0.7))
                            )
                            .overlay(
                                Circle()
                                    .stroke(CyberpunkTheme.primary.opacity(0.5), lineWidth: 2)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                
                // Author name and username
                VStack(alignment: .leading, spacing: 2) {
                    Text(cast.author?.displayName ?? "")
                        .font(.system(.headline, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(CyberpunkTheme.accent)
                    
                    Text("@\(cast.author?.username ?? "")")
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(CyberpunkTheme.textSecondary)
                }
                
                Spacer()
                
                // Post timestamp with futuristic format
                Text(formatDate(cast.timestamp))
                    .font(.system(.caption, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(CyberpunkTheme.darkBackground)
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(CyberpunkTheme.secondary.opacity(0.5), lineWidth: 1)
                    )
                    .foregroundColor(CyberpunkTheme.secondary)
            }
            
            // Divider line with gradient
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [CyberpunkTheme.primary.opacity(0), CyberpunkTheme.primary, CyberpunkTheme.primary.opacity(0)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
            
            // Post text content
            Text(cast.text)
                .font(.system(.body, design: .default))
                .foregroundColor(CyberpunkTheme.text)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .padding(.vertical, 6)
            
            // Media embeds
            if let embeds = cast.embeds, !embeds.isEmpty {
                ForEach(embeds) { embed in
                    if !embed.url.isEmpty {
                        // Handle different media types
                        if isImage(embed: embed) {
                            // Image embed with cyber frame
                            Button {
                                if let url = URL(string: embed.url) {
                                    selectedImageURL = url
                                    isImagePresented = true
                                }
                            } label: {
                                AsyncImage(url: URL(string: embed.url)) { phase in
                                    switch phase {
                                    case .empty:
                                        Rectangle()
                                            .fill(CyberpunkTheme.darkBackground)
                                            .aspectRatio(16/9, contentMode: .fill)
                                            .cornerRadius(CyberpunkTheme.cornerRadius)
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .font(.largeTitle)
                                                    .foregroundColor(CyberpunkTheme.primary.opacity(0.5))
                                            )
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .cornerRadius(CyberpunkTheme.cornerRadius)
                                    case .failure:
                                        Rectangle()
                                            .fill(CyberpunkTheme.darkBackground)
                                            .aspectRatio(16/9, contentMode: .fill)
                                            .cornerRadius(CyberpunkTheme.cornerRadius)
                                            .overlay(
                                                Image(systemName: "exclamationmark.triangle")
                                                    .font(.largeTitle)
                                                    .foregroundColor(CyberpunkTheme.primary.opacity(0.5))
                                            )
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(height: 200)
                                .cornerRadius(CyberpunkTheme.cornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: CyberpunkTheme.cornerRadius)
                                        .stroke(CyberpunkTheme.primary.opacity(0.7), lineWidth: 1)
                                        .shadow(color: CyberpunkTheme.primary.opacity(0.5), radius: CyberpunkTheme.glowRadius)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else if isVideo(embed: embed) {
                            // Video embed with cyber styling
                            Button {
                                if let url = URL(string: embed.url) {
                                    selectedVideoURL = url
                                    isVideoPresented = true
                                }
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .fill(CyberpunkTheme.darkBackground)
                                        .aspectRatio(16/9, contentMode: .fill)
                                        .cornerRadius(CyberpunkTheme.cornerRadius)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: CyberpunkTheme.cornerRadius)
                                                .stroke(CyberpunkTheme.secondary.opacity(0.7), lineWidth: 1.5)
                                                .shadow(color: CyberpunkTheme.secondary.opacity(0.5), radius: CyberpunkTheme.glowRadius)
                                        )
                                        
                                    VStack {
                                        Image(systemName: "play.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                            .foregroundColor(CyberpunkTheme.secondary)
                                            .padding(12)
                                            .background(
                                                Circle()
                                                    .fill(Color.black.opacity(0.5))
                                                    .overlay(
                                                        Circle()
                                                            .stroke(CyberpunkTheme.secondary, lineWidth: 2)
                                                            .shadow(color: CyberpunkTheme.secondary.opacity(0.8), radius: 3)
                                                    )
                                            )
                                        
                                        if let duration = embed.metadata?.video?.durationS {
                                            Text("T+ \(formatDuration(duration))")
                                                .font(.system(.caption, design: .monospaced))
                                                .foregroundColor(CyberpunkTheme.secondary)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.black.opacity(0.6))
                                                .cornerRadius(4)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .stroke(CyberpunkTheme.secondary.opacity(0.7), lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .frame(height: 200)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else if let url = URL(string: embed.url) {
                            // Other link with cyber styling
                            Link(destination: url) {
                                HStack {
                                    Image(systemName: "link")
                                        .font(.headline)
                                        .foregroundColor(CyberpunkTheme.secondary)
                                    
                                    VStack(alignment: .leading) {
                                        Text("EXTERN::LINK")
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(CyberpunkTheme.textSecondary)
                                        
                                        Text(url.host ?? "")
                                            .font(.system(.caption2, design: .monospaced))
                                            .lineLimit(1)
                                            .truncationMode(.middle)
                                            .foregroundColor(CyberpunkTheme.text.opacity(0.9))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.up.forward.square")
                                        .foregroundColor(CyberpunkTheme.secondary)
                                }
                                .padding(10)
                                .background(CyberpunkTheme.darkBackground)
                                .cornerRadius(CyberpunkTheme.cornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: CyberpunkTheme.cornerRadius)
                                        .stroke(CyberpunkTheme.secondary.opacity(0.5), lineWidth: 1)
                                )
                            }
                        }
                    }
                }
            }
            
            // Engagement metrics with cyber styling
            HStack(spacing: 24) {
                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(CyberpunkTheme.primary)
                    Text("\(cast.reactions?.likesCount ?? 0)")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(CyberpunkTheme.textSecondary)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(CyberpunkTheme.secondary)
                    Text("\(cast.reactions?.recastsCount ?? 0)")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(CyberpunkTheme.textSecondary)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "text.bubble.fill")
                        .foregroundColor(CyberpunkTheme.accent)
                    Text("\(cast.replies?.count ?? 0)")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(CyberpunkTheme.textSecondary)
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 4)
        }
        .padding(12)
        .background(CyberpunkTheme.cardBackground)
        .cornerRadius(CyberpunkTheme.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: CyberpunkTheme.cornerRadius)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [CyberpunkTheme.primary.opacity(0.6), CyberpunkTheme.secondary.opacity(0.6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: CyberpunkTheme.primary.opacity(0.2), radius: 5, y: 2)
        .sheet(isPresented: $isImagePresented, onDismiss: {
            selectedImageURL = nil
        }) {
            if let url = selectedImageURL {
                ImageViewer(imageURL: url)
            }
        }
        .sheet(isPresented: $isVideoPresented, onDismiss: {
            selectedVideoURL = nil
        }) {
            if let url = selectedVideoURL {
                VideoPlayerView(videoURL: url)
            }
        }
    }
    
    // Helper functions
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func formatDuration(_ seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "0:%02d", seconds)
        }
    }
    
    private func isImage(embed: Embed) -> Bool {
        if let contentType = embed.metadata?.contentType {
            return contentType.starts(with: "image")
        }
        return false
    }
    
    private func isVideo(embed: Embed) -> Bool {
        // Check for video metadata - this is the most reliable indicator
        if embed.metadata?.video != nil {
            return true
        }
        
        // Check content type for video indicators
        if let contentType = embed.metadata?.contentType {
            if contentType.contains("video") || 
               contentType.contains("mpegurl") || 
               contentType.contains("mp4") ||
               contentType.contains("stream") {
                return true
            }
        }
        
        // Check URL for video indicators
        let videoExtensions = [".m3u8", ".mp4", ".mov", ".avi", ".webm", ".mkv"]
        let videoKeywords = ["stream", "video", "media", "player"]
        
        for ext in videoExtensions {
            if embed.url.contains(ext) {
                return true
            }
        }
        
        for keyword in videoKeywords {
            if embed.url.lowercased().contains(keyword) {
                return true
            }
        }
        
        // Special case for Farcaster/Warpcast videos
        if embed.url.contains("warpcast.com") && embed.url.contains("v1/video") {
            return true
        }
        
        return false
    }
}