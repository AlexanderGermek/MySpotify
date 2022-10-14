//
//  PlayerControlsView.swift
//  MySpotify
//
//  Created by Alexander Germek on 04.07.2021.
//

import UIKit
import SnapKit

protocol PlayerControlsViewDelegate: AnyObject {
    
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView : PlayerControlsView)
    func playerControlsViewDidTapForwardButton(_ playerControlsView : PlayerControlsView)
    func playerControlsViewDidTapBackwardsButton(_ playerControlsView : PlayerControlsView)
    func playerControlsView(_ playerControlsView : PlayerControlsView, didSlideVolumeSlider value: Float)
}

struct PlayerControlsViewViewModel {
    let title: String?
    let subtitle: String?
}

final class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private var isPlaying = true
     
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.4
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "name"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "subtitle"
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSliderVolumeSlider), for: .valueChanged)
        
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(50)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.width.equalTo(width)
            make.height.equalTo(50)
        }
        
        volumeSlider.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.width.equalTo(width - 20)
            make.height.equalTo(44)
        }
        
        let buttonSize = CGFloat(60)
        
        playPauseButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset((width - buttonSize) / 2)
            make.top.equalTo(volumeSlider.snp.bottom).offset(30)
            make.width.height.equalTo(buttonSize)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(playPauseButton.snp.leading).offset(-80)
            make.top.equalTo(playPauseButton.snp.top)
            make.width.height.equalTo(buttonSize)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.leading.equalTo(playPauseButton.snp.trailing).offset(80)
            make.top.equalTo(playPauseButton.snp.top)
            make.width.height.equalTo(buttonSize)
        }
         
    }
    
    public func configure(with viewModel: PlayerControlsViewViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
    
    //MARK: - Actions
    @objc private func didTapBack() {
        delegate?.playerControlsViewDidTapBackwardsButton(self)
    }
    
    @objc private func didTapNext() {
        delegate?.playerControlsViewDidTapForwardButton(self)
    }
    
    @objc private func didTapPlayPause() {
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
        
        //Update icon
        let buttonName = isPlaying ? "pause.fill" : "play.fill"
        let image = UIImage(systemName: buttonName,
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        playPauseButton.setImage(image , for: .normal)
    }
    
    @objc private func didSliderVolumeSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideVolumeSlider: value)
    }
}
