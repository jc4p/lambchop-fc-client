//
//  CyberpunkTheme.swift
//  LambchopCast
//
//  Created by Kasra Rahjerdi on 4/10/25.
//

import SwiftUI

struct CyberpunkTheme {
    // Colors
    static let background = Color.black
    static let darkBackground = Color(red: 0.05, green: 0.05, blue: 0.1)
    static let cardBackground = Color(red: 0.12, green: 0.12, blue: 0.18)
    static let primary = Color(red: 0.9, green: 0.2, blue: 0.6) // Neon pink
    static let secondary = Color(red: 0.1, green: 0.7, blue: 0.9) // Cyan
    static let accent = Color(red: 1.0, green: 0.8, blue: 0.0) // Yellow
    static let text = Color.white
    static let textSecondary = Color(white: 0.7)
    
    // UI Elements
    static let cornerRadius: CGFloat = 8
    static let cardPadding: CGFloat = 12
    static let glowRadius: CGFloat = 5
    static let borderWidth: CGFloat = 1
    
    // Text
    static let titleFont = Font.custom("Helvetica", size: 20).weight(.bold)
    static let bodyFont = Font.custom("Helvetica", size: 16)
    static let captionFont = Font.custom("Helvetica", size: 12)
    
    // Animations
    static let standardAnimation = Animation.easeInOut(duration: 0.2)
}

// Extend View to add cyberpunk styling
extension View {
    func cyberpunkCard() -> some View {
        self
            .background(CyberpunkTheme.cardBackground)
            .cornerRadius(CyberpunkTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: CyberpunkTheme.cornerRadius)
                    .stroke(CyberpunkTheme.primary.opacity(0.5), lineWidth: CyberpunkTheme.borderWidth)
                    .shadow(color: CyberpunkTheme.primary.opacity(0.5), radius: CyberpunkTheme.glowRadius)
            )
    }
    
    func neonText(_ color: Color = CyberpunkTheme.primary) -> some View {
        self
            .foregroundColor(color)
            .shadow(color: color.opacity(0.8), radius: 2, x: 0, y: 0)
    }
    
    func neonButton(_ color: Color = CyberpunkTheme.primary) -> some View {
        self
            .foregroundColor(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(color)
            .cornerRadius(CyberpunkTheme.cornerRadius)
            .shadow(color: color.opacity(0.7), radius: CyberpunkTheme.glowRadius)
    }
}

// Create a cyberpunk-styled progress indicator
struct CyberpunkProgress: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(CyberpunkTheme.primary.opacity(0.2), lineWidth: 4)
                .frame(width: 40, height: 40)
            
            Circle()
                .trim(from: 0.0, to: 0.75)
                .stroke(CyberpunkTheme.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 40, height: 40)
                .rotationEffect(Angle(degrees: rotation))
                .onAppear {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
        }
    }
}