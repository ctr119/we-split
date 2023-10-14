import SwiftUI

struct ContentView: View {
    private enum Tip: Int, CaseIterable {
        case zero = 0
        case ten = 10
        case fifteen = 15
        case twenty = 20
        case twentyfive = 25
        
        var assignedColor: Color {
            switch self {
            case .zero:
                return .gray
                
            case .ten:
                return .cyan
                
            case .fifteen:
                return .mint
                
            case .twenty:
                return .green
                
            case .twentyfive:
                return .orange
            }
        }
        
        var promotionalText: String {
            switch self {
            case .zero:
                return "Ok... 🥲"
            case .ten:
                return "Nice! 🙂"
            case .fifteen:
                return "Cool! 😊"
            case .twenty:
                return "Great! 😍"
            case .twentyfive:
                return "Awesome! 🤩"
            }
        }
    }
    
    @FocusState private var amountIsFocused: Bool
    @State private var orderAmount: Double? = nil
    
    @State private var numberOfPeopleIndex: Int = 2
    
    @State private var tipPercentage: Tip = .twenty
    
    private var grandTotal: Double {
        guard let orderAmount else { return 0 }
        
        let tipSelection = Double(tipPercentage.rawValue)
        let tipValue = (tipSelection / 100) * orderAmount
        
        return orderAmount + tipValue
    }
    
    private var peopleCount: Int {
        numberOfPeopleIndex + 2
    }
    
    private var totalPerPerson: Double {
        return grandTotal / Double(peopleCount)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    amountTextField
                    peoplePicker
                }
                tipSection
                summarySection
            }
            .navigationTitle("We Split")
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
        Picker("Number of persons", selection: $numberOfPeopleIndex) {
            ForEach(2..<100) {
                Text("\($0) people")
            }
        }
    }
    
    private var tipSection: some View {
        Section {
            tipPicker
        } header: {
            Text("What about a tip?")
        } footer: {
            Text(tipPercentage.promotionalText)
        }
    }
    
    private var tipPicker: some View {
        Picker("Tip percentage", selection: $tipPercentage) {
            ForEach(Tip.allCases, id: \.self) {
                if $0 == .zero {
                    Text("None")
                } else {
                    Text("\($0.rawValue)%")
                }
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var summarySection: some View {
        Section {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(grandTotal,
                         format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
                    
                    Text("- total amount (incl. the tip)")
                        .font(.subheadline)
                        .fontWeight(.light)
                }
                
                Text("between \(peopleCount) persons")
                    .font(.subheadline)
                    .padding(.leading, 2)
            }
            .foregroundColor(.gray)
            .italic()
            
            Text(totalPerPerson,
                 format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
        } header: {
            Label {
                Text("Summary")
            } icon: {
                Image(systemName: "checkmark.seal")
                    .foregroundColor(tipPercentage.assignedColor)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
