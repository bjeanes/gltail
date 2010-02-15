GlTail
    by Erlend Simonsen <mr@fudgie.org>, http://www.fudgie.org
    slightly hacked up by jm3 / John Manoogian III <jm3@jm3.net>

== DESCRIPTION:
Real-time view of server traffic and events using OpenGL and SSH.

== FEATURES:
Everything Fudgie's gltail does, with added visualization support for:
* the 140 Proof ad-serving appserver cluster
* the 140 Proof database (slow-query log only, at this point)
* the Plus 1 "goodness generator"

== RUNNING:
  rake -T # for available modes

  Press 'b' while running to change default blob type, and space to toggle bouncing.

== REQUIREMENTS:
* rubygems    0.9.4
* ruby-opengl 0.40.1
* net-ssh     1.1.2
* opengl/ruby development packages (ruby1.8-dev libgl1-mesa-dev libglu1-mesa-dev libglut3-dev)
