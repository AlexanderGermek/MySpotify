//
//  NewReleasesCollectionViewCell.swift
//  MySpotify
//
//  Created by Alexander Germek on 23.05.2021.
//

import UIKit
import SDWebImage
import SnapKit

class NewReleasesCollectionViewCell: UICollectionViewCell {
    static let identifire = "NewReleasesCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        //Image
        let imageSize = contentView.height - 10

        albumCoverImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(5)
            make.width.height.equalTo(imageSize)
        }
        
        //Album label
        albumNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(albumCoverImageView.snp.trailing).offset(10)
            make.top.equalTo(3)
            make.trailing.equalToSuperview()
            make.height.equalTo(60)
        }

        artistNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(albumCoverImageView.snp.trailing).offset(10)
            make.top.equalTo(albumNameLabel.snp.bottom)
            make.trailing.equalToSuperview()
            make.height.equalTo(30)
        }

        numberOfTracksLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(albumCoverImageView.snp.trailing).offset(10)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
}
