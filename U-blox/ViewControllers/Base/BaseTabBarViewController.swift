/*
 * Copyright (C) u-blox
 *
 * u-blox reserves all rights in this deliverable (documentation, software, etc.,
 * hereafter “Deliverable”).
 *
 * u-blox grants you the right to use, copy, modify and distribute the
 * Deliverable provided hereunder for any purpose without fee.
 *
 * THIS DELIVERABLE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
 * WARRANTY. IN PARTICULAR, NEITHER THE AUTHOR NOR U-BLOX MAKES ANY
 * REPRESENTATION OR WARRANTY OF ANY KIND CONCERNING THE MERCHANTABILITY OF THIS
 * DELIVERABLE OR ITS FITNESS FOR ANY PARTICULAR PURPOSE.
 *
 * In case you provide us a feedback or make a contribution in the form of a
 * further development of the Deliverable (“Contribution”), u-blox will have the
 * same rights as granted to you, namely to use, copy, modify and distribute the
 * Contribution provided to us for any purpose without fee.
 */

import UIKit

class BaseTabBarViewController: BaseViewController {

    var isThisView: Bool {
        return self.viewIfLoaded?.window != nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = BluetoothManager.shared.currentPeripheral?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Disconnect", style: .plain, target: self, action: #selector(disconnectButtonWasPressed))
        NotificationCenter.default.addObserver(forType: .peripheralDisconnected, object: nil, queue: .main, using: { [weak self] notification in
            let peripheralName = notification.userInfo?[UbloxDictionaryKeys.name] as? String
            self?.showDisconnectAlert(forDevice: peripheralName)
        })
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func disconnectButtonWasPressed() {
        guard let peripheral = BluetoothManager.shared.currentPeripheral else {
            showDisconnectAlert(forDevice: navigationItem.title)
            return
        }
        BluetoothManager.shared.disconnect(peripheral)
    }

    private func showDisconnectAlert(forDevice name: String?) {
        guard self.isThisView else {
            return
        }

        let alert = AlertUtil.createAlert(type: .basic, title: "\(name ?? "Peripheral") disconnected", message: nil, action: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
}
