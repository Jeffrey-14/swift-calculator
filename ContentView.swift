 ContentView.swift
//  MyCalculatorApp
//
//  Created by Jeffrey on 06/7/25.
//  updated on 08/03/25
//
import SwiftUI

struct ContentView: View {
    @State public var displayText = "0"
    @State public var currentInput = ""
    @State public var storedValue: Double? = nil
    @State public var currentOperator: String?
    @State public var isNewCalculation = false

    var body: some View {
        VStack(spacing: 10) {
            Text(displayText)
                .font(.system(size: 80))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)

            VStack(spacing: 10) {
                HStack {
                    Button(action: clearButton) {
                        Text("AC")
                            .frame(width: 80, height: 80)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .font(.title)
                            .cornerRadius(40)
                    }
                    Spacer()
                }
                
                CalculatorButtonRow(buttons: ["7", "8", "9", "÷"], action: buttonTap)
                CalculatorButtonRow(buttons: ["4", "5", "6", "×"], action: buttonTap)
                CalculatorButtonRow(buttons: ["1", "2", "3", "-"], action: buttonTap)
                CalculatorButtonRow(buttons: ["0", ".", "=", "+"], action: buttonTap)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    func buttonTap(_ button: String) {
        switch button {
        case "+", "-", "×", "÷":
            if !currentInput.isEmpty, let value = Double(currentInput) {
                storedValue = value
                currentInput = ""
                currentOperator = button
                displayText = button
                isNewCalculation = false
            }
            
        case "=":
            guard let operatorType = currentOperator,
                  let stored = storedValue,
                  let current = Double(currentInput) else { return }
            
            let result: Double
            switch operatorType {
            case "+": result = stored + current
            case "-": result = stored - current
            case "×": result = stored * current
            case "÷":
                if current == 0 {
                    displayText = "Error"
                    currentInput = ""
                    storedValue = nil
                    currentOperator = nil
                    return
                }
                result = stored / current
            default: return
            }
            
            displayText = formatResult(result)
            currentInput = displayText
            storedValue = nil
            currentOperator = nil
            isNewCalculation = true
            
        case ".":
            if !currentInput.contains(".") {
                currentInput += currentInput.isEmpty ? "0." : "."
                displayText = currentInput
            }
            
        default: // Numbers
            if isNewCalculation {
                
                currentInput = button
                storedValue = nil
                currentOperator = nil
                isNewCalculation = false
            } else {
                currentInput += button
            }
            displayText = currentInput
        }
    }
    
    func clearButton() {
        currentInput = ""
        storedValue = nil
        currentOperator = nil
        displayText = "0"
    }
    
    private func formatResult(_ result: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.minimumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: result)) ?? String(result)
    }
}

struct CalculatorButtonRow: View {
    let buttons: [String]
    let action: (String) -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(buttons, id: \.self) { button in
                Button(action: {
                    action(button)
                }) {
                    Text(button)
                        .frame(width: 80, height: 80)
                        .background(button.isOperator ? Color.orange : Color.blue)
                        .foregroundColor(.white)
                        .font(.title)
                        .cornerRadius(40)
                }
            }
        }
    }
}

extension String {
    var isOperator: Bool {
        return ["+", "-", "×", "÷", "="].contains(self)
    }
}

#Preview {
    ContentView()
}
