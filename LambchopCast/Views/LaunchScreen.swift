//
//  LaunchScreen.swift
//  LambchopCast
//
//  Created by Kasra Rahjerdi on 4/10/25.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var animateGlow = false
    @State private var animateText = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    CyberpunkTheme.background,
                    CyberpunkTheme.darkBackground
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Grid overlay
            ZStack {
                GeometryReader { geo in
                    let width = geo.size.width
                    let height = geo.size.height
                    let gridSize: CGFloat = 40
                    
                    // Horizontal lines
                    ForEach(0..<Int(height/gridSize), id: \.self) { i in
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: CGFloat(i) * gridSize))
                            path.addLine(to: CGPoint(x: width, y: CGFloat(i) * gridSize))
                        }
                        .stroke(CyberpunkTheme.primary.opacity(0.1), lineWidth: 0.5)
                    }
                    
                    // Vertical lines
                    ForEach(0..<Int(width/gridSize), id: \.self) { i in
                        Path { path in
                            path.move(to: CGPoint(x: CGFloat(i) * gridSize, y: 0))
                            path.addLine(to: CGPoint(x: CGFloat(i) * gridSize, y: height))
                        }
                        .stroke(CyberpunkTheme.primary.opacity(0.1), lineWidth: 0.5)
                    }
                }
            }
            
            // Main content
            VStack(spacing: 30) {
                Spacer()
                
                // Neon sheep icon
                Text("🐑")
                    .font(.system(size: 100))
                    .overlay(
                        Text("🐑")
                            .font(.system(size: 100))
                            .foregroundColor(CyberpunkTheme.primary)
                            .blur(radius: animateGlow ? 12 : 8)
                            .opacity(animateGlow ? 0.8 : 0.4)
                    )
                    .padding()
                
                VStack(spacing: 10) {
                    // App name
                    Text("LAMBCHOP")
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .overlay(
                            Text("LAMBCHOP")
                                .font(.system(size: 40, weight: .bold, design: .monospaced))
                                .foregroundColor(CyberpunkTheme.primary)
                                .blur(radius: animateGlow ? 4 : 2)
                                .opacity(animateGlow ? 0.8 : 0.5)
                        )
                    
                    Text("CAST")
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .overlay(
                            Text("CAST")
                                .font(.system(size: 40, weight: .bold, design: .monospaced))
                                .foregroundColor(CyberpunkTheme.secondary)
                                .blur(radius: animateGlow ? 4 : 2)
                                .opacity(animateGlow ? 0.8 : 0.5)
                        )
                }
                
                // Animated subtitle
                Text("FARCASTER CHANNEL VIEWER")
                    .font(.system(.subheadline, design: .monospaced))
                    .tracking(5)
                    .foregroundColor(CyberpunkTheme.textSecondary)
                    .opacity(animateText ? 1 : 0)
                
                Spacer()
                
                // API credit
                HStack(spacing: 0) {
                    Text("POWERED BY ")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(CyberpunkTheme.textSecondary)
                    
                    Text("NEYNAR API")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(CyberpunkTheme.accent)
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Circuit decorations
            VStack {
                HStack {
                    circuitDecoration
                        .frame(width: 120, height: 120)
                        .rotationEffect(Angle(degrees: 0))
                    
                    Spacer()
                    
                    circuitDecoration
                        .frame(width: 120, height: 120)
                        .rotationEffect(Angle(degrees: 90))
                }
                
                Spacer()
                
                HStack {
                    circuitDecoration
                        .frame(width: 120, height: 120)
                        .rotationEffect(Angle(degrees: 270))
                    
                    Spacer()
                    
                    circuitDecoration
                        .frame(width: 120, height: 120)
                        .rotationEffect(Angle(degrees: 180))
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animateGlow = true
            }
            
            withAnimation(Animation.easeIn(duration: 1.0).delay(0.5)) {
                animateText = true
            }
        }
    }
    
    // Circuit decoration component
    private var circuitDecoration: some View {
        ZStack {
            // Circuit paths
            Path { path in
                path.move(to: CGPoint(x: 0, y: 40))
                path.addLine(to: CGPoint(x: 40, y: 40))
                path.addLine(to: CGPoint(x: 40, y: 0))
                
                path.move(to: CGPoint(x: 0, y: 80))
                path.addLine(to: CGPoint(x: 80, y: 80))
                path.addLine(to: CGPoint(x: 80, y: 0))
            }
            .stroke(CyberpunkTheme.primary.opacity(0.3), lineWidth: 1)
            
            // Circuit nodes
            Circle()
                .fill(CyberpunkTheme.primary.opacity(0.5))
                .frame(width: 6, height: 6)
                .position(x: 40, y: 40)
                .shadow(color: CyberpunkTheme.primary, radius: 3)
            
            Circle()
                .fill(CyberpunkTheme.secondary.opacity(0.5))
                .frame(width: 6, height: 6)
                .position(x: 80, y: 80)
                .shadow(color: CyberpunkTheme.secondary, radius: 3)
        }
    }
}

#Preview {
    LaunchScreen()
}