//
//  UIViewController-Ext.swift
//  COVID-19Helper
//
//  Created by Sushree Swagatika on 23/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func push(newVC: UIViewController.Type) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showVC = storyboard.instantiateViewController(withIdentifier: "\(newVC)")
        self.navigationController?.pushViewController(showVC, animated: true)
    }
}

