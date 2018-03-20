import Foundation
import Routing
import Vapor
import Fluent
import FluentSQLite
import Leaf

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
  router.get("setup") { req -> String in
    let forum1 = Forum(id: 1, name: "Taylor's Songs")
    let forum2 = Forum(id: 2, name: "Taylor's Albums")
    let forum3 = Forum(id: 3, name: "Taylor's Concerts")

    let message1 = Message(id: 1, forum: 1, title: "Welcome", body: "Hello", parent: 0, user: "nkleekamp", date: Date())
    let message2 = Message(id: 2, forum: 1, title: "Second Post", body: "Hello", parent: 0, user: "nkleekamp", date: Date())
    let message3 = Message(id: 3, forum: 1, title: "Test Reply", body: "My reply worked!", parent: 1, user: "lkleekamp", date: Date())

    _ = forum1.create(on: req)
    _ = forum2.create(on: req)
    _ = forum3.create(on: req)

    _ = message1.create(on: req)
    _ = message2.create(on: req)
    _ = message3.create(on: req)
    
    return "OK"
  }

  router.get("forums", Int.parameter) { req -> Future<View> in
    struct ForumContext: Codable {
      var username: String?
      var forum: Forum
      var messages: [Message]
    }

    let forumId = try req.parameter(Int.self)

    return Forum.find(forumId, on: req).flatMap(to: View.self) { forum in
      guard let forum = forum else {
        throw Abort(.notFound)
      }

      let query = Message.query(on: req)
        .filter(\.forum == forum.id!)
        .filter(\.parent == 0)
        .all()

      return query.flatMap(to: View.self) { messages in
        let context = ForumContext(username: getUsername(req), forum: forum, messages: messages)
        return try req.view().render("forum", context)
      }
    }
  }

  router.get("forums", Int.parameter, "messages", Int.parameter) { req -> Future<View> in
    struct MessageContext: Codable {
      var forum: Forum
      var message: Message
      var replies: [Message]
    }

    let forumId = try req.parameter(Int.self)
    let messageId = try req.parameter(Int.self)

    return Forum.find(forumId, on: req).flatMap(to: View.self) { forum in
      guard let forum = forum else {
        throw Abort(.notFound)
      }

      return Message.find(messageId, on: req).flatMap(to: View.self) { message in
        guard let message = message else {
          throw Abort(.notFound)
        }

        let replies = Message.query(on: req)
          .filter(\.parent == message.id!)
          .all()

        return replies.flatMap(to: View.self) { replies in
          let context = MessageContext(forum: forum, message: message, replies: replies)
          return try req.view().render("message", context)
        }
      }
    }
  }

  router.get("login") { req -> Future<View> in
    return try req.view().render("login")
  }

  router.get("logout") { req -> Future<View> in
    return try req.view().render("logout")
  }

  router.get { req -> Future<View> in
    struct HomeContext: Codable {
      var username: String?
      var forums: [Forum]
    }

    return Forum.query(on: req).all().flatMap(to: View.self) { forums in
      let context = HomeContext(username: getUsername(req), forums: forums)
      return try req.view().render("home", context)
    }
  }
}

func getUsername(_ req: Request) -> String? {
  return "Testing"
}
