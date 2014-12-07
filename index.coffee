contentEncodings =
    '&': '&amp;'
    '<': '&lt;'
    '>': '&gt;'
    '"': '&quot;'
    '\'': '&#x27;'
    '/': '&#x2F;'

contentRegex = /[&<>"'\/]/g
contentEncoder = (char) -> contentEncodings[char]
encodeContent = (s) -> s.toString().replace contentRegex, contentEncoder
# http://www.devcurry.com/2011/07/javascript-convert-camelcase-to-dashes.html
camelToDash = (str) ->
    str.replace(/\W+/g, '-').replace /([a-z\d])([A-Z])/g, '$1-$2'


module.exports = kup = class

    constructor: -> @htmlOut = ''

    doctype: -> @htmlOut += '<!DOCTYPE html>\n'

    tag: (name, attrs, content) ->
        if typeof attrs isnt 'object'
            content = attrs
            attrs = null

        @htmlOut += @open(name, attrs) + '>'
        type = typeof content
        if type is 'function'
            @htmlOut += '\n'
            content()
        else if content?
            stringContent = if type isnt 'string' then content.toString() else content
            @htmlOut += encodeContent stringContent
        @htmlOut += "</#{name}>\n"

    open: (name, attrs) ->
        out = "<#{name}"
        for k, v of attrs
            # XSS prevention for attributes:
            # properly quoted attributes can only be escaped with the corresponding quote
            if not v?
                msg = "value of attribute `#{k}` in tag #{name} is undefined or null"
                throw new Error msg
            else if k is "css"
                out += " style=\"#{@css v}\""
            else
                out += " #{k}=\"#{v.toString().replace /"/g, '&quot;'}\""
        out

    empty: (name, attrs) -> @htmlOut += @open(name, attrs) + ' />\n'

    unsafe: (string) -> @htmlOut += string

    safe: (string) -> @htmlOut += encodeContent string

    css: (css) ->
        r = ""
        for k, v of css
            r += " #{camel2dashed k}: #{v};"
        r.slice 1

regular = 'a abbr address article aside audio b bdi bdo blockquote body button
    canvas caption cite code colgroup datalist dd del details dfn div dl dt em
    fieldset figcaption figure footer form frameset h1 h2 h3 h4 h5 h6 head header hgroup
    html i iframe ins kbd label legend li map mark menu meter nav noscript object
    ol optgroup option output p pre progress q rp rt ruby s samp script section
    select small span strong sub summary sup table tbody td textarea tfoot
    th thead time title tr u ul video style'.split(/[\n ]+/)

for tagName in regular
    do (tagName) ->
        kup.prototype[tagName] = (attrs, content) -> @tag tagName, attrs, content

empty = 'area base br col command embed hr img input keygen link meta
    param source track wbr frame'.split(/[\n ]+/)

for tagName in empty
    do (tagName) ->
        kup.prototype[tagName] = (attrs) -> @empty tagName, attrs
