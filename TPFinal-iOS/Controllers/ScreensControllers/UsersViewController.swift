//
//  UsersViewController.swift
//  TPFinal-iOS
//
//  Created by Steven F. on 07/06/2018.
//  Copyright © 2018 Steven F. All rights reserved.
//

import UIKit

class UsersViewController: UITableViewController, UISearchResultsUpdating, UsersListProtocol, pullRefreshProtocol {
    
    // Loading Bar View XIB
    var loadingView = LoadingBarView()
    
    // Managers
    var mAlertManager = AlertsManager()
    var mDatasourceManager = DataSourceManager()
    
    // Datas
    var mUserList: Array<UserModel>!
    var mFilteredUserList : Array<UserModel>!

    // Segue Variables
    var selectionIndex: Int?
    var selectedUser = 0
    let albumsIdentifier = "albumsSegue"
    
    // Timers & Others
    var isOneDisplay = true
    var networkTimer : Timer?

    
    // MARK : - APP Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mDatasourceManager.userListProtocol = self
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.networkTimer?.invalidate()
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
        
        // Search Controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search_user", comment: "")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // NetworkTimer
        networkTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.checkNetwork), userInfo: nil, repeats: true)
        
        mDatasourceManager.getUsers()
    }
    
    func resetView(isExit: Bool) {
        if(mUserList?.isEmpty == false) {
            mUserList?.removeAll()
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
    func performAction(userList : Array<UserModel>) {
        mUserList = userList
        
        if(mUserList?.isEmpty == true) {
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
        mDatasourceManager.getUsers()
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return mFilteredUserList.count
        } else {
            if(mUserList != nil) {
                return mUserList.count
            } else {
                return 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell
        
        if(isFiltering()) {
            cell?.username.text = mFilteredUserList[indexPath.row].name
            cell?.pseudo.text = mFilteredUserList[indexPath.row].username
            cell?.companyName.text = NSLocalizedString("txt_company", comment: "") + (mFilteredUserList[indexPath.row].company?.name)!
        } else {
            cell?.username.text = mUserList[indexPath.row].name
            cell?.pseudo.text = mUserList[indexPath.row].username
            cell?.companyName.text = NSLocalizedString("txt_company", comment: "") + (mUserList[indexPath.row].company?.name)!
        }
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isFiltering()) {
            self.selectedUser = mFilteredUserList[indexPath.row].id!
        } else {
            self.selectedUser = mUserList[indexPath.row].id!
        }
        self.selectionIndex = indexPath.row
        
        self.performSegue(withIdentifier: self.albumsIdentifier, sender: self)
    }
    
    
    // MARK : SearchBar Controlelr Delegate Methods
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText (searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        return self.navigationItem.searchController?.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        mFilteredUserList = mUserList.filter({( user : UserModel) -> Bool in
            let researchString = user.name! + user.username! + (user.company?.name)!
            let doesCategoryMatch = (scope == "All") || (researchString == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
            return researchString.lowercased().contains(searchText.lowercased())
            }
        })
        
        self.tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return (self.navigationItem.searchController?.isActive)! && !searchBarIsEmpty()
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

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var pseudo: UILabel!
    @IBOutlet weak var companyName: UILabel!
    
}
