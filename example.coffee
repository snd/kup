Kup = require 'kup'

k = new Kup

k.doctype()

k.html ->
  k.head ->
    k.title "a title"
    k.script {
      src: "/script.js"
      type: "text/javascript"
    }
  k.body ->
    k.div {id: "container"}, ->
      k.h1 "a heading"
      k.h2 {class: "secondary-heading"}, "another heading"
      k.ul ->
        "red green blue".split(' ').forEach (color) ->
          k.li ->
            k.a {
              style: {color: color}
              href: "http://www.example.com"
            }, "a #{color} link"
      k.p ->
        k.unsafe "not html encoded plaintext: &<>\"'/"
        k.br()
        k.safe "html encoded plaintext: &<>\"'/"
        k.span {
          style: {fontWeight: "bold"}
        }, "bold"

console.log k.htmlOut
