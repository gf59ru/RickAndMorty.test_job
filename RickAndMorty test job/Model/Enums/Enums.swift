//
//  Enums.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import Foundation

enum RMGender: String, Decodable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}

enum RMCharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

enum RMCharacterSpecies: String, Decodable {
    case human = "Human"
    case alien = "Alien"
    case animal = "Animal"
    case robot = "Robot"
    case humanoid = "Humanoid"
    case poopybutthole = "Poopybutthole"
    case mythologicalCreature = "Mythological Creature"
    case cronenberg = "Cronenberg"
    case decease = "Disease"

    case unknown = "unknown"
}
