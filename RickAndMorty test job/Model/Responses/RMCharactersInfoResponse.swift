//
//  RMCharactersInfoResponse.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import Foundation

struct RMCharactersInfoResponse: Decodable {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
}
