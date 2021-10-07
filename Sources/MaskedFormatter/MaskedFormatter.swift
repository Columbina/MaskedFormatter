import Foundation

class MaskedFormatter: Formatter {
    struct Rule {
        let maskCharacter: Character
        let validation: (Character) -> Bool
    }

    let mask: String

    // Save rules by maskedChar so we have O(1) access
    var rules = [Character: Rule]()

    init(mask: String, rules: [Rule]) {
        self.mask = mask

        super.init()

        rules.forEach { self.rules[$0.maskCharacter] = $0 }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func string(for obj: Any?) -> String? {
        if let string = obj as? String {
            return formattedAddress(text: string)
        }
        return nil
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String,
                                 errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string as AnyObject?
        return true
    }

    func formattedAddress(text: String?) -> String? {
        guard let text = text else { return nil }
        let textArray = Array(text)
        let mask = Array(mask)
        var result = ""

        var i = 0
        var j = 0

        while i < mask.count && j < text.count {
            if j >= text.count { break }
            let maskChar = mask[i]
            let textChar = textArray[j]

            if isValidInput(textChar, for: maskChar) {
                result += String(textChar)
                j += 1
            }
            else if isValidMaskCharacter(maskChar) {
                j += 1
                continue
            }
            else if maskChar == textChar {
                result += String(maskChar)
                j += 1
            } else {
                result += String(maskChar)
            }
            i += 1
        }

        return result
    }

    private func isValidMaskCharacter(_ maskChar: Character) -> Bool {
        rules[maskChar] != nil
    }

    private func isValidInput(_ inputChar: Character, for maskChar: Character) -> Bool {
        guard let rule = rules[maskChar] else { return false }
        return rule.validation(inputChar)
    }
}
