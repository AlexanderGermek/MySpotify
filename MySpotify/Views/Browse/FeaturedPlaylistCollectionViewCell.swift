//
//  FeaturedPlaylistsCollectionViewCell.swift
//  MySpotify
//
//  Created by iMac on 23.05.2021.
//

import UIKit
import SnapKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifire = "FeaturedPlaylistCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height - 90
        
        playlistCoverImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(3)
            make.width.height.equalTo(imageSize)
        }
        
        let size = CGFloat(30)
        
        playlistNameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(3)
            make.top.equalToSuperview().offset(contentView.height-70)
            make.width.equalTo(contentView.width-6)
            make.height.equalTo(size)
        }
        
        creatorNameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(3)
            make.top.equalToSuperview().offset(contentView.height-size)
            make.width.equalTo(contentView.width-6)
            make.height.equalTo(size)
        }

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
}
