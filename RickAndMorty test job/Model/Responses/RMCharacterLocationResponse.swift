//
//  RMCharacterLocationResponse.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import Foundation

struct RMCharacterLocationResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case name
        case url        
    }

    let name: String
    let url: URL?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try? container.decode(URL.self, forKey: .url)
    }
}
