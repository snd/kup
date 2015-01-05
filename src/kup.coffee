################################################################################
# exports and constructor

module.exports = Kup = ->
  @htmlOut = ''

################################################################################
# encode

contentEncodings =
  '&': '&amp;'
  '<': '&lt;'
  '>': '&gt;'
  '"': '&quot;'
  '\'': '&#x27;'
  '/': '&#x2F;'

# matches any of the chars that are keys in `contentEncodings` above
contentRegex = /[&<>"'\/]/g
encodeContentChar = (char) -> contentEncodings[char]
encodeContent = (content) ->
  content.toString().replace contentRegex, encodeContentChar

encodeAttribute = (value) ->
  value.toString().replace /"/g, '&quot;'

################################################################################
# API

Kup.prototype =

  encodeContent: encodeContent
  encodeAttribute: encodeAttribute

  doctype: ->
    @htmlOut += '<!DOCTYPE html>'
    @newline()

  tag: (name, attrs, content) ->
    if 'object' isnt typeof attrs
      content = attrs
      attrs = null

    @beforeOpen?(name, attrs)
    @htmlOut += @open(name, attrs) + '>'
    type = typeof content
    if type is 'function'
      @afterOpen?(name, attrs)
      content()
      @beforeClose?(name, attrs)
    else if content?
      @beforeInnerText?(name, attrs)
      stringContent = if type isnt 'string' then content.toString() else content
      @htmlOut += @encodeContent stringContent
      @afterInnerText?(name, attrs)
    @htmlOut += "</#{name}>"
    @afterClose?(name, attrs)

  open: (name, attrs) ->
    out = "<#{name}"
    for k, v of attrs
      # XSS prevention for attributes:
      # properly quoted attributes can only be escaped with the corresponding quote
      if not v?
        msg = "value of attribute `#{k}` in tag #{name} is undefined or null"
        throw new Error msg
      out += " #{k}=\"#{@encodeAttribute(v)}\""
    out

  empty: (name, attrs) ->
    @beforeEmpty?(name, attrs)
    @htmlOut += @open(name, attrs) + ' />'
    @afterEmpty?(name, attrs)

  unsafe: (string) ->
    @htmlOut += string

  safe: (string) ->
    @htmlOut += @encodeContent string

################################################################################
# tags

regular = 'a abbr address article aside audio b bdi bdo blockquote body button
  canvas caption cite code colgroup datalist dd del details dfn div dl dt em
  fieldset figcaption figure footer form frameset h1 h2 h3 h4 h5 h6 head header hgroup
  html i iframe ins kbd label legend li map mark menu meter nav noscript object
  ol optgroup option output p pre progress q rp rt ruby s samp script section
  select small span strong sub summary sup table tbody td textarea tfoot
  th thead time title tr u ul video style'.split(/[\n ]+/)

for tagName in regular
  do (tagName) ->
    Kup.prototype[tagName] = (attrs, content) ->
      @tag tagName, attrs, content

empty = 'area base br col command embed hr img input keygen link meta
  param source track wbr frame'.split(/[\n ]+/)

for tagName in empty
  do (tagName) ->
    Kup.prototype[tagName] = (attrs) -> @empty tagName, attrs
