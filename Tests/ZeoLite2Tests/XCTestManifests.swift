import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ZeoLite2Tests.allTests),
    ]
}
#endif
