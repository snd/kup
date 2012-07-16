Kup = require './index'

attrs =
    id: 'container'
    class: 'active danger'

module.exports =

    'regular':
        'empty':
            'without attributes': (test) ->
                kup = new Kup
                kup.a()
                test.equals kup.htmlOut, '<a>\n</a>\n'
                test.done()

            'with attributes': (test) ->
                kup = new Kup
                kup.a attrs
                test.equals kup.htmlOut, '<a id="container" class="active danger">\n</a>\n'
                test.done()

        'text content':
            'without attributes': (test) ->
                kup = new Kup
                kup.a 'Lorem Ipsum'
                test.equals kup.htmlOut, '<a>\nLorem Ipsum\n</a>\n'
                test.done()

            'with attributes': (test) ->
                kup = new Kup
                kup.a attrs, 'Lorem Ipsum'
                test.equals kup.htmlOut, '<a id="container" class="active danger">\nLorem Ipsum\n</a>\n'
                test.done()

        'html content':
            'without attributes': (test) ->
                kup = new Kup
                kup.p ->
                    kup.a 'First Indent'
                    kup.p ->
                        kup.a 'Second Indent'
                test.equals kup.htmlOut, '<p>\n<a>\nFirst Indent\n</a>\n<p>\n<a>\nSecond Indent\n</a>\n</p>\n</p>\n'
                test.done()

            'with attributes': (test) ->
                kup = new Kup
                kup.p attrs, ->
                    kup.a 'First Indent'
                    kup.p ->
                        kup.a 'Second Indent'
                test.equals kup.htmlOut, '<p id="container" class="active danger">\n<a>\nFirst Indent\n</a>\n<p>\n<a>\nSecond Indent\n</a>\n</p>\n</p>\n'
                test.done()

        'no content': (test) ->
            kup = new Kup
            kup.a()
            test.equals kup.htmlOut, '<a>\n</a>\n'
            test.done()

    'void':
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

    'sanitize':

        'attribute': (test) ->
            kup = new Kup
                sanitizeAttribute: (s) ->
                    s.replace(/"/g, '&quot;').replace(/'/g, '&#x27;')
            kup.img {id: '" onclick=\'alert("foo")\''}
            test.equals kup.htmlOut, '<img id="&quot; onclick=&#x27;alert(&quot;foo&quot;)&#x27;" />\n'
            test.done()

        'content': (test) ->
            kup = new Kup
                sanitizeContent: (s) ->
                    s.replace(/</g, '&lt;').replace(/>/g, '&gt;')
            kup.a '<script>alert("foo")</script>'
            test.equals kup.htmlOut, '<a>\n&lt;script&gt;alert("foo")&lt;/script&gt;\n</a>\n'
            test.done()
