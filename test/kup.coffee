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

  'hooks':

    'calls': (test) ->

      k = new Kup

      calls = []

      k.beforeOpen = (tag, attrs, content) ->
        calls.push
          type: 'beforeOpen'
          tag: tag
          attrs: attrs
          content: content
      k.afterOpen = (tag, attrs, content) ->
        calls.push
          type: 'afterOpen'
          tag: tag
          attrs: attrs
          content: content
      k.beforeClose = (tag, attrs, content) ->
        calls.push
          type: 'beforeClose'
          tag: tag
          attrs: attrs
          content: content
      k.afterClose = (tag, attrs, content) ->
        calls.push
          type: 'afterClose'
          tag: tag
          attrs: attrs
          content: content
      k.beforeVoid = (tag, attrs) ->
        calls.push
          type: 'beforeVoid'
          tag: tag
          attrs: attrs
      k.afterVoid = (tag, attrs) ->
        calls.push
          type: 'afterVoid'
          tag: tag
          attrs: attrs

      insideHtml = ->
        k.img attrs
        k.div()
        k.p 'test'
        k.br()

      k.html attrs, insideHtml

      test.deepEqual calls, [
        {
          type: 'beforeOpen'
          tag: 'html'
          attrs: attrs
          content: insideHtml
        }
        {
          type: 'afterOpen'
          tag: 'html'
          attrs: attrs
          content: insideHtml
        }
        {
          type: 'beforeVoid'
          tag: 'img'
          attrs: attrs
        }
        {
          type: 'afterVoid'
          tag: 'img'
          attrs: attrs
        }
        {
          type: 'beforeOpen'
          tag: 'div'
          attrs: undefined
          content: undefined
        }
        {
          type: 'afterOpen'
          tag: 'div'
          attrs: undefined
          content: undefined
        }
        {
          type: 'beforeClose'
          tag: 'div'
          attrs: undefined
          content: undefined
        }
        {
          type: 'afterClose'
          tag: 'div'
          attrs: undefined
          content: undefined
        }
        {
          type: 'beforeOpen'
          tag: 'p'
          attrs: undefined
          content: 'test'
        }
        {
          type: 'afterOpen'
          tag: 'p'
          attrs: undefined
          content: 'test'
        }
        {
          type: 'beforeClose'
          tag: 'p'
          attrs: undefined
          content: 'test'
        }
        {
          type: 'afterClose'
          tag: 'p'
          attrs: undefined
          content: 'test'
        }
        {
          type: 'beforeVoid'
          tag: 'br'
          attrs: undefined
        }
        {
          type: 'afterVoid'
          tag: 'br'
          attrs: undefined
        }
        {
          type: 'beforeClose'
          tag: 'html'
          attrs: attrs
          content: insideHtml
        }
        {
          type: 'afterClose'
          tag: 'html'
          attrs: attrs
          content: insideHtml
        }
      ]

      test.done()

    'newlines': (test) ->

      k = new Kup

      k.afterOpen = (tag, attrs, content) ->
        if 'function' is typeof content
          @unsafe '\n'
      k.afterClose = (tag, attrs, content) ->
        @unsafe '\n'

      k.html ->
        k.div()
        k.p ->
          k.div ->
            k.p 'test'

      test.equal k.htmlOut, '<html>\n<div></div>\n<p>\n<div>\n<p>test</p>\n</div>\n</p>\n</html>\n'

      test.done()
