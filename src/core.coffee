root = global ? window
root.root = root

L = {}
if exports? and module?
  module.exports = L
else if provide?
  provide "lemur", L

root.lemur = L

core = L.core = {}

do ->
  {toString} = Object::
  core.to_type = (o) ->
    s = toString.call o
    s = s.substring 8, s.length - 1
    s.toLowerCase()
    
core.s_trim = String::trim ? -> String(this).replace(/^\s+/, '').replace(/\s+$/, '')
    
if not String::trim
  String::trim = (s) -> s.replace(/^\s+/, '').replace(/\s+$/, '')