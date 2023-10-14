import SwiftUI

struct Lab: View {
    @State private var tapCount = 0
    @State private var name = ""
    private let students = [
        "Harry Potter",
        "Ron Weasly",
        "Hermione Granger",
        "Draco Malfoy"
    ]
    @State private var selectedStudend = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Select your student", selection: $selectedStudend) {
                    ForEach(students, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Enter your name", text: $name)
                
                Button("Tap Count: \(tapCount)") {
                    self.tapCount += 1
                }
            }
            .navigationTitle("SwiftUI")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Lab_Previews: PreviewProvider {
    static var previews: some View {
        Lab()
    }
}
