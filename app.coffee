express       = require "express"
session       = require "express-session"
cookie_parser = require "cookie-parser"

app = express()

app.set "title", "RAC"
app.set "view engine", "jade"
app.use express.static "public"
app.use '/', require "./routes/index"

env = process.env.NODE_ENV || "development"

server = app.listen 3000, ->

  host = server.address().address
  port = server.address().port

  console.log "listening at http://#{host}:#{port}"
