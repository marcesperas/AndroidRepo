//
//  RepositoryDetailsViewController.swift
//  AndroidRepos
//
//  Created by Marc Jardine Esperas on 2/26/22.
//

import UIKit

class RepositoryDetailsViewController: UIViewController, ViewModelBased {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var watchingLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    var viewModel: RepositoryDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadUI(data: Data) {
        title = !viewModel.name.isEmpty ? viewModel.name : "Android Repository Details"
        imageView.image = UIImage(data: data)
        starsLabel.text = viewModel.stars
        watchingLabel.text = viewModel.watchers
        forksLabel.text = viewModel.forks
        descriptionLabel.text = viewModel.description
    }
    
    private func loadData() {
        let urlString = viewModel.avatarURLString
        
        ActivityIndicatorView.start(for: view)
        
        viewModel.fetchImageData(with: urlString) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.loadUI(data: data)
                case .failure(let error):
                    self?.showAlert(message: error.description)
                }
            }
            
            ActivityIndicatorView.stop()
        }
    }

}
