//
//  LibraryPlaylistsViewController.swift
//  MySpotify
//
//  Created by Alexander Germek on 05.07.2021.
//

import UIKit
import SnapKit

class LibraryPlaylistsViewController: UIViewController {
    
    private var playlists = [Playlist]()
    
    public var selectionHandler: ((Playlist) -> Void)? //для добавления трека в плэйлист
    
    private let noPlaylistsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifire)
        
        
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        setUpNoPlaylistsView()
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
               
        fetchData()

    }
    
    @objc func didTapClose() {
        dismiss(animated: true)
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noPlaylistsView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        tableView.snp.makeConstraints { (maker) in
            maker.leading.top.bottom.trailing.equalToSuperview()
        }
        
    }
    
    private func fetchData() {
        APICaller.shared.getCurrentUserPlaylists { [weak self] (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setUpNoPlaylistsView() {
        
        noPlaylistsView.delegate = self
        view.addSubview(noPlaylistsView)
        
        noPlaylistsView.configure(with:
                                    ActionLabelViewViewModel(
                                        text: "You don't have any playlists!",
                                        actionTitle: "Create"))
    }
    
    
    private func updateUI() {
        
        if playlists.isEmpty {
            //show label
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
            
        } else {
            //show table
            noPlaylistsView.isHidden = true
            tableView.reloadData()
            tableView.isHidden = false
        }
    }
    
    public func showCreatePlaylistAlert() {
        
        let alert = UIAlertController(title: "New Playlist",
                                      message: "Enter playlist name.",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "playlist name..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (_) in
            
            guard let field = alert.textFields?.first, let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            
            APICaller.shared.createPlaylist(with: text) { [weak self] (success) in
                
                if success {
                    //refeash list of playlists
                    HapticsManager.shared.vibrate(for: .success)
                    self?.fetchData()
                    
                } else {
                    HapticsManager.shared.vibrate(for: .error)
                    print("Failed to create playlist!")
                }
            }
        }))
        
        present(alert, animated: true)
    }
    
}



extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        //show creation UI
        showCreatePlaylistAlert()
    }
}


extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifire,
            for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
        
        let playlist = playlists[indexPath.row]
        
        cell.configure(with:
                        SearchResultSubtitleTableViewCellViewModel(
                            title: playlist.name,
                            subtitle: playlist.owner.display_name,
                            imageURL: URL(string: playlist.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let playlist = playlists[indexPath.row]
        
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true)
            return
        }
        
        
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
