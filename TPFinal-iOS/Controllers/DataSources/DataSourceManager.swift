//
//  DataSourceManager.swift
//  TPFinal-iOS
//
//  Created by Steven F. on 07/06/2018.
//  Copyright © 2018 Steven F. All rights reserved.
//

import UIKit

class DataSourceManager {
    
    // Managers
    let mAlertManager = AlertsManager()
    
    // DataSources protocol
    var userListProtocol: UsersListProtocol?
    var albumListProtocol: AlbumListProtocol?
    var albumPhotoProtocol: AlbumPhotoProtocol?
    
    // API PATHS
    let BASE_URL = "http://jsonplaceholder.typicode.com/"
    
    // USERS LIST
    let USERS_PATH = "users"
    
    // ALBUMS LIST
    let ALBUMS_PATH = "albums"
    
    // ALBUM PHOTOS LIST
    let ALBUM_PATH = "photos?albumId={albumID}"
}
