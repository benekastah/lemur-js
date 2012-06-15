require("coffee-script");
var compiler_scripts = [
  "construct",
  "array",
  "class",
  "function",
  "null",
  "number",
  "object",
  "regex",
  "scope",
  "string",
  "var"
]
for (var i = 0, len = compiler_scripts.length; i < len; i++) {
  require("./" + compiler_scripts[i]);
}