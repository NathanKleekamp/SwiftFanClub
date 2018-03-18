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
}
