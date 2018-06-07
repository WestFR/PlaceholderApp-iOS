//
//  PhotoViewController.swift
//  TPFinal-iOS
//
//  Created by Steven F. on 07/06/2018.
//  Copyright © 2018 Steven F. All rights reserved.
//

import UIKit

class PhotoViewController: UITableViewController {
    
    // Loading Bar View XIB
    var loadingView = LoadingBarView()
    
    // Managers
    var mAlertManager = AlertsManager()
    
    // Segue Variables
    var selectedPhoto: PhotoModel?
    var selectedAlbumName: String?
    
    // Timers & Others
    var isOneDisplay = true
    var networkTimer : Timer?
    
    
    // MARK : - APP Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        adjustLoadingFromZero(loading: loadingView)
        showLoading(view: self.view, loading: loadingView)
        
        self.navigationItem.title = NSLocalizedString("photos", comment: "") + String(describing: (selectedPhoto?.id)!)
        
        // NetworkTimer
        networkTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.checkNetwork), userInfo: nil, repeats: true)
        
        hasSingleValueTableApply()
        removeLoadingView(loadingView: loadingView, tableView: self.tableView)
    }
    
    @objc func checkNetwork() {
        if(!NetworkManager().isConnectedToNetwork() && isOneDisplay) {
            AlertsManager().showNetworkAlert(message: NSLocalizedString("txt_missNetwork", comment: ""), view: view)
            isOneDisplay = false
        }
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onePhotoCell", for: indexPath) as? OnePhotoCell
        
        cell?.photoTitle.text = selectedPhoto?.title
        
        let fileUrl = URL(string: (selectedPhoto?.url)!)
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
        
        cell?.photoAlbum.text = NSLocalizedString("txt_albumName", comment: "") + String(describing: (selectedAlbumName)!)
        
        return cell!
    }

}

class OnePhotoCell: UITableViewCell {
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoAlbum: UILabel!
    
    override func awakeFromNib() {
        photoTitle.numberOfLines = 0
        photoTitle.lineBreakMode = .byWordWrapping
        photoTitle.sizeToFit()
        
        photoAlbum.numberOfLines = 0
        photoAlbum.lineBreakMode = .byWordWrapping
        photoAlbum.sizeToFit()
    }
    
}
