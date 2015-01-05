contentEncodings =
  '&': '&amp;'
  '<': '&lt;'
  '>': '&gt;'
  '"': '&quot;'
  '\'': '&#x27;'
  '/': '&#x2F;'

################################################################################
# exports is a constructor with a prototype

module.exports = Kup = ->
  @htmlOut = ''

Kup.prototype =

################################################################################
# string helpers

  encodeContent: (content) ->
    # regex matches any of the chars that are keys in `contentEncodings` above
    content.toString().replace /[&<>"'\/]/g, (char) -> contentEncodings[char]

  # html escape double quotes
  encodeAttribute: (value) ->
    value.toString().replace /"/g, '&quot;'

  # http://stackoverflow.com/a/8955580
  camelcaseToDashcase: (string) ->
    string.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase()

################################################################################
# pure functions that return strings

  attributeToString: (key, value) ->
    if key is 'style' and 'object' is typeof value
      value = @styleObjectToString(value)
    "#{key}=\"#{@encodeAttribute(value)}\""

  styleObjectToString: (styles) ->
    parts = []
    for key, value of styles
      parts.push "#{@camelcaseToDashcase key}: #{value};"
    return parts.join(' ')

  openingTagUntilExceptClosingBracketToString: (tag, attrs) ->
    parts = ["<#{tag}"]
    for key, value of attrs
      # XSS prevention for attributes:
      # properly quoted attributes can only be escaped with the corresponding quote
      if not value?
        throw new Error "value of attribute `#{key}` in tag `#{tag}` is undefined or null"
      parts.push @attributeToString key, value
    return parts.join(' ')

################################################################################
# side effects on @htmlOut

  doctype: ->
    @htmlOut += '<!DOCTYPE html>'

  open: (tag, attrs) ->
    @htmlOut += @openingTagUntilExceptClosingBracketToString(tag, attrs) + '>'

  content: (content) ->
    type = typeof content
    if type is 'function'
      content()
    else if content?
      stringContent = if type isnt 'string' then content.toString() else content
      @htmlOut += @encodeContent stringContent

  close: (tag) ->
    @htmlOut += "</#{tag}>"

  tag: (tag, attrs, content) ->
    @open tag, attrs
    @content content
    @close tag

  empty: (tag, attrs) ->
    @htmlOut += @openingTagUntilExceptClosingBracketToString(tag, attrs) + ' />'

  unsafe: (string) ->
    @htmlOut += string

  safe: (string) ->
    @htmlOut += @encodeContent string

################################################################################
# all the regular tags with content

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

################################################################################
# all the void tags without content

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
