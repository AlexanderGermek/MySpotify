//
//  ViewController.swift
//  MySpotify
//
//  Created by iMac on 15.05.2021.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    
    //MARK: - Private prop-es
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()
    
    private var newAlbums: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "gear"),
                            style: .done,
                            target: self,
                            action: #selector(didTapSettings))
        
        
        configureCollectionView()
        view.addSubview(spinner)
        
        addLongTapGesture()
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionView.snp.makeConstraints { (make) in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
    }
    
    
    //MARK: - Private funcs
    private func addLongTapGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_ :)))
        
        collectionView.addGestureRecognizer(gesture)
    }
    
    
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        guard gesture.state == .began else {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint), indexPath.section == 2 else {
            return
        }
        
        let model = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(title: model.name,
                                            message: "Would you like to add this to a playlist?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: { [weak self] _ in
            
            DispatchQueue.main.async {
                let vc = LibraryPlaylistsViewController()
                vc.selectionHandler = { playlist in
                    
                    
                    APICaller.shared.addTrackToPlaylist(track: model, playlist: playlist) { (success) in
                        
                        if success {
                            print("ok")
                        } else {
                            print("no{")
                        }
                    }
                }
                
                vc.title = "Select Playlist"
                
                self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
            
        }))
        
        present(actionSheet, animated: true)
        
        //TODO
//        let section = indexPath.section
//
//        switch <#value#> {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
    }
    
    //MARK: - Configure
    private func configureCollectionView() {
        
        collectionView.register(NewReleasesCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifire)
        
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifire)
        
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifire)
        //header for all Sections:
        collectionView.register(TitleHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleHeaderCollectionReusableView.identifire)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistResponse?
        var recommendations: RecommendationsResponse?
        
        //New Releases
        APICaller.shared.getNewReleases { (result) in
            defer {
                group.leave()
            }
            
            switch result {
            
            case .success(let model):
                
                newReleases = model

            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
        
        //Featured PLaylists
        APICaller.shared.getFeaturedPlaylist { (result) in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let model):
                featuredPlaylist = model
                //print(featuredPlaylist)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        //Recommended Tracks
        APICaller.shared.getRecommendedGenres { (result) in
            switch result {
            
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds) { (recommendedResult) in
                    defer {
                        group.leave()
                    }
                    
                    switch recommendedResult {
                    case .success(let model):
                        recommendations = model
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) {
            
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks else {
                
                fatalError("Models are nil")
            }
            
            //print("Configure models")
            self.configureModels(newAlbums: newAlbums,
                                 playlists: playlists,
                                 tracks: tracks)
        }

    }
    

    private func configureModels(newAlbums: [Album], playlists: [Playlist], tracks: [AudioTrack]) {
        // - Configure Models

        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks    = tracks
        
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? "-")
        })))
        
        
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            return FeaturedPlaylistCellViewModel(name: $0.name,
                                                 artworkURL: URL(string: $0.images.first?.url ?? ""),
                                                 creatorName: $0.owner.display_name)
        })))
       
        
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return RecommendedTrackCellViewModel(name: $0.name,
                                                 artistName: $0.artists.first?.name ?? "-",
                                                 artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
        })))
        collectionView.reloadData()
    }
    
    @objc private func didTapSettings() {
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionType = sections[section]
        
        switch sectionType {
        
        case .newReleases(let viewModels):
            return viewModels.count
            
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        
        case .newReleases(let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifire,
                                                          for: indexPath) as! NewReleasesCollectionViewCell
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .featuredPlaylists(let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifire,
                                                          for: indexPath) as! FeaturedPlaylistCollectionViewCell
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        
        case .recommendedTracks(let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifire,
                                                          for: indexPath) as! RecommendedTrackCollectionViewCell
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }

}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let section = sections[indexPath.section]
        
        switch section {
        
        case .featuredPlaylists:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .newReleases:
            let album = newAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .recommendedTracks:
            let track = tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifire,
                for: indexPath) as? TitleHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let model = sections[indexPath.section]
        header.configure(with: model.title)
        return header
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(50)
                                                    ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
                                                        )
                                ]
        
        switch section {
        case 0: //newReleases

            
            let height = CGFloat(390)
            // Item
            let item = NSCollectionLayoutItem(layoutSize:
                                NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize:
                    NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(height)),
                subitem: item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize:
                    NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                           heightDimension: .absolute(height)),
                subitem: verticalGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 1: // featuredPlaylists
            
            let height = CGFloat(200)
            // Item
            let item = NSCollectionLayoutItem(layoutSize:
                                NSCollectionLayoutSize(widthDimension: .absolute(height),
                                                       heightDimension: .absolute(height)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize:
                    NSCollectionLayoutSize(widthDimension:  .absolute(height),
                                           heightDimension: .absolute(2*height)),
                subitem: item,
                count: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize:
                    NSCollectionLayoutSize(widthDimension:  .absolute(height),
                                           heightDimension: .absolute(2*height)),
                subitem: verticalGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 2: // recommendedTracks
            
            let height = CGFloat(80)
            // Item
            let item = NSCollectionLayoutItem(layoutSize:
                                NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize:
                    NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(height)),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        default:
            let height = CGFloat(390)
            // Item
            let item = NSCollectionLayoutItem(layoutSize:
                                NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize:
                    NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(height)),
                subitem: item,
                count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }

}
