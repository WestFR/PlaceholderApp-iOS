//
//  DataSourceProtocol.swift
//  TPFinal-iOS
//
//  Created by Steven F. on 07/06/2018.
//  Copyright © 2018 Steven F. All rights reserved.
//

import UIKit

protocol UsersListProtocol {
    func performAction(userList : Array<UserModel>)
    func cancelAction()
}

protocol AlbumListProtocol {
    func performAction(albumList : Array<AlbumModel>)
    func cancelAction()
}

protocol AlbumPhotoProtocol {
    func performAction(albumPhotoList : Array<PhotoModel>)
    func cancelAction()
}
