//
//  ActionLabelView.swift
//  MySpotify
//
//  Created by iMac on 07.07.2021.
//

import UIKit
import SnapKit

struct ActionLabelViewViewModel {
    
    let text: String
    let actionTitle: String
}

protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}

class ActionLabelView: UIView {
    
    weak var delegate: ActionLabelViewDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        clipsToBounds = true
        
        isHidden = true
        
        
        addSubview(label)
        addSubview(button)
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(40)
        }
        
        label.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalToSuperview().offset(-45)
        }
      
    }
    
    
    @objc func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }
    
    
    func configure(with viewModel: ActionLabelViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
    
    
    


}
