import XCTest
@testable import ZeoLite2

final class ZeoLite2Tests: XCTestCase {
    var database: ZeoLite2!
    
    override func setUp() {
        super.setUp()
        database = ZeoLite2("./Tests/ZeoLite2Tests/GeoLite2-Country.mmdb")
    }

    func testLookup() {
        XCTAssertEqual(database.lookup("202.108.22.220")?.isoCode, "CN")
    }

    func testCloudFlare() {
        let cloudflareDNS = database.lookup("1.1.1.1")
        XCTAssertNotNil(cloudflareDNS)
    }

    static var allTests = [
        ("testLookup", testLookup),
        ("testCloudFlare", testCloudFlare),
    ]
}
