//
//  AsyncImageView.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 29/06/23.
//

import SwiftUI

struct AsyncImageView: View {
    var imageURL: String

    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }

    }
}
