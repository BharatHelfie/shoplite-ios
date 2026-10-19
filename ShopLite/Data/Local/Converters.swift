import Foundation

struct Converters {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func fromStringList(_ value: [String]?) -> String? {
        String(decoding: try! encoder.encode(value), as: UTF8.self)
    }

    func toStringList(_ value: String?) -> [String]? {
        guard let value else { return nil }
        return try! decoder.decode([String]?.self, from: Data(value.utf8))
    }

    func fromReviews(_ value: [Review]?) -> String? {
        String(decoding: try! encoder.encode(value), as: UTF8.self)
    }

    func toReviews(_ value: String?) -> [Review]? {
        guard let value else { return nil }
        return try! decoder.decode([Review]?.self, from: Data(value.utf8))
    }
}
