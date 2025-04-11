//
//  APIService.swift
//  LambchopCast
//
//  Created by Kasra Rahjerdi on 4/10/25.
//

import Foundation

class APIService {
    private let baseURL = "https://api.neynar.com/v2/farcaster/feed/channels"
    private let apiKey = Config.apiKey
    
    func fetchChannel(cursor: String? = nil, limit: Int = 50) async throws -> FeedResponse {
        var components = URLComponents(string: baseURL)!
        
        var queryItems = [
            URLQueryItem(name: "channel_ids", value: "lambchop"),
            URLQueryItem(name: "with_recasts", value: "true"),
            URLQueryItem(name: "with_replies", value: "false"),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        if let cursor = cursor {
            queryItems.append(URLQueryItem(name: "cursor", value: cursor))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            if httpResponse.statusCode != 200 {
                if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorMessage = errorJson["message"] as? String {
                    throw NetworkError.apiError(message: errorMessage, code: httpResponse.statusCode)
                } else {
                    throw NetworkError.httpError(statusCode: httpResponse.statusCode)
                }
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(FeedResponse.self, from: data)
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw error
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case apiError(message: String, code: Int)
    case httpError(statusCode: Int)
    case decodingError(DecodingError)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .apiError(let message, _):
            return "API Error: \(message)"
        case .httpError(let statusCode):
            return "HTTP Error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to parse response: \(error.localizedDescription)"
        }
    }
}