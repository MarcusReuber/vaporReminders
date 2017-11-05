//
//  CategoriesController.swift
//  remindersPackageDescription
//
//  Created by Marcus Reuber Almeida Moraes Silva on 05/11/17.
//

import Vapor
import FluentProvider

struct CategoriesController {
    func addRoutes(to droplet: Droplet) {
        let categoryGroup = droplet.grouped("api", "categories")
        categoryGroup.get(handler: allCategries)
        categoryGroup.post("create", handler: createCategory)
        categoryGroup.get(Category.parameter, handler: getCategory)
        categoryGroup.get(Category.parameter, "reminders", handler: getCategoryReminders)
    }
    
    func createCategory(_ req: Request) throws ->  ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        let category = try Category(json: json)
        try category.save()
        return category
    }
    
    func allCategries(_ req: Request) throws -> ResponseRepresentable {
        let categories = try Category.all()
        return try categories.makeJSON()
    }
    
    func getCategory(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.parameters.next(Category.self)
        return category
    }
    
    func getCategoryReminders(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.parameters.next(Category.self)
        return try category.reminders.all().makeJSON()
    }
}
