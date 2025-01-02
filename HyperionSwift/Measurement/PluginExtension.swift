//
//  PluginExtension.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 02/01/25.
//

import Foundation
import UIKit

protocol PluginExtension: AnyObject {
    var attachedWindow: UIWindow? { get }
}
