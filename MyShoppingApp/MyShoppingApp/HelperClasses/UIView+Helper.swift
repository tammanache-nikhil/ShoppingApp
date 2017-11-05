//
//  UIView+Helper.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 06/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import Foundation
import UIKit

extension UIView {    
    var height: CGFloat { return self.bounds.height }
    var width: CGFloat { return self.bounds.width }
    var x: CGFloat { return self.frame.origin.x }
    var y: CGFloat { return self.frame.origin.y }
}
