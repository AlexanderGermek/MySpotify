//
//  PlaylistHeaderCollectionReusableView.swift
//  MySpotify
//
//  Created by iMac on 14.06.2021.
//

import SDWebImage
import UIKit
import SnapKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDelegateDidTapPlayAll(
        _ header: PlaylistHeaderCollectionReusableView)
}


final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifire = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "photo")
        return image
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 30, weight: .regular))
        
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(imageView)
        addSubview(playAllButton)
        
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    @objc private func didTapPlayAll() {
        delegate?.playlistHeaderCollectionReusableViewDelegateDidTapPlayAll(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = height / 1.8
        
        imageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset((width-imageSize)/2)
            make.top.equalTo(20)
            make.width.height.equalTo(imageSize)
        }
        
        let heightSize = CGFloat(44)
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(imageView.snp.bottom)
            make.width.equalTo(width - 20)
            make.height.equalTo(heightSize)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(nameLabel.snp.bottom)
            make.width.equalTo(width - 20)
            make.height.equalTo(heightSize)
        }
        
        ownerLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.width.equalTo(width - 20)
            make.height.equalTo(heightSize)
        }
        
        let buttonSize = CGFloat(60)
        
        playAllButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(width - 80)
            make.top.equalToSuperview().offset(height - 80)
            make.width.equalTo(buttonSize)
            make.height.equalTo(buttonSize)
        }

    }
    
    func configure(with viewModel: PlaylistHeaderViewViewModel) {
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        imageView.sd_setImage(with: viewModel.artworkURL,
                              placeholderImage: UIImage(systemName: "music.note.list"))
    }
}
