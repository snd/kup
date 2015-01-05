Kup = require '../src/kup'

attrs =
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
        k.a attrs
        test.equals k.htmlOut, '<a id="container" class="active danger"></a>'
        test.done()

      'with attributes': (test) ->
        k = new Kup
        k.a attrs
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
        k.a attrs, 'Lorem Ipsum'
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
        k.p attrs, ->
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
      k.img attrs
      test.equals k.htmlOut, '<img id="container" class="active danger" />'
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
