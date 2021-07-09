//
//  LibraryAlbumsViewController.swift
//  MySpotify
//
//  Created by iMac on 05.07.2021.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    private var albums = [Album]()
    
    private let noAlbumsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifire)
        
        
        tableView.isHidden = true
        return tableView
    }()
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        tableView.delegate   = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchData()
        })
        
        setUpNoAlbumsView()

               
        fetchData()

    }
    
    @objc func didTapClose() {
        dismiss(animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noAlbumsView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        tableView.snp.makeConstraints { (maker) in
            maker.leading.top.bottom.trailing.equalToSuperview()
        }
        
    }
    
    private func fetchData() {
        albums.removeAll()
        
        APICaller.shared.getCurrentUserAlbums { [weak self] result in

            DispatchQueue.main.async {

                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setUpNoAlbumsView() {
        
        noAlbumsView.delegate = self
        view.addSubview(noAlbumsView)
        
        noAlbumsView.configure(with:
                                    ActionLabelViewViewModel(
                                        text: "You have not saved any albums yet!",
                                        actionTitle: "Browse"))
    }
    
    
    private func updateUI() {
        
        if albums.isEmpty {
            //show label
            noAlbumsView.isHidden = false
            tableView.isHidden = true
            
        } else {
            //show table
            noAlbumsView.isHidden = true
            tableView.reloadData()
            tableView.isHidden = false
        }
    }

}



extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
            self.tabBarController?.selectedIndex = 0   
    }
}


extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifire,
            for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
        
        let album = albums[indexPath.row]
        
        cell.configure(with:
                        SearchResultSubtitleTableViewCellViewModel(
                            title: album.name,
                            subtitle: album.artists.first?.name ?? "-",
                            imageURL: URL(string: album.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let album = albums[indexPath.row]
        
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
