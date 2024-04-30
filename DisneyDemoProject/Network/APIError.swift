//
//  APIError.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 26/04/2024.
//

import Foundation

enum APIError {
    struct NetworkFailure: Error, LocalizedError {
        let code: UInt
        let message: String

        public var errorDescription: String? {
            return "Network Failure - HTTP \(code): \(message)"
        }

        public var failureReason: String? {
            return "The network request failed with HTTP \(code): \(message)"
        }

        public var recoverySuggestion: String? {
            return "Please check your network connection and try again."
        }

        init(response: URLResponse?, data: Data?) {
            if let httpResponse = response as? HTTPURLResponse,
               let responseData = data {
                self.code = UInt(httpResponse.statusCode)
                self.message = String(data: responseData, encoding: .utf8) ?? "No message"
            } else {
                self.code = 500
                self.message = "Response or data is nil"
            }
        }
    }
    
    struct DecodingFailure: Error, LocalizedError {
           let error: Error

           public var errorDescription: String? {
               return "Decoding Failure: \(error.localizedDescription)"
           }

           public var failureReason: String? {
               return "The data received from the network could not be decoded."
           }

           public var recoverySuggestion: String? {
               return "Please check the data format and try again."
           }

           init(error: Error) {
               self.error = error
           }
       }
}
