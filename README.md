# kup

[![Build Status](https://travis-ci.org/snd/kup.png)](https://travis-ci.org/snd/kup)

kup is an html builder for nodejs

### install

```
npm install kup
```

### use

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

produces the following html:

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

### xss prevention

kup will [html escape text content](https://www.owasp.org/index.php/xss_%28cross_site_scripting%29_prevention_cheat_sheet#rule_.231_-_html_escape_before_inserting_untrusted_data_into_html_element_content).

kup will [properly quote attributes using double quotes](https://www.owasp.org/index.php/xss_%28cross_site_scripting%29_prevention_cheat_sheet#rule_.232_-_attribute_escape_before_inserting_untrusted_data_into_html_common_attributes).
properly quoted attributes can only be escaped with the corresponding quote.
kup escapes all double quotes inside attributes values to prevent escaping.
in order to prevent [xss](http://en.wikipedia.org/wiki/cross-site_scripting) kup will:

use the `unsafe` function to insert inner text which will not be escaped:

```coffeescript
kup.script ->
    kup.unsafe 'javascript which should not be escaped'
```

use the `safe` function to insert inner text which will be escaped:

```coffeescript
kup.p ->
    k.safe 'this will be escaped'
    k.br()
    k.safe 'this will also be escaped'
```

### credit

kup is inspired by [mark hahn's](https://github.com/mark-hahn) [drykup](https://github.com/mark-hahn/drykup)

### license: MIT
