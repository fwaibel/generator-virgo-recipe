'use strict';
var yeoman = require('yeoman-generator');
var chalk = require('chalk');
var yosay = require('yosay');

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
      }];

    return this.prompt(prompts).then(function (props) {
      // To access props later use this.props.someAnswer;
      this.props = props;
    }.bind(this));
  },

  writing: function () {
    this.fs.copyTpl(
      this.templatePath('settings.gradle'),
      this.destinationPath('settings.gradle'),
      {guideShortName: this.props.guideShortName}
    );
  },

  install: function () {
    this.installDependencies();
  }
});
