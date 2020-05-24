//
//  Gadget.swift
//  BLEDiscovery
//
//  Created by Amanda Baret on 2020/05/24.
//  Copyright © 2020 Amanda Baret. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Gadget {
    var name: String
    var description: String
    var peripheral: CBPeripheral
}
