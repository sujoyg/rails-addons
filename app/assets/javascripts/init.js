function module(path, def) {
  var parent = window;

  path.split(".").every(function (token) {
    if (!parent[token]) {
      parent[token] = {};
    }
    parent = parent[token];

    return true;
  });

  $.extend(parent, def);
}
