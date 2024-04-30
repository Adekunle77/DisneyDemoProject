//
//  Extension+View.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 30/04/2024.
//

import SwiftUI

extension View {
    func asyncImage(url: URL, placeholder: Image) -> some View {
        AsyncImage( url: url, content: { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                placeholder
                    .resizable()
                    .scaledToFit()
            case .empty:
                ProgressView()
            @unknown default:
                placeholder
                    .resizable()
                    .scaledToFit()
            }
        })
    }
}

