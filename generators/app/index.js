'use strict';
var yeoman = require('yeoman-generator');
var chalk = require('chalk');
var yosay = require('yosay');

var path = require('path');
var glob = require('glob');

function replaceVarsInPath(path, vars) {
  var replaced = path;
  Object.keys(vars).forEach(function (key) {
    replaced = replaced.split('$' + key + '$').join(vars[key]);
  });
  return replaced;
}

module.exports = yeoman.Base.extend({
  prompting: function () {
    // Have Yeoman greet the user.
    this.log(yosay(
      'Welcome to the pioneering ' + chalk.red('generator-virgo-recipe') + ' generator!'
    ));

    var prompts = [{
      type: 'input',
      name: 'recipeName',
      message: 'What\'s the Virgo recipe name?',
      default: 'Messaging with RabbitMQ'
    },
      {
        type: 'input',
        name: 'guideShortName',
        message: 'What\'s the Spring Guide short name?',
        default: 'messaging-rabbitmq'
      },
      {
        type: 'input',
        name: 'recipePackage',
        message: 'What\'s the Recipe\'s package name?',
        default: 'messaging.rabbitmq'
      }
    ];

    return this.prompt(prompts).then(function (props) {
      // To access props later use this.props.someAnswer;
      this.props = props;
    }.bind(this));
  },

  writing: function () {
    var context = {
      guideShortName: this.props.guideShortName,
      recipeName: this.props.recipeName,
      recipePackage: this.props.recipePackage
    };
    var templates = path.join(this.templatePath('.'), '/**/*.tpl');
    this.log('Using templates: \'' + templates + '\'.');
    var _this = this;
    glob.sync(templates).forEach(function (template) {
      var source = replaceVarsInPath(path.relative(_this.templatePath('.'), template), context);
      _this.log('Processing \'' + source + '\' based on ' + template + '\'...');
      var dest = source.substring(0, source.length - '.tpl'.length);
      _this.fs.copyTpl(template, dest, context);
      _this.log('Done.');
    });
  },

  install: function () {
    this.installDependencies();
  }
});
