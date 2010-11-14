fs = require "fs"
readFile = (name) -> fs.readFileSync name, 'utf-8'

task "all", "a full build", () ->
    invoke "compile-styles"
    invoke "compress"

task "compile-coffee", "Compile the coffee sources to javascript.", () ->
    invoke "create-output-dir"

    coffee = require "coffee-script"
    src = readFile "src/hn.coffee"

    try
        fs.writeFile "build/hn.js", coffee.compile src
        console.log "successfully compiled hn.coffee -> hn.js"
    catch err
        console.log "error compiling hn.coffee: #{err}"

task "compile-styles", "Compile the less source to css", () ->
    invoke "create-output-dir"

    less = require "less"
    src = readFile "src/hn.less"

    less.render src, (errs, css) ->
        if errs
            console.log "error compiling hn.less:\n #{errs}"
        else
            fs.writeFile "build/hn.css", css
            console.log "successfully compiled hn.less -> hn.css"

task 'create-output-dir', '', () ->
    try
        fs.mkdirSync "build", 0777
        console.log "Created the build directory"
    catch err
        console.log "The build directory already exists, but that's fine"

task 'compress', 'squash the javascript file up real nice', () ->
    invoke 'compile-coffee'

    {parser, uglify} = require "uglify"

    fat_js = readFile "build/hn.js"
    ast = parser.parse fat_js
    ast = uglify.ast_mangle ast
    ast = uglify.ast_squeeze ast
    final = uglify.gen_code ast

    fs.writeFile "build/hn.min.js", final
    console.log "compressed hn.js -> hn.min.js"
