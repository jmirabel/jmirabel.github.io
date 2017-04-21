---
layout: publication
section-type: post
id: thesis
options: [ "menu-bar" ]
---

## Thesis manuscript

[Dissertation](http://homepages.laas.fr/~jmirabel/jmirabel-thesis.pdf)
|
[Defense slides (without videos ~ 9M)](http://homepages.laas.fr/~jmirabel/defense/jmirabel-defense-reduced.pdf)
|
[Defense slides (full ~ 93M)](http://homepages.laas.fr/~jmirabel/defense/jmirabel-defense.zip)

#### Abstract

This thesis tackles the manipulation planning for documented objects.
The difficulty of the problem is the coupling of a symbolic and a geometrical problem.
Classical approaches combine task and motion planning.
They are hard to implement and time consuming.
This approach is different on three aspects.

The first aspect is a theoretical framework to model admissible motions of the robot and objects.
This model uses constraints to link symbolic task and motions achieving such task.
A graph of constraint models the manipulation rules.
A planning algorithm using this graph is proposed.

The second aspect is the handling of constrained motion.
In manipulation planning, an abstract definition of numerical constraint is necessary.
A continuity criterion for Newton-Raphson methods is proposed to ensure the continuity of trajectories in sub-manifolds.

The last aspect is object documentation.
Some information, easy to define for human beings, greatly speeds up the search.
This documentation, specific to each object and end-effector, is used to generate a graph of constraint, easing the problem specification and resolution.

###### Key words
Manipulation planning, Constrained planning, Continuous trajectory generation, Affordance, Documented objects

<style>
ul {
text-align: left;
}
li {
text-align: left;
}
</style>

#### Chapters

A summary of each chapter is available (only in French so far).

1. [State of the art](thesis/chap1.html)
  - Motion planning
  - Task planning
  - Manipulation planning

1. [Constrained motion planning](thesis/chap2.html)
  - Notations and definitions
  - **Continuous path on manifolds**
  - Static stability

1. [Manipulation planner](thesis/chap3.html)
  - **Constraint Graph**
  - **Crossed foliation issue**
  <!--{% youtube kptp-zZw634?start=50&end=1m06 %}-->
  - Generalized reduction property
  - Narrow passages

1. [Affordance](thesis/chap4.html)
  - Documented objects
  - **Constraint graph generation**

1. [Result](thesis/chap5.html) \\
    <!--<small>See the [HPP website](https://humanoid-path-planner.github.io/hpp-doc/index.html) for an overview of the results.</small>-->
  - Humanoid Path Planner
  <!--{% youtube 01K_nmax9E0 %}-->
  - Manipulator arms
  <!--{% youtube kptp-zZw634?start=4&end=34 width=500 %}-->
  <!--{% youtube iRJtmt7RzDM                width=500 %}-->
  - Humanoid robots
  <!--{% youtube kptp-zZw634?start=34&end=50 %}-->
  <!--{% video http://homepages.laas.fr/jmirabel/raw/videos/hrp2_stairs.mp4 300px 315px %}-->
