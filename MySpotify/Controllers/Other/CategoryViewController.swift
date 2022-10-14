//
//  CategoryViewController.swift
//  MySpotify
//
//  Created by Alexander Germek on 03.07.2021.
//

import UIKit
import SnapKit

class CategoryViewController: UIViewController {
    
    
    //MARK: - Private properties
    private let category: Category
    
    private var playlists = [Playlist]()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 5, leading: 5,
                bottom: 5, trailing: 5)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(250)),
                subitem: item,
                count: 2)
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 5, leading: 5,
                bottom: 5, trailing: 5)
            
            
            return NSCollectionLayoutSection(group: group)
        }))
    
    
    
    //MARK: - Init
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category.name
        view.backgroundColor = .systemBackground
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifire)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        APICaller.shared.getCategoryPlaylists(category: category) { [weak self] (result) in
            
            DispatchQueue.main.async {
                switch result {
                
                case .success(let playlists):
                    self?.playlists = playlists
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

}


extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifire, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let playlist = playlists[indexPath.row]
        
        cell.configure(with: FeaturedPlaylistCellViewModel(
                        name:        playlist.name,
                        artworkURL:  URL(string: playlist.images.first?.url ?? ""),
                        creatorName: playlist.owner.display_name))
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = PlaylistViewController(playlist: playlists[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
