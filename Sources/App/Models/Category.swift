import FluentProvider

final class Category: Model {
    //sets the table name, instead of using the automatic generated name "categorys"
    static let entity = "categories"
    
    let storage = Storage()
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name",name)
        return row
    }
    
    init(row: Row) throws {
        name = try row.get("name")
    }
}

extension Category: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("name")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Category: JSONConvertible {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        return json
    }
    
    convenience init(json: JSON) throws {
        try self.init(name: json.get("name"))
    }
}

extension Category: ResponseRepresentable {}

extension Category {
    var reminders: Siblings<Category, Reminder, Pivot<Category, Reminder>> {
        return siblings()
    }
}
