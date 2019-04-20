import FluentSQLite
import Vapor

/// A single entry of a Cache list.
final class Cache: SQLiteModel {
    /// The unique identifier for this `Cache`.
    var id: Int?

    var key: String

    var value: String

    var expiry: Int

    /// Creates a new `Cache`.
    init(id: Int? = nil, key: String, value: String, expiry: Int) {
        self.id = id
        self.key = key
        self.value = value
        self.expiry = expiry
    }
}

/// Allows `Cache` to be used as a dynamic migration.
extension Cache: Migration { }

/// Allows `Cache` to be encoded to and decoded from HTTP messages.
extension Cache: Content { }

/// Allows `Cache` to be used as a dynamic parameter in route definitions.
extension Cache: Parameter { }
