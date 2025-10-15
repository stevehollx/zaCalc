//
//  WatchConnectivityManager.swift
//  zaCalc2 Watch App
//
//  Created by sholl on 9/30/25.
//

import Foundation
import Combine
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()

    @Published var calculatorData = CalculatorData()

    private override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    private func updateCalculatorData(from dictionary: [String: Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // Update basic properties
            if let quantity = dictionary["quantity"] as? Double {
                self.calculatorData.quantity = quantity
            }
            if let diameter = dictionary["diameter"] as? Double {
                self.calculatorData.diameter = diameter
            }
            if let thickness = dictionary["thickness"] as? Double {
                self.calculatorData.thickness = thickness
            }
            if let hydration = dictionary["hydration"] as? Double {
                self.calculatorData.hydration = hydration
            }
            if let prefermentAmount = dictionary["prefermentAmount"] as? Double {
                self.calculatorData.prefermentAmount = prefermentAmount
            }
            if let prefermentHydration = dictionary["prefermentHydration"] as? Double {
                self.calculatorData.prefermentHydration = prefermentHydration
            }
            if let salt = dictionary["salt"] as? Double {
                self.calculatorData.salt = salt
            }
            if let oil = dictionary["oil"] as? Double {
                self.calculatorData.oil = oil
            }
            if let sugar = dictionary["sugar"] as? Double {
                self.calculatorData.sugar = sugar
            }
            if let waste = dictionary["waste"] as? Double {
                self.calculatorData.waste = waste
            }
            if let useCentimeters = dictionary["useCentimeters"] as? Bool {
                self.calculatorData.useCentimeters = useCentimeters
            }
            if let useOunces = dictionary["useOunces"] as? Bool {
                self.calculatorData.useOunces = useOunces
            }
            if let useCelsius = dictionary["useCelsius"] as? Bool {
                self.calculatorData.useCelsius = useCelsius
            }
            if let yeastTypeString = dictionary["yeastType"] as? String,
               let yeastType = CalculatorData.YeastType(rawValue: yeastTypeString) {
                self.calculatorData.yeastType = yeastType
            }
            if let pizzaStyleString = dictionary["pizzaStyle"] as? String,
               let pizzaStyle = CalculatorData.PizzaStyle(rawValue: pizzaStyleString) {
                self.calculatorData.pizzaStyle = pizzaStyle
            }
            if let bakersYeastPercentage = dictionary["bakersYeastPercentage"] as? Double {
                self.calculatorData.bakersYeastPercentage = bakersYeastPercentage
            }
            if let bakersYeastTypeString = dictionary["bakersYeastType"] as? String,
               let bakersYeastType = CalculatorData.BakersYeastType(rawValue: bakersYeastTypeString) {
                self.calculatorData.bakersYeastType = bakersYeastType
            }
            if let bakersYeastAmountInput = dictionary["bakersYeastAmountInput"] as? Double {
                self.calculatorData.bakersYeastAmountInput = bakersYeastAmountInput
            }
            if let toppingsSize = dictionary["toppingsSize"] as? Double {
                self.calculatorData.toppingsSize = toppingsSize
            }

            // Handle custom pizza style if present
            if let styleDict = dictionary["selectedCustomStyle"] as? [String: Any],
               let styleData = try? JSONSerialization.data(withJSONObject: styleDict),
               let customStyle = try? JSONDecoder().decode(CalculatorData.CustomPizzaStyle.self, from: styleData) {

                // Update or add the custom style
                if let existingIndex = self.calculatorData.customPizzaStyles.firstIndex(where: { $0.id == customStyle.id }) {
                    self.calculatorData.customPizzaStyles[existingIndex] = customStyle
                } else {
                    self.calculatorData.customPizzaStyles.append(customStyle)
                }
                self.calculatorData.selectedCustomStyleId = customStyle.id
            }
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Session activation completed
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Session became inactive
    }

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        updateCalculatorData(from: message)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        updateCalculatorData(from: userInfo)
    }
}