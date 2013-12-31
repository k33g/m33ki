module simple

import m33ki.spark
import m33ki.jackson
import m33ki.models
import m33ki.collections
import m33ki.strings

function main = |args| {

  let humans = Collection()

  # create some humans
  let bob = Model()
    : setField("firstName", "Bob")
    : setField("lastName", "Morane")
    : setField("id", "bob")

  let john = Model()
    : setField("firstName", "John")
    : setField("lastName", "Doe")
    : setField("id", "john")

  let jane = Model()
    : setField("firstName", "Jane")
    : setField("lastName", "Doe")
    : setField("id", "jane")

  println(bob: toJsonString())

  humans: addItem(bob): addItem(john): addItem(jane)

  initialize(): static("/samples/simple/public"): port(8888): error(true)

  # Create a human
  POST("/humans", |request, response| {
    response:type("application/json")
    let human = Model(): fromJsonString(request: body())
    human: generateId()
    humans: addItem(human)

    response: status(201) # 201: created
    return human: toJsonString()
  })

  # Retrieve all humans
  GET("/humans", |request, response| {
    response:type("application/json")
    return humans: toJsonString()
  })

  # Retrieve a human by id
  GET("/humans/:id", |request, response| {
    response:type("application/json")

    let human = humans: getItem(request: params(":id"))

    if human isnt null{
      return human: toJsonString()
    } else {
      response: status(404) # 404 Not found
      return Json(): toJsonString(map[["message", "Human not found"]])
    }
  })

  # generate error
  GET("/stop", |request, response| {
    let a = 5/0
    return null
  })

}
