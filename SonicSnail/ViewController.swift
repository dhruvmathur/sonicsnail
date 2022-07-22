//
//  ViewController.swift
//  SonicSnail
//
//  Created by Dhruv Mathur on 2022-07-08.
//

import UIKit
import SceneKit
import SpriteKit
import CoreBluetooth

class ViewController: UIViewController {
    
    @IBOutlet weak var `switch`: UISwitch!
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    
    var transferCharacteristic: CBMutableCharacteristic?
    var connectedCentral: CBCentral?
    private var service: CBUUID!
    private let value = "AD34E"
    
    var myChar1: CBMutableCharacteristic?

    
    static var sendingEOM = false
    var dataToSend = Data()
    var sendDataIndex: Int = 0
    let mockData: String = "kodakshere"


    var kodakKFC: CBPeripheral!
    var sceneView: SKView!
    
    @IBAction func switchFlipped(_ sender: Any) {
        if `switch`.isOn {
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [TransferService.characteristicUUID]])
        } else {
            peripheralManager.stopAdvertising()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
//
        // Do any additional setup after loading the view.
        sceneView = SKView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view = sceneView
        
        if let view = self.view as! SKView? {
            print("gamescene")
            let scene = GameScene()
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            print("calling setupAudioNode")
            scene.setupAudioNode()
        }
    }


//extension ViewController: CBCentralManagerDelegate {
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("Connected!")
//        peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey: "succing"])
//
//    }
//
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//            switch central.state {
//              case .unknown:
//                print("central.state is .unknown")
//              case .resetting:
//                print("central.state is .resetting")
//              case .unsupported:
//                print("central.state is .unsupported")
//              case .unauthorized:
//                print("central.state is .unauthorized")
//              case .poweredOff:
//                print("central.state is .poweredOff")
//              case .poweredOn:
//                print("central.state is .poweredOn")
//                centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
//            }
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
//                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
//        if let name = peripheral.name {
//            if name.contains("Your") {
//                print("KDOAKKKKK")
//                kodakKFC = peripheral
//                centralManager.stopScan()
//                centralManager.connect(kodakKFC)
//            }
//        }
//        print(peripheral)
//    }
    
    func addServices() {
        let valueData = value.data(using: .utf8)
         // 1. Create instance of CBMutableCharcateristic
        myChar1 = CBMutableCharacteristic(type: CBUUID(nsuuid: UUID(uuidString: "26FD51F6-89F4-4D6C-AE15-F13C42DD519A")!), properties: [.notify, .write, .read], value: nil, permissions: [.readable, .writeable])
        let descriptor = CBMutableDescriptor(type: CBUUID(string: CBUUIDCharacteristicUserDescriptionString), value: "BLESensor prototype")
        myChar1?.descriptors = [descriptor]
        // 2. Create instance of CBMutableService
        service = CBUUID(nsuuid: UUID(uuidString: "F88EAC6C-0CDC-4A91-B360-8BB44EFD4597")!)
        print(service.uuidString)
        let myService = CBMutableService(type: service, primary: true)
        // 3. Add characteristics to the service
        myService.characteristics = [myChar1!]
        // 4. Add service to peripheralManager
        peripheralManager.add(myService)
        // 5. Start advertising
        startAdvertising()
    }
    
    func startAdvertising() {
        peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey : "blueboy", CBAdvertisementDataServiceUUIDsKey :     [service]])
        print("Started Advertising")
    }
}

    


extension ViewController: CBPeripheralDelegate, CBPeripheralManagerDelegate {
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("saidjaosda")
        var requesty: CBATTRequest = requests[0]
        let returnData = String(data: requesty.value!, encoding: .utf8)
        print(returnData)
    }

    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("ASIDJAIOSJD")
//        messageLabel.text = "Data getting Read"
//        readValueLabel.text = value
        // Perform your additional operations here
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        print("testingtesting")
        guard let data = characteristic.value else {
            // no data transmitted, handle if needed
            return
        }
    }


//
    // implementations of the CBPeripheralManagerDelegate methods

    /*
     *  Required protocol method.  A full app should take care of all the possible states,
     *  but we're just waiting for to know when the CBPeripheralManager is ready
     *
     *  Starting from iOS 13.0, if the state is CBManagerStateUnauthorized, you
     *  are also required to check for the authorization state of the peripheral to ensure that
     *  your app is allowed to use bluetooth
     */
    internal func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {

        if let `switch` = `switch` {
            `switch`.isEnabled = peripheral.state == .poweredOn
        }

        switch peripheral.state {
        case .poweredOn:
            // ... so start working with the peripheral
            print("CBManager is powered on")
            addServices()
//            setupPeripheral()
        case .poweredOff:
            print("CBManager is not powered on")
            // In a real app, you'd deal with all the states accordingly
            return
        case .resetting:
            print("CBManager is resetting")
            // In a real app, you'd deal with all the states accordingly
            return
        case .unauthorized:
            // In a real app, you'd deal with all the states accordingly
            if #available(iOS 13.0, *) {
                switch peripheral.authorization {
                case .denied:
                    print("You are not authorized to use Bluetooth")
                case .restricted:
                    print("Bluetooth is restricted")
                default:
                    print("Unexpected authorization")
                }
            } else {
                // Fallback on earlier versions
            }
            return
        case .unknown:
            print("CBManager state is unknown")
            // In a real app, you'd deal with all the states accordingly
            return
        case .unsupported:
            print("Bluetooth is not supported on this device")
            // In a real app, you'd deal with all the states accordingly
            return
        @unknown default:
            print("A previously unknown peripheral manager state occurred")
            // In a real app, you'd deal with yet unknown cases that might occur in the future
            return
        }
    }

}
