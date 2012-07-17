# Kup

generate html from pure coffeescript

### Install

    npm install kup

### Use

this coffeescript program:

```coffeescript
Kup = require 'kup'

k = new Kup

k.doctype()

k.html ->
    k.head ->
        k.title 'a title'
        k.script
            src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'
            type: 'text/javascript'
    k.body ->
        k.div {id: 'container'}, ->
            k.h1 'a heading'
            k.h2 {class: 'secondary-heading'}, 'another heading'
            k.ul ->
                'first second third'.split(' ').forEach (x) ->
                    k.li -> k.a x
            k.p ->
                k.unsafe 'Before the break'
                k.br()
                k.unsafe 'After the break'

console.log k.htmlOut
```

will generate this html:

```html
<!DOCTYPE html>
<html>
<head>
<title>a title</title>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
</head>
<body>
<div id="container">
<h1>a heading</h1>
<h2 class="secondary-heading">another heading</h2>
<ul>
<li>
<a>first</a>
</li>
<li>
<a>second</a>
</li>
<li>
<a>third</a>
</li>
</ul>
<p>Before the break<br />
After the break</p>
</div>
</body>
</html>
```

### XSS Prevention

in order to prevent [XSS](http://en.wikipedia.org/wiki/Cross-site_scripting) Kup will:

- [HTML escape content](https://www.owasp.org/index.php/XSS_%28Cross_Site_Scripting%29_Prevention_Cheat_Sheet#RULE_.231_-_HTML_Escape_Before_Inserting_Untrusted_Data_into_HTML_Element_Content)
- [escape attributes](https://www.owasp.org/index.php/XSS_%28Cross_Site_Scripting%29_Prevention_Cheat_Sheet#RULE_.232_-_Attribute_Escape_Before_Inserting_Untrusted_Data_into_HTML_Common_Attributes)
    - Kup properly escapes all attributes with double quotes
    - properly quoted attributes can only be escaped with the corresponding quote
    - Kup escapes all double quotes inside attributes to prevent escaping

#### Disable XSS Prevention selectively

The `unsafe` function doesn't escape the string you pass to it:

```coffeescript
kup.script ->
    kup.unsafe 'javascript which should not be escaped'
```

### Credit

Kup is a rewrite of [mark hahn's](https://github.com/mark-hahn) [drykup](https://github.com/mark-hahn/drykup)

#### Differences to drykup

- well tested
- much smaller codebase
- twice as fast
- no indentation of the generated code
- xss prevention
- only html5 doctype

### License: MIT
