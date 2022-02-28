//
//  WebService.swift
//  AndroidRepos
//
//  Created by Marc Jardine Esperas on 2/24/22.
//

import Foundation

typealias DefaultWebServiceCompletion = (Result<Data, WebServiceError>) -> ()
typealias NoResponseWebServiceCompletion = (Result<Void, WebServiceError>) -> ()
typealias RepositoryWebServiceCompletion = (Result<[Repository], WebServiceError>) -> ()

protocol WebServiceProtocol {
    func fetchRepositories(completion: @escaping RepositoryWebServiceCompletion)
    func fetchImageData(with urlString: String, completion: @escaping DefaultWebServiceCompletion)
    func fetchData(with urlString: String, completion: @escaping DefaultWebServiceCompletion)
}

class WebService: WebServiceProtocol {
    
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func fetchRepositories(completion: @escaping RepositoryWebServiceCompletion) {
        
        let urlString = "\(Constants.Url.baseUrlString)\(Constants.Url.repositoryUrlString)"
        
        fetchData(with: urlString) { result in
    
            switch result {
            case .success(let data):
                do {
                    let repository = try JSONDecoder().decode([Repository].self, from: data)
                    completion(.success(repository))
                    print(String(describing: repository))
                } catch(let error) {
                    completion(.failure(.jsonDecodingError))
                    print(String(describing: error))
                }
            case .failure(let error):
                completion(.failure(error))
                
            }
            
        }
        
    }
    
    public func fetchImageData(with urlString: String, completion: @escaping DefaultWebServiceCompletion) {
        
        let dataCache = NSCache<NSString, NSData>()
        
        if let cachedData = dataCache.object(forKey: NSString(string: urlString)) {
            let data = Data(referencing: cachedData)
            completion(.success(data))
            return
        }
        
        fetchData(with: urlString, completion: completion)
        
    }
    
    func fetchData(with urlString: String, completion: @escaping DefaultWebServiceCompletion) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let dataTask = urlSession.dataTask(with: url) { (data, httpUrlResponse, error) in
            
            guard error == nil else {
                return completion(.failure(.unableToCompleteRequest))
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            completion(.success(data))

        }
        
        dataTask.resume()
        
    }
    
}
