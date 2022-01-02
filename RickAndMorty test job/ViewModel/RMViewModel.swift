//
//  RMViewModel.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import UIKit

class RMViewModel: ObservableObject {

    @Published private(set) var currentPageCharacters: [RMCharacterResponse] = []
    @Published private(set) var currentPagePhotos: [Int: UIImage] = [:]
    @Published private(set) var isLoading = false
    @Published private(set) var isPhotosLoading = false
    @Published private(set) var errorMessage: String? {
        didSet {
            if errorMessage == nil { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.errorMessage = nil
            }
        }
    }

    var hasNextPage: Bool { nextPageCharactersUrl != nil }
    var hasPrevPage: Bool { prevPageCharactersUrl != nil }

    private var nextPageCharactersUrl: URL?
    private var prevPageCharactersUrl: URL?

    private var nextPageCharacters: RMCharactersResponse?
    private var prevPageCharacters: RMCharactersResponse?

    private var photos: [Int: UIImage] = [:]
    private var photosLoadingFlag: Date?
    private let setPhotosQueue = DispatchQueue(label: "com.rm_test.set_photos", attributes: .initiallyInactive)


    // MARK: - public methods

    func startingCharactersRequest() {
        isLoading = true
        RMRequestManager.shared.getFirstPageCharacters { [weak self] response, error in
            self?.processResponse(response: response, error: error)
        }
    }

    func nextPage() {
        guard let `nextPageCharactersUrl` = nextPageCharactersUrl else { return }
        showPage(from: nextPageCharacters, requestIfEmpty: nextPageCharactersUrl)
    }

    func prevPage() {
        guard let `prevPageCharactersUrl` = prevPageCharactersUrl else { return }
        showPage(from: prevPageCharacters, requestIfEmpty: prevPageCharactersUrl)
    }

    // MARK: - private methods
    // MARK: characters

    private func processResponse(response: RMCharactersResponse?, error: Error?) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = nil
        }
        guard let `response` = response else {
            DispatchQueue.main.async {
                self.handleError(error)
            }
            return
        }

        let photoUrls = response.results
            .compactMap { $0.image == nil ? nil : (id: $0.id, url: $0.image) }
            .reduce(into: [Int: URL]()) {
                $0[$1.id] = $1.url
            }
        loadPhotos(photoUrls)

        DispatchQueue.main.async {
            self.applyResponse(response)
        }

        if let nextUrl = response.info.next {
            requestCharacters(at: nextUrl) { [weak self] response in
                self?.nextPageCharacters = response
            }
        }

        if let prevUrl = response.info.prev {
            requestCharacters(at: prevUrl) { [weak self] response in
                self?.prevPageCharacters = response
            }
        }
    }

    private func requestCharacters(at url: URL, completion: @escaping (RMCharactersResponse) -> Void) {
        RMRequestManager.shared.getCharacters(at: url) { response, error in
            guard let `response` = response else { return }
            completion(response)
        }
    }

    private func showPage(from readyResults: RMCharactersResponse?, requestIfEmpty url: URL) {
        if let `readyResults` = readyResults {
            processResponse(response: readyResults, error: nil)
        } else {
            isLoading = true
            clearPhotos()
            RMRequestManager.shared.getCharacters(at: url) { [weak self] response, error in
                self?.processResponse(response: response, error: error)
            }
        }
    }

    private func applyResponse(_ response: RMCharactersResponse) {
        currentPageCharacters = response.results
        nextPageCharactersUrl = response.info.next
        prevPageCharactersUrl = response.info.prev
    }

    // MARK: photos

    private func loadPhotos(_ urls: [Int: URL]) {
        setPhotosQueue.activate()
        DispatchQueue.main.async {
            self.isPhotosLoading = true
            self.currentPagePhotos = [:]
        }
        clearPhotos()
        let flag = Date()
        photosLoadingFlag = flag
        let photosGroup = DispatchGroup()
        let photosQueue = DispatchQueue.global()

        for url in urls {
            photosGroup.enter()
            photosQueue.async(group: photosGroup) { [weak self] in
                guard let `self` = self,
                      flag == self.photosLoadingFlag else {
                          return
                      }

                guard let data = try? Data(contentsOf: url.value),
                      let image = UIImage(data: data) else {
                          photosGroup.leave()
                          return
                      }

                self.setPhotosQueue.sync {
                    self.photos[url.key] = image
                    photosGroup.leave()
                }
            }
        }

        photosGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let `self` = self,
                  flag == self.photosLoadingFlag else {
                      return
                  }
            self.photosLoadingFlag = nil
            self.currentPagePhotos = self.photos
            self.isPhotosLoading = false
        }

    }

    private func clearPhotos() {
        setPhotosQueue.sync {
            photos = [:]
        }
    }

    // MARK: errors
    private func handleError(_ error: Error?) {
        errorMessage = error?.localizedDescription ?? "Something wrong"
    }
}
