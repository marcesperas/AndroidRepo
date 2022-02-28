//
//  RepositoriesViewController.swift
//  AndroidRepos
//
//  Created by Marc Jardine Esperas on 2/24/22.
//

import UIKit

protocol RepositoriesViewControllerProtocol {
    func goToRepositoryDetailsViewController(with viewModel: RepositoryDetailsViewModel)
}

class RepositoriesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var viewModel: RepositoriesViewModel = RepositoriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        getRepositories()
        addBackButton()
    }
    
    private func loadUI() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func getRepositories() {
        ActivityIndicatorView.start(for: view)
        viewModel.getRepositories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(()):
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                    self?.showAlert(message: error.description)
                }
            }
            ActivityIndicatorView.stop()
        }
    }

    private func loadImage(row: Int, completion: @escaping (UIImage?) -> ()) {
        let urlString = viewModel.repositoryAtIndex(row).owner?.avatarURL
        viewModel.fetchImageData(with: urlString) { result in
            if case let .success(data) = result {
                completion(UIImage(data: data))
            } else {
                completion(UIImage(named: "ImageNotAvailable"))
            }
        }
    }
}

extension RepositoriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let textString = searchController.searchBar.text else {
            return
        }
        
        viewModel.filterRepositories(textString)
        tableView.reloadData()
    }
}

extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.repositoryCell) as? RepositoryTableViewCell else {
            fatalError("TableViewCell not found")
        }
        
        loadImage(row: indexPath.row) { image in
            DispatchQueue.main.async {
                cell.iconImageView.image = image
            }
        }
        cell.nameLabel.text = viewModel.repositoryAtIndex(indexPath.row).name
        cell.descriptionLabel.text = viewModel.repositoryAtIndex(indexPath.row).description
        
        return cell
    }
}

extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.repositoryAtIndex(indexPath.row)
        let repositoryDetailsViewModel = RepositoryDetailsViewModel(repository: repository)
        goToRepositoryDetailsViewController(with: repositoryDetailsViewModel)
    }
}

extension RepositoriesViewController: RepositoriesViewControllerProtocol {
    func goToRepositoryDetailsViewController(with viewModel: RepositoryDetailsViewModel) {
        let viewController = RepositoryDetailsViewController.instantiate(with: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
