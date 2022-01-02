//
//  RMDetailEnumItemView.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import SwiftUI

protocol RMDetailEnumItemView: View {
    var title: String { get }
    var value: String { get }
}

extension RMDetailEnumItemView {
    @ViewBuilder
    var body: some View {
        keyValueBody(title: title, value: value)
    }
}

extension RMGender: RMDetailEnumItemView {
    var title: String { "Gender" }
    var value: String { rawValue }
}

extension RMCharacterStatus: RMDetailEnumItemView {
    var title: String { "Status" }
    var value: String { rawValue }
}

extension RMCharacterSpecies: RMDetailEnumItemView {
    var title: String { "Species" }
    var value: String { rawValue }
}

