//
//  MockWebService.swift
//  AndroidReposTests
//
//  Created by Marc Jardine Esperas on 2/27/22.
//

import XCTest

@testable import AndroidRepos

class MockWebService: WebServiceProtocol {

    var shouldReturnError: Bool = false

    func fetchRepositories(completion: @escaping RepositoryWebServiceCompletion) {
        guard !shouldReturnError else {
            completion(.failure(.unableToCompleteRequest))
            return
        }

        let repository = Repository(name: "ndk-samples", description: "Android NDK samples with Android Studio", owner: Owner(avatarURL: "https://avatars.githubusercontent.com/u/32689599?v=4"), stars: 8668, watchers: 8668, forks: 3865)

        completion(.success([repository]))
    }

    func fetchImageData(with urlString: String, completion: @escaping DefaultWebServiceCompletion) {
        guard !shouldReturnError else {
            completion(.failure(.unableToCompleteRequest))
            return
        }

    }

    func fetchData(with urlString: String, completion: @escaping DefaultWebServiceCompletion) {
        
    }

}
