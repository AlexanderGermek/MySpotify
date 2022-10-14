//
//  SearchResultDefaultTableViewCell.swift
//  MySpotify
//
//  Created by Alexander Germek on 03.07.2021.
//

import UIKit
import SnapKit
import SDWebImage

class SearchResultDefaultTableViewCell: UITableViewCell {
    
    static let identifire = "SearchResultDefaultTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
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
        
        iconImageView.layer.cornerRadius = imageSize / 2
        iconImageView.layer.masksToBounds = true
        
        label.snp.makeConstraints { (maker) in
            maker.leading.equalTo(iconImageView.snp.trailing).offset(10)
            maker.top.trailing.equalToSuperview()
            maker.height.equalTo(imageSize)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        label.text = nil
    }
    
    
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel) {
        label.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.artworkURL)
    }
    
}
