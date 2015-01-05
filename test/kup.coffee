Kup = require '../src/kup'

attrs =
  id: 'container'
  class: 'active danger'

module.exports =
  'throw if attribute name is undefined': (test) ->
    kup = new Kup
    test.throws -> kup.a {foo: undefined}
    test.done()

  'regular tag (with content)':

    'empty':

      'without attributes': (test) ->
        kup = new Kup
        kup.a()
        test.equals kup.htmlOut, '<a></a>\n'
        test.done()

      'with attributes': (test) ->
        kup = new Kup
        kup.a attrs
        test.equals kup.htmlOut, '<a id="container" class="active danger"></a>\n'
        test.done()

    'with text content':

      'without attributes': (test) ->
        kup = new Kup
        kup.a 'Lorem Ipsum'
        test.equals kup.htmlOut, '<a>Lorem Ipsum</a>\n'
        test.done()

      'with attributes': (test) ->
        kup = new Kup
        kup.a attrs, 'Lorem Ipsum'
        test.equals kup.htmlOut, '<a id="container" class="active danger">Lorem Ipsum</a>\n'
        test.done()

    'with html content':

      'without attributes': (test) ->
        kup = new Kup
        kup.p ->
          kup.a 'First Indent'
          kup.p ->
            kup.a 'Second Indent'
        test.equals kup.htmlOut, '<p>\n<a>First Indent</a>\n<p>\n<a>Second Indent</a>\n</p>\n</p>\n'
        test.done()

      'with attributes': (test) ->
        kup = new Kup
        kup.p attrs, ->
          kup.a 'First Indent'
          kup.p ->
            kup.a 'Second Indent'
        test.equals kup.htmlOut, '<p id="container" class="active danger">\n<a>First Indent</a>\n<p>\n<a>Second Indent</a>\n</p>\n</p>\n'
        test.done()

    'with number as content': (test) ->
      kup = new Kup
      kup.a 10
      kup.a 10.1
      test.equals kup.htmlOut, '<a>10</a>\n<a>10.1</a>\n'
      test.done()

  'void tag (without content)':

    'without attributes': (test) ->
      kup = new Kup
      kup.img()
      test.equals kup.htmlOut, '<img />\n'
      test.done()

    'with attributes': (test) ->
      kup = new Kup
      kup.img attrs
      test.equals kup.htmlOut, '<img id="container" class="active danger" />\n'
      test.done()

  'encode':

    'attribute': (test) ->
      kup = new Kup
      kup.img {id: '" onclick=\'alert("foo")\''}
      test.equals kup.htmlOut, '<img id="&quot; onclick=\'alert(&quot;foo&quot;)\'" />\n'
      test.done()

    'content': (test) ->
      kup = new Kup
      kup.a '<script>alert("foo"); alert(\'bar\');</script>'
      expected = '<a>&lt;script&gt;alert(&quot;foo&quot;); alert(&#x27;bar&#x27;);&lt;&#x2F;script&gt;</a>\n'
      test.equals kup.htmlOut, expected
      test.done()
