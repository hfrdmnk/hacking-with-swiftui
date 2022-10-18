//
//  ContentView.swift
//  rolli
//
//  Created by Dominik Hofer on 16.10.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel(dice: Dice())
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Text(viewModel.dice.currentValue)
                            .font(.largeTitle.bold())
                    }
                    
                    Button("Roll ma dice!") {
                        viewModel.rollDice()
                    }
                    .buttonStyle(.bordered)
                    .tint(.indigo)
                }
                
                
                VStack {
                    Spacer()
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<viewModel.dice.results.count, id: \.self) { index in
                                Text(String(viewModel.dice.results[index]))
                                    .padding()
                                    .bold()
                                    .foregroundColor(.indigo)
                                    .background(Color(hue: 0.70, saturation: Double(index).interpolated(from: 0...Double(viewModel.dice.results.count - 1), to: 0...1, reverseTo: true), brightness: 1).opacity(0.25))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Rolli")
            .toolbar {
                ToolbarItem {
                    Button {
                        viewModel.showingConfirmationDialog = true
                    } label: {
                        Label("Change dice", systemImage: "dice")
                            .foregroundColor(.indigo)
                    }
                }
            }
            .confirmationDialog("Change dice", isPresented: $viewModel.showingConfirmationDialog) {
                Button("4 sides") {
                    viewModel.dice = Dice(diceType: .four)
                }
                
                Button("6 sides") {
                    viewModel.dice = Dice(diceType: .six)
                }
                
                Button("8 sides") {
                    viewModel.dice = Dice(diceType: .eight)
                }
                
                Button("10 sides") {
                    viewModel.dice = Dice(diceType: .ten)
                }
                
                Button("12 sides") {
                    viewModel.dice = Dice(diceType: .twelve)
                }
                
                Button("20 sides") {
                    viewModel.dice = Dice(diceType: .twenty)
                }
                
                Button("100 sides") {
                    viewModel.dice = Dice(diceType: .hundred)
                }
            } message: {
                Text("Change dice. This will reset all results.")
            }
        }
    }
}

extension FloatingPoint {
  /// Allows mapping between reverse ranges, which are illegal to construct (e.g. `10..<0`).
  func interpolated(
    fromLowerBound: Self,
    fromUpperBound: Self,
    toLowerBound: Self,
    toUpperBound: Self) -> Self
  {
    let positionInRange = (self - fromLowerBound) / (fromUpperBound - fromLowerBound)
    return (positionInRange * (toUpperBound - toLowerBound)) + toLowerBound
  }

    func interpolated(from: ClosedRange<Self>, to: ClosedRange<Self>, reverseTo: Bool = false) -> Self {
        if !reverseTo {
            return interpolated(
              fromLowerBound: from.lowerBound,
              fromUpperBound: from.upperBound,
              toLowerBound: to.lowerBound,
              toUpperBound: to.upperBound)
        } else {
            return interpolated(
              fromLowerBound: from.lowerBound,
              fromUpperBound: from.upperBound,
              toLowerBound: to.upperBound,
              toUpperBound: to.lowerBound)
        }
    
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
