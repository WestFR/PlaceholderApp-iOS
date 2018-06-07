//
//  AlbumPhotoViewController.swift
//  TPFinal-iOS
//
//  Created by Steven F. on 07/06/2018.
//  Copyright © 2018 Steven F. All rights reserved.
//

import UIKit
import CollectionViewSlantedLayout

class AlbumPhotoViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AlbumPhotoProtocol, pullRefreshProtocol, CollectionViewDelegateSlantedLayout {

    // Loading Bar View XIB
    var loadingView = LoadingBarView()
    
    // Managers
    var mAlertManager = AlertsManager()
    var mDatasourceManager = DataSourceManager()
    
    // Datas
    var mAlbumPhoto: Array<PhotoModel>!
    
    // Segue Variables (in)
    var selectedAlbum: Int?
    
    // Segue Variables (inout)
    var selectedAlbumName: String?

    // Segue Variables (out)
    var selectedPhoto: PhotoModel?
    let onePhotoIdentifier = "onePhotoIdentifier"
    
    // Timers & Others
    var isOneDisplay = true
    var networkTimer : Timer?
    
    @IBOutlet weak var mCollectionViewLayout: CollectionViewSlantedLayout!
    
    // MARK : - APP Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mDatasourceManager.albumPhotoProtocol = self
        setupView()
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
        adjustLoadingFromZero(loading: loadingView)
        showLoading(view: self.view, loading: loadingView)
    
        self.navigationItem.title = NSLocalizedString("albums", comment: "") + self.selectedAlbumName!
        
        // CollectionViewLayout
        mCollectionViewLayout.isFirstCellExcluded = true
        mCollectionViewLayout.isLastCellExcluded = true
        mCollectionViewLayout.lineSpacing = 0
        
        // NetworkTimer
        networkTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.checkNetwork), userInfo: nil, repeats: true)
        
        mDatasourceManager.getPhotos(forAlbum: self.selectedAlbum!)
    }

    func resetView(isExit: Bool) {
        if(mAlbumPhoto?.isEmpty == false) {
            mAlbumPhoto?.removeAll()
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
    func performAction(albumPhotoList : Array<PhotoModel>) {
        mAlbumPhoto = albumPhotoList
        
        if(mAlbumPhoto?.isEmpty == true) {
            emptyTableApplyData()
            //showEmptyMessage(localizedKeyString: "buildings_empty_list")
        } else {
            hasValueTableApplyData()
        }
        
        removeLoadingView(loadingView: loadingView)
        endRefresh()
    }
    
    func cancelAction() {
        emptyTableApplyData()
        removeLoadingView(loadingView: loadingView)
        //showEmptyMessage(localizedKeyString: "api_error_server")
        endRefresh()
    }
    
    
    // MARK : Pull To Refresh DataSource Methods
    func reloadData() {
        showLoading(view: self.view, loading: loadingView)
        resetView(isExit: false)
        mDatasourceManager.getPhotos(forAlbum: self.selectedAlbum!)
    }

    
    // MARK: - CollectionView data source
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(mAlbumPhoto != nil) {
            return mAlbumPhoto.count
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell
        
        let fileUrl = URL(string: mAlbumPhoto[indexPath.row].url)
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPhoto = mAlbumPhoto[indexPath.row]
        self.performSegue(withIdentifier: self.onePhotoIdentifier, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewSlantedLayout, sizeForItemAt indexPath: IndexPath) -> CGFloat {
        return collectionViewLayout.scrollDirection == .vertical ? self.view.frame.size.width : self.view.frame.size.height
    }
    
    // MARK : - SCROLL DELEGATE

    
    // MARK : - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc: PhotoViewController = segue.destination as? PhotoViewController {
            if segue.identifier == self.onePhotoIdentifier {
                vc.selectedPhoto = self.selectedPhoto
                vc.selectedAlbumName = self.selectedAlbumName
            }
        }
    }
}

class PhotoCell: CollectionViewSlantedCell {
    @IBOutlet weak var photoImage: UIImageView!
}
