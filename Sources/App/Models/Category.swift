import FluentProvider

final class Category: Model {
    //sets the table name, instead of using the automatic generated name "categorys"
    static let entity = "categories"
    
    let storage = Storage()
    
    let name: String
    
    struct Properties {
        static let id = "id"
        static let name = "name"
    }
    
    init(name: String) {
        self.name = name
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Properties.name,name)
        return row
    }
    
    init(row: Row) throws {
        name = try row.get(Properties.name)
    }
    
    static func addCategory(name: String, to reminder: Reminder) throws {
        var category: Category
        
        let foundCategory = try Category.makeQuery().filter(Properties.name, name).first()
        
        if let existingCategory = foundCategory {
            category = existingCategory
        }else {
            category = Category(name: name)
            try category.save()
        }
        
        try category.reminders.add(reminder)
    }
}

extension Category: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Properties.name)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Category: JSONConvertible {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Properties.id, id)
        try json.set(Properties.name, name)
        return json
    }
    
    convenience init(json: JSON) throws {
        try self.init(name: json.get(Properties.name))
    }
}

extension Category: ResponseRepresentable {}

extension Category {
    var reminders: Siblings<Category, Reminder, Pivot<Category, Reminder>> {
        return siblings()
    }
}
