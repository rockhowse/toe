name: 'ToE'

description: 'Theory of Everything'

keywords: ['ToE']

version: require('fs').readFileSync('./VERSION', 'utf8')

author: 'feisty <ToE@feisty.co> (http://feisty.co/)'

licenses: [
  type: 'FEISTY'
  url: 'http://github.com/feisty/license/raw/master/LICENSE'
]

contributors: [
  'Nicholas Kinsey <pyro@feisty.co>'
  'Nathan Rashleigh <margh@feisty.co>'
]

repository:
  type: 'git'
  url: 'http://github.com/feisty/ToE.git'
  private: 'git@github.com:feisty/ToE.git'
  web: 'http://github.com/feisty/ToE'

bugs:
  mail: 'ToE@feisty.co'
  web: 'http://github.com/feisty/ToE/issues'

bin:
  ToE: './bin/ToE.coffee'

main: 'ToE.coffee'

dependencies:
  'express': '>= 2.4.0 < 2.5'
  'connect': '>= 1.5.1 < 1.6'
  'browserify': '>= 1.2.6 < 1.3'
  'coffee-script': '>= 1.1.1 < 1.2'
  'dnode': '>= 0.7.3 < 0.8'
  'redis': '>= 0.6.4 < 0.7'
  'colors': '>= 0.5.0 < 0.6'
  'underscore': '>= 1.1.6 < 1.2'
  'optimist': '>= 0.2.5 < 0.3'
  'backbone': '>= 0.5.0 < 0.6'
  'eyes': '>= 0.1.6 < 0.2'
  'fileify': '>= 0.2.1 < 0.3'
  
  # feisty
  # 'hydrogen': '>= 0.1.0 < 0.2'
  # 'radium': '>= 0.1.0 < 0.2'

engines:
  node: '>= 0.4.9 < 0.5'
  npm: '>= 1.0.15 < 1.1'