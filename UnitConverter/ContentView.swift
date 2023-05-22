//
//  ContentView.swift
//  UnitConverter
//
//  Created by Carlos Cardoso on 5/21/23.
//

import SwiftUI

struct MyConverter {
    let name : ConverterType
    let units : [(String, Dimension)]
}

enum ConverterType: String {
    case temperature, time, volume, length
    
    var displayName: String {
        self.rawValue.capitalized
    }
}

extension UnitDuration {
    class var days: UnitDuration {
        hours
    }
}

struct ContentView: View {
    
    init() {
        // TODO: remove hardcoded value
        selectedConverterName = "Temperature"
        selectedSourceUnit = "Celsius"
        selectedDestinationUnit = "Fahrenheit"
    }
    
    let converters = [
        MyConverter(name: .temperature, units: [
            ("Celsius", UnitTemperature.celsius),
            ("Fahrenheit", UnitTemperature.fahrenheit),
            ("Kelvin", UnitTemperature.kelvin)]),
        MyConverter(name: .time, units: [
            ("Seconds", UnitDuration.seconds),
            ("Minutes", UnitDuration.minutes),
            ("Hours", UnitDuration.hours),
            ("Days", UnitDuration.days)]),
        MyConverter(name:.length, units: [
            ("Meters", UnitLength.meters),
            ("Kilometers", UnitLength.kilometers),
            ("Feet", UnitLength.feet),
            ("Yards", UnitLength.yards),
            ("Miles", UnitLength.miles)]),
        MyConverter(name: .volume, units: [
            ("Milliliters", UnitVolume.milliliters),
            ("Liters", UnitVolume.liters),
            ("Cups", UnitVolume.cups),
            ("Pints", UnitVolume.pints),
            ("Gallons", UnitVolume.gallons)])
    ]
    
    @State private var amount = 0.0
    @State private var selectedConverterName: String
    @State private var selectedSourceUnit: String
    @State private var selectedDestinationUnit: String
    @FocusState private var amountIsFocused: Bool
    
    var convertersNames: [ConverterType] {
        converters.map { $0.name }
    }
    
    var units: [String] {
        let converter = converters.first(where: { $0.name == selectedConverterName})!
        return converter.units.map { $0.0 }
    }
    
    var result: Double {
        let converter = converters.first(where: { $0.name == selectedConverterName})!
        
        let from = converter.units.first(where: { $0.0 == selectedSourceUnit})?.1
        let to = converter.units.first(where: { $0.0 == selectedDestinationUnit})?.1
        
        if from == nil || to == nil {
            return 0.0
        }
        
        return Measurement(value: amount, unit: from.unsafelyUnwrapped).converted(to: to.unsafelyUnwrapped).value
    }
    
    func initializeUnitsFor(converter: ConverterType) {
        switch converter {
        case .temperature:
            selectedSourceUnit = "Fahrenheit"
            selectedDestinationUnit = "Celsius"
        case .time:
            selectedSourceUnit = "Seconds"
            selectedDestinationUnit = "Hours"
        case .length:
            selectedSourceUnit = "Meters"
            selectedDestinationUnit = "Kilometers"
        default:
            selectedSourceUnit = "Liters"
            selectedDestinationUnit = "Pints"
        }
    }
    
    var body: some View {
        NavigationView() {
            Form() {
                Section {
                    Picker("Converter", selection: $selectedConverterName) {
                        ForEach(convertersNames, id: \.self) {
                            Text($0.capitalized)
                        }
                    }.onChange(of: selectedConverterName) {
                        initializeUnitsFor(converter: ConverterType(rawValue: $0) ?? .temperature)
                        
                    }
                } header: {
                    Text("Type of convertion")
                }
                
                Section() {
                    
                    Picker("From", selection: $selectedSourceUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("To", selection: $selectedDestinationUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    TextField("Amount",
                              value: $amount,
                              format: .number)
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
                } header: {
                    Text("Units")
                }
                
                Section() {
                    Text("Conversion of \(selectedConverterName) from \(amount.formatted(.number)) \(selectedSourceUnit) to \(selectedDestinationUnit) is \(result.formatted(.number))")
                    
                } header: {
                    Text("Debug")
                }
            }
            .navigationTitle("Super Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


