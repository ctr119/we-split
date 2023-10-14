import SwiftUI

struct ContentView: View {
    @FocusState private var amountIsFocused: Bool
    @State private var orderAmount: Double? = nil
    
    @State private var numberOfPeopleIndex: Int = 2
    
    @State private var tipPercentage: Int = 20
    private let availableTipPercentages = [
        0, 10, 15, 20, 25
    ]
    
    private var grandTotal: Double {
        guard let orderAmount else { return 0 }
        
        let tipSelection = Double(tipPercentage)
        let tipValue = (tipSelection / 100) * orderAmount
        
        return orderAmount + tipValue
    }
    
    private var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeopleIndex + 2)
        
        return grandTotal / peopleCount
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    amountTextField
                    peoplePicker
                }
                
                Section("What about a tip?") {
                    tipPicker
                }
                
                summarySection
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
    
    private var amountTextField: some View {
        TextField("Amount to split",
                  value: $orderAmount,
                  format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
        .keyboardType(.decimalPad)
        .focused($amountIsFocused)
    }
    
    private var peoplePicker: some View {
        Picker("Number of people", selection: $numberOfPeopleIndex) {
            ForEach(2..<100) {
                Text("\($0) people")
            }
        }
    }
    
    private var tipPicker: some View {
        Picker("Tip percentage", selection: $tipPercentage) {
            ForEach(availableTipPercentages, id: \.self) {
                if $0 == 0 {
                    Text("None")
                } else {
                    Text("\($0)%")
                }
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var summarySection: some View {
        Section {
            Text(grandTotal,
                 format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
            .foregroundColor(.gray)
            
            Text(totalPerPerson,
                 format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
        } header: {
            Label {
                Text("Summary")
            } icon: {
                Image(systemName: "checkmark.seal")
                    .foregroundColor(tipPercentage == 0 ? .gray : .green)
            }
        }
    }
    
//    private var colorForTip: Color {
//
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
