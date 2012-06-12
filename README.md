# up

simple html5 builder

## install

    npm install https://github.com/snd/up.git

## example usage

```coffeescript
Up = require 'up'

up = new Up

up.doctype()

up.html ->
    up.head ->
        up.title 'a title'
        up.script {
            src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'
            type: 'text/javascript'
        }
    up.body ->
        up.div {id: 'container'}, ->
            up.h1 'a heading'
            up.h2 {class: 'secondary-heading'}, 'another heading'
            up.ul ->
                'first second third'.split(' ').forEach (x) ->
                    up.li -> up.a x
            up.p ->
                up.addText 'Before the break'
                up.br()
                up.addText 'After the break'

console.log up.htmlOut
```

...will print this html:

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

## credit

up is inspired by [mark hahn's](https://github.com/mark-hahn) [drykup](https://github.com/mark-hahn/drykup)

### differences to drykup

- well tested
- only 43 loc (vs. drykup's 237 loc)
- twice as fast
- no indentation of the generated code
- only html5 doctype

## license

up is released under the MIT License (see LICENSE for details).
