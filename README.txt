GlTail
    by Erlend Simonsen <mr@fudgie.org>, http://www.fudgie.org
    slightly hacked up by John Manoogian III <jm3@jm3.net>, http://jm3.net

== DESCRIPTION:
Real-time view of server traffic and events using OpenGL and SSH.

== FEATURES:
everything that fudgie's gltail does, plus:
* parses the output of the goodness generator

== RUNNING:
  gl_tail config.yml
  gl_tail --new gl_tail.yaml

  You can press 'f' while running to toggle the attempted frames per second. Or 'b'
  to change default blob type, and space to toggle bouncing.

== REQUIREMENTS:
* rubygems    0.9.4
* ruby-opengl 0.40.1
* net-ssh     1.1.2
* opengl/ruby development packages (ruby1.8-dev libgl1-mesa-dev libglu1-mesa-dev libglut3-dev)

== INSTALL:
  * sudo gem install gl_tail
