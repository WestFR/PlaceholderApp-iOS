//
//  LoginLogoutManager.swift
//  TPFinal-iOS
//
//  Created by Steven F. on 07/06/2018.
//  Copyright © 2018 Steven F. All rights reserved.
//

import UIKit

extension UIView {
    
    /*func performLogin() {
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVCAfterLoginScreen") as! DrawerViewController
        UIApplication.shared.keyWindow?.rootViewController = rootVC
    }
    
    func performLogout() {
        Preferences().resetData()
        let rootVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "navLoginVC") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = rootVC
    }*/
    
    func performRestart() {
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "startController") as! TabBarViewController
        UIApplication.shared.keyWindow?.rootViewController = rootVC
    }
}
