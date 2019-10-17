import XCTest
@testable import GEOSwift

class GEOSContextTestCase: XCTestCase {

    var context: GEOSContext!

    override func setUp() {
        super.setUp()
        do {
            context = try GEOSContext()
        } catch {
            continueAfterFailure = false
            XCTFail("Unable to create context: \(error)")
        }
    }

    override func tearDown() {
        context = nil
        super.tearDown()
    }

    typealias GEOSObjectCompatible = Equatable & GEOSObjectConvertible & GEOSObjectInitializable

    func verifyRoundtripToGEOS<T>(value: T,
                                  file: StaticString = #file,
                                  line: UInt = #line) where T: GEOSObjectCompatible {

        do {
            let geosObject = try value.geosObject(with: context)
            let otherValue = try T(geosObject: geosObject)
            XCTAssertEqual(value, otherValue, file: file, line: line)
        } catch {
            XCTFail("Error while round-tripping to GEOS: \(error)", file: file, line: line)
        }
    }
}
