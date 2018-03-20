//
//  User.swift
//  App
//
//  Created by Nathan Kleekamp on 3/19/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct User: Content, SQLiteModel, Migration {
  var id: Int?
  var username: String
  var password: String
}
