//
//  FeedViewModel.swift
//  LambchopCast
//
//  Created by Kasra Rahjerdi on 4/10/25.
//

import Foundation
import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var casts: [Cast] = []
    @Published var nextCursor: String? = nil
    @Published var isLoading = false
    @Published var error: Error? = nil
    
    private let apiService = APIService()
    
    func fetchFeed(cursor: String?) async {
        do {
            // Retry up to 3 times with exponential backoff
            var attempt = 0
            var lastError: Error? = nil
            
            while attempt < 3 {
                do {
                    let response = try await apiService.fetchChannel(cursor: cursor)
                    DispatchQueue.main.async {
                        self.casts.append(contentsOf: response.casts)
                        self.nextCursor = response.next?.cursor
                        self.error = nil
                    }
                    return
                } catch {
                    lastError = error
                    attempt += 1
                    
                    // Skip retry for client errors, only retry server errors or network issues
                    let nsError = error as NSError
                    if nsError.domain == NSURLErrorDomain && 
                       (nsError.code == NSURLErrorTimedOut || 
                        nsError.code == NSURLErrorNetworkConnectionLost || 
                        nsError.code == NSURLErrorNotConnectedToInternet) {
                        // Network error - worth retrying
                        
                        // Wait with exponential backoff
                        try? await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt)) * 500_000_000))
                        continue
                    }
                    
                    // For other errors, just throw immediately
                    throw error
                }
            }
            
            // If we got here, all retries failed
            throw lastError ?? NSError(domain: "FeedViewModel", code: 1000, 
                                      userInfo: [NSLocalizedDescriptionKey: "Failed after multiple attempts"])
            
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
        }
    }
    
    func resetAndFetchFeed() async {
        DispatchQueue.main.async {
            self.casts = []
            self.nextCursor = nil
            self.error = nil
        }
        await fetchFeed(cursor: nil)
    }
}