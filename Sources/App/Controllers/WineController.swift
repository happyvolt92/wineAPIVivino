import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let wines = routes.grouped("wine")
        wines.get(use: index)
        wines.post(use: create)
        wines.group(":wineID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [Wine] {
        try await Wine.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Wine {
        let wine = try req.content.decode(Wine.self)
        try await wine.save(on: req.db)
        return wine
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let wine = try await Wine.find(req.parameters.get("wineID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await wine.delete(on: req.db)
        return .noContent
    }
}
