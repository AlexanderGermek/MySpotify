//
//  SettingsViewController.swift
//  MySpotify
//
//  Created by Alexander Germek on 15.05.2021.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private var sections = [Section]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configureModels()
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureModels() {
        sections.append(Section(title: "Profile", options: [Option(title: "View Your Profile", handler: {
            [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        
        sections.append(Section(title: "Account", options: [Option(title: "Sign Out", handler: {
            [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
        })]))
    }
    
    private func viewProfile() {
        let vc = ProfileViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signOutTapped() {
        
        let alert = UIAlertController(title: "Sign Out",
                                      message: "Are you sure?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
           
            AuthManager.shared.signOut { (success) in
                if success {
                    DispatchQueue.main.async {
                        
                        let navVC = UINavigationController(rootViewController: WelcomeViewController())
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        navVC.modalPresentationStyle = .fullScreen
                        
                        
                        self?.present(navVC, animated: true)
                    }
                }
            }
        }))
        
        present(alert, animated: true)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    

    //MARK: - UITableViewDataSource, UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //call handler for cell
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
        
    }
}
