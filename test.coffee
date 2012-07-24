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
                test.equals kup.htmlOut, '<a></a>\n'
                test.done()

            'with attributes': (test) ->
                kup = new Kup
                kup.a attrs
                test.equals kup.htmlOut, '<a id="container" class="active danger"></a>\n'
                test.done()

            'with number': (test) ->
                kup = new Kup
                kup.th 1
                test.equals kup.htmlOut, '<th>1</th>\n'
                test.done()

        'text content':
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

        'html content':
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
