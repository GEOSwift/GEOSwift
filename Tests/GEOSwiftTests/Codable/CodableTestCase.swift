import XCTest
import GEOSwift

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
class CodableTestCase: XCTestCase {
    var encoder: JSONEncoder!
    var decoder: JSONDecoder!

    override func setUp() {
        super.setUp()
        encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        decoder = JSONDecoder()
    }

    override func tearDown() {
        decoder = nil
        encoder = nil
        super.tearDown()
    }

    func verifyCodable<T>(with codable: T,
                          json: String,
                          file: StaticString = #file,
                          line: UInt = #line) where T: Codable & Equatable {

        // verify decoding

        do {
            let data = json.data(using: .utf8)!

            let actual = try decoder.decode(T.self, from: data)

            XCTAssertEqual(
                actual,
                codable,
                "Decoded \(String(describing: T.self)) does not match expected",
                file: file,
                line: line)
        } catch {
            XCTFail(
                "Caught unexpected error while decoding: \(error)",
                file: file,
                line: line)
        }

        // verify encoding

        do {
            let data = try encoder.encode(codable)

            XCTAssertEqual(
                String(data: data, encoding: .utf8)!,
                json,
                "Encoded \(String(describing: T.self)) does not match expected",
                file: file,
                line: line)
        } catch {
            XCTFail(
                "Caught unexpected error while encoding: \(error)",
                file: file,
                line: line)
        }
    }

    func verifyDecodable<T>(with decodableType: T.Type,
                            json: String,
                            expectedError: GEOSwiftError,
                            file: StaticString = #file,
                            line: UInt = #line) where T: Decodable {
        do {
            let data = json.data(using: .utf8)!

            _ = try decoder.decode(decodableType, from: data)

            XCTFail(
                "Expected decoding to throw \(expectedError)",
                file: file,
                line: line)
        } catch let error as GEOSwiftError {
            XCTAssertEqual(error, expectedError, file: file, line: line)
        } catch {
            XCTFail("Caught unexpected error: \(error)", file: file, line: line)
        }
    }
}
