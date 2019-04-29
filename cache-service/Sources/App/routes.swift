import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let cacheController = CacheController()
    router.get("cache", use: cacheController.index)
    router.get("cache", String.parameter, use: cacheController.fetch)
    router.post("cache", use: cacheController.create)
    router.delete("cache", Cache.parameter, use: cacheController.delete)
}
