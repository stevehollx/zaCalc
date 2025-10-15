//
//  CalculatorData.swift
//  zaCalc2
//
//  Created by sholl on 9/27/25.
//

import Foundation
import SwiftUI
import Combine

class CalculatorData: ObservableObject {
    @Published var quantity: Double = 1.0
    @Published var diameter: Double = 14.0
    @Published var thickness: Double = 0.125
    @Published var hydration: Double = 65.0
    @Published var prefermentAmount: Double = 20.0
    @Published var prefermentHydration: Double = 100.0
    @Published var salt: Double = 2.0
    @Published var oil: Double = 2.0
    @Published var sugar: Double = 1.0
    @Published var waste: Double = 5.0
    @Published var useCentimeters: Bool = false // Inches is default
    @Published var useOunces: Bool = false // Grams is default
    @Published var useCelsius: Bool = false // Fahrenheit is default
    @Published var yeastType: YeastType = .sourdough
    @Published var pizzaStyle: PizzaStyle = .neapolitan
    @Published var bakersYeastPercentage: Double = 0.5
    @Published var bakersYeastType: BakersYeastType = .instantDry
    @Published var bakersYeastAmountInput: Double = 0.0 // Direct amount input with conversion
    @Published var desiredFermentationTime: Double = 24.0 // Desired fermentation time in hours
    @Published var desiredFermentationTemp: Double = 18.3 // Desired fermentation temperature (65°F = 18.3°C)
    @Published var customPizzaStyles: [CustomPizzaStyle] = []
    @Published var selectedCustomStyleId: UUID? = nil
    @Published var toppingsSize: Double = 12.4 // Default to Neapolitan size
    @Published var visibleSourdoughStages: Int = 2 // Start with 2 stages visible

    enum YeastType: String, CaseIterable, Codable {
        case sourdough = "sourdough"
        case bakers = "bakers"

        var displayName: String {
            switch self {
            case .sourdough:
                return "Sourdough"
            case .bakers:
                return "Baker's Yeast"
            }
        }
    }

    enum BakersYeastType: String, CaseIterable, Codable {
        case instantDry = "instantDry"
        case activeDry = "activeDry"
        case cake = "cake"

        var displayName: String {
            switch self {
            case .instantDry:
                return "Instant Dry Yeast"
            case .activeDry:
                return "Active Dry Yeast"
            case .cake:
                return "Cake Yeast"
            }
        }

        // Conversion factor from Active Dry Yeast (which is what the lookup table provides)
        var conversionFromActiveDry: Double {
            switch self {
            case .activeDry:
                return 1.0 // No conversion needed
            case .instantDry:
                return 0.762 // ADY to IDY: 0.096/0.126 = 0.762
            case .cake:
                return 2.381 // ADY to CY: 0.300/0.126 = 2.381
            }
        }

        // Legacy conversion factor for bakersYeastAmount calculation
        var conversionFactor: Double {
            return 1.0 // This is just for weight calculation, no conversion needed
        }
    }

    enum PizzaStyle: String, CaseIterable, Codable {
        case neapolitan = "neapolitan"
        case newYork = "newYork"
        case chicago = "chicago"

        var displayName: String {
            switch self {
            case .neapolitan:
                return "Neapolitan"
            case .newYork:
                return "New York"
            case .chicago:
                return "Chicago Tavern"
            }
        }
    }

    struct CustomPizzaStyle: Identifiable, Codable {
        var id: UUID
        var name: String
        var referenceSize: Double // in inches
        var toppings: [Topping]

        init(name: String, referenceSize: Double, toppings: [Topping] = []) {
            self.id = UUID()
            self.name = name
            self.referenceSize = referenceSize
            self.toppings = toppings
        }
    }

    struct Topping: Identifiable, Codable {
        var id: UUID
        var name: String
        var amount: Double // weight per pizza at reference size
        var unit: String

        init(name: String, amount: Double, unit: String) {
            self.id = UUID()
            self.name = name
            self.amount = amount
            self.unit = unit
        }
    }

    // Sourdough calculator properties
    @Published var useSourdoughCalculator: Bool = false
    @Published var time1: Double = 0.0
    @Published var time2: Double = 0.0
    @Published var time3: Double = 0.0
    @Published var time4: Double = 0.0
    @Published var time5: Double = 0.0
    @Published var temp1: Double = 70.0
    @Published var temp2: Double = 70.0
    @Published var temp3: Double = 70.0
    @Published var temp4: Double = 70.0
    @Published var temp5: Double = 70.0
    @Published var yeastCorrectionFactor: Double = 1.0

    // Saved recipes
    @Published var savedRecipes: [SavedRecipe] = []

    struct SavedRecipe: Codable, Identifiable {
        var id: UUID
        let name: String
        let dateSaved: Date
        let quantity: Double
        let diameter: Double
        let thickness: Double
        let hydration: Double
        let prefermentAmount: Double
        let prefermentHydration: Double
        let salt: Double
        let oil: Double
        let sugar: Double
        let waste: Double
        let yeastType: YeastType
        let pizzaStyle: PizzaStyle
        let bakersYeastPercentage: Double
        let bakersYeastType: BakersYeastType
        let bakersYeastAmountInput: Double
        let useCentimeters: Bool
        let useOunces: Bool

        // Sourdough specific data
        let useSourdoughCalculator: Bool
        let time1: Double
        let time2: Double
        let time3: Double
        let time4: Double
        let time5: Double
        let temp1: Double
        let temp2: Double
        let temp3: Double
        let temp4: Double
        let temp5: Double
        let yeastCorrectionFactor: Double
    }

    // Calculated properties - matching original Objective-C logic exactly
    var ballWeight: Double {
        let radius = diameter / 2
        let volume = 3.1415 * pow(radius, 2) * thickness
        return volume * 28.3495 // grams conversion factor
    }

    var totalDoughWeight: Double {
        ballWeight * (1 + waste / 100) * quantity
    }

    // Original complex calculation from Objective-C
    var totalFlour: Double {
        totalDoughWeight / (hydration / 100 + 1 + salt / 100 + oil / 100 + sugar / 100) - (prefermentAmount / 100 * prefermentHydration)
    }

    var totalPreferment: Double {
        totalFlour * prefermentAmount / 100
    }

    var prefermentFlour: Double {
        totalPreferment * (1 - prefermentHydration / 200)
    }

    var totalFlourPlusPreferment: Double {
        totalFlour + prefermentFlour
    }

    var sugarAmount: Double {
        totalFlourPlusPreferment * sugar / 100
    }

    var oilAmount: Double {
        totalFlourPlusPreferment * oil / 100
    }

    var saltAmount: Double {
        totalFlourPlusPreferment * salt / 100
    }

    var water: Double {
        totalFlourPlusPreferment * hydration / 100 - (totalPreferment * prefermentHydration / 200) - oilAmount
    }

    var bakersYeastAmount: Double {
        totalFlourPlusPreferment * (bakersYeastPercentage * bakersYeastType.conversionFactor) / 100
    }

    // Topping calculations
    var scalingFactor: Double {
        // Scale based on actual pizza area vs reference area
        let actualArea = 3.1415 * pow(diameter / 2, 2)
        let referenceArea: Double

        switch pizzaStyle {
        case .neapolitan:
            // Reference: ~10" pizza area for 250g dough
            referenceArea = 3.1415 * pow(5.0, 2) // 5" radius = 10" diameter
        case .newYork:
            // Scale based on dough weight ratio
            return ballWeight / 250.0 // 250g reference
        case .chicago:
            // Reference: 14" pizza
            referenceArea = 3.1415 * pow(7.0, 2) // 7" radius = 14" diameter
        }

        return (actualArea / referenceArea) * quantity
    }

    var mozzarellaAmount: Double {
        switch pizzaStyle {
        case .neapolitan:
            return 100.0 * scalingFactor
        case .newYork:
            return ballWeight * 0.5 * quantity // Half weight of dough
        case .chicago:
            return (10.0 * 28.35) * scalingFactor // 10 oz in grams
        }
    }

    var parmesanAmount: Double {
        switch pizzaStyle {
        case .neapolitan:
            return 15.0 * scalingFactor
        case .newYork:
            return 0.0 // Not typically used in NY style
        case .chicago:
            return (2.0 * 28.35) * scalingFactor // 2 oz in grams
        }
    }

    var tomatoSauceAmount: Double {
        switch pizzaStyle {
        case .neapolitan:
            return 80.0 * scalingFactor
        case .newYork:
            return ballWeight * 0.25 * quantity // Quarter weight of dough
        case .chicago:
            return (0.875 * 236.59) * scalingFactor // 7/8 cup in ml
        }
    }

    // Custom toppings management
    func getDefaultPizzaStyles() -> [CustomPizzaStyle] {
        return [
            CustomPizzaStyle(
                name: "Neapolitan",
                referenceSize: 12.4,
                toppings: [
                    Topping(name: "Tomatoes", amount: 80, unit: "g"),
                    Topping(name: "Oil", amount: 7, unit: "g"),
                    Topping(name: "Garlic", amount: 1, unit: "clove"),
                    Topping(name: "Oregano", amount: 0.5, unit: "g"),
                    Topping(name: "Mozzarella", amount: 100, unit: "g"),
                    Topping(name: "Parmesan", amount: 7, unit: "g")
                ]
            ),
            CustomPizzaStyle(
                name: "Chicago Tavern",
                referenceSize: 14.0,
                toppings: [
                    Topping(name: "Giardiniera", amount: 0.75, unit: "cup"),
                    Topping(name: "Sauce", amount: 1, unit: "cup"),
                    Topping(name: "Parmesan", amount: 2, unit: "oz"),
                    Topping(name: "Mozzarella", amount: 10, unit: "oz"),
                    Topping(name: "Sausage", amount: 8, unit: "oz")
                ]
            ),
            CustomPizzaStyle(
                name: "NY Style",
                referenceSize: 14.0,
                toppings: [
                    Topping(name: "Sauce", amount: 142, unit: "g"),
                    Topping(name: "Cheese", amount: 142, unit: "g"),
                    Topping(name: "Parmesan", amount: 8, unit: "g"),
                    Topping(name: "Sausage", amount: 5, unit: "oz")
                ]
            )
        ]
    }

    func restoreDefaultStyles() {
        customPizzaStyles = getDefaultPizzaStyles()
        saveCustomStyles()
    }

    func addCustomStyle(_ style: CustomPizzaStyle) {
        customPizzaStyles.append(style)
        saveCustomStyles()
    }

    func deleteCustomStyle(_ style: CustomPizzaStyle) {
        customPizzaStyles.removeAll { $0.id == style.id }
        if selectedCustomStyleId == style.id {
            selectedCustomStyleId = nil
        }
        saveCustomStyles()
    }

    func updateCustomStyle(_ style: CustomPizzaStyle) {
        if let index = customPizzaStyles.firstIndex(where: { $0.id == style.id }) {
            customPizzaStyles[index] = style
            saveCustomStyles()
        }
    }

    private func saveCustomStyles() {
        if let encoded = try? JSONEncoder().encode(customPizzaStyles) {
            UserDefaults.standard.set(encoded, forKey: "customPizzaStyles")
        }
    }

    private func loadCustomStyles() {
        if let data = UserDefaults.standard.data(forKey: "customPizzaStyles"),
           let decoded = try? JSONDecoder().decode([CustomPizzaStyle].self, from: data) {
            customPizzaStyles = decoded
        } else {
            // Load defaults if no custom styles saved
            restoreDefaultStyles()
        }
    }

    // Sourdough calculator computed properties
    var totalTime: Double {
        time1 + time2 + time3 + time4 + time5
    }

    var calculatedPrefermentAmount: Double {
        // Convert temperatures to Fahrenheit if needed (original formula expects Fahrenheit)
        var workingTemps = [temp1, temp2, temp3, temp4, temp5]
        if useCentimeters {
            // Convert from Celsius to Fahrenheit
            workingTemps = workingTemps.map { $0 * 9/5 + 32 }
        }

        let times = [time1, time2, time3, time4, time5]

        // Helper function to calculate the complex temperature-dependent factor for each stage
        func calculateTempFactor(temp: Double) -> Double {
            let temp2 = temp * temp
            let temp3 = temp2 * temp
            let temp4 = temp3 * temp

            // First polynomial (for log(0.01))
            let poly1 = (-0.0000336713 * temp4) + (0.0105207916 * temp3) - (1.2495985607 * temp2) + (67.0024722564 * temp) - 1374.6540546564

            // Second polynomial
            let poly2 = (-0.000003773 * temp4) + (0.0011788625 * temp3) - (0.1400139318 * temp2) + (7.5072379375 * temp) - 154.0188143761

            // First part: poly1 * log(0.01) + poly2
            let part1 = poly1 * log(0.01) + poly2

            // Third part: poly1 * log(0.4) + poly2
            let part3 = poly1 * log(0.4) + poly2

            // Final calculation: (part1 - part3) / (log(40) / log(2))
            return (part1 - part3) / (log(40) / log(2))
        }

        // Calculate the sum of time/tempFactor for each active stage
        var totalCalculation: Double = 0

        for i in 0..<5 {
            if times[i] > 0 {
                let tempFactor = calculateTempFactor(temp: workingTemps[i])
                if tempFactor != 0 {
                    totalCalculation += times[i] / tempFactor
                }
            }
        }

        // Apply the main formula: 89.4 / (2^totalCalculation)
        let result = 89.4 / pow(2, totalCalculation)

        // Apply yeast correction factor
        return result * yeastCorrectionFactor
    }

    // Recipe saving methods
    func saveRecipe(name: String) {
        let recipe = SavedRecipe(
            id: UUID(),
            name: name,
            dateSaved: Date(),
            quantity: quantity,
            diameter: diameter,
            thickness: thickness,
            hydration: hydration,
            prefermentAmount: prefermentAmount,
            prefermentHydration: prefermentHydration,
            salt: salt,
            oil: oil,
            sugar: sugar,
            waste: waste,
            yeastType: yeastType,
            pizzaStyle: pizzaStyle,
            bakersYeastPercentage: bakersYeastPercentage,
            bakersYeastType: bakersYeastType,
            bakersYeastAmountInput: bakersYeastAmountInput,
            useCentimeters: useCentimeters,
            useOunces: useOunces,
            useSourdoughCalculator: useSourdoughCalculator,
            time1: time1,
            time2: time2,
            time3: time3,
            time4: time4,
            time5: time5,
            temp1: temp1,
            temp2: temp2,
            temp3: temp3,
            temp4: temp4,
            temp5: temp5,
            yeastCorrectionFactor: yeastCorrectionFactor
        )

        savedRecipes.append(recipe)
        saveSavedRecipes()
    }

    func loadRecipe(_ recipe: SavedRecipe) {
        quantity = recipe.quantity
        diameter = recipe.diameter
        thickness = recipe.thickness
        hydration = recipe.hydration
        prefermentAmount = recipe.prefermentAmount
        prefermentHydration = recipe.prefermentHydration
        salt = recipe.salt
        oil = recipe.oil
        sugar = recipe.sugar
        waste = recipe.waste
        yeastType = recipe.yeastType
        pizzaStyle = recipe.pizzaStyle
        bakersYeastPercentage = recipe.bakersYeastPercentage
        bakersYeastType = recipe.bakersYeastType
        bakersYeastAmountInput = recipe.bakersYeastAmountInput
        useCentimeters = recipe.useCentimeters
        useOunces = recipe.useOunces
        useSourdoughCalculator = recipe.useSourdoughCalculator
        time1 = recipe.time1
        time2 = recipe.time2
        time3 = recipe.time3
        time4 = recipe.time4
        time5 = recipe.time5
        temp1 = recipe.temp1
        temp2 = recipe.temp2
        temp3 = recipe.temp3
        temp4 = recipe.temp4
        temp5 = recipe.temp5
        yeastCorrectionFactor = recipe.yeastCorrectionFactor

        saveToDefaults()
    }

    func deleteRecipe(_ recipe: SavedRecipe) {
        savedRecipes.removeAll { $0.id == recipe.id }
        saveSavedRecipes()
    }

    private func saveSavedRecipes() {
        if let encoded = try? JSONEncoder().encode(savedRecipes) {
            UserDefaults.standard.set(encoded, forKey: "savedRecipes")
        }
    }

    private func loadSavedRecipes() {
        if let data = UserDefaults.standard.data(forKey: "savedRecipes"),
           let decoded = try? JSONDecoder().decode([SavedRecipe].self, from: data) {
            savedRecipes = decoded
        }
    }

    // Save to UserDefaults
    func saveToDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(quantity, forKey: "quantityN")
        defaults.set(diameter, forKey: "diameterN")
        defaults.set(thickness, forKey: "thicknessN")
        defaults.set(hydration, forKey: "hydrationN")
        defaults.set(prefermentAmount, forKey: "prefermentAmountN")
        defaults.set(prefermentHydration, forKey: "prefermentHydrationN")
        defaults.set(salt, forKey: "saltN")
        defaults.set(oil, forKey: "oilN")
        defaults.set(sugar, forKey: "sugarN")
        defaults.set(waste, forKey: "wasteN")
        defaults.set(useCentimeters, forKey: "useCentimeters")
        defaults.set(useOunces, forKey: "useOunces")
        defaults.set(useCelsius, forKey: "useCelsius")
        defaults.set(yeastType.rawValue, forKey: "yeastType")
        defaults.set(pizzaStyle.rawValue, forKey: "pizzaStyle")
        defaults.set(bakersYeastPercentage, forKey: "bakersYeastPercentage")
        defaults.set(bakersYeastType.rawValue, forKey: "bakersYeastType")
        defaults.set(bakersYeastAmountInput, forKey: "bakersYeastAmountInput")
        defaults.set(desiredFermentationTime, forKey: "desiredFermentationTime")
        defaults.set(desiredFermentationTemp, forKey: "desiredFermentationTemp")

        // Save sourdough properties
        defaults.set(useSourdoughCalculator, forKey: "useSourdoughCalculator")
        defaults.set(time1, forKey: "time1")
        defaults.set(time2, forKey: "time2")
        defaults.set(time3, forKey: "time3")
        defaults.set(time4, forKey: "time4")
        defaults.set(time5, forKey: "time5")
        defaults.set(temp1, forKey: "temp1")
        defaults.set(temp2, forKey: "temp2")
        defaults.set(temp3, forKey: "temp3")
        defaults.set(temp4, forKey: "temp4")
        defaults.set(temp5, forKey: "temp5")
        defaults.set(yeastCorrectionFactor, forKey: "yeastCorrectionFactor")
        defaults.set(visibleSourdoughStages, forKey: "visibleSourdoughStages")

        // Save toppings and style selection
        defaults.set(toppingsSize, forKey: "toppingsSize")
        if let selectedId = selectedCustomStyleId {
            defaults.set(selectedId.uuidString, forKey: "selectedCustomStyleId")
        }
    }

    // Load from UserDefaults
    func loadFromDefaults() {
        let defaults = UserDefaults.standard
        quantity = defaults.object(forKey: "quantityN") as? Double ?? 1.0
        diameter = defaults.object(forKey: "diameterN") as? Double ?? 12.0
        thickness = defaults.object(forKey: "thicknessN") as? Double ?? 0.125
        hydration = defaults.object(forKey: "hydrationN") as? Double ?? 65.0
        prefermentAmount = defaults.object(forKey: "prefermentAmountN") as? Double ?? 20.0
        prefermentHydration = defaults.object(forKey: "prefermentHydrationN") as? Double ?? 100.0
        salt = defaults.object(forKey: "saltN") as? Double ?? 2.0
        oil = defaults.object(forKey: "oilN") as? Double ?? 2.0
        sugar = defaults.object(forKey: "sugarN") as? Double ?? 1.0
        waste = defaults.object(forKey: "wasteN") as? Double ?? 5.0
        useCentimeters = defaults.bool(forKey: "useCentimeters")
        useOunces = defaults.bool(forKey: "useOunces")
        useCelsius = defaults.bool(forKey: "useCelsius")
        if let yeastTypeString = defaults.string(forKey: "yeastType"),
           let loadedYeastType = YeastType(rawValue: yeastTypeString) {
            yeastType = loadedYeastType
        }
        if let pizzaStyleString = defaults.string(forKey: "pizzaStyle"),
           let loadedPizzaStyle = PizzaStyle(rawValue: pizzaStyleString) {
            pizzaStyle = loadedPizzaStyle
        }
        bakersYeastPercentage = defaults.object(forKey: "bakersYeastPercentage") as? Double ?? 0.5
        if let bakersYeastTypeString = defaults.string(forKey: "bakersYeastType"),
           let loadedBakersYeastType = BakersYeastType(rawValue: bakersYeastTypeString) {
            bakersYeastType = loadedBakersYeastType
        }
        bakersYeastAmountInput = defaults.object(forKey: "bakersYeastAmountInput") as? Double ?? 0.0
        desiredFermentationTime = defaults.object(forKey: "desiredFermentationTime") as? Double ?? 24.0
        desiredFermentationTemp = defaults.object(forKey: "desiredFermentationTemp") as? Double ?? 18.3

        // Load sourdough properties
        useSourdoughCalculator = defaults.bool(forKey: "useSourdoughCalculator")
        time1 = defaults.object(forKey: "time1") as? Double ?? 0.0
        time2 = defaults.object(forKey: "time2") as? Double ?? 0.0
        time3 = defaults.object(forKey: "time3") as? Double ?? 0.0
        time4 = defaults.object(forKey: "time4") as? Double ?? 0.0
        time5 = defaults.object(forKey: "time5") as? Double ?? 0.0
        temp1 = defaults.object(forKey: "temp1") as? Double ?? 70.0
        temp2 = defaults.object(forKey: "temp2") as? Double ?? 70.0
        temp3 = defaults.object(forKey: "temp3") as? Double ?? 70.0
        temp4 = defaults.object(forKey: "temp4") as? Double ?? 70.0
        temp5 = defaults.object(forKey: "temp5") as? Double ?? 70.0
        yeastCorrectionFactor = defaults.object(forKey: "yeastCorrectionFactor") as? Double ?? 1.0
        visibleSourdoughStages = defaults.object(forKey: "visibleSourdoughStages") as? Int ?? 2

        // Load toppings and style selection
        toppingsSize = defaults.object(forKey: "toppingsSize") as? Double ?? 12.4
        if let selectedIdString = defaults.string(forKey: "selectedCustomStyleId"),
           let selectedId = UUID(uuidString: selectedIdString) {
            selectedCustomStyleId = selectedId
        }
    }

    func convertYeastAmount(from fromType: BakersYeastType, to toType: BakersYeastType, amount: Double) -> Double {
        // Since the lookup table gives us Active Dry Yeast percentages,
        // we convert from ADY to the target type
        if fromType == .activeDry {
            return amount * toType.conversionFromActiveDry
        } else {
            // If converting from other types, first convert to ADY, then to target
            let adyAmount = amount / fromType.conversionFromActiveDry
            return adyAmount * toType.conversionFromActiveDry
        }
    }

    init() {
        loadFromDefaults()
        loadSavedRecipes()
        loadCustomStyles()

        // Set default selected style if none is set
        if selectedCustomStyleId == nil {
            selectedCustomStyleId = customPizzaStyles.first?.id
        }
    }

    // MARK: - Yeast Lookup Functions

    var recommendedYeastPercentage: Double? {
        return lookupYeastPercentage(for: desiredFermentationTime, temperature: desiredFermentationTemp)
    }

    private func lookupYeastPercentage(for time: Double, temperature: Double) -> Double? {
        // Yeast lookup table data from Excel file
        let temperatures: [Double] = [
            1.6666666666666665, 2.2222222222222223, 2.7777777777777777, 3.333333333333333, 3.888888888888889,
            4.444444444444445, 5.0, 5.555555555555555, 6.111111111111111, 6.666666666666666, 7.222222222222222,
            7.777777777777778, 8.333333333333334, 8.88888888888889, 9.444444444444445, 10.0, 10.555555555555555,
            11.11111111111111, 11.666666666666666, 12.222222222222221, 12.777777777777777, 13.333333333333332,
            13.88888888888889, 14.444444444444445, 15.0, 15.555555555555555, 16.11111111111111, 16.666666666666668,
            17.22222222222222, 17.77777777777778, 18.333333333333332, 18.88888888888889, 19.444444444444443,
            20.0, 20.555555555555554, 21.11111111111111, 21.666666666666668, 22.22222222222222, 22.77777777777778,
            23.333333333333332, 23.88888888888889, 24.444444444444443, 25.0, 25.555555555555554, 26.11111111111111,
            26.666666666666664, 27.22222222222222, 27.77777777777778, 28.333333333333332, 28.88888888888889,
            29.444444444444443, 30.0, 30.555555555555554, 31.11111111111111, 31.666666666666664, 32.22222222222222,
            32.77777777777778, 33.333333333333336, 33.888888888888886, 34.44444444444444, 35.0
        ]

        let yeastPercentages: [Double] = [
            0.004, 0.008, 0.013, 0.021, 0.032, 0.042, 0.053, 0.063, 0.074, 0.084, 0.126, 0.168, 0.21, 0.252,
            0.294, 0.336, 0.42, 0.504, 0.588, 0.672, 0.756, 0.84, 0.924, 1.008, 1.092, 1.176, 1.26
        ]

        // Find closest temperature
        guard let tempIndex = findClosestIndex(in: temperatures, to: temperature) else { return nil }

        // Complete time matrix from Excel file (61 temperatures x 27 yeast percentages)
        let timeMatrix: [[Double?]] = [
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 167.0, 136.0, 115.0, 101.0, 90.0, 82.0, 70.0, 61.0, 54.0, 49.0, 45.0, 42.0, 39.0, 37.0, 35.0, 33.0, 31.0],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 149.0, 121.0, 103.0, 90.0, 80.0, 73.0, 62.0, 54.0, 49.0, 44.0, 40.0, 37.0, 35.0, 33.0, 31.0, 29.0, 28.0],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 133.0, 108.0, 92.0, 80.0, 72.0, 65.0, 55.0, 49.0, 43.0, 39.0, 36.0, 33.0, 31.0, 29.0, 28.0, 26.0, 25.0],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, 161.0, 120.0, 97.0, 82.0, 72.0, 65.0, 59.0, 50.0, 44.0, 39.0, 35.0, 32.0, 30.0, 28.0, 26.0, 25.0, 24.0, 22.0],
            [nil, nil, nil, nil, nil, nil, nil, nil, 159.0, 145.0, 108.0, 87.0, 74.0, 65.0, 58.0, 53.0, 45.0, 39.0, 35.0, 32.0, 29.0, 27.0, 25.0, 24.0, 22.0, 21.0, 20.0],
            [nil, nil, nil, nil, nil, nil, nil, 161.0, 144.0, 130.0, 97.0, 79.0, 67.0, 59.0, 52.0, 48.0, 40.0, 35.0, 32.0, 29.0, 26.0, 24.0, 23.0, 21.0, 20.0, 19.0, 18.0],
            [nil, nil, nil, nil, nil, nil, 165.0, 145.0, 130.0, 118.0, 88.0, 71.0, 61.0, 53.0, 47.0, 43.0, 37.0, 32.0, 29.0, 26.0, 24.0, 22.0, 21.0, 19.0, 18.0, 17.0, 16.0],
            [nil, nil, nil, nil, nil, nil, 151.0, 132.0, 118.0, 107.0, 80.0, 65.0, 55.0, 48.0, 43.0, 39.0, 33.0, 29.0, 26.0, 24.0, 22.0, 20.0, 19.0, 18.0, 17.0, 16.0, 15.0],
            [nil, nil, nil, nil, nil, 161.0, 137.0, 120.0, 107.0, 97.0, 72.0, 59.0, 50.0, 44.0, 39.0, 35.0, 30.0, 26.0, 24.0, 21.0, 20.0, 18.0, 17.0, 16.0, 15.0, 14.0, 14.0],
            [nil, nil, nil, nil, nil, 147.0, 125.0, 109.0, 98.0, 88.0, 66.0, 53.0, 45.0, 40.0, 36.0, 32.0, 27.0, 24.0, 21.0, 19.0, 18.0, 17.0, 15.0, 14.0, 14.0, 13.0, 12.0],
            [nil, nil, nil, nil, 165.0, 134.0, 114.0, 100.0, 89.0, 81.0, 60.0, 49.0, 41.0, 36.0, 32.0, 29.0, 25.0, 22.0, 20.0, 18.0, 16.0, 15.0, 14.0, 13.0, 12.0, 12.0, 11.0],
            [nil, nil, nil, nil, 151.0, 122.0, 104.0, 91.0, 81.0, 74.0, 55.0, 45.0, 38.0, 33.0, 30.0, 27.0, 23.0, 20.0, 18.0, 16.0, 15.0, 14.0, 13.0, 12.0, 11.0, 11.0, 10.0],
            [nil, nil, nil, nil, 138.0, 112.0, 95.0, 83.0, 74.0, 67.0, 50.0, 41.0, 35.0, 30.0, 27.0, 25.0, 21.0, 18.0, 16.0, 15.0, 14.0, 13.0, 12.0, 11.0, 10.0, 10.0, 9.0],
            [nil, nil, nil, nil, 126.0, 102.0, 87.0, 76.0, 68.0, 62.0, 46.0, 37.0, 32.0, 28.0, 25.0, 23.0, 19.0, 17.0, 15.0, 14.0, 12.0, 12.0, 11.0, 10.0, 10.0, 9.0, 9.0],
            [nil, nil, nil, 156.0, 116.0, 94.0, 80.0, 70.0, 63.0, 57.0, 42.0, 34.0, 29.0, 26.0, 23.0, 21.0, 18.0, 15.0, 14.0, 12.0, 11.0, 11.0, 10.0, 9.0, 9.0, 8.0, 8.0],
            [nil, nil, nil, 143.0, 107.0, 86.0, 74.0, 64.0, 58.0, 52.0, 39.0, 32.0, 27.0, 23.0, 21.0, 19.0, 16.0, 14.0, 13.0, 11.0, 11.0, 10.0, 9.0, 9.0, 8.0, 8.0, 7.0],
            [nil, nil, nil, 132.0, 98.0, 80.0, 68.0, 59.0, 53.0, 48.0, 36.0, 29.0, 25.0, 22.0, 19.0, 18.0, 15.0, 13.0, 12.0, 11.0, 10.0, 9.0, 8.0, 8.0, 7.0, 7.0, 7.0],
            [nil, nil, nil, 122.0, 90.0, 73.0, 62.0, 55.0, 49.0, 44.0, 33.0, 27.0, 23.0, 20.0, 18.0, 16.0, 14.0, 12.0, 11.0, 10.0, 9.0, 8.0, 8.0, 7.0, 7.0, 6.0, 6.0],
            [nil, nil, 163.0, 112.0, 84.0, 68.0, 58.0, 50.0, 45.0, 41.0, 30.0, 25.0, 21.0, 18.0, 16.0, 15.0, 13.0, 11.0, 10.0, 9.0, 8.0, 8.0, 7.0, 7.0, 6.0, 6.0, 6.0],
            [nil, nil, 150.0, 104.0, 77.0, 63.0, 53.0, 47.0, 42.0, 38.0, 28.0, 23.0, 19.0, 17.0, 15.0, 14.0, 12.0, 10.0, 9.0, 8.0, 8.0, 7.0, 7.0, 6.0, 6.0, 6.0, 5.0],
            [nil, nil, 139.0, 96.0, 71.0, 58.0, 49.0, 43.0, 39.0, 35.0, 26.0, 21.0, 18.0, 16.0, 14.0, 13.0, 11.0, 9.0, 8.0, 8.0, 7.0, 7.0, 6.0, 6.0, 5.0, 5.0, 5.0],
            [nil, nil, 129.0, 89.0, 66.0, 54.0, 46.0, 40.0, 36.0, 32.0, 24.0, 20.0, 17.0, 15.0, 13.0, 12.0, 10.0, 9.0, 8.0, 7.0, 7.0, 6.0, 6.0, 5.0, 5.0, 5.0, 5.0],
            [nil, 161.0, 120.0, 82.0, 61.0, 50.0, 42.0, 37.0, 33.0, 30.0, 22.0, 18.0, 15.0, 14.0, 12.0, 11.0, 9.0, 8.0, 7.0, 7.0, 6.0, 6.0, 5.0, 5.0, 5.0, 4.0, 4.0],
            [nil, 149.0, 111.0, 77.0, 57.0, 46.0, 39.0, 34.0, 31.0, 28.0, 21.0, 17.0, 14.0, 13.0, 11.0, 10.0, 9.0, 8.0, 7.0, 6.0, 6.0, 5.0, 5.0, 5.0, 4.0, 4.0, 4.0],
            [nil, 139.0, 103.0, 71.0, 53.0, 43.0, 37.0, 32.0, 29.0, 26.0, 19.0, 16.0, 13.0, 12.0, 10.0, 9.0, 8.0, 7.0, 6.0, 6.0, 5.0, 5.0, 5.0, 4.0, 4.0, 4.0, 4.0],
            [nil, 129.0, 96.0, 66.0, 49.0, 40.0, 34.0, 30.0, 27.0, 24.0, 18.0, 15.0, 12.0, 11.0, 10.0, 9.0, 7.0, 7.0, 6.0, 5.0, 5.0, 5.0, 4.0, 4.0, 4.0, 4.0, 3.0],
            [nil, 120.0, 90.0, 62.0, 46.0, 37.0, 32.0, 28.0, 25.0, 22.0, 17.0, 14.0, 12.0, 10.0, 9.0, 8.0, 7.0, 6.0, 5.0, 5.0, 5.0, 4.0, 4.0, 4.0, 3.0, 3.0, 3.0],
            [nil, 112.0, 83.0, 58.0, 43.0, 35.0, 30.0, 26.0, 23.0, 21.0, 16.0, 13.0, 11.0, 9.0, 8.0, 8.0, 6.0, 6.0, 5.0, 5.0, 4.0, 4.0, 4.0, 3.0, 3.0, 3.0, 3.0],
            [nil, 105.0, 78.0, 54.0, 40.0, 32.0, 28.0, 24.0, 22.0, 20.0, 15.0, 12.0, 10.0, 9.0, 8.0, 7.0, 6.0, 5.0, 5.0, 4.0, 4.0, 4.0, 3.0, 3.0, 3.0, 3.0, 3.0],
            [162.0, 98.0, 73.0, 50.0, 37.0, 30.0, 26.0, 23.0, 20.0, 18.0, 14.0, 11.0, 9.0, 8.0, 7.0, 7.0, 6.0, 5.0, 4.0, 4.0, 4.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0],
            [152.0, 92.0, 68.0, 47.0, 35.0, 28.0, 24.0, 21.0, 19.0, 17.0, 13.0, 10.0, 9.0, 8.0, 7.0, 6.0, 5.0, 5.0, 4.0, 4.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 2.0],
            [142.0, 86.0, 64.0, 44.0, 33.0, 27.0, 23.0, 20.0, 18.0, 16.0, 12.0, 10.0, 8.0, 7.0, 6.0, 6.0, 5.0, 4.0, 4.0, 4.0, 3.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0],
            [133.0, 80.0, 60.0, 41.0, 31.0, 25.0, 21.0, 19.0, 17.0, 15.0, 11.0, 9.0, 8.0, 7.0, 6.0, 5.0, 5.0, 4.0, 4.0, 3.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0],
            [120.0, 73.0, 54.0, 37.0, 28.0, 22.0, 19.0, 17.0, 15.0, 14.0, 10.0, 8.0, 7.0, 6.0, 5.0, 5.0, 4.0, 4.0, 3.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0],
            [109.0, 66.0, 49.0, 34.0, 25.0, 20.0, 17.0, 15.0, 14.0, 12.0, 9.0, 7.0, 6.0, 6.0, 5.0, 4.0, 4.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0],
            [99.0, 60.0, 45.0, 31.0, 23.0, 19.0, 16.0, 14.0, 12.0, 11.0, 8.0, 7.0, 6.0, 5.0, 4.0, 4.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0],
            [90.0, 55.0, 41.0, 28.0, 21.0, 17.0, 14.0, 13.0, 11.0, 10.0, 8.0, 6.0, 5.0, 5.0, 4.0, 4.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0],
            [83.0, 50.0, 37.0, 26.0, 19.0, 15.0, 13.0, 12.0, 10.0, 9.0, 7.0, 6.0, 5.0, 4.0, 4.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0],
            [76.0, 46.0, 34.0, 24.0, 18.0, 14.0, 12.0, 11.0, 9.0, 9.0, 6.0, 5.0, 4.0, 4.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0],
            [70.0, 42.0, 32.0, 22.0, 16.0, 13.0, 11.0, 10.0, 9.0, 8.0, 6.0, 5.0, 4.0, 4.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
            [65.0, 39.0, 29.0, 20.0, 15.0, 12.0, 10.0, 9.0, 8.0, 7.0, 5.0, 4.0, 4.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
            [60.0, 36.0, 27.0, 19.0, 14.0, 11.0, 10.0, 8.0, 7.0, 7.0, 5.0, 4.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
            [56.0, 34.0, 25.0, 17.0, 13.0, 10.0, 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
            [52.0, 31.0, 23.0, 16.0, 12.0, 10.0, 8.0, 7.0, 6.0, 6.0, 4.0, 4.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
            [48.0, 29.0, 22.0, 15.0, 11.0, 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
            [45.0, 27.0, 20.0, 14.0, 10.0, 8.0, 7.0, 6.0, 6.0, 5.0, 4.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
            [42.0, 26.0, 19.0, 13.0, 10.0, 8.0, 7.0, 6.0, 5.0, 5.0, 4.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [40.0, 24.0, 18.0, 12.0, 9.0, 7.0, 6.0, 6.0, 5.0, 5.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [38.0, 23.0, 17.0, 12.0, 9.0, 7.0, 6.0, 5.0, 5.0, 4.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [36.0, 21.0, 16.0, 11.0, 8.0, 7.0, 6.0, 5.0, 4.0, 4.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [34.0, 20.0, 15.0, 10.0, 8.0, 6.0, 5.0, 5.0, 4.0, 4.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [32.0, 19.0, 14.0, 10.0, 7.0, 6.0, 5.0, 4.0, 4.0, 4.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [30.0, 18.0, 14.0, 9.0, 7.0, 6.0, 5.0, 4.0, 4.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [29.0, 18.0, 13.0, 9.0, 7.0, 5.0, 5.0, 4.0, 4.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [28.0, 17.0, 13.0, 9.0, 6.0, 5.0, 4.0, 4.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [27.0, 16.0, 12.0, 8.0, 6.0, 5.0, 4.0, 4.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [26.0, 16.0, 12.0, 8.0, 6.0, 5.0, 4.0, 4.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [25.0, 15.0, 11.0, 8.0, 6.0, 5.0, 4.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [24.0, 15.0, 11.0, 7.0, 6.0, 5.0, 4.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [23.0, 14.0, 10.0, 7.0, 5.0, 4.0, 4.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [22.0, 13.0, 10.0, 7.0, 5.0, 4.0, 4.0, 3.0, 3.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
        ]

        // Use the complete matrix to find the appropriate yeast percentage
        return lookupYeastFromMatrix(time: time, tempIndex: tempIndex, timeMatrix: timeMatrix, yeastPercentages: yeastPercentages)
    }

    private func calculateYeastFromTimeTemp(time: Double, temperature: Double) -> Double {
        // Simplified calculation based on typical fermentation patterns
        // This is a rough approximation - the full lookup table would be more accurate

        // Base yeast percentage for 24h at 20°C
        let baseYeast = 0.3
        let baseTime = 24.0
        let baseTemp = 20.0

        // Temperature adjustment (higher temp = less time needed = more yeast)
        let tempFactor = pow(1.4, (temperature - baseTemp) / 10.0)

        // Time adjustment (longer time = less yeast needed)
        let timeFactor = baseTime / time

        let recommendedYeast = baseYeast * timeFactor / tempFactor

        // Clamp to reasonable range
        return max(0.01, min(1.5, recommendedYeast))
    }

    private func lookupYeastFromMatrix(time: Double, tempIndex: Int, timeMatrix: [[Double?]], yeastPercentages: [Double]) -> Double? {
        // Each row in timeMatrix corresponds to a temperature (using tempIndex)
        // Each column in a row corresponds to a yeast percentage

        guard tempIndex < timeMatrix.count else { return nil }
        let timeRow = timeMatrix[tempIndex]

        // First check for exact match
        for (yeastIndex, timeValue) in timeRow.enumerated() {
            guard let timeValue = timeValue else { continue }
            if abs(timeValue - time) < 0.01 { // Within 0.01 hours is considered exact
                if yeastIndex < yeastPercentages.count {
                    return yeastPercentages[yeastIndex]
                }
            }
        }

        // No exact match, so interpolate between adjacent time values
        return interpolateYeastFromTimeValues(time: time, timeRow: timeRow, yeastPercentages: yeastPercentages)
    }

    private func interpolateYeastFromTimeValues(time: Double, timeRow: [Double?], yeastPercentages: [Double]) -> Double? {
        // Find adjacent time values that bracket our target time
        var lowerPair: (index: Int, time: Double, yeast: Double)?
        var upperPair: (index: Int, time: Double, yeast: Double)?

        for (index, timeValue) in timeRow.enumerated() {
            guard let timeValue = timeValue, index < yeastPercentages.count else { continue }
            let yeastValue = yeastPercentages[index]

            // Find the closest lower bound
            if timeValue <= time {
                if lowerPair == nil || timeValue > lowerPair!.time {
                    lowerPair = (index, timeValue, yeastValue)
                }
            }

            // Find the closest upper bound
            if timeValue >= time {
                if upperPair == nil || timeValue < upperPair!.time {
                    upperPair = (index, timeValue, yeastValue)
                }
            }
        }

        // If we have both bounds, use sophisticated interpolation
        if let lower = lowerPair, let upper = upperPair {
            if lower.index == upper.index {
                return lower.yeast
            }

            // Calculate interpolation factor
            let timeDiff = upper.time - lower.time
            let timeFraction = (time - lower.time) / timeDiff

            // Use exponential interpolation for fermentation curves
            // Yeast fermentation follows an exponential decay pattern
            let lowerLog = log(lower.yeast)
            let upperLog = log(upper.yeast)
            let interpolatedLog = lowerLog + timeFraction * (upperLog - lowerLog)

            return exp(interpolatedLog)
        }

        // If only one bound, use that
        if let lower = lowerPair {
            return lower.yeast
        }
        if let upper = upperPair {
            return upper.yeast
        }

        return nil
    }

    private func interpolateYeastPercentage(time: Double, tempIndex: Int, timeMatrix: [[Double?]], yeastPercentages: [Double]) -> Double? {
        // Legacy function - now redirects to the improved interpolation
        guard tempIndex < timeMatrix.count else { return nil }
        let timeRow = timeMatrix[tempIndex]
        return interpolateYeastFromTimeValues(time: time, timeRow: timeRow, yeastPercentages: yeastPercentages)
    }

    private func findClosestIndex(in array: [Double], to value: Double) -> Int? {
        guard !array.isEmpty else { return nil }

        var closestIndex = 0
        var minDistance = abs(array[0] - value)

        for (index, element) in array.enumerated() {
            let distance = abs(element - value)
            if distance < minDistance {
                minDistance = distance
                closestIndex = index
            }
        }

        return closestIndex
    }
}
