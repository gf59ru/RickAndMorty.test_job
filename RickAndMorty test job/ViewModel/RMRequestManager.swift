//
//  RMRequestManager.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import UIKit

class RMRequestManager: NSObject {

    static let shared = RMRequestManager()

    private static let baseUrl = "https://rickandmortyapi.com/api"
    private static let charactersUrl = "\(baseUrl)/character"

    private override init() { }

    private var _session: URLSession?
    private var session: URLSession {
        if let result = _session {
            return result
        }

        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.urlCache = nil

        let result = URLSession(configuration: sessionConfiguration,
                                delegate: self,
                                delegateQueue: nil)
        _session = result
        return result
    }

    // MARK: - public methods

    func getFirstPageCharacters(completion: @escaping (RMCharactersResponse?, Error?) -> Void) {
        guard let url = URL(string: Self.charactersUrl) else {
            completion(nil, nil)
            return
        }
        getCharacters(at: url, completion: completion)
    }

    func getCharacters(at pageUrl: URL, completion: @escaping (RMCharactersResponse?, Error?) -> Void) {
        request(url: pageUrl) { (result: RMCharactersResponse?, error: Error?) in
            completion(result, error)
        }
    }

    // MARK: - private methods

    private func request<T>(url: URL, completion: @escaping (T?, Error?) -> Void)
    where T: Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: { [self] (data, response, responseError) in
            guard let `response` = response,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                      completion(nil, ResponseError.noStatusError(responseError))
                      return
                  }
            switch statusCode {
            case 100..<399:
                guard let `data` = data else {
                    completion(nil, DateParseError.dataEmpty)
                    return
                }
                do {
                    let result: T = try parse(data)
                    completion(result, nil)
                } catch {
                    completion(nil, DateParseError.wrongData(error))
                }
            case 400:
                completion(nil, HttpError.badRequest)
            case 401:
                completion(nil, HttpError.noAuth)
            case 402:
                completion(nil, HttpError.paymentRequired)
            case 403:
                completion(nil, HttpError.forbidden)
            case 404:
                completion(nil, HttpError.wrongUrl)
            case 405:
                completion(nil, HttpError.wrongMethod)
            case 500:
                completion(nil, ResponseError.internalServerError(responseError))
            default:
                completion(nil, ResponseError.unknown(responseError))
            }
        })
        task.resume()
    }

    private func parse<T>(_ data: Data) throws -> T
    where T: Decodable {
        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: data)
        return result
    }

}

extension RMRequestManager: URLSessionDelegate {
}
