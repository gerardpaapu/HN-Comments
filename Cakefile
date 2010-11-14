task 'build', 'put it all together', () ->
    fs = require "fs"
    less = require "less"
    coffee = require "coffee-script"

    coffee_src = fs.readFileSync 'src/hn.coffee', 'utf-8'
    less_src = fs.readFileSync 'src/hn.less', 'utf-8'

    try
        fs.mkdirSync "build", 0777
    catch err
        log "The build directory already exists, but that's fine"

    fs.writeFile "build/hn.js", coffee.compile coffee_src

    less.render less_src, (errs, css) ->
        if errs then log "error compiling hn.less:\n #{errs}"
        fs.writeFile "build/hn.css", css
