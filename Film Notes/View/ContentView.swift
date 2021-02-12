
import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @FetchRequest(entity: Frame.entity(), sortDescriptors: []) var frames: FetchedResults<Frame>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var aperture = "5.6"
    @State private var speed = "60"
    @State private var note = ""
    
    @State var showingList = false
        
    let apertures = ["1.8", "2.8", "4", "5.6", "8", "11", "16"]
    let speeds = ["B", "1", "2", "4", "8", "15", "30", "60", "125", "250", "500", "1000"]    
        
    let generator = UINotificationFeedbackGenerator()
            
    var body: some View {
        NavigationView {
            VStack {
                TextField("Note", text: $note)
                    .font(.title2)
                    .padding(.horizontal, 20)
                    
                Spacer()
                                                            
                Picker("Aperture", selection: $aperture) {
                    ForEach(apertures, id: \.self) {
                        Text($0)
                    }
                }
                .padding(.horizontal, 12.0)
                                    
                Picker("Speed", selection: $speed) {
                    ForEach(speeds, id: \.self) {
                        Text($0)
                    }
                }
                .padding(.horizontal, 12.0)
                .padding(.bottom, 40.0)
                                
                HStack (alignment: .center) {
                    Button(action: {
                        let newFrame = Frame(context: self.moc)
                        newFrame.aperture = self.aperture
                        newFrame.speed = self.speed
                        newFrame.note = self.note
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                        self.generator.notificationOccurred(.success)
                    }) {
                        Text("Add Frame")
                            .fontWeight(.medium)
                            
                    }
                    .buttonStyle(FilledButton())
                }
                .padding([.horizontal], 20)
                .padding(.bottom, 10)
                                                                        
                .navigationBarTitle(Text("f \(aperture) · s \(speed)"))
                
                .navigationBarItems(trailing:
                    Button(action: {
                        self.showingList.toggle()
                    }) {
                        Text("\(frames.count) frames")
                    }
                    .sheet(isPresented: $showingList) {
                        ListView()
                    }
                )
            }
            .keyboardAdaptive()
        }
    }
}

struct FilledButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.8) : .white)
            .background(configuration.isPressed ? Color.accentColor.opacity(0.5) : Color.accentColor)
            .cornerRadius(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
