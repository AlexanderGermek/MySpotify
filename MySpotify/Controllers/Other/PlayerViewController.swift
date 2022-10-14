//
//  PlayerViewController.swift
//  MySpotify
//
//  Created by Alexander Germek on 15.05.2021.
//

import UIKit
import SnapKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        configureBarButtons()
        
        controlsView.delegate = self
        
        configure()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview().offset(view.safeAreaInsets.top)
            maker.height.width.equalTo(view.width)
        }
        
        controlsView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(10)
            maker.top.equalTo(imageView.snp.bottom).offset(10)
            maker.width.equalTo(view.width - 20)
            maker.bottom.equalTo(view.snp.bottomMargin).offset(15)
        }
    }
    
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL)
        controlsView.configure(with:
                                PlayerControlsViewViewModel(
                                    title: dataSource?.songName, subtitle: dataSource?.subtitle))
    }
    
    private func configureBarButtons() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self, action: #selector(didTapClose))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self, action: #selector(didTapAction))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction() {
       //do smth
    }
    
    func refreshUI() {
        configure()
    }
    
}


extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func playerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
    
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideVolumeSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    
}
