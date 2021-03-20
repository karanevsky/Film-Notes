import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Frame.entity(), sortDescriptors: []) var frames: FetchedResults<Frame>
    
    @Environment(\.presentationMode) private var presentationMode    
        
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(frames, id: \.self) { frame in
                        VStack(alignment: .leading) {
                            Text("\(frame.aperture ?? "Aperture") · \(frame.speed ?? "Speed")")
                                .font(.headline)
                            
                            Text("\(frame.note ?? "Note")")
                                .font(.subheadline)
                            
                        }
                        .padding(.top, 6.0)
                        .padding(.bottom, 9.0)
                        
                    }
                    .onDelete(perform: deleteFrame)
                }
                
                .navigationBarTitle("\(frames.count) frames", displayMode: .inline)
                
                .navigationBarItems(
                    leading:
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Close")
                                .fontWeight(.regular)
                        },
                    trailing:
                        Button(action: {
                            deteteAllFrames()
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Delete All")
                                .foregroundColor(Color.red)
                        }
                )
            }
        }
    }
    
    func deleteFrame(at offsets: IndexSet) {
        for offset in offsets {
            let frame = frames[offset]
            moc.delete(frame)
        }
        try? moc.save()
    }
    
    func deteteAllFrames() {
        for _ in frames {
            let frame = frames[0]
            moc.delete(frame)
            try? moc.save()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
