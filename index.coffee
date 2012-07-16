module.exports = kup = class

    constructor: (@options) -> @htmlOut = ''

    _sanitizeAttribute: (string) ->
        return string if (typeof @options?.sanitizeAttribute) isnt 'function'
        @options.sanitizeAttribute string

    _sanitizeContent: (string) ->
        return string if (typeof @options?.sanitizeContent) isnt 'function'
        @options.sanitizeContent string

    doctype: -> @htmlOut += '<!DOCTYPE html>\n'

    tag: (name, attrs, content) ->
        if (typeof attrs) in ['string', 'function']
            content = attrs
            attrs = null

        @htmlOut += @open(name, attrs) + '>\n'
        @htmlOut += (@_sanitizeContent content) + '\n' if (typeof content) is 'string'
        content?()
        @htmlOut += "</#{name}>\n"

    open: (name, attrs) ->
        out = "<#{name}"
        for k, v of attrs
            out += " #{k}=\"#{@_sanitizeAttribute v}\""
        out

    empty: (name, attrs) -> @htmlOut += @open(name, attrs) + ' />\n'

    addText: (string) -> @htmlOut += string + '\n'

regular = 'a abbr address article aside audio b bdi bdo blockquote body button
    canvas caption cite code colgroup datalist dd del details dfn div dl dt em
    fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup
    html i iframe ins kbd label legend li map mark menu meter nav noscript object
    ol optgroup option output p pre progress q rp rt ruby s samp script section
    select small span strong sub summary sup table tbody td textarea tfoot
    th thead time title tr u ul video style'.split(/[\n ]+/)

for tagName in regular
    do (tagName) ->
        kup.prototype[tagName] = (attrs, content) -> @tag tagName, attrs, content

empty = 'area base br col command embed hr img input keygen link meta
    param source track wbr'.split(/[\n ]+/)

for tagName in empty
    do (tagName) ->
        kup.prototype[tagName] = (attrs, content) -> @empty tagName, attrs, content
