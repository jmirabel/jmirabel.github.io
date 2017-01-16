---
layout: publication
section-type: post
id: thesis
pdf: http://homepages.laas.fr/jmirabel/jmirabel-thesis.pdf
---

## Thesis manuscript

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

- [State of the art]({{ page.pdf }}#page=17)
  - Motion planning
  - Task planning
  - Manipulation planning
- [Constrained motion planning]({{ page.pdf }}#page=31)
  - Notations and definitions
  - **Continuous path on manifolds**
  - Static stability
- [Manipulation planner]({{ page.pdf }}#page=53)
  - **Constraint Graph**
  - **Crossed foliation issue**
{% include video.html youtubeid="kptp-zZw634?start=50" %}
  - Generalized reduction property
  - Narrow passages
- [Affordance]({{ page.pdf }}#page=81)
  - Documented objects
  - **Constraint graph generation**
- [Result]({{ page.pdf }}#page=91)
  <br/><small>See the [HPP website](https://humanoid-path-planner.github.io/hpp-doc/index.html) for an overview of the results.</small>
  - Humanoid Path Planner
{% include video.html youtubeid="2ELEpuPjGP4" %}
  - Manipulator arms
{% include video.html youtubeid="kptp-zZw634?end=50" %}
{% include video.html youtubeid="iRJtmt7RzDM" %}
  - Humanoid robots
{% include video.html video="http://homepages.laas.fr/jmirabel/raw/videos/hrp2_stairs.mp4" %}
