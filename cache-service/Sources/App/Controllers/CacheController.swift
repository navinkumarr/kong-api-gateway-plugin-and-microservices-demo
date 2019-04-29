import FluentSQLite
import Vapor

/// Controls basic CRUD operations on `Cache`s.
final class CacheController {
    /// Returns a list of all `Cache`s.
    func index(_ req: Request) throws -> Future<[Cache]> {
        let timestamp = Int(NSDate().timeIntervalSince1970)
        return Cache.query(on: req).filter(\.expiry > timestamp).all()
    }

    func fetch(_ req: Request) throws -> Future<[Cache]> {
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let cacheKey = try req.parameters.next(String.self)
        return Cache.query(on: req).filter(\.expiry > timestamp)
                .filter(\.key == String(cacheKey)).all()
    }

    /// Saves a decoded `Cache` to the database.
    func create(_ req: Request) throws -> Future<Cache> {
        return try req.content.decode(Cache.self).flatMap { cache in
            return cache.save(on: req)
        }
    }

    /// Deletes a parameterized `Cache`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Cache.self).flatMap { cache in
            return cache.delete(on: req)
        }.transform(to: .ok)
    }
}
