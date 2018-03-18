//
//  Forum.swift
//  App
//
//  Created by Nathan Kleekamp on 3/18/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct Forum: Content, SQLiteModel, Migration {
  var id: Int?
  var name: String
}
