//
//  RMCharactersResponse.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import Foundation

struct RMCharactersResponse: Decodable {
    let info: RMCharactersInfoResponse
    let results: [RMCharacterResponse]
}
