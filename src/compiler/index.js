require("coffee-script");

var compiler_scripts = [
  "compiler",
  "construct",
  "array",
  "class",
  "function",
  "null",
  "number",
  "object",
  "operations",
  "regex",
  "scope",
  "string",
  "symbol"
];

for (var i = 0, len = compiler_scripts.length; i < len; i++) {
  require(__dirname + "/" + compiler_scripts[i]);
  //console.log(__dirname + "/" + compiler_scripts[i]);
}