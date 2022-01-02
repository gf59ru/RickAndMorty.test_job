//
//  RMCharacterResponse.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import Foundation

struct RMCharacterResponse: Decodable, Identifiable {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case image
        case episode
        case url
        case created
    }

    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: RMCharacterSpecies
    let type: String
    let gender: RMGender
    let origin: RMCharacterLocationResponse
    let location: RMCharacterLocationResponse
    let image: URL?
    let episode: [URL]
    let url: URL?
    let created: Date 

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(RMCharacterStatus.self, forKey: .status)
        species = try container.decode(RMCharacterSpecies.self, forKey: .species)
        type = try container.decode(String.self, forKey: .type)
        gender = try container.decode(RMGender.self, forKey: .gender)
        origin = try container.decode(RMCharacterLocationResponse.self, forKey: .origin)
        location = try container.decode(RMCharacterLocationResponse.self, forKey: .location)
        image = try? container.decode(URL.self, forKey: .image)
        episode = try container.decode([URL].self, forKey: .episode)
        url = try? container.decode(URL.self, forKey: .url)

        let createdString = try container.decode(String.self, forKey: .created)
        guard let createdDate = DateFormatter.serverDateFormatter.date(from: createdString) else {
            throw DateParseError.wrongData(NSError(domain: "Created data wrong format", code: -1, userInfo: nil) as Error)
        }
        created = createdDate
    }

    var nameInitials: String {
        let nameParts = name.components(separatedBy: .whitespaces)
        let initials = nameParts.compactMap { $0.first }
        return initials.map { String($0) }.joined()
    }
}
