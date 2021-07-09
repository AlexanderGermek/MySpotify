//
//  CategoryCollectionViewCell.swift
//  MySpotify
//
//  Created by iMac on 03.07.2021.
//

import UIKit
import SnapKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "CategoryCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let colors: [UIColor] = [.systemPink, .systemBlue, .systemPurple,
                                 .systemOrange, .systemGreen, .systemRed,
                                 .systemYellow, .systemTeal, .darkGray]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(contentView.width/2)
            maker.top.equalTo(10)
            maker.width.equalTo(contentView.width/2)
            maker.height.equalTo(contentView.height/2)
        }
        
        label.snp.makeConstraints { (maker) in
            maker.leading.equalTo(10)
            maker.top.equalTo(contentView.height / 2)
            maker.width.equalTo(contentView.width - 20)
            maker.height.equalTo(contentView.height / 2)
        }
    }
    
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel) {
        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL)
        contentView.backgroundColor = colors.randomElement()
    }
}
