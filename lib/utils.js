var fs = require('fs'),
    path = require('path'),
    root = require.main.filename,
    _ = require('underscore'),
    fm = require('file-manifest'),
    injectables = require('./injectables');

exports.find = function(list) {
  var location = _(list).find(function(dir) {
    if (/^\//.test(dir)) {
      return fs.existsSync(dir);
    } else {
      return fs.existsSync(path.resolve(root, dir));
    }
  });
  if (location) {
    return root + '/' + location;
  } else {
    return '';
  }
};

exports.require = function(dir) {
  return fm.generate(dir, '**/*.{js|coffee}', function(manifest, file) {
    var req = require(this.dir + '/' + file);
    if (req.name) {
      if (req.controller) {
        manifest[req.name] = req.controller;
      } else if (req.middleware) {
        manifest[req.name] = req.middleware;
      } else {
        manifest[req.name] = _(req).omit('name');
      }
    }
    return manifest;
  });
};

exports.inspect = function(fn) {
  return fn.toString().match(/^function\s*\(([^\)]*)/)[1].split(/,\s*/);
};

exports.inject = function(args) {
  return _(args).filter(function(arg) {
    return injectables[arg] ? true : false;
  }).map(function(arg) {
    return injectables[arg];
  });
};
