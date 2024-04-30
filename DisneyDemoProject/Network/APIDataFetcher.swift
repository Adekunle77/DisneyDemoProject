//
//  APIFetcher.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 26/04/2024.
//

import Foundation

protocol DataFetchable {
    func fetchData<T: Decodable>(url: URL) async throws -> T
    func downloadData(from url: URL) async throws -> Data
}

final class APIDataFetcher {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
}

extension APIDataFetcher: DataFetchable {
    func fetchData<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw APIError.NetworkFailure(response: response, data: data)
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.DecodingFailure(error: error)
        }
    }
    
    func downloadData(from url: URL) async throws -> Data {
         let (data, _) = try await session.data(from: url)
         return data
     }
}


