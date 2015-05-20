import UIKit
import Interstellar

var TextSignalHandle: UInt8 = 0
var TypingSignalHandle: UInt8 = 0
extension UITextField: UITextFieldDelegate {
    public var textSignal: Signal<String> {
        let signal: Signal<String>
        if let handle = objc_getAssociatedObject(self, &TextSignalHandle) as? Signal<String> {
            signal = handle
        } else {
            signal = Signal("")
            delegate = self
            objc_setAssociatedObject(self, &TextSignalHandle, signal, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
        return signal
    }
    
    public var typingSignal: Signal<String> {
        let signal: Signal<String>
        if let handle = objc_getAssociatedObject(self, &TypingSignalHandle) as? Signal<String> {
            signal = handle
        } else {
            signal = Signal("")
            delegate = self
            objc_setAssociatedObject(self, &TypingSignalHandle, signal, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
        return signal
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        typingSignal.update(.Success(Box(text)))
        return true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        textSignal.update(.Success(Box(text)))
    }
}
