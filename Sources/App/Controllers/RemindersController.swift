//
//  RemindersController.swift
//  remindersPackageDescription
//
//  Created by Marcus Reuber Almeida Moraes Silva on 05/11/17.
//

import Vapor
import FluentProvider

struct RemindersController {
    func addRoutes(to drop: Droplet) {
        let reminderGroup = drop.grouped("api","reminders")
        reminderGroup.post("create", handler: createReminder)
        reminderGroup.get(handler: allReminders)
        reminderGroup.get(Reminder.parameter, handler: getReminder)
        reminderGroup.get(Reminder.parameter, "user", handler: getReminderUser)
    }
    
    func createReminder(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        
        let reminder = try Reminder(json: json)
        try reminder.save()
        return "New Reminder Created"
    }
    
    func allReminders(_ req: Request) throws -> ResponseRepresentable {
        let reminders = try Reminder.all()
        return try reminders.makeJSON()
    }
    
    func getReminder(_ req: Request) throws -> ResponseRepresentable {
        let reminder = try req.parameters.next(Reminder.self)
        return reminder
    }
    
    func getReminderUser(_ req: Request) throws -> ResponseRepresentable {
        let reminder = try req.parameters.next(Reminder.self)
        guard let user = try reminder.user.get() else {
            throw Abort.notFound
        }
        return user
    }
}