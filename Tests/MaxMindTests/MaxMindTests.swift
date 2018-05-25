import XCTest
@testable import MaxMind

final class MaxMindTests: XCTestCase {
    var database: MaxMind!
    
    override func setUp() {
        super.setUp()
        database = MaxMind("./Tests/MaxMindTests/GeoLite2-Country.mmdb")
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
