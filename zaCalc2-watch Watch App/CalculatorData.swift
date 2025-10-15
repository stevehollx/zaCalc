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
                return "Instant Dry"
            case .activeDry:
                return "Active"
            case .cake:
                return "Cake"
            }
        }

        // Conversion to instant dry yeast percentage
        var conversionFactor: Double {
            switch self {
            case .instantDry:
                return 1.0
            case .activeDry:
                return 0.42 / 0.32 // Active dry to instant dry
            case .cake:
                return 0.32 // Cake to instant dry
            }
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
        let id = UUID()
        var name: String
        var referenceSize: Double // in inches
        var toppings: [Topping]

        init(name: String, referenceSize: Double, toppings: [Topping] = []) {
            self.name = name
            self.referenceSize = referenceSize
            self.toppings = toppings
        }
    }

    struct Topping: Identifiable, Codable {
        let id = UUID()
        var name: String
        var amount: Double // weight per pizza at reference size
        var unit: String

        init(name: String, amount: Double, unit: String) {
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
        let id = UUID()
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
        defaults.set(yeastType.rawValue, forKey: "yeastType")
        defaults.set(pizzaStyle.rawValue, forKey: "pizzaStyle")
        defaults.set(bakersYeastPercentage, forKey: "bakersYeastPercentage")
        defaults.set(bakersYeastType.rawValue, forKey: "bakersYeastType")
        defaults.set(bakersYeastAmountInput, forKey: "bakersYeastAmountInput")

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
    }

    func convertYeastAmount(from fromType: BakersYeastType, to toType: BakersYeastType, amount: Double) -> Double {
        // Convert to IDY equivalent first, then to target type
        let idyAmount = amount / fromType.conversionFactor
        return idyAmount * toType.conversionFactor
    }

    init() {
        loadFromDefaults()
        loadSavedRecipes()
        loadCustomStyles()
    }

    // MARK: - Yeast Lookup Functions

    var recommendedYeastPercentage: Double? {
        return lookupYeastPercentage(for: desiredFermentationTime, temperature: desiredFermentationTemp)
    }

    private func lookupYeastPercentage(for time: Double, temperature: Double) -> Double? {
        // Yeast lookup table data from Excel file
        let temperatures: [Double] = [
            1.67, 2.22, 2.78, 3.33, 3.89, 4.44, 5.0, 5.56, 6.11, 6.67, 7.22, 7.78, 8.33, 8.89, 9.44, 10.0,
            10.56, 11.11, 11.67, 12.22, 12.78, 13.33, 13.89, 14.44, 15.0, 15.56, 16.11, 16.67, 17.22, 17.78,
            18.33, 18.89, 19.44, 20.0, 20.56, 21.11, 21.67, 22.22, 22.78, 23.33, 23.89, 24.44, 25.0, 25.56,
            26.11, 26.67, 27.22, 27.78, 28.33, 28.89, 29.44, 30.0, 30.56, 31.11, 31.67, 32.22, 32.78, 33.33,
            33.89, 34.44, 35.0
        ]

        let yeastPercentages: [Double] = [
            0.004, 0.008, 0.013, 0.021, 0.032, 0.042, 0.053, 0.063, 0.074, 0.084, 0.126, 0.168, 0.21, 0.252,
            0.294, 0.336, 0.42, 0.504, 0.588, 0.672, 0.756, 0.84, 0.924, 1.008, 1.092, 1.176, 1.26
        ]

        // Find closest temperature
        guard let tempIndex = findClosestIndex(in: temperatures, to: temperature) else { return nil }

        // Sample time matrix for key yeast percentages (simplified version)
        let timeMatrix: [[Double?]] = [
            // This would contain the full matrix from the Excel file
            // For now, using a simplified version for demonstration
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 167, 136, 115, 101, 90, 82, 70, 61, 54, 49, 45, 42, 39, 37, 35, 33, 31],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 149, 121, 103, 90, 80, 73, 62, 54, 49, 44, 40, 37, 35, 33, 31, 29, 28]
            // ... more rows would be added here
        ]

        // For a more robust implementation, we would need the full matrix
        // For now, let's use a simplified calculation based on common yeast percentages
        return calculateYeastFromTimeTemp(time: time, temperature: temperature)
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
