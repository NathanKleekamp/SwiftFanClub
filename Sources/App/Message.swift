//
//  Message.swift
//  App
//
//  Created by Nathan Kleekamp on 3/18/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct Message: Content, SQLiteModel, Migration {
  var id: Int?
  var forum: Int
  var title: String
  var body: String
  var parent: Int
  var user: String
  var date: Date
  var slug: String

  init(id: Int, forum: Int, title: String, body: String, parent: Int, user: String, date: Date) {
    self.id = id
    self.forum = forum
    self.title = title
    self.body = body
    self.parent = parent
    self.user = user
    self.date = date
    self.slug = title.lowercased().split(separator: " ").joined(separator: "-")
  }
}
