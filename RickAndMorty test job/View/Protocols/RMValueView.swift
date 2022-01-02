//
//  RMValueView.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import SwiftUI

enum RMKeyValueLayout {
    case vertical
    case horizontal
}

protocol RMValueView: View {
    associatedtype ValueView: View
    var content: Self.ValueView { get }
    var layout: RMKeyValueLayout { get }
}

extension RMValueView {
    @ViewBuilder
    public var body: some View {
        content
    }
}

extension String: RMValueView {
    var content: some View {
        Text(self)
    }

    var layout: RMKeyValueLayout { .horizontal }
}

extension RMCharacterLocationResponse: RMValueView {
    @ViewBuilder
    var content: some View {
        if let `url` = url {
            Link(name, destination: url)
        } else {
            Text(name)
        }
    }

    var layout: RMKeyValueLayout { .vertical }
}

extension URL: RMValueView {
    var content: some View {
        Link(relativePath, destination: self)
    }

    var layout: RMKeyValueLayout { .horizontal }
}
