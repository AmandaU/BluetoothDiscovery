//
//  BluetoothViewController.swift
//  Bluetooth
//
//  Created by Amanda Baret on 2020/05/24.
//  Copyright © 2020 Amanda Baret. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController {
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bluetoothTable: UITableView!
    var centralManager: CBCentralManager!
    var gadgets: [Gadget] = [Gadget]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.scanForPeripherals(withServices: nil)
        bluetoothTable.dataSource = self
        bluetoothTable.delegate = self
        activityIndicator.startAnimating()
        
        _ = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: false, block: { timer in
            print("stop scanning for devices")
            self.activityIndicator.stopAnimating()
            self.centralManager.stopScan()
            self.bluetoothTable.reloadData()
        })
    }
}

extension BluetoothViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
      switch central.state {
      case .unknown:
        print("central.state is .unknown")
      case .resetting:
        print("central.state is .resetting")
      case .unsupported:
        print("central.state is .unsupported")
      case .unauthorized:
        print("central.state is .unauthorized")
      case .poweredOff:
        print("central.state is .poweredOff")
      case .poweredOn:
          print("central.state is .poweredOn")
          centralManager.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
      print(peripheral)
       
        if  gadgets.count < 50 && gadgets.first(where: {$0.peripheral.name  == peripheral.name}) == nil {
            
            var state: String = "unknown state"
            switch central.state {
            case .unknown:
             state = "state is unknown"
            case .resetting:
             state = "state is resetting"
            case .unsupported:
            state = "state is unsupported"
            case .unauthorized:
             state = "state is unauthorized"
            case .poweredOff:
             state = "state is poweredOff"
            case .poweredOn:
               state = "state is poweredOn"
              }
         
        gadgets.append(Gadget(name: peripheral.name ?? "unknown", description: state, peripheral: peripheral))
                print(gadgets.count)
        }
    }
}

extension BluetoothViewController: UITableViewDelegate {
}

extension BluetoothViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(gadgets.count)
        return gadgets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BluetoothCell",
                                                    for: indexPath) as? BluetoothCell {
            let model = gadgets[indexPath.row]
                  cell.setup(gadget: model)
            return cell
        }
       return UITableViewCell()
    }
}
