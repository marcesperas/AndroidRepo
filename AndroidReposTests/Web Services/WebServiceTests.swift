//
//  WebServiceTests.swift
//  AndroidReposTests
//
//  Created by Marc Jardine Esperas on 2/27/22.
//

import XCTest

@testable import AndroidRepos

class WebServiceTests: XCTestCase {

    var sut: WebService!

    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = WebService(urlSession: urlSession)
    }

    override func tearDown() {
        sut = nil
        MockUrlProtocol.stubResponseData = nil
    }

    func testFetchRepositories_SuccessfulResponse() {
        
        let repository = Repository(name: "ndk-samples", description: "Android NDK samples with Android Studio", owner: Owner(avatarURL: "https://avatars.githubusercontent.com/u/32689599?v=4"), stars: 8668, watchers: 8668, forks: 3865)
        
        let mockJsonString = "[{\"name\":\"ndk-samples\",\"owner\":{\"avatar_url\":\"https://avatars.githubusercontent.com/u/32689599?v=4\"},\"description\":\"Android NDK samples with Android Studio\",\"stargazers_count\":8668,\"watchers_count\":8668,\"forks_count\":3865}]"

        MockUrlProtocol.stubResponseData = mockJsonString.data(using: .utf8)
        
        let expectation = self.expectation(description: "Repository web service response expectation")
        
        sut.fetchRepositories { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, [repository])
            case .failure(let error):
                XCTFail("Error fetching repositories: \(error)")
            }
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testFetchRepositories_ErrorJsonResponse() {
        let jsonString = "{\"message\": \"Not Found\",\"documentation_url\":\"https://docs.github.com/rest\"}"

        MockUrlProtocol.stubResponseData = jsonString.data(using: .utf8)

        let expectation = self.expectation(description: "Feed web service unsuccessful response expectation")
        
        sut.fetchRepositories { result in
            if case let .failure(error) = result {
                XCTAssertNotNil(error)
                XCTAssertEqual(error, .jsonDecodingError)
                expectation.fulfill()
            }
        }

        self.wait(for: [expectation], timeout: 2)
    }

}
