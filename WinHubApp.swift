import SwiftUI
import UniformTypeIdentifiers

@main
struct WinHubApp: App {
    var body: some Scene {
        WindowGroup {
            WinHubMainView()
        }
    }
}

struct WinHubMainView: View {
    @State private var isImporting = false
    @State private var importedFileName = "No Environment Loaded"
    @State private var isGameRunning = false
    
    var body: some View {
        ZStack {
            // Background: Windows style environment
            Color.black.ignoresSafeArea()
            
            if isGameRunning {
                // গেম শুরু হলে কন্ট্রোলার দেখাবে
                GameOverlayView(fileName: importedFileName) {
                    isGameRunning = false
                }
            } else {
                // হোম স্ক্রিন: ফাইল ইম্পোর্ট করার অপশন
                VStack(spacing: 30) {
                    Text("Win Game Hub - Pro Max")
                        .font(.largeTitle.bold())
                        .foregroundColor(.blue)
                    
                    Text("Status: \(importedFileName)")
                        .foregroundColor(.white.opacity(0.7))
                    
                    Button(action: { isImporting = true }) {
                        HStack {
                            Image(systemName: "plus.rectangle.on.folder")
                            Text("Import Windows File (.exe / .iso)")
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    if importedFileName != "No Environment Loaded" {
                        Button(action: { isGameRunning = true }) {
                            Text("Launch Environment")
                                .padding()
                                .frame(width: 200)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isImporting) {
            DocumentPicker(fileContent: $importedFileName)
        }
    }
}

// MARK: - Document Picker Logic
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var fileContent: String
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        // এখানে আপনি নির্দিষ্ট ফাইল ফরম্যাট সিলেক্ট করতে পারেন
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        init(_ parent: DocumentPicker) { self.parent = parent }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            // ফাইল ইম্পোর্ট সফল হলে নাম আপডেট হবে
            parent.fileContent = url.lastPathComponent
        }
    }
}

// MARK: - Game Controller Overlay
struct GameOverlayView: View {
    let fileName: String
    var onExit: () -> Void
    
    var body: some View {
        ZStack {
            // গেম এরিয়া (এখানে এমুলেটর কোড বসবে)
            Color.darkGray
                .overlay(Text("Running: \(fileName)").foregroundColor(.white.opacity(0.3)))
            
            VStack {
                HStack {
                    Button("Exit", action: onExit)
                        .padding().background(Color.red).foregroundColor(.white).cornerRadius(8)
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                HStack {
                    // Joystick
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .overlay(Circle().fill(.white).frame(width: 50, height: 50))
                        .padding(.leading, 40)
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: 15) {
                        Circle().fill(.blue).frame(width: 60, height: 60).overlay(Text("X"))
                        HStack {
                            Circle().fill(.yellow).frame(width: 60, height: 60).overlay(Text("Y"))
                            Circle().fill(.red).frame(width: 60, height: 60).overlay(Text("B"))
                        }
                        Circle().fill(.green).frame(width: 60, height: 60).overlay(Text("A"))
                    }
                    .padding(.trailing, 40)
                }
                .padding(.bottom, 30)
            }
        }
        .ignoresSafeArea()
    }
}

extension Color {
    static let darkGray = Color(white: 0.1)
}
