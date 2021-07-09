//
//  AlbumViewController.swift
//  MySpotify
//
//  Created by iMac on 06.06.2021.
//

import UIKit
import SnapKit

class AlbumViewController: UIViewController {
    
    //MARK: - Private prop-es
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
                // Item
                let height = CGFloat(60)
                
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize:
                        NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(height)),
                    subitem: item,
                    count: 1)
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(1)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top)]
                
                return section
            }
        )
    )
    
    private var album: Album
    
    private var viewModels = [AlbumCollectionVoewCellViewModel]()
    private var hrefAlbum: String = ""
    private var tracks = [AudioTrack]()
    
    //MARK: - Init
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = album.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        collectionView.register(AlbumTrackCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifire)
        
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifire)
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        fetchData()
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapActions))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.snp.makeConstraints { (make) in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
    }
    
    //MARK: - Private funcs
    @objc private func didTapActions() {
        
        let actionSheet = UIAlertController(title: album.name,
                                            message: "Actions",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Save Album", style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            APICaller.shared.saveAlbum(album: strongSelf.album) { (success) in
                if success {
                    HapticsManager.shared.vibrate(for: .success)
                    NotificationCenter.default.post(name : .albumSavedNotification, object: nil)
                }
                else {
                    HapticsManager.shared.vibrate(for: .error)
                }
            }
        }))
        
        present(actionSheet, animated: true)
        
        //        guard let url = URL(string: hrefAlbum) else {
        //            return
        //        }
        //
        //        let vc = UIActivityViewController(
        //            activityItems: [url],//activityItems: ["CHeck out this playlist I found!", url],
        //            applicationActivities: [])
        //
        //        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        //        present(vc, animated: true)
    }
    
    
    private func fetchData() {
        APICaller.shared.getAlbumDetails(for: album) { [weak self] (result) in
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let model):
                    self?.hrefAlbum = model.href
                    
                    self?.tracks = model.tracks.items
                    
                    self?.viewModels = model.tracks.items
                        .compactMap({ AlbumCollectionVoewCellViewModel(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "-"
                        )})
                    
                    self?.collectionView.reloadData()
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumTrackCollectionViewCell.identifire,
            for: indexPath) as! AlbumTrackCollectionViewCell
        
        //cell.backgroundColor = .red
        cell.configure(with: viewModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //play song
        var track = tracks[indexPath.row]
        track.album = self.album
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifire,
            for: indexPath
        ) as? PlaylistHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        
        
        let headerViewModel = PlaylistHeaderViewViewModel(
            name: album.name,
            ownerName: album.artists.first?.name,
            description: "Release Date: \(String.formattedDate(string: album.release_date))",
            artworkURL: URL(string: album.images.first?.url ?? "")
        )
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    
    
}

//MARK: - PlaylistHeaderCollectionReusableViewDelegate
extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    
    func playlistHeaderCollectionReusableViewDelegateDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        //Start playlist play in queue
        
        let tracksWithAlbum: [AudioTrack] = tracks.compactMap ({
            var track = $0
            track.album = self.album
            return track
        })
        
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }
}
