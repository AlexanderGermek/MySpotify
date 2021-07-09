//
//  TitleHeaderCollectionReusableView.swift
//  MySpotify
//
//  Created by iMac on 02.07.2021.
//

import UIKit
import SnapKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifire = "TitleHeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(15)
            maker.top.equalToSuperview()
            maker.width.equalToSuperview().offset(-30)
            maker.height.equalToSuperview()
        }
        
    }
    
    func configure(with title: String) {
        label.text = title
        
    }
}
