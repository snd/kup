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

  tag: (tag, attrs, content) ->
    @open tag, attrs
    @content content
    @close tag

  open: (tag, attrs) ->
    @htmlOut += @prefix(tag, attrs) + '>'

  content: (content) ->
    type = typeof content
    if type is 'function'
      content()
    else if content?
      stringContent = if type isnt 'string' then content.toString() else content
      @htmlOut += @encodeContent stringContent

  close: (tag) ->
    @htmlOut += "</#{tag}>"

  prefix: (tag, attrs) ->
    out = "<#{tag}"
    for k, v of attrs
      # XSS prevention for attributes:
      # properly quoted attributes can only be escaped with the corresponding quote
      if not v?
        throw new Error "value of attribute `#{k}` in tag `#{tag}` is undefined or null"
      out += " #{k}=\"#{@encodeAttribute(v)}\""
    return out

  empty: (tag, attrs) ->
    @htmlOut += @prefix(tag, attrs) + ' />'

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

for tag in regular
  do (tag) ->
    Kup.prototype[tag] = (attrs, content) ->
      if 'object' isnt typeof attrs
        content = attrs
        attrs = undefined
      @tag tag, attrs, content

empty = 'area base br col command embed hr img input keygen link meta
  param source track wbr frame'.split(/[\n ]+/)

for tag in empty
  do (tag) ->
    Kup.prototype[tag] = (attrs, content) ->
      if 'object' isnt typeof attrs
        content = attrs
        attrs = undefined
      if content?
        throw new Error "void tag `#{tag}` accepts no content but content `#{content}` was given"
      @empty tag, attrs, content
