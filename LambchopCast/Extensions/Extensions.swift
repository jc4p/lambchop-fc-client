//
//  Extensions.swift
//  LambchopCast
//
//  Created by Kasra Rahjerdi on 4/10/25.
//

import SwiftUI

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let errorPresented = Binding<Bool>(
            get: { error.wrappedValue != nil },
            set: { if !$0 { error.wrappedValue = nil } }
        )
        
        return alert(
            "Error",
            isPresented: errorPresented,
            actions: {
                Button(buttonTitle) {
                    error.wrappedValue = nil
                }
            },
            message: {
                Text(error.wrappedValue?.localizedDescription ?? "An unknown error occurred")
            }
        )
    }
}