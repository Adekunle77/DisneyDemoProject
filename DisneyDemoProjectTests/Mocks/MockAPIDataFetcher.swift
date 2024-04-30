//
//  MockAPIDataFetcher.swift
//  DisneyDemoProjectTests
//
//  Created by Ade Adegoke on 27/04/2024.
//

import XCTest
@testable import DisneyDemoProject

class MockAPIDataFetcher: DataFetchable {
   
    var isReturningError = false
 
    func fetchData<T: Decodable>(url: URL) async throws -> T {
        if isReturningError {
            throw APIError.NetworkFailure(response: nil, data: nil)
        } else {
            do {
                let stubs = try StubsData.loadJson(filename: AppConstants.disneyCharacterStubsfileName)
                return stubs as! T
            } catch {
                throw APIError.DecodingFailure(error: error)
            }
        }
    }
   

    func downloadData(from url: URL) async throws -> Data {
        if let image = UIImage(systemName: "pencil") {
            if let pngData = image.pngData() {
                return pngData
            } else {
                throw APIError.DecodingFailure(error: NSError(domain: "Failed to decode data", code: 0, userInfo: nil))
            }
        } else {
            throw APIError.DecodingFailure(error: NSError(domain: "Failed to download data", code: 0, userInfo: nil))
        }
    }
}
