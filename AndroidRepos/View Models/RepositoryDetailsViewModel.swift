//
//  RepositoryDetailsViewModel.swift
//  AndroidRepos
//
//  Created by Marc Jardine Esperas on 2/24/22.
//

import Foundation

class RepositoryDetailsViewModel {
    
    private var repository: Repository
    
    private var webService: WebServiceProtocol
    
    init(webService: WebServiceProtocol = WebService(),
         repository: Repository) {
        self.repository = repository
        self.webService = webService
    }
    
    public var name: String {
        return repository.name ?? ""
    }
    
    public var description: String {
        return repository.description ?? ""
    }
    
    public var stars: String {
        return String(describing: repository.stars ?? 0)
    }
    
    public var watchers: String {
        return String(describing: repository.watchers ?? 0)
    }
    
    public var forks: String {
        return String(describing: repository.forks ?? 0)
    }
    
    public var avatarURLString: String {
        repository.owner?.avatarURL ?? ""
    }
    
    public func fetchImageData(with urlString: String?, completion: @escaping DefaultWebServiceCompletion) {
        webService.fetchImageData(with: urlString ?? "", completion: completion)
    }
    
}
