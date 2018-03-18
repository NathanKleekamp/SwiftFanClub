import Routing
import Vapor
import Leaf

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
  router.get("setup") { req -> String in
    let forum1 = Forum(id: 1, name: "Taylor's Songs")
    let forum2 = Forum(id: 2, name: "Taylor's Albums")
    let forum3 = Forum(id: 3, name: "Taylor's Concerts")

    _ = forum1.create(on: req)
    _ = forum2.create(on: req)
    _ = forum3.create(on: req)

    return "OK"
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
