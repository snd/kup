# kup

[![NPM Package](https://img.shields.io/npm/v/kup.svg?style=flat)](https://www.npmjs.org/package/kup)
[![Build Status](https://travis-ci.org/snd/kup.svg?branch=master)](https://travis-ci.org/snd/kup/branches)
[![Dependencies](https://david-dm.org/snd/kup.svg)](https://david-dm.org/snd/kup)

> forget underpowered template languages - build HTML with the full power of coffeescript

**nodejs:** `npm install kup` then `Kup = require 'kup'`

**browser:** include [lib/kup.js](lib/kup.js) which sets `window.Kup`

```coffeescript
Kup = require 'kup'

k = new Kup

k.doctype()

k.html ->
  k.head ->
    k.title "a title"
    k.script {
      src: "/script.js"
      type: "text/javascript"
    }
  k.body ->
    k.div {id: "container"}, ->
      k.h1 "a heading"
      k.h2 {class: "secondary-heading"}, "another heading"
      k.ul ->
        "red green blue".split(' ').forEach (color) ->
          k.li ->
            k.a {
              style: {color: color}
              href: "http://www.example.com"
            }, "a #{color} link"
      k.p ->
        k.unsafe "not html encoded plaintext: &<>\"'/"
        k.br()
        k.safe "html encoded plaintext: &<>\"'/"
        k.span {
          style: {fontWeight: "bold"}
        }, "bold"

console.log k.htmlOut
```

produces the following HTML (whitespace added for readability):

```html
<!DOCTYPE html>
<html>
  <head>
    <title>a title</title>
    <script src="/script.js" type="text/javascript"></script>
  </head>
  <body>
    <div id="container">
      <h1>a heading</h1>
      <h2 class="secondary-heading">another heading</h2>
      <ul>
        <li>
          <a style="color: red;" href="http://www.example.com">
            a red link
          </a>
        </li>
        <li>
          <a style="color: green;" href="http://www.example.com">
            a green link
          </a>
        </li>
        <li>
          <a style="color: blue;" href="http://www.example.com">
            a blue link
          </a>
        </li>
      </ul>
      <p>
        not html encoded plaintext: &<>"'/
        <br />
        html encoded plaintext: &amp;&lt;&gt;&quot;&#x27;&#x2F;
        <span font-weight="bold">bold</span>
      </p>
    </div>
  </body>
</html>
```

## inline styles

if the `style` attribute is a string it is added to the tag unchanged.

if the `style` attribute is an object it is converted to a css style string.
camelcased keys are converted to dashcase:

```coffeescript
k = new Kup

k.div
  style: 'color: red'

k.div
  style:
    color: 'blue'
    backgroundImage: 'url(test.png)'
    msTransition: 'all'

console.log k.htmlOut
```

produces the following HTML:

```html
<div style="color: red"></div>
<div style="color: blue; background-image: url(test.png); ms-transition: all;">
</div>
```

if you want a similar special treatment for attributes other than `style`
overwrite `Kup.prototype.attributeToString = (key, value) -> ...`.
it's 3 lines of code that are easily customized.

## cross site scripting (XSS) protection

kup implements [RULE 1](https://www.owasp.org/index.php/XSS_%28Cross_Site_Scripting%29_Prevention_Cheat_Sheet#RULE_.231_-_HTML_Escape_Before_Inserting_Untrusted_Data_into_HTML_Element_Content)
and [RULE 2](https://www.owasp.org/index.php/XSS_%28Cross_Site_Scripting%29_Prevention_Cheat_Sheet#RULE_.232_-_Attribute_Escape_Before_Inserting_Untrusted_Data_into_HTML_Common_Attributes)
of the
[OWASP XSS prevention cheat sheet](https://www.owasp.org/index.php/XSS_%28Cross_Site_Scripting%29_Prevention_Cheat_Sheet).
reading it is highly recommended !
kup can not protect you from the many other XSS attack vectors described there.
that requires a bit of effort on your part.

kup will [properly quote attributes using double quotes](https://www.owasp.org/index.php/XSS_%28Cross_Site_Scripting%29_Prevention_Cheat_Sheet#RULE_.232_-_Attribute_Escape_Before_Inserting_Untrusted_Data_into_HTML_Common_Attributes):
properly quoted attributes can only be escaped with the corresponding quote.
kup escapes all double quotes inside attribute values to prevent escaping out of the double quote context.
attribute values are escaped with the function `Kup.prototype.encodeAttribute` that you can overwrite.

kup will [HTML escape text content](https://www.owasp.org/index.php/XSS_%28Cross_Site_Scripting%29_Prevention_Cheat_Sheet#RULE_.231_-_HTML_Escape_Before_Inserting_Untrusted_Data_into_HTML_Element_Content).
content is encoded with the function `Kup.prototype.encodeContent` that you can overwrite.

use the `unsafe` function to insert text which should not be escaped:

```coffeescript
k.script ->
  k.unsafe 'javascript which should not be escaped'
```

use the `safe` function to insert text which should be escaped:

```coffeescript
k.p ->
  k.safe 'this will be escaped'
```

## pretty printing

kup doesn't insert any newlines into the generated HTML.

for some very basic pretty printing you can
configure kup to insert newlines after each opening tag (that has inner HTML)
and each closing tag:

```coffeescript
k = new Kup

k.newline = ->
  @htmlOut += '\n'
k.tag = (tag, attrs, content) ->
  @open tag, attrs
  if 'function' is typeof content
    @newline()
  @content content
  @close tag
  @newline()
```

## contribution

**TLDR: bugfixes, issues and discussion are always welcome.
ask me before implementing new features.**

i will happily merge pull requests that fix bugs with reasonable code.

i will only merge pull requests that modify/add functionality
if the changes align with my goals for this package
and only if the changes are well written, documented and tested.

**communicate:** write an issue to start a discussion
before writing code that may or may not get merged.

## credit

kup is inspired by [mark hahn's](https://github.com/mark-hahn) [drykup](https://github.com/mark-hahn/drykup)

## [license: MIT](LICENSE)
