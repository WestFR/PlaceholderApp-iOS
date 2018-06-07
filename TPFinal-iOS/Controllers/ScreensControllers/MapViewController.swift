//
//  MapViewController.swift
//  TPFinal-iOS
//
//  Created by Steven F. on 07/06/2018.
//  Copyright © 2018 Steven F. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UsersListProtocol {

    // Loading Bar View XIB
    var loadingView = LoadingBarView()
    
    // Managers
    var mAlertManager = AlertsManager()
    var mDatasourceManager = DataSourceManager()
    
    // Datas
    var mUserList: Array<UserModel>!
    
    // Segue Variables
    var selectionIndex: Int?
    var selectedUser = 0
    let albumsIdentifier = "albumsSegue"
    
    // LocationManager
    let mManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 10000000
    
    // Timers & Others
    var isOneDisplay = true
    var networkTimer : Timer?
    
    // IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK : - APP Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mDatasourceManager.userListProtocol = self
        setupView()
    }
    
    
    // MARK : IBACTIONS
    @IBAction func moreBtn(_ sender: Any) {
        mAlertManager.showAboutActions()
    }
    
    
    // MARK : CUSTOM Methods
    func setupView() {
        // Add GPS delegate
        mManager.delegate = self
        mManager.desiredAccuracy = kCLLocationAccuracyBest
        //enableLocationServices()
        
        // Add Maps delegate
        mapView.delegate = self
        
        showLoading(view: self.view, loading: loadingView)
        
        // NetworkTimer
        networkTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.checkNetwork), userInfo: nil, repeats: true)
    
        mDatasourceManager.getUsers()
    }
    
    func resetView() {
        //removeEmptyMessage()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        removeLoadingView(loadingView: loadingView)
    }
    
    func addMapAnnotation(location2D: CLLocationCoordinate2D, title: String, subtitle: String) {
        let point = MKPointAnnotation()
        point.coordinate = location2D
        point.title = title
        point.subtitle = subtitle
        
        mapView.addAnnotation(point)
    }
    
    @objc func checkNetwork() {
        if(!NetworkManager().isConnectedToNetwork() && isOneDisplay) {
            AlertsManager().showNetworkAlert(message: NSLocalizedString("txt_missNetwork", comment: ""), view: view)
            isOneDisplay = false
        }
    }
    
    
    // MARK : - DataSource Methods
    func performAction(userList: Array<UserModel>) {
        mUserList = userList
        
        if mUserList.isEmpty == false {
            for user in mUserList {
                let latitude = Double((user.address?.geo?.lat)!)
                let longitude = Double((user.address?.geo?.lng)!)
                
                let location2D =  CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                addMapAnnotation(location2D: location2D, title: user.name!, subtitle: user.phone!)
            }
        }

        let latitude = CLLocationDegrees(Double((userList[0].address?.geo?.lat)!)!)
        let longitude = CLLocationDegrees(Double((userList[0].address?.geo?.lng)!)!)
        let location2D = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: location2D)
    }
    
    func cancelAction() {
        removeLoadingView(loadingView: loadingView)
        //showEmptyMessage(localizedKeyString: "api_error_server")
    }
    
    
    // MARK : - CLLocation Delegates
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectionIndex = Int(mUserList.index(where: { $0.name == view.annotation?.title })!)
        self.selectedUser = mUserList[selectionIndex!].id!
        
        mAlertManager.showMapConfirmation(title: NSLocalizedString("txt_mapTitle", comment: ""),
                                          message: NSLocalizedString("txt_mapPage", comment: ""), closure: {
            self.performSegue(withIdentifier: self.albumsIdentifier, sender: self)
        })
    }
    
    
    // MARK : - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc: AlbumsViewController = segue.destination as? AlbumsViewController {
            if segue.identifier == self.albumsIdentifier {
                vc.selectedUser = self.selectedUser
                vc.selectedUsername = self.mUserList[self.selectionIndex!].name
            }
        }
    }
}
