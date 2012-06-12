Up = require './index'

attrs =
    id: 'container'
    class: 'active danger'

module.exports =

        'regular':
            'empty':
                'without attributes': (test) ->
                    up = new Up
                    up.a()
                    test.equals up.htmlOut, '<a>\n</a>\n'
                    test.done()

                'with attributes': (test) ->
                    up = new Up
                    up.a attrs
                    test.equals up.htmlOut, '<a id="container" class="active danger">\n</a>\n'
                    test.done()

            'text content':
                'without attributes': (test) ->
                    up = new Up
                    up.a 'Lorem Ipsum'
                    test.equals up.htmlOut, '<a>\nLorem Ipsum\n</a>\n'
                    test.done()

                'with attributes': (test) ->
                    up = new Up
                    up.a attrs, 'Lorem Ipsum'
                    test.equals up.htmlOut, '<a id="container" class="active danger">\nLorem Ipsum\n</a>\n'
                    test.done()

            'html content':
                'without attributes': (test) ->
                    up = new Up
                    up.p ->
                        up.a 'First Indent'
                        up.p ->
                            up.a 'Second Indent'
                    test.equals up.htmlOut, '<p>\n<a>\nFirst Indent\n</a>\n<p>\n<a>\nSecond Indent\n</a>\n</p>\n</p>\n'
                    test.done()

                'with attributes': (test) ->
                    up = new Up
                    up.p attrs, ->
                        up.a 'First Indent'
                        up.p ->
                            up.a 'Second Indent'
                    test.equals up.htmlOut, '<p id="container" class="active danger">\n<a>\nFirst Indent\n</a>\n<p>\n<a>\nSecond Indent\n</a>\n</p>\n</p>\n'
                    test.done()

        'void':
            'without attributes': (test) ->
                up = new Up
                up.img()
                test.equals up.htmlOut, '<img />\n'
                test.done()

            'with attributes': (test) ->
                up = new Up
                up.img attrs
                test.equals up.htmlOut, '<img id="container" class="active danger" />\n'
                test.done()
