//
//  ContentView.swift
//  UnitConverter
//
//  Created by Carlos Cardoso on 5/21/23.
//

import SwiftUI

enum ConverterType: String {
    case temperature, time, volume, length
    
    var displayName: String {
        self.rawValue.capitalized
    }
}

struct ContentView: View {
    
    init() {
        selectedConverter = .temperature
        selectedSourceUnit = UnitTemperature.celsius
        selectedDestinationUnit = UnitTemperature.fahrenheit
    }
    
    let converters: [ConverterType: [Dimension]] = [
        .length: [UnitLength.meters,
                  UnitLength.kilometers,
                  UnitLength.feet,
                  UnitLength.yards,
                  UnitLength.miles],
        
        .temperature: [UnitTemperature.celsius,
                      UnitTemperature.fahrenheit,
                      UnitTemperature.kelvin],
        
        .time: [UnitDuration.seconds,
                UnitDuration.minutes,
                UnitDuration.hours],
        
        .volume: [UnitVolume.milliliters,
                  UnitVolume.liters,
                  UnitVolume.gallons,
                  UnitVolume.cups,
                  UnitVolume.pints]]
    
    @State private var amount = 0.0
    @State private var selectedConverter: ConverterType
    @State private var selectedSourceUnit: Dimension
    @State private var selectedDestinationUnit: Dimension
    @FocusState private var amountIsFocused: Bool
        
    var units: [Dimension] {
        return converters[selectedConverter] ?? []
    }
    
    var result: Double {
        return Measurement(value: amount, unit: selectedSourceUnit).converted(to: selectedDestinationUnit).value
    }
    
    func resetDefaultDimensions() {
        switch selectedConverter {
        case .temperature:
            selectedSourceUnit = UnitTemperature.celsius
            selectedDestinationUnit = UnitTemperature.fahrenheit
        case .time:
            selectedSourceUnit = UnitDuration.hours
            selectedDestinationUnit = UnitDuration.seconds
        case .volume:
            selectedSourceUnit = UnitVolume.liters
            selectedDestinationUnit = UnitVolume.gallons
        case .length:
            selectedSourceUnit = UnitLength.miles
            selectedDestinationUnit = UnitLength.kilometers
        }
    }
    
    var body: some View {
        NavigationView() {
            Form() {
                Section {
                    Picker("Converter", selection: $selectedConverter) {
                        ForEach(Array(converters.keys), id: \.self) {
                            Text($0.displayName)
                        }
                    }
                    .onChange(of: selectedConverter) { c in
                        resetDefaultDimensions()
                    }
                } header: {
                    Text("Type of conversion")
                }

                Section() {
                    Picker("From", selection: $selectedSourceUnit) {
                        ForEach(units, id: \.self) {
                            Text($0.symbol)
                        }
                    }

                    Picker("To", selection: $selectedDestinationUnit) {
                        ForEach(units, id: \.self) {
                            Text($0.symbol)
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
                    Text(result.formatted(.number))

                } header: {
                    Text("Results")
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


