//
//  Errors.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import Foundation

enum DateParseError: LocalizedError {
    case dataEmpty
    case wrongData(Error)

    var errorDescription: String? { "Data is wrong or empty " }
}

enum HttpError: LocalizedError {
    case badRequest
    case noAuth
    case paymentRequired
    case forbidden
    case wrongUrl
    case wrongMethod

    var errorDescription: String? { "Http error" }
}

enum ResponseError: LocalizedError {
    case unknown(Error?)
    case internalServerError(Error?)
    case noStatusError(Error?)

    var errorDescription: String? { "Server or network troubles" }
}
