//
//  TextAlert.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 24/01/2022.
//

import SwiftUI
import UIKit

extension UIAlertController {
    convenience init(alert: TextAlert) {
        self.init(title: alert.title, message: alert.message, preferredStyle: .alert)
        addTextField {
            $0.placeholder = alert.placeholder1
            $0.text = alert.initialText
        }
        addTextField {
            $0.placeholder = alert.placeholder2
            if let double: Double = alert.initialDouble {
                $0.text = String(format: "%.2f", double)
            }
        }
        let textField1 = self.textFields?.first
        let textField2 = self.textFields?.last
        textField2?.keyboardType = .decimalPad
        
        addAction(UIAlertAction(title: alert.cancel, style: .cancel) { _ in
            alert.action(nil, nil)
        })

        func double() -> Double? {
                let doubleText = textField2?.text
                if !(doubleText == nil) {
                    return Double(doubleText!.replacingOccurrences(of: ",", with: "."))
                } else {
                    return nil
                }
        }
        
        addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
            alert.action(textField1?.text, double())
        })
        
        // On appearance of the popup (before any modifications)
        self.actions.last?.isEnabled = false
        
        // Observe the UITextFieldTextDidChange notification to be notified in the below block when text is changed
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField1, queue: OperationQueue.main, using:
            {_ in
                // Being in this block means that something fired the UITextFieldTextDidChange notification.
                
                // Access the textField object from alertController.addTextField(configurationHandler:) above and get the character count of its non whitespace characters
                let textCount1 = textField1!.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty1 = textCount1 > 0
                let textCount2 = textField2!.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty2 = textCount2 > 0
                
                // If the text contains non whitespace characters, enable the OK Button
                self.actions.last?.isEnabled = textIsNotEmpty1 && textIsNotEmpty2
        })
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField2, queue: OperationQueue.main, using:
            {_ in
                // Being in this block means that something fired the UITextFieldTextDidChange notification.
                
                // Access the textField object from alertController.addTextField(configurationHandler:) above and get the character count of its non whitespace characters
                let textCount1 = textField1!.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty1 = textCount1 > 0
                let textCount2 = textField2!.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty2 = textCount2 > 0
                
                // If the text contains non whitespace characters, enable the OK Button
                self.actions.last?.isEnabled = textIsNotEmpty1 && textIsNotEmpty2
        })
    }
}



struct AlertWrapper<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let alert: TextAlert
    let content: Content
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWrapper>) -> UIHostingController<Content> {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color.accentColor)
        return UIHostingController(rootView: content)
    }
    
    final class Coordinator {
        var alertController: UIAlertController?
        init(_ controller: UIAlertController? = nil) {
            self.alertController = controller
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: UIViewControllerRepresentableContext<AlertWrapper>) {
        uiViewController.rootView = content
        if isPresented && uiViewController.presentedViewController == nil {
            var alert = self.alert
            alert.action = {
                self.isPresented = false
                self.alert.action($0,$1)
            }
            context.coordinator.alertController = UIAlertController(alert: alert)
            uiViewController.present(context.coordinator.alertController!, animated: true)
        }
        if !isPresented && uiViewController.presentedViewController == context.coordinator.alertController {
            uiViewController.dismiss(animated: true)
        }
    }
}

public struct TextAlert {
    public var title: String
    public var message: String
    public var placeholder1: String = ""
    public var placeholder2: String = ""
    public var initialText: String?
    public var initialDouble: Double?
    public var accept: String = "OK"
    public var cancel: String = "Cancel"
    public var action: (String?, Double?) -> ()
}

extension View {
    public func alert(isPresented: Binding<Bool>, _ alert: TextAlert) -> some View {
        AlertWrapper(isPresented: isPresented, alert: alert, content: self)
    }
}

struct TextAlertView: View {
    @State var showsAlert = false
    
    @State var name = "Potato Wedges"
    @State var price: Double = 2.35
    
    var body: some View {
        VStack {
            Text("Item: \(name)")
            Text("Price: \(price)")
                .padding()
            Button("Alert") {
                self.showsAlert = true
            }
        }
        .alert(isPresented: $showsAlert, TextAlert(title: "New item",
                                                   message:"Please enter item name and price",
                                                   placeholder1: "Name",
                                                   placeholder2: "Price",
                                                   initialText: name,
                                                   initialDouble: price,
                                                   action: {
                                                        name = $0==nil ? self.name : ($0!=="" ? self.name : $0!)
                                                        price = $1 ?? self.price
                                                    }))
    }
}

struct TextAlertView_Previews: PreviewProvider {
    static var previews: some View {
        TextAlertView()
    }
}
