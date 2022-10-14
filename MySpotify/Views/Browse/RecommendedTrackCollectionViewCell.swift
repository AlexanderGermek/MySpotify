//
//  RecommendedTrackCollectionViewCell.swift
//  MySpotify
//
//  Created by Alexander Germek on 23.05.2021.
//

import UIKit
import SnapKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifire = "RecommendedTrackCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 2
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumCoverImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(2)
            make.width.height.equalTo(contentView.height-4)
        }
        
        trackNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(albumCoverImageView.snp.trailing).offset(10)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(contentView.height/2)
        }
        
        artistNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(albumCoverImageView.snp.trailing).offset(10)
            make.top.equalTo(trackNameLabel.snp.bottom)
            make.trailing.equalToSuperview()
            make.height.equalTo(contentView.height/2)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
}
