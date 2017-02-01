---
layout: thesis_chapter
chapter: 3
title: Manipulation planner
page: 53
id: thesis
options: [ "use-toc", "mathjax", "syntax-highlight" ]
---

* Will be replaced with the ToC, excluding the "Contents" header
{:toc}

### Graphe des contraintes

Le graphe des contraintes est une description symbolique des règles de manipulation
pour un problème donné.

#### États et transisions

État
: Un état $$S$$ contient une contrainte de validation $$S.constraint$$
  et un ensemble de transitions sortantes $$S.transitions$$.

Transition
: Une transition $$T$$ contient une fonction de paramétrisation $$T.f$$,
  un état d'origine $$T.origState$$, un état de destination $$T.dstState$$
  et un état $$T.state$$.

Chemin admissible
: Un chemin $$\cpath \in \pathSpace$$ est *admissible pour la transition $$T$$*, ou *$$T$$-admissible*,
  si et seulement si les conditions suivantes sont toutes satisfaites:

    - $$\cpath(0) \in T.origState$$,
    - $$\forall t \in [0,1], \cpath(t) \in T.state$$,
    - $$\forall t \in [0,1], T.\func (\cpath(t)) = T.\func (\cpath(0))$$.

{% include img/with_cap_b.html
 id="constraint_graph_example"
 src="/img/thesis/constraint_graph_example.jpg"
 alt="Graph of constraints for a pick-and-place problem"
 style="width: 40%; float: left; margin-right: 1em;"%}
Graphe des contraintes pour un problème avec un robot
possédant une préhenseur et manipulant un objet.
{% include img/with_cap_e.html %}

Une configuration $$\conf$$ est dans $$S$$, noté $$\conf \in S$$,
si et seulement si $$\conf$$ satisfait $$S.constraint$$.
Une transition définit l'ensemble des chemins admissibles depuis un état.
L'état $$T.state$$ correspond à l'état contenant toutes les configurations
le long des chemins générés par cette transition.
Cet état garantit que, pour un chemin admissible $$\cpath$$,
toute restriction à des intervalles de la forme $$[0,t]\subset[0,1]$$ est admissible.

{% include img/with_cap_b.html
 id="grasp_and_placement_constraints"
 src="/img/thesis/maniprrt/frames.jpg"
 alt="Illustration of grasp and placement constraints"
 style="width: 40%; float: right; margin-left: 1em;"%}
Illustration des contraintes de saisies et positionnement.
{% include img/with_cap_e.html %}

Considèrons un robot et un objet cylindrique comme sur la figure ci-contre.
Nous autorisons un DDL en rotation pour la saisie de l'objet par le robot.
L'objet cylindrique peut être posé sur la table.
Les paramètres $y_p$, $z_p$ et $\theta_p$ sont contraints par la contrainte de paramétrisation du positionnement.
Ils paramétrisent le feuilletage de l'espace des positionnements.
Le paramètre $\theta_g$ est contraint par la contrainte de paramétrisation de saisie.
Il paramétrise le feuilletage de l'espace des saisies.

L'état *grasp* contient la contrainte de validation de saisie et *placement* contient celle relative au positionnement.
Les transitions *transit* et *grasp object* contiennent la contrainte de paramétrisation de positionnement.
Les transitions *transfer* et *release object* contiennent la contrainte de paramétrisation de saisie.

#### Planificateur de manipulation

La figure ci-dessous illustre le fonctionne de l'algorithme *Manipulation-RRT*.
Elle représente l'espace des configurations du robot et de l'objet.
Les feuilles vertes correspondent à des positionnements contants de l'objet,
Les jaunes à des saisies contantes de l'objet.

{% include img/with_cap_b.html
 id="manipulation_rrt"
 src="/img/thesis/maniprrt/maniprrt.jpg"
 alt="Steps of the Manipulation-RRT algorithm"
 class="img-responsive center-block"
 style="width: 80%;"%}
Étapes de l'algorithme *Manipulation-RRT*.
{% include img/with_cap_e.html %}

- (a): tirage d'une configuration aléatoire $$\conf_{rand}$$.
- (b): pour chaque composante connexe de l'arbre des configurations,
  recherche de la configuration la plus proche $$\conf_{near}$$.
- choix d'une transition sortant de l'état de la configuration $$\conf_{near}$$ dans le graphe des contraintes.
  Ce choix est fait aléatoirement.
- (c-d): extension de $$\conf_{near}$$ en utilisant la transition précédente, jusqu'à $$\conf_{new}$$.[^extension]
- tentative de connexion les nouvelles configurations ensemble.[^connexion]
- (f): l'algorithme termine quand la configuration initiale et une configuration but sont dans la même composante connexe.

### Problème des feuilletages croisés

Ce problème subtil intervient lorsque deux feuilletages se croisent.
Considérons encore l'exemple du robot avec un objet cylindique.

{% include img/with_cap_b.html
 id="crossed-foliation"
 src="/img/thesis/crossed_foliation/connecting-trees.png"
 alt="The crossed foliation issue"
 class="center-block"
 style="width: 50%;" %}
Croisement de feuilletage.
{% include img/with_cap_e.html %}

Si *grasp* et *placement* sont feuilletés,
les arbres partant des configurations initiale et finales ne se rencontreront jamais.
En effet, les façons d'attraper l'objet, i.e. les plans bleus ci-dessus, sont choisies aléatoirement.
La probabilité de choisir le même plan est nulle.
Afin de palier à ce problème, des transitions de type *crossed foliation transition*
mémorisent les feuilles atteintes par chaque composante connexe.
Cette information est utilisé pour générer des configurations dans les feuilles déjà atteintes.
Ce type de transitions ne remplace pas le type normal car il ne permette pas d'explorer de nouvelles feuilles.
Il est complémentaire au précédent.

Le problème est abordé de façon plus formelle dans le manuscrit.

### Propriété de réduction généralisée

L'exemple ci-dessous est un contre-exemple à la propriété de réduction telle qu'énoncé originellement.[^reduction]

{% include img/with_cap_b.html
 id="reduction_property_infeasible"
 src="/img/thesis/reduction_property/infeasible.jpg"
 alt="Counter examples to the reduction property"
 class="img-responsive center-block"
 style="width: 40%; float: left; margin-right: 1em;"%}
2 contre-exemples à la propriété de réduction.
{% include img/with_cap_e.html %}

Dans les 2 cas ci-contre, l'objet se déplace dans le plan.
La différence entre les positions initiales (a) et (b),
et les positions finales (c) et (d) est l'orientation de l'objet.
Chacune de ces configurations est dans $$\mathcal{CP} \cap \mathcal{CP}$$.
Il existe bien un chemin dans cet espace qui connecte les configurations,
cependant, il n'existe pas de solution à ces deux cas.

$$\newcommand{\motion}[3][]{\ensuremath{\mathcal{M}^{#1}(#2, #3)}\xspace}$$

Soit $\motion[i]{\conf}{\epsilon}$ l'espace des chemins admissibles depuis $$\conf$$
et inclus dans $$\ball{\conf}{\epsilon}$$,
i.e. $$ \{ \cpath \in \mathcal{C}^i([0,1],\ball{\conf}{\epsilon}) \mid \cpath(0)=\conf \}$$.

Les robots ci-dessus sont contrôlable en espace petit.
Cependant, l'objet n'est pas manipulable en espace petit par le robot.
Il n'existe pas de petit chemin qui permette de changer l'orientation de l'objet en gardant sa position.
Il est nécessaire de changer d'inverse cinématique.

Manipulabilité en espace petit
: Soit $$R$$ un robot et $$O$$ un objet.
  Soit $$e_r : \mathcal{CS}_R \to SE(3)$$, resp. $$e_o : \mathcal{CS}_O \to SE(3)$$
  la fonction continue de cinématique directe qui associe à une configuration du robot, resp. de l'objet,
  une position de la préhenseur, resp. une poignée.

  $$O$$ est *manipulable en temps petit par $R$ en
  $$(\conf_{r}, \conf_{o}) \in \mathcal{CS}_R \times \mathcal{CS}_O $$*
  si et seulement si $$ \forall \epsilon_r > 0$$,
  $$\exists \epsilon_o > 0, \forall \cpath_o \in \motion[1]{\conf_o}{\epsilon_o},
  \exists \cpath_r \in \motion[1]{\conf_r}{\epsilon_r}$$ such that

  $$
  e_r(\cpath_r(t))^{-1} e_o(\cpath_o(t)) = e_r(\conf_r)^{-1} e_o(\conf_o)
  $$

Une condition nécéssaire et une condition suffisante, vérifiables en pratique, sont fournies dans le manuscrit.

{% include theorem/b.html
  id="generalized_reduction_property"
  title="Propriété de reduction généralisée" %}

Soit $R$ un robot et $O$ un objet.
Tout chemin $\cpath$ dans $\mathcal{CG} \cap \mathcal{CP}$ satisfaisant les conditions suivantes
en tout instant peut être approximé par une séquence finie de chemin de <em>transit</em> et de <em>transfert</em> :
<ul>
<li>le robot est sans collision avec les objets statiques en $\cpath(t)$,</li>
<li>$R$ est contrôlable en temps petit,</li>
<li>$O$ est manipulable en temps petit par $R$ en $\cpath(t)$.</li>
</ul>
{% include theorem/e.html %}

L'utilisation des fonctions de cinématique directe permet de couvrir les cas de saisie d'un objet par deux préhenseurs.
Cela donne le corollaire 3.2, qui étant le théorème précédent à $$\mathcal{CG}_1 \cap \mathcal{CG}_2$$.

### Passages étroits

{% include img/with_cap_b.html
 id="waypoint_simplecase"
 src="/img/thesis/waypoints/simple_case.jpg"
 alt="Narrow passages with a simple example"
 style="width: 60%; float: left; margin-right: 1em;"%}
Passages étroits avec des exemples simples.
{% include img/with_cap_e.html %}

L'échantillonnage aléatoire résout difficilement les problèmes pour lesquels il est nécessaire de trouver
un passage étroit.

La planification de mouvement de manipulation est sujette à ce problème puisque l'on souhaite
que le préhenseur soit proche de l'objet à manipuler et que l'objet soit proche de l'environnement pour y être posé.
Ces cas sont résumés sur les figures ci-contre.
Pour aider le planificateur, des points de passages sont ajoutés automatiquement.
Ils correspondent par exemple aux figures (c) et (d).

{% include img/with_cap_b.html
 id="waypoints_configspace"
 src="/img/thesis/waypoints/configspace.jpg"
 alt="Way-point transition in the configuration space"
 style="width: 40%; float: right; margin-left: 1em;"%}
Point de passage dans l'espace des configurations.
{% include img/with_cap_e.html %}

Ces points de passage aident à trouver les passages étroits induit par les règles de manipulations.
Ils sont encodés dans le graphe des contraintes par un troisième type de
transition appelée *way-point transition*.
Le figure ci-contre montre l'effet des points de passage dans l'espace des configurations.
Les configurations $$w_i$$ sont calculées à partir des points de passage.
Le chemin de $$\conf_{init} \in \mathcal{C}_{grasp}$$ à $$\conf_{end} \in \mathcal{C}_{placement}$$
est calculé en un coup.

-----

*[DDL]: Degré de liberté
*[RRT]: Randomly exploring Random Trees
[^extension]: voir l'algorithm 3.2.
[^connexion]: voir l'algorithm 3.3.
[^reduction]: Benoit Dacre-Wright, Jean-Paul Laumond, and Rachid Alami.
              Motion planning for a robot and a movable object amidst polygonal obstacles.
              In Proceedings of IEEE International Conference on Robotics and Automation, 1992.
