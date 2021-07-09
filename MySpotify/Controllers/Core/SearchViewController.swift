//
//  SearchViewController.swift
//  MySpotify
//
//  Created by iMac on 15.05.2021.
//

import UIKit
import SnapKit
import SafariServices

class SearchViewController: UIViewController, UISearchBarDelegate {

    
    //MARK: - Private prop-es
    private let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(150)),
                subitem: item,
                count: 2)
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 7,
                bottom: 10,
                trailing: 7)
            
            return NSCollectionLayoutSection(group: group)
        }))

    
    private var categories = [Category]()
    
    //MARK: - Lifecycle -----------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        //searchController.searchResultsUpdater = self //объект ответственный за обновление результат-контроллера
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        view.addSubview(collectionView)
        
        collectionView.register(CategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: CategoryCollectionViewCell.identifire)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        
        APICaller.shared.getCategories { [weak self] (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let categories):
                    
                    self?.categories = categories
                    self?.collectionView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
        
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
            let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { [weak resultsController] (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let results):
                    resultsController?.update(with: results)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
//    //MARK: - UISearchResultsUpdating ---------------------------------------------------
//    func updateSearchResults(for searchController: UISearchController) {
//        
//        guard let _ = searchController.searchResultsController as? SearchResultsViewController,
//            let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
//            return
//        }
//       // resultsController.update(with: results)
//    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifire, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.row]
        
        let viewModel = CategoryCollectionViewCellViewModel(title: category.name, artworkURL: URL(string: category.icons.first?.url ?? ""))
        
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - SearchResultsViewControllerDelegate
extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapResult(_ result: SearchResult) {
        
        switch result {
        case .artist(let model):
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else {
                return
            }
            
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
            
        case .album(let model):
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .playlist(let model):
            let vc = PlaylistViewController(playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .track(let model):
            PlaybackPresenter.shared.startPlayback(from: self, track: model)
        }
    }
}
