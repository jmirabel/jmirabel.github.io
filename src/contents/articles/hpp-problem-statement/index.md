---
title: HPP - Problem statement
author: Joseph Mirabel
date: 2016-03-17 15:00
template: article.jade
---

The Humanoid Path Planner (HPP) is an open-source library for motion planning.

<span class="more"></span>

As most classic motion planners, it solves problems defined by the following inputs:
- a robot, defining the configuration space,
- an environment,
- an initial and several goal configurations.

However, as its name suggests it, it is intended to be used on humanoid robots and this formulation is not general enough.
Indeed, the robot balance implies that motion planning has to be done in a sub-manifold.
Thus, HPP extends the motion planning problem to constrained problems. The user can specify __constraints__, such as quasi-static equilibrium.

Another specificity of HPP is its manipulation planning framework.
HPP tackles manipulation problems defined by the following inputs:
- a set of robots and objects - possibly articulated - with handles and grippers attached to specific joints,
- a static environment, with surfaces on which object can be put down,
- a configuration for the robots,
- an initial and goal configuration for each object.

From the set of robots, objects and surfaces, we define a finite state machine.
The states are symbolic relationship between those elements, such as *handle H is grasped by gripper G* or *object I is on surface S*.
The transition between states represents possible actions, such *put down object O on surface S*.
This finite state machine is called **Constraint graph**
