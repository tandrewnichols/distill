var events = require('events'),
    emitter = new events.EventEmitter(),
    utils = require('./utils'),
    $ = require('varity'),
    extend = require('config-extend'),
    express = require('express'),
    injectables = require('injectables'),
    nconf = require('nconf'),
    _ = require('underscore');

var self = exports;

exports.config = $('of', function(config, fn) {
  var opts = {};
  opts.locations = {
    controllers: (config.locations.controllers || ['controllers', 'routes']),
    services: (config.locations.services || ['services', 'lib']),
    resources: (config.locations.resources || ['resources']),
    middleware: (config.locations.middleware || ['middleware'])
  };
  //opts.config = config.config || nconf;
  self.opts = opts;
  return self;
});

exports.load = function(config) {
  
};

exports.run = $('fof', function(cb) {
  var args = utils.inspect(cb);
  cb.apply(null, utils.inject(args));
});

exports.register = function (type, list) {
  _.chain().keys().each(function(name) {
    self[type](name, list[name]);
  });
};

exports.controller = function (name, fn) {

};

exports.service = function (name, fn) {

};

exports.resource = function (name, fn) {

};

exports.middleware = function (name, fn) {

};
