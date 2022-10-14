//
//  LibraryToggleView.swift
//  MySpotify
//
//  Created by Alexander Germek on 05.07.2021.
//

import UIKit
import SnapKit

protocol LibraryToggleViewDelegate: AnyObject {
    
    func libraryToggleViewDidTapPlaylists(_ toogleVIew: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toogleVIew: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    weak var delegate: LibraryToggleViewDelegate?
    
    private let playlistsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playlistsButton)
        addSubview(albumsButton)
        
        playlistsButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
        
        addSubview(indicatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistsButton.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        albumsButton.snp.makeConstraints { (make) in
            make.leading.equalTo(playlistsButton.snp.trailing)
            make.top.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        layoutIndicator()
        
    }
    
    
    private func layoutIndicator() {
        let xCoor: CGFloat
        
        switch state {
        case .playlist:
            xCoor = 0
            
        case .album:
           xCoor = 100
        }
        
        indicatorView.frame = CGRect(x: xCoor, y: playlistsButton.bottom, width: 100, height: 3)
        
    }
    
    @objc private func didTapPlaylists() {
        state = .playlist
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        
        delegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc private func didTapAlbums() {
        state = .album
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
    
    func update(for state: State) {
        self.state = state
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
