//
//  LibraryViewController.swift
//  MySpotify
//
//  Created by Alexander Germek on 15.05.2021.
//

import UIKit
import SnapKit

class LibraryViewController: UIViewController {
    
    //MARK: - Private properties
    private let playlistsVC = LibraryPlaylistsViewController()
    private let albumsVC    = LibraryAlbumsViewController()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    private let toggleView = LibraryToggleView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        addChildren()
        
        updateBarButtons()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(view.safeAreaInsets.top+55)
            make.width.equalTo(view.width)
            make.height.equalTo(view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55)
        }
        
        playlistsVC.view.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        albumsVC.view.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(view.width)
            make.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        toggleView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(view.safeAreaInsets.top)
            make.width.equalTo(200)
            make.height.equalTo(55)
        }
        
    }
    
    //MARK: - Private funcs
    private func updateBarButtons() {
        switch toggleView.state {
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self, action: #selector(didTapAdd))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func didTapAdd() {
        playlistsVC.showCreatePlaylistAlert()
    }
    
    private func addChildren() {
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height)
        view.addSubview(scrollView)
        
        
        toggleView.delegate = self
        view.addSubview(toggleView)
        
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.didMove(toParent: self)
        
        
        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        playlistsVC.didMove(toParent: self)
    }
    
    
}

extension LibraryViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x >= (view.width-100) {
            
            toggleView.update(for: .album)
            
        } else {
            toggleView.update(for: .playlist)
        }
        
        updateBarButtons()
    }
}


extension LibraryViewController: LibraryToggleViewDelegate {
    
    func libraryToggleViewDidTapPlaylists(_ toogleVIew: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func libraryToggleViewDidTapAlbums(_ toogleVIew: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    }
}
