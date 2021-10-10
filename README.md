# Columbina's Masked Formatter

A fully customizable formatter used to create masks for texts.

```swift
let mask = "##/$$-@@"

let rules = [
    MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber }),
    MaskedFormatter.Rule(maskCharacter: "$", validation: { $0.isLetter }),
    MaskedFormatter.Rule(maskCharacter: "@", validation: { (Int(String($0)) ?? 0) >= 5 })
]

let maskedFormatter = MaskedFormatter(mask: mask, rules: rules)

let input = "123ABC456"
let output = maskedFormatter.string(for: input)

print(output!)
// "12/AB-56"
```


## Quick start

### 1. Import the module
```swift
import MaskedFormatter
```

### 2. Define a mask
For instance, an "expiration date" mask, commonly used for credit card forms, can be defined as such:
```swift
let mask = "##/##"
```

### 3. Define the rules
Using the same example for an "expiration date" mask, this is how our rule would look like:
```swift
let rule = MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber })
```

### 4. Initiate a MaskedFormatter
```swift
let maskedFormatter = MaskedFormatter(mask: mask, rules: [rule])
```

### 5. Apply formatter
```swift
let input = "1234"
let output = maskedFormatter.string(for: input)
print(output!)
// "12/34"
```

## Tips

### Create your own formatters
For instance, by inheriting MaskedFormatter:

```swift
class CreditCardFormatter: MaskedFormatter {
    init() {
        let mask = "#### #### #### ####"
        let rule = MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber })
        super.init(mask: mask, rules: [rule])
    }
    ...
}
```

### Apply to UITextField
Mask a UITextField in "realtime" by listening to changes in the textfield:
```swift
let textField = UITextField()
textField.addTarget(self, 
                    action: #selector(textFieldDidChange(_:)),
                    for: .editingChanged)

...
@objc func textFieldDidChange(_ textField: UITextField) {
    textField.text = maskedFormatter.string(for: textField.text)
}
```

### Apply to SwiftUI's TextField
Mask a TextField in "realtime" through `onChange`:
```swift
@State var text: String
...
TextField(placeholder, text: $text)
    .onChange(of: text) { value in
        text = maskedFormatter.string(for: text) ?? ""
    }
```

## More details

### Rule
```swift
MaskedFormatter.Rule(maskCharacter: Character, validation: @escaping (Character) -> Bool)
```
Rules will tell the formatter which characters from the mask are supposed to be replaced by what (letter, number, etc)
In our "expiration date" mask example (`##/##`), we have two different characters, `#` and `/`.  We want to replace `#`, thus we will create a rule for that character.

```swift
MaskedFormatter.Rule(maskCharacter: "#", validation: { ... })
```

In order to tell which input is valid for that specific character, we use the validation parameter. This parameter receives a **Character** and returns a **Bool**:
```swift
MaskedFormatter.Rule(maskCharacter: "#", validation: { (char: Character) -> Bool in
    ...
})
```
In our example, we want the `#` character to be replaced by a number, so we can check `char` and see if it is a number: 

```swift
MaskedFormatter.Rule(maskCharacter: "#", validation: { (char: Character) -> Bool in
    char.isNumber
})
```
Now we can use this rule in one or more MaskedFormatters:

```swift
let rule = MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber })
let formatter1 = MaskedFormatter(mask: "##", rules: [rule])
let formatter2 = MaskedFormatter(mask: "#/#", rules: [rule])
```
