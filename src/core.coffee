root = global ? window
root.root = root

L = {}

## Do some setup of the global lemur object
root.lemur = L
core = L.core = {}

## Useful utility functions
do ->
  {toString} = Object::
  core.to_type = (o) ->
    s = toString.call o
    s = s.substring 8, s.length - 1
    s.toLowerCase()
    
core.s_trim = String::trim ? -> String(this).replace(/^\s+/, '').replace(/\s+$/, '')

do ->
  Noop = ->
  core.clone = Object.create ? (o) ->
    Noop:: = o
    new Noop()
    
    
## Set up node.js
#if process?.title is "node"
#  require "#{__dirname}/compiler"
#  require "#{__dirname}/parser"

## Export module
if exports? and module?
  #module.exports = L
else if provide?
  provide "lemur", L