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

    
//    func discoverDescriptors(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
//        peripheral.discoverDescriptors(for: characteristic)
//    }
//
//    // In CBPeripheralDelegate class/extension
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//        guard let descriptors = characteristic.descriptors else { return }
//
//        // Get user description descriptor
//        if let userDescriptionDescriptor = descriptors.first(where: {
//            return $0.uuid.uuidString == CBUUIDCharacteristicUserDescriptionString
//        }) {
//            // Read user description for characteristic
//            peripheral.readValue(for: userDescriptionDescriptor)
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
//        // Get and print user description for a given characteristic
//        if descriptor.uuid.uuidString == CBUUIDCharacteristicUserDescriptionString,
//            let userDescription = descriptor.value as? String {
//            print("Characterstic \(descriptor.characteristic?.uuid.uuidString) is also known as \(userDescription)")
//        }
//    }


        
//    private func setupPeripheral() {
//
//        // Build our service.
//
//        // Start with the CBMutableCharacteristic.
//        let transferCharacteristic = CBMutableCharacteristic(type: TransferService.characteristicUUID,
//                                                         properties: [.notify, .writeWithoutResponse],
//                                                         value: nil,
//                                                         permissions: [.readable, .writeable])
//
//        // Create a service from the characteristic.
//        let transferService = CBMutableService(type: TransferService.serviceUUID, primary: true)
//
//        // Add the characteristic to the service.
//        transferService.characteristics = [transferCharacteristic]
//
//        // And add it to the peripheral manager.
//        peripheralManager.add(transferService)
//
//        // Save the characteristic for later.
//        self.transferCharacteristic = transferCharacteristic
//
//    }


extension ViewController: CBPeripheralDelegate, CBPeripheralManagerDelegate {
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("saidjaosda")
    }
    
//    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
//        print("Writing Data")
//        if let value = requests.first?.value {
//            print(requests.first?.value)
////            print(value.hexEncodedString())
//            //Perform here your additional operations on the data.
//        }
//    }
//
//    func peripheralManager(
//        _ peripheral: CBPeripheralManager,
//        didReceiveWriteRequest requests: [CBATTRequest]
//    )  {
//        print("didReceiveWriteRequest")
//    }
//


    
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
//        if characteristic.uuid == batteryLevelUUID {
//            // Decode data and map it to your model object
//        }
    }


//
//    func discoverServices(peripheral: CBPeripheral) {
//        print(" discoverServices(peripheral")
//        peripheral.discoverServices(nil)
//    }
//
//    // Call after discovering services
//    func discoverCharacteristics(peripheral: CBPeripheral) {
//        print(" discoverCharacteristics")
//        guard let services = peripheral.services else {
//            return
//        }
//        for service in services {
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        print(" peripheral: CBPeripheral")
//        guard let services = peripheral.services else {
//            return
//        }
//        discoverCharacteristics(peripheral: peripheral)
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics else {
//            return
//        }
//        print("DSICOVERED CHARACTERISTICS")
//        print(service.characteristics)
//        subscribeToNotifications(peripheral: peripheral, characteristic: (service.characteristics?.first)!)
//        // Consider storing important characteristics internally for easy access and equivalency checks later.
//        // From here, can read/write to characteristics or subscribe to notifications as desired.
//    }
//
//    func subscribeToNotifications(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
//        print(" subscribeToNotifications")
//        peripheral.setNotifyValue(true, for: characteristic)
//     }
//
//    // In CBPeripheralDelegate class/extension
//    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//        print("ASDNJKANSDKJASN")
//        print(characteristic.uuid)
//        if let error = error {
//            // Handle error
//            print(error)
//            return
//        }
//        // Successfully subscribed to or unsubscribed from notifications/indications on a characteristic
//    }
//
//    func readValue(characteristic: CBCharacteristic) {
//        print(" readValue(characteristic")
//        self.kodakKFC?.readValue(for: characteristic)
//    }
//
//    // In CBPeripheralDelegate class/extension
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        print("    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)")
//        if let error = error {
//            // Handle error
//            return
//        }
//        guard let value = characteristic.value else {
//            return
//        }
//        // Do something with data
//    }


//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("Connected!")
////        self.kodakKFC = peripheral
////        peripheral.delegate = self
////        self.discoverServices(peripheral: self.kodakKFC)
//    }

        
//    private func sendData() {
//
//        guard let transferCharacteristic = transferCharacteristic else {
//            return
//        }
//
//        // First up, check if we're meant to be sending an EOM
//        if ViewController.sendingEOM {
//            // send it
//            let didSend = peripheralManager.updateValue("EOM".data(using: .utf8)!, for: transferCharacteristic, onSubscribedCentrals: nil)
//            // Did it send?
//            if didSend {
//                // It did, so mark it as sent
//                ViewController.sendingEOM = false
//                print("Sent: EOM")
//            }
//            // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
//            return
//        }
//
//        // We're not sending an EOM, so we're sending data
//        // Is there any left to send?
//        if sendDataIndex >= dataToSend.count {
//            // No data left.  Do nothing
//            return
//        }
//
//        // There's data left, so send until the callback fails, or we're done.
//        var didSend = true
//        while didSend {
//
//            // Work out how big it should be
//            var amountToSend = dataToSend.count - sendDataIndex
//            if let mtu = connectedCentral?.maximumUpdateValueLength {
//                amountToSend = min(amountToSend, mtu)
//            }
//
//            // Copy out the data we want
//            let chunk = dataToSend.subdata(in: sendDataIndex..<(sendDataIndex + amountToSend))
//
//            // Send it
//            didSend = peripheralManager.updateValue(chunk, for: transferCharacteristic, onSubscribedCentrals: nil)
//
//            // If it didn't work, drop out and wait for the callback
//            if !didSend {
//                return
//            }
//
//            let stringFromData = String(data: chunk, encoding: .utf8)
//            print("Sent %d bytes: %s", chunk.count, String(describing: stringFromData))
//
//            // It did send, so update our index
//            sendDataIndex += amountToSend
//            // Was it the last one?
//            if sendDataIndex >= dataToSend.count {
//                // It was - send an EOM
//
//                // Set this so if the send fails, we'll send it next time
//                ViewController.sendingEOM = true
//
//                //Send it
//                let eomSent = peripheralManager.updateValue("EOM".data(using: .utf8)!,
//                                                             for: transferCharacteristic, onSubscribedCentrals: nil)
//
//                if eomSent {
//                    // It sent; we're all done
//                    ViewController.sendingEOM = false
//                    print("Sent: EOM")
//                }
//                return
//            }
//        }
//    }
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

    /*
     *  Catch when someone subscribes to our characteristic, then start sending them data
//     */
//    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
//        print("Central subscribed to characteristic")
//
//        // Get the data
//        dataToSend = mockData.data(using: .utf8)!
//
//        // Reset the index
//        sendDataIndex = 0
//
//        // save central
//        connectedCentral = central
//
//        // Start sending
//        sendData()
//    }
//
//    /*
//     *  Recognize when the central unsubscribes
//     */
//    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
//        print("Central unsubscribed from characteristic")
//        connectedCentral = nil
//    }
//
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        print("Failure reason")
//        print(error)
//    }
//
//    /*
//     *  This callback comes in when the PeripheralManager is ready to send the next chunk of data.
//     *  This is to ensure that packets will arrive in the order they are sent
//     */
//    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
//        // Start sending again
//        sendData()
//    }
//
//    /*
//     * This callback comes in when the PeripheralManager received write to characteristics
//     */
//    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
//        for aRequest in requests {
//            guard let requestValue = aRequest.value,
//                let stringFromData = String(data: requestValue, encoding: .utf8) else {
//                    continue
//            }
//
//            print("Received write request of %d bytes: %s", requestValue.count, stringFromData)
//        }
//    }
}
