//
//  ContentView.swift
//  Convertr
//
//  Created by Dominik Hofer on 05.07.22.
//

import SwiftUI

struct ContentView: View {
    let units = ["m", "km", "ft", "yd", "mi"]
    
    @FocusState private var numberIsFocused: Bool
    @State private var input: Double = 0
    @State private var fromUnit = "m"
    @State private var toUnit = "km"
    
    var convertToM: Double {
        switch fromUnit {
        case "km":
            return input * 1000
        case "ft":
            return input / 3.281
        case "yd":
            return input / 1.094
        case "mi":
            return input * 1609
        default:
            return input
        }
    }
    
    var convertToUnit: Double {
        switch toUnit {
        case "km":
            return convertToM / 1000
        case "ft":
            return convertToM * 3.281
        case "yd":
            return convertToM * 1.094
        case "mi":
            return convertToM / 1609
        default:
            return convertToM
        }
    }
    
    var result: String {
        return convertToUnit.formatted()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Number", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($numberIsFocused)
                } header: {
                    Text("Enter the number you want to convert:")
                }
                
                Section {
                    Picker("From:", selection: $fromUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("To:", selection: $toUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Choose your units to convert:")
                }
                
                Section {
                    Text(result)
                } header: {
                    Text("Result in \(toUnit):")
                }
            }
            .navigationTitle("Convertr")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        numberIsFocused = false
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
