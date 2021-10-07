import XCTest
@testable import MaskedFormatter

final class MaskedFormatterTests: XCTestCase {
    
    func test_EmptyInput() throws {
        let input = ""
        let mask = "##"

        let rules = [
            MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber })
        ]

        let formatter = MaskedFormatter(mask: mask, rules: rules)
        
        XCTAssertEqual(formatter.string(for: input), "")
    }
    
    func test_SingleRule() throws {
        let input = "12"
        let mask = "##"

        let rules = [
            MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber })
        ]

        let formatter = MaskedFormatter(mask: mask, rules: rules)
        
        XCTAssertEqual(formatter.string(for: input), "12")
    }
    
    func test_MultipleRules_ValidInput() throws {
        let input = "12AB"
        let mask = "##-$$"

        let rules = [
            MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber }),
            MaskedFormatter.Rule(maskCharacter: "$", validation: { $0.isLetter }),
        ]

        let formatter = MaskedFormatter(mask: mask, rules: rules)
        
        XCTAssertEqual(formatter.string(for: input), "12-AB")
    }
    
    func test_MultipleRules_InvalidInput() throws {
        let input = "1234"
        let mask = "##-$$"

        let rules = [
            MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber }),
            MaskedFormatter.Rule(maskCharacter: "$", validation: { $0.isLetter }),
        ]

        let formatter = MaskedFormatter(mask: mask, rules: rules)
        
        XCTAssertEqual(formatter.string(for: input), "12-")
    }
    
    func test_OnlyNumbersInput_FullInput_UsingSpecialCharactersInMask() throws {
        let input = "1234"
        let mask = "##-##"

        let rules = [
            MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber })
        ]

        let formatter = MaskedFormatter(mask: mask, rules: rules)
        
        XCTAssertEqual(formatter.string(for: input), "12-34")
    }
    
    func test_OnlyNumbersInput_FullInput_WithValidCharacter_UsingSpecialCharactersInMask() throws {
        let input = "12.34"
        let mask = "##-##"

        let rules = [
            MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber })
        ]

        let formatter = MaskedFormatter(mask: mask, rules: rules)
        
        XCTAssertEqual(formatter.string(for: input), "12-34")
    }
    
    func test_OnlyNumbersInput_FullInput_WithInvalidCharacter_UsingSpecialCharactersInMask() throws {
        let input = "12-34"
        let mask = "##-##"

        let rules = [
            MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber })
        ]

        let formatter = MaskedFormatter(mask: mask, rules: rules)
        
        XCTAssertEqual(formatter.string(for: input), "12-34")
    }
    
    func test_OnlyNumbersInput_HalfInput_UsingSpecialCharactersInMask() throws {
        let input = "12"
        let mask = "##-##"

        let rules = [
            MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber })
        ]

        let formatter = MaskedFormatter(mask: mask, rules: rules)
        
        XCTAssertEqual(formatter.string(for: input), "12")
    }
    
    func test_OnlyNumbersInput_MissingLastInput_UsingSpecialCharactersInMask() throws {
        let input = "123"
        let mask = "##-##"

        let rules = [
            MaskedFormatter.Rule(maskCharacter: "#", validation: { $0.isNumber })
        ]

        let formatter = MaskedFormatter(mask: mask, rules: rules)
        
        XCTAssertEqual(formatter.string(for: input), "12-3")
    }
}
