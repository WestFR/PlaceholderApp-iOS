//
//  DataSourceActions.swift
//  TPFinal-iOS
//
//  Created by Steven F. on 07/06/2018.
//  Copyright © 2018 Steven F. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

extension DataSourceManager {
    
    
    // **
    // ** MARK : GET USERS
    // **
    func getUsers() {
        let URL = BASE_URL + USERS_PATH
        
        Alamofire.request(URL)
            .responseData { response in
                
                // get JSON return status
                if let status = response.response?.statusCode {
                    
                    switch(status) {
                        
                    case 200:
                        // 200
                        let mUsersList = try? JSONDecoder().decode(Array<UserModel>.self, from: response.result.value!)
                        self.userListProtocol?.performAction(userList: mUsersList!)
                    default:
                        self.userListProtocol?.cancelAction()
                        break
                    }
                }
        }
    }
    
    
    // **
    // ** MARK : GET ALBUMS FOR SELECTED USER
    // **
    func getAlbums(forUser: Int) {
        let URL = BASE_URL + ALBUMS_PATH
        
        Alamofire.request(URL)
            .responseData { response in
                
                // get JSON return status
                if let status = response.response?.statusCode {
                    
                    switch(status) {
                        
                    case 200:
                        // 200
                        var mAlbumsList = try? JSONDecoder().decode(Array<AlbumModel>.self, from: response.result.value!)
                        mAlbumsList = mAlbumsList?.filter({ $0.userId == forUser}) // Filter list only for selected user
                        self.albumListProtocol?.performAction(albumList: mAlbumsList!)
                    default:
                        self.albumListProtocol?.cancelAction()
                        break
                    }
                }
        }
    }
    
    
    // **
    // ** MARK : GET PHOTOS FOR SELECTED ALBUM
    // **
    func getPhotos(forAlbum: Int) {
        var GET_PHOTOS = ALBUM_PATH
        GET_PHOTOS = GET_PHOTOS.replacingOccurrences(of: "{albumID}", with: String.init(describing: forAlbum))
        
        let URL = BASE_URL + GET_PHOTOS
        
        Alamofire.request(URL)
            .responseData { response in
                
                // get JSON return status
                if let status = response.response?.statusCode {
                    
                    switch(status) {
                        
                    case 200:
                        // 200
                        let mPhotosList = try? JSONDecoder().decode(Array<PhotoModel>.self, from: response.result.value!)
                        self.albumPhotoProtocol?.performAction(albumPhotoList: mPhotosList!)
                    default:
                        self.albumPhotoProtocol?.cancelAction()
                        break
                    }
                }
        }
    }
}
