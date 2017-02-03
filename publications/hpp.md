---
layout: publication
section-type: post
id: hpp
youtubeid: 01K_nmax9E0
---

### Humanoid Path Planner

{% youtube 01K_nmax9E0 class="center-block" %}

More details on the [website](https://humanoid-path-planner.github.io/hpp-doc/index.html).

### Abstract

We present HPP, a software designed for complex classes of motion planning problems,
such as navigation among movable objects, manipulation, contact-rich multiped locomotion, or elastic rods in cluttered environments.
HPP is an open-source answer to the lack of a standard framework for these important issues for robotics and graphics communities.

HPP adopts a clear object oriented architecture,
which makes it easy to implement parts of an existing planning algorithm,
or entirely new algorithms.
Python bindings and a visualization tool allow for fast problem setting and prototyping:
a new algorithm can be implemented in just a few lines of code.

HPP can be used for classic planning problems such as pick and place for mobile robots,
but is specifically designed to solve problems where the motion of the robot is constrained.
Examples of behaviors produced by HPP thanks to a generic constraint formulation include:
maintaining a relative orientation between bodies,
enforcing the static equilibrium of the robot,
or automatically inferring that an object must be moved to allow locomotion.
Constraints are tied to a custom representation of the kinematic chain,
compatible with the Unified Robot Description format (URDF).

To illustrate the possibilities of HPP,
we present several recent scientific contributions implemented with HPP,
most of which are provided with Python tutorials.
HPP aims at being seamlessly integrated within a global robot control loop:
Pinocchio, the fast multi-body dynamics library, is currently being integrated in HPP,
thus bridging the gap between the planning and control communities.	
