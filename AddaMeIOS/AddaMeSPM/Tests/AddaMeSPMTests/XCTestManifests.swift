import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AddaMeSPMTests.allTests),
    ]
}
#endif
