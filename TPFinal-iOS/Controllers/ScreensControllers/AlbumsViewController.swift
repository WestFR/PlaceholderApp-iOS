//
//  AlbumsViewController.swift
//  TPFinal-iOS
//
//  Created by Steven F. on 07/06/2018.
//  Copyright © 2018 Steven F. All rights reserved.
//

import UIKit

class AlbumsViewController: UITableViewController, UISearchResultsUpdating, AlbumListProtocol, pullRefreshProtocol {
    
    // Loading Bar View XIB
    var loadingView = LoadingBarView()
    
    // Managers
    var mAlertManager = AlertsManager()
    var mDatasourceManager = DataSourceManager()
    
    // Datas
    var mAlbumList: Array<AlbumModel>!
    var mFilteredAlbumList : Array<AlbumModel>!
    
    // Segue Variables (in)
    var selectedUser: Int?
    var selectedUsername: String?
    
    // Segue Variables (out)
    var selectionIndex: Int?
    var selectedAlbum: Int?
    let photoAlbumIdentifier = "albumPhotoIdentifier"
    
    // Timers & Others
    var isOneDisplay = true
    var networkTimer : Timer?
    
    
    // MARK : - APP Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mDatasourceManager.albumListProtocol = self
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    // MARK : IBACTIONS
    @IBAction func moreBtn(_ sender: Any) {
        mAlertManager.showAboutActions()
    }
    
    
    // MARK : Custom Method
    func setupView() {
        // Setup Table & embedded views
        setupTable()
        setupPullRefresh()
        adjustLoading(loading: loadingView)
        showLoading(view: self.view, loading: loadingView)
        
        self.navigationItem.title = NSLocalizedString("albums", comment: "") + self.selectedUsername!
        
        // Search Controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search_albums", comment: "")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // NetworkTimer
        networkTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.checkNetwork), userInfo: nil, repeats: true)
        
        mDatasourceManager.getAlbums(forUser: self.selectedUser!)
    }
    
    func resetView(isExit: Bool) {
        if(mAlbumList?.isEmpty == false) {
            mAlbumList?.removeAll()
        }
        
        if(isExit) {
            navigationItem.searchController = nil
        }
        
        //removeEmptyMessage()
        emptyTableApplyData()
    }
    
    @objc func checkNetwork() {
        if(!NetworkManager().isConnectedToNetwork() && isOneDisplay) {
            AlertsManager().showNetworkAlert(message: NSLocalizedString("txt_missNetwork", comment: ""), view: view)
            isOneDisplay = false
        }
    }
    
    
    // MARK : - DataSource Methods
    func performAction(albumList : Array<AlbumModel>) {
        mAlbumList = albumList
        
        if(mAlbumList?.isEmpty == true) {
            emptyTableApplyData()
            //showEmptyMessage(localizedKeyString: "buildings_empty_list")
        } else {
            hasValueTableApplyData()
        }
        
        removeLoadingView(loadingView: loadingView, tableView: self.tableView)
        endRefresh()
    }
    
    func cancelAction() {
        emptyTableApplyData()
        removeLoadingView(loadingView: loadingView, tableView: self.tableView)
        //showEmptyMessage(localizedKeyString: "api_error_server")
        endRefresh()
    }
    
    
    // MARK : Pull To Refresh DataSource Methods
    func reloadData() {
        showLoading(view: self.view, loading: loadingView)
        resetView(isExit: false)
        mDatasourceManager.getAlbums(forUser: self.selectedUser!)
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return mFilteredAlbumList.count
        } else {
            if(mAlbumList != nil) {
                return mAlbumList.count
            } else {
                return 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumCell
        
        if(isFiltering()) {
            cell?.albumTitle.text = mFilteredAlbumList[indexPath.row].title
            cell?.albumID = mFilteredAlbumList[indexPath.row].id
            cell?.getPhotosGallery()
        } else {
            cell?.albumTitle.text = mAlbumList[indexPath.row].title
            cell?.albumID = mAlbumList[indexPath.row].id
            cell?.getPhotosGallery()
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isFiltering()) {
            self.selectedAlbum = mFilteredAlbumList[indexPath.row].id
        } else {
            self.selectedAlbum = mAlbumList[indexPath.row].id
        }
        self.selectionIndex = indexPath.row
        
        self.performSegue(withIdentifier: self.photoAlbumIdentifier, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    // MARK : SearchBar Controlelr Delegate Methods
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText (searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        return self.navigationItem.searchController?.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        mFilteredAlbumList = mAlbumList.filter({( album : AlbumModel) -> Bool in
            let doesCategoryMatch = (scope == "All") || (album.title == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return album.title.lowercased().contains(searchText.lowercased())
            }
        })
        
        self.tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return self.navigationItem.searchController?.isActive != nil ? (self.navigationItem.searchController?.isActive)! : false && !searchBarIsEmpty()
    }
    
    
    // MARK : - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc: AlbumPhotoViewController = segue.destination as? AlbumPhotoViewController {
            if segue.identifier == self.photoAlbumIdentifier {
                vc.selectedAlbum = self.selectedAlbum
                vc.selectedAlbumName = mAlbumList[self.selectionIndex!].title
            }
        }
    }
}

class AlbumCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, AlbumPhotoProtocol {
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumPhotoGallery: UICollectionView!
    
    var albumID: Int?
    
    // Datas
    var mDatasourceManager = DataSourceManager()
    var mPhotoList: Array<PhotoModel>!
    
    override func awakeFromNib() {
        albumTitle.numberOfLines = 0
        albumTitle.lineBreakMode = .byWordWrapping
        albumTitle.sizeToFit()
    
        albumPhotoGallery.delegate = self
        albumPhotoGallery.dataSource = self
        
        mDatasourceManager.albumPhotoProtocol = self
    }
    
    
    // MARK : - Custom Methods
    func getPhotosGallery() {
        mDatasourceManager.getPhotos(forAlbum: albumID!)
    }
    
    // MARK : - DataSource Methods
    func performAction(albumPhotoList : Array<PhotoModel>) {
        mPhotoList = albumPhotoList
        
        if(mPhotoList?.isEmpty == false) {
            albumPhotoGallery.reloadData()
        }
    }
    
    func cancelAction() {
    }
    
    // MARK: - Collection view data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(mPhotoList != nil) {
            return mPhotoList.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoGalleryCell", for: indexPath) as? PhotoGalleryCell
        
        let fileUrl = URL(string: mPhotoList[indexPath.row].thumbnailURL)
        cell?.photoImage.af_setImage(
            withURL: fileUrl!,
            placeholderImage: nil,
            filter: nil,
            progress: nil,
            imageTransition: .crossDissolve(0),
            runImageTransitionIfCached: false,
            completion: { response in
                cell?.photoImage.image = response.result.value
        })
        
        return cell!
    }
}

class PhotoGalleryCell: UICollectionViewCell {
    @IBOutlet weak var photoImage: UIImageView!
}


