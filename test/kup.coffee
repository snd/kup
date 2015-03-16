Kup = require '../src/kup'

ATTRS =
  id: 'container'
  class: 'active danger'

module.exports =

  'errors':

    'attribute value undefined': (test) ->
      test.expect 1
      k = new Kup
      try
        k.a {foo: undefined}
      catch e
        test.equal e.message, 'value of attribute `foo` in tag `a` is undefined or null'
      test.done()

    'content given to void tag': (test) ->
      test.expect 2

      k = new Kup
      try
        k.img 'test'
      catch e
        test.equal e.message, 'void tag `img` accepts no content but content `test` was given'

      k = new Kup
      try
        k.img {a: 1}, 'test'
      catch e
        test.equal e.message, 'void tag `img` accepts no content but content `test` was given'

      test.done()

  'regular tag (with content)':

    'empty':

      'without attributes': (test) ->
        k = new Kup
        k.a()
        test.equals k.htmlOut, '<a></a>'
        test.done()

      'with attributes': (test) ->
        k = new Kup
        k.a ATTRS
        test.equals k.htmlOut, '<a id="container" class="active danger"></a>'
        test.done()

      'with attributes': (test) ->
        k = new Kup
        k.a ATTRS
        test.equals k.htmlOut, '<a id="container" class="active danger"></a>'
        test.done()

    'with text content':

      'without attributes': (test) ->
        k = new Kup
        k.a 'Lorem Ipsum'
        test.equals k.htmlOut, '<a>Lorem Ipsum</a>'
        test.done()

      'with attributes': (test) ->
        k = new Kup
        k.a ATTRS, 'Lorem Ipsum'
        test.equals k.htmlOut, '<a id="container" class="active danger">Lorem Ipsum</a>'
        test.done()

    'with html content':

      'without attributes': (test) ->
        k = new Kup
        k.p ->
          k.a 'First Indent'
          k.p ->
            k.a 'Second Indent'
        test.equals k.htmlOut, '<p><a>First Indent</a><p><a>Second Indent</a></p></p>'
        test.done()

      'with attributes': (test) ->
        k = new Kup
        k.p ATTRS, ->
          k.a 'First Indent'
          k.p ->
            k.a 'Second Indent'
        test.equals k.htmlOut, '<p id="container" class="active danger"><a>First Indent</a><p><a>Second Indent</a></p></p>'
        test.done()

    'with number as content': (test) ->
      k = new Kup
      k.a 10
      k.a 10.1
      test.equals k.htmlOut, '<a>10</a><a>10.1</a>'
      test.done()

  'void tag (without content)':

    'without attributes': (test) ->
      k = new Kup
      k.img()
      test.equals k.htmlOut, '<img />'
      test.done()

    'with attributes': (test) ->
      k = new Kup
      k.img ATTRS
      test.equals k.htmlOut, '<img id="container" class="active danger" />'
      test.done()

  'doctype': (test) ->
    k = new Kup
    k.doctype()
    k.a()
    test.equals k.htmlOut, '<!DOCTYPE html><a></a>'
    test.done()

  'encode':

    'attribute': (test) ->
      k = new Kup
      k.img {id: '" onclick=\'alert("foo")\''}
      test.equals k.htmlOut, '<img id="&quot; onclick=\'alert(&quot;foo&quot;)\'" />'
      test.done()

    'content': (test) ->
      k = new Kup
      k.a '<script>alert("foo"); alert(\'bar\');</script>'
      expected = '<a>&lt;script&gt;alert(&quot;foo&quot;); alert(&#x27;bar&#x27;);&lt;&#x2F;script&gt;</a>'
      test.equals k.htmlOut, expected
      test.done()

  'newlines': (test) ->
    k = new Kup

    k.newline = ->
      @htmlOut += '\n'
    # add newlines after opening tag and after closing tag
    k.tag = (tag, attrs, content) ->
      if 'object' isnt typeof attrs
        content = attrs
        attrs = undefined
      @_open tag, attrs
      if 'function' is typeof content
        @newline()
      @_content content
      @_close tag
      @newline()

    k.html ->
      k.div()
      k.p ->
        k.div ->
          k.p 'test'

    test.equal k.htmlOut, '<html>\n<div></div>\n<p>\n<div>\n<p>test</p>\n</div>\n</p>\n</html>\n'

    test.done()

  'style':

    'string': (test) ->
      k = new Kup
      k.div
        style: "color: blue"
      test.equal k.htmlOut, "<div style=\"color: blue\"></div>"
      test.done()

    'style object with camelcase': (test) ->
      k = new Kup
      k.div
        style:
          color: 'blue'
          backgroundImage: 'url(test.png)'
          msTransition: 'all'
      test.equal k.htmlOut, "<div style=\"color: blue; background-image: url(test.png); ms-transition: all;\"></div>"
      test.done()

    'style object with dashcase': (test) ->
      k = new Kup
      k.div
        style:
          color: 'blue'
          'background-image': 'url(test.png)'
          'ms-transition': 'all'
      test.equal k.htmlOut, "<div style=\"color: blue; background-image: url(test.png); ms-transition: all;\"></div>"
      test.done()

    'empty style object': (test) ->
      k = new Kup
      k.div
        style: {}
      test.equal k.htmlOut, "<div style=\"\"></div>"
      test.done()

  'custom tag':

    'without content':

      'without attributes': (test) ->
        k = new Kup
        k.tag 'url'
        test.equals k.htmlOut, '<url></url>'
        test.done()

      'with attributes': (test) ->
        k = new Kup
        k.tag 'url', ATTRS
        test.equals k.htmlOut, '<url id="container" class="active danger"></url>'
        test.done()

    'with content':

      'without attributes': (test) ->
        k = new Kup
        k.tag 'url', 'Lorem Ipsum'
        test.equals k.htmlOut, '<url>Lorem Ipsum</url>'
        test.done()

      'with attributes': (test) ->
        k = new Kup
        k.tag 'url', ATTRS, 'Lorem Ipsum'
        test.equals k.htmlOut, '<url id="container" class="active danger">Lorem Ipsum</url>'
        test.done()
