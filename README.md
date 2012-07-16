# Kup

generate html from pure coffeescript

**Warning:** using Kup naively will leave you vulnerable to XSS attacks.
See section: *XSS Prevention* below for solutions.

### Install

    npm install kup

### Use

this coffeescript program:

```coffeescript
Kup = require 'kup'

kup = new Kup

kup.doctype()

kup.html ->
    kup.head ->
        kup.title 'a title'
        kup.script {
            src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'
            type: 'text/javascript'
        }
    kup.body ->
        kup.div {id: 'container'}, ->
            kup.h1 'a heading'
            kup.h2 {class: 'secondary-heading'}, 'another heading'
            kup.ul ->
                'first second third'.split(' ').forEach (x) ->
                    kup.li -> kup.a x
            kup.p ->
                kup.addText 'Before the break'
                kup.br()
                kup.addText 'After the break'

console.log kup.htmlOut
```

will generate this html:

```html
<!DOCTYPE html>
<html>
<head>
<title>
a title
</title>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript">
</script>
</head>
<body>
<div id="container">
<h1>
a heading
</h1>
<h2 class="secondary-heading">
another heading
</h2>
<ul>
<li>
<a>
first
</a>
</li>
<li>
<a>
second
</a>
</li>
<li>
<a>
third
</a>
</li>
</ul>
<p>
Before the break
<br />
After the break
</p>
</div>
</body>
</html>
```

### XSS Prevention

[XSS Prevention Cheat Sheet](https://www.owasp.org/index.php/XSS_%28Cross_Site_Scripting%29_Prevention_Cheat_Sheet)

[HTML Escaping](http://wonko.com/post/html-escaping)

```coffeescript
Kup = require 'kup'
{escape} = require 'html-escape'

kup = new Kup
    sanitizeContent: escape.content
    sanitizeAttribute: escape.attribute
```

#### Script Tags

```coffeescript
kup.script ->
    kup.addText 'javascript which should not be escaped'
```

### Credit

Kup is a rewrite of [mark hahn's](https://github.com/mark-hahn) [drykup](https://github.com/mark-hahn/drykup)

#### Differences to drykup

- well tested
- much smaller codebase
- twice as fast
- no indentation of the generated code
- hooks for xss prevention
- only html5 doctype

### License: MIT
