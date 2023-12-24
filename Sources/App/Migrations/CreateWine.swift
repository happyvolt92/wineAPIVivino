import Fluent

struct CreateWine: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("wine")
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("wine").delete()
    }
}
