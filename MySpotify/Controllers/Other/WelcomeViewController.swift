//
//  WelcomeViewController.swift
//  MySpotify
//
//  Created by iMac on 15.05.2021.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "albums_background")
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Millions\nof Songs on\nthe go!"
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        view.addSubview(overlayView)
        
        
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSighIn), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(logoImageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signInButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(50)
            maker.width.equalTo(view.width - 40)
            maker.height.equalTo(50)
        }
        
        imageView.snp.makeConstraints { (maker) in
            maker.leading.top.trailing.bottom.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { (maker) in
            maker.leading.top.trailing.bottom.equalToSuperview()
        }
        
        label.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(30)
            maker.top.equalTo(logoImageView.snp.bottom).offset(30)
            maker.width.equalTo(view.width - 60)
            maker.height.equalTo(150)
        }
        
        logoImageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset((view.width-120) / 2)
            maker.top.equalToSuperview().offset((view.height-350) / 2)
            maker.width.height.equalTo(120)
        }
    }
    
    
    @objc func didTapSighIn() {
        let vc = AuthViewController()
        
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        //log in or error
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when signing in.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
}
