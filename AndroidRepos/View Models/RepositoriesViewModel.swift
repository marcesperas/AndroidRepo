//
//  RepositoriesViewModel.swift
//  AndroidRepos
//
//  Created by Marc Jardine Esperas on 2/24/22.
//

import Foundation

protocol RepositoriesViewModelProtocol {
    func getRepositories(completion: @escaping NoResponseWebServiceCompletion)
    func fetchImageData(with urlString: String?, completion: @escaping DefaultWebServiceCompletion)
}

class RepositoriesViewModel: RepositoriesViewModelProtocol {

    private var repositories: [Repository] = []
    private var filteredRepositories: [Repository] = []
    private var isSearchTextEmpty: Bool = true

    private var webService: WebServiceProtocol

    init(webService: WebServiceProtocol = WebService()) {
        self.webService = webService
    }

    public func numberOfRowsInSection(_ section: Int) -> Int {
        return isSearchTextEmpty ? repositories.count : filteredRepositories.count
    }

    public func repositoryAtIndex(_ index: Int) -> Repository {
        return isSearchTextEmpty ? repositories[index] : filteredRepositories[index]
    }

    public func getRepositories(completion: @escaping NoResponseWebServiceCompletion) {
        webService.fetchRepositories { [weak self] result in

            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }

        }
    }
    
    public func filterRepositories(_ textString: String) {
        filteredRepositories = repositories.filter {
            $0.name?.range(of: textString, options: .caseInsensitive) != nil ||
            $0.description?.range(of: textString, options: .caseInsensitive) != nil
        }
        isSearchTextEmpty = textString.isEmpty
    }
    
    public func fetchImageData(with urlString: String?, completion: @escaping DefaultWebServiceCompletion) {
        webService.fetchImageData(with: urlString ?? "", completion: completion)
    }

}

