//
//  WatchConnectivityManager.swift
//  zaCalc2
//
//  Created by sholl on 9/30/25.
//

import Foundation
import Combine
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()

    private override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func sendCalculatorData(_ data: CalculatorData) {
        guard WCSession.default.isReachable else {
            // Try transferUserInfo for background delivery
            transferCalculatorData(data)
            return
        }

        let message = createDataDictionary(from: data)

        WCSession.default.sendMessage(message, replyHandler: { _ in
            // Message sent successfully
        }) { _ in
            // Fallback to transferUserInfo
            self.transferCalculatorData(data)
        }
    }

    private func transferCalculatorData(_ data: CalculatorData) {
        guard WCSession.default.activationState == .activated else { return }

        let userInfo = createDataDictionary(from: data)
        WCSession.default.transferUserInfo(userInfo)
    }

    private func createDataDictionary(from data: CalculatorData) -> [String: Any] {
        var dict: [String: Any] = [
            "quantity": data.quantity,
            "diameter": data.diameter,
            "thickness": data.thickness,
            "hydration": data.hydration,
            "prefermentAmount": data.prefermentAmount,
            "prefermentHydration": data.prefermentHydration,
            "salt": data.salt,
            "oil": data.oil,
            "sugar": data.sugar,
            "waste": data.waste,
            "useCentimeters": data.useCentimeters,
            "useOunces": data.useOunces,
            "useCelsius": data.useCelsius,
            "yeastType": data.yeastType.rawValue,
            "pizzaStyle": data.pizzaStyle.rawValue,
            "bakersYeastPercentage": data.bakersYeastPercentage,
            "bakersYeastType": data.bakersYeastType.rawValue,
            "bakersYeastAmountInput": data.bakersYeastAmountInput,
            "toppingsSize": data.toppingsSize,
            // Calculated results
            "totalDoughWeight": data.totalDoughWeight,
            "ballWeight": data.ballWeight,
            "totalFlour": data.totalFlour,
            "prefermentFlour": data.prefermentFlour,
            "totalPreferment": data.totalPreferment,
            "water": data.water,
            "saltAmount": data.saltAmount,
            "oilAmount": data.oilAmount,
            "sugarAmount": data.sugarAmount,
            "bakersYeastAmount": data.bakersYeastAmount
        ]

        // Include custom pizza styles if selected
        if let selectedId = data.selectedCustomStyleId,
           let selectedStyle = data.customPizzaStyles.first(where: { $0.id == selectedId }) {

            // Encode the custom style
            if let styleData = try? JSONEncoder().encode(selectedStyle),
               let styleDict = try? JSONSerialization.jsonObject(with: styleData) as? [String: Any] {
                dict["selectedCustomStyle"] = styleDict
            }
        }

        return dict
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
        // Handle messages from watch if needed
    }
}