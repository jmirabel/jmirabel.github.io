---
layout: thesis_chapter
chapter: 4
title: Affordance
page: 81
id: thesis
options: [ "use-toc", "mathjax" ]
---

* Will be replaced with the ToC, excluding the "Contents" header
{:toc}

### Objets documentées

{% include img/with_cap_b.html
 id="affordance_dor-gripper"
 src="/img/thesis/affordance/gripper.png"
 alt="Documentation of a gripper"
 style="float: left; margin-right: 1em;"
 img-style="height: 200px" %}
Préhenseur du robot.
{% include img/with_cap_e.html %}

L'affordance est un problème complexe.
Une documentation basique pour les préhenseurs, poignées et surfaces de contacts
permet de s'abstraire de ce problème.

{% include img/with_cap_b.html
 id="affordance_dor-handle"
 src="/img/thesis/affordance/handle.png"
 alt="Documentation of a handle"
 style="width: 150px; float: right; margin-left: 1em;"
 img-style="height: 200px" %}
Poignée et surface de l'objet.
{% include img/with_cap_e.html %}

Sur les trois images ci-contre, les repères représentent les positions de saisies.
L'axe X, en rouge, est un axe d'approche.
L'axe Z, en bleu, est un axe possible de rotation.
Il est utilisé pour les saisies autorisant un ou plusieurs degrés de liberté.
Une saisie est valide si les deux repères se confondent.

{% include img/with_cap_b.html
 id="affordance_dor-kitchen"
 src="/img/thesis/affordance/kitchen.png"
 alt="Documentation of an environment"
 style="width: 200px; float: left; margin-right: 1em;"
 img-style="height: 200px" %}
Surfaces de contact sur l'environnement.
{% include img/with_cap_e.html %}

Les surfaces vertes sur l'objet définissent les parties de l'objet pouvant être en contact avec l'environnement.
Celles sur l'environnement définissent les surfaces sur lesquelles peut être posé un objet.
Une surface est définie par un polygone convexe et coplanaire.

#### Contrainte de contact

{% include img/with_cap_b.html
 id="dist_between_polygons"
 src="/img/thesis/affordance/dist_between_polygones.jpg"
 alt="Distance between polygons"
 style="width: 495px; float: right; margin-left: 1em;"
 img-style="height: 300px" %}
Distance entre deux polygones convexes coplanaires.
{% include img/with_cap_e.html %}

Un contact entre deux surfaces $$M$$, mobile, et $$S$$, support, est considéré valide si le centre
de la surface mobile est inclu dans la surface support.

Le polygone support, $$S$$, est inclu dans le plan $$\Pi$$.
$$C_M$$ est le barycentre du polygone mobile $$M$$.
$$Q_{M,S}$$ est la projection de $$C_M$$ sur $$\Pi$$, orthogonalement à $$\Pi$$.
$$d_{\parallel} (M, S)$$ est la norme de $$\vec{Q_{M,S}C_S}$$.
{::comment} correspond à Eq.~\eqref{eqn:distancePolygon_parallel} {:/comment}
$$d_{\bot} (M, S)$$ est la norme de $$\vec{Q_{M,S}C_M}$$.
{::comment} corresponds to Eq.~\eqref{eqn:distancePolygon_ortho} {:/comment}

La contrainte de validation de contact est :
$$
\begin{align}
  \func_{place} (\conf) =
                            \left\{
                              \begin{array}{cl}
                                \left[ v_x, 0  , 0  , \omega_y, \omega_z \right] & \text{if } Q_{M,S} \in S \\
                                \left[ v_x, v_y, v_z, \omega_y, \omega_z \right] & \text{otherwise}
                            \end{array}
                            \right. = 0
  \label{eqn:place_valid_c}
\end{align}
$$
et la fonction de paramétrization est :
$$
\begin{align}
  \bar\func_{place} (\conf) =
                            \left\{
                              \begin{array}{cl}
                                \left[ v_y, v_z, \omega_x \right] & \text{if } Q_{M,S} \in S \\
                                \left[ 0  , 0  , \omega_x \right] & \text{otherwise}
                            \end{array}
                            \right.
  \label{eqn:place_param_c}
\end{align}
$$
où $\vec{v} = (v_x, v_y, v_z) \in \real{3}$ et $\vec{\omega} = (\omega_x, \omega_y, \omega_z) \in \real{3}$
sont tel que $(\cross{\vec{\omega}}, \vec{v})$ est le logarithme[^logarithme] de la transformation de 
$$\mathcal{R}_M$$ par rapport à $$\mathcal{R}_S$$.

### Génération du graphe des contraintes

À partir de la documentation ci-dessus, il est possible de générer automatiquement un graphe des contraintes.
Pour limiter la combinatoire, l'utilisateur spécifie des règles indiquant,
par exemple, quelles sont les associations de préhenseurs et de poignées qui sont
valides ou interdites.
Cet algorithme permet notamment de rendre plus accessible un outil de planification de manipulation.
Bien que cela n'est pas été nécessaire, il serait également possible de spécifier des règles sur les surfaces de contact.

#### Génération des états

Les états sont générés simplement en itérant sur toutes les possibilités d'associations de préhenseurs
et de poignées.

#### Génération des transitions

L'algorithme construit automatiquement des transitions avec points de passage.
Il détecte également les espaces de saisie et de placement qui sont feuilletés
et intégre des "crossed foliation transition" si nécessaire.

[^logarithme]: Le logarithme est l'inverse de la
               [carte exponentielle](https://en.wikipedia.org/wiki/Exponential_map_(Lie_theory))
               de $$\mathfrak{se}(3)$$ vers $$SE(3)$$.
               Cet inverse est unique si l'on ne s'intéresse qu'à l'inverse de plus petite norme.
