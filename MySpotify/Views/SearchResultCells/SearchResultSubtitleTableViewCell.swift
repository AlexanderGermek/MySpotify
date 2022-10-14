//
//  SearchResultSubtitleTableViewCell.swift
//  MySpotify
//
//  Created by Alexander Germek on 04.07.2021.
//

import UIKit
import SnapKit
import SDWebImage

class SearchResultSubtitleTableViewCell: UITableViewCell {
    
    static let identifire = "SearchResultSubtitleTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(subtitleLabel)
        contentView.clipsToBounds = true
        
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height - 10
        
        iconImageView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(10)
            maker.top.equalToSuperview().offset(5)
            maker.width.height.equalTo(imageSize)
        }
        
//        iconImageView.layer.cornerRadius = imageSize / 2
//        iconImageView.layer.masksToBounds = true
        
        
        let labelHeight = contentView.height / 2
        
        label.snp.makeConstraints { (maker) in
            maker.leading.equalTo(iconImageView.snp.trailing).offset(10)
            maker.top.trailing.equalToSuperview()
            maker.height.equalTo(labelHeight)
        }
        
        subtitleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(iconImageView.snp.trailing).offset(10)
            maker.top.equalTo(label.snp.bottom)
            maker.trailing.equalToSuperview()
            maker.height.equalTo(labelHeight)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        label.text = nil
        subtitleLabel.text = nil
    }
    
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel) {
        label.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "music.note.list"))
    }
    
}

