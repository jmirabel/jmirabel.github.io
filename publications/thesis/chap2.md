---
layout: thesis_chapter
chapter: 2
title: Constrained motion planning
page: 31
id: thesis
options: [ "use-toc", "mathjax", "syntax-highlight" ]
---

* Will be replaced with the ToC, excluding the "Contents" header
{:toc}

### Notations et définitions

Ce chapitre rappelle la définition de l'espace des configurations $$ \mathcal{CS} $$.
Cet espace est le produit cartésien des ensembles de définition de chacune des articulations.
Un soin particulier est porté aux espaces qui ne sont pas des espaces vectoriels.
Les rotations non bornées sont représentées par le groupe spécial orthogonal de 2, $$ SO(2) $$.
Les rotations 3D sont représentées par le groupe spécial orthogonal de 3, $$ SO(3) $$.
Pour chacun des espaces de configurations mentionnés, l'espace des vitesses correspondants est rappelé.
Sur ces espaces, sont définies deux opérations:

{% include img/with_cap_b.html
 id="quaternion_interpolation"
 src="/img/thesis/chapter2/notations/quaternion_interpolation.jpg"
 alt="Quaternion interpolation"
 style="width: 40%; float: left; margin-right: 2em;"%}
Représentation schématique de l'interpolation de quaternion.
La sphère unité de $\real{3}$ est représentée.
$q_1$ et $q_2$ sont deux éléments de celle-ci.
$-q_2$ représente la même rotation que $q_2$.
Quand $cos(\theta) \ge 0$, le chemin $q_1 \to q_2$ est plus court que $q_1 \to -q_2$.
Quand $cos(\theta) \lt 0$, le chemin $q_1 \to -q_2$ est plus court.
{% include img/with_cap_e.html %}

- L'addition d'une vitesse $$v$$ à une configuration $$q$$,
  qui donne la configuration obtenue après intégration de la vitesse pendant un temps unitaire.
- La différence entre deux configurations $$q_1$$ et $$q_2$$,
  qui donne la vitesse de plus petite norme pour passer de $$q_1$$ à $$q_2$$.
  Une attention particulière est portée à $$ SO(3) $$ afin d'éviter de faire "le grand tour".
  Les éléments de $$ SO(3) $$ sont représentés par des quaternions.
  La [figure](#quaternion_interpolation) ci-contre illustre le problème à prendre en compte.

Ces deux opérations nous permettent de définir, entre deux configurations $$ \conf_1, \conf_2 $$, une fonction de distance
$$\distance[D]{\conf_0}{\conf_1} = (\conf_1 - \conf_0)^T D (\conf_1 - \conf_0)$$
et une fonction d'interpolation linéaire

$$
\begin{equation}
\label{eqn:straight_interpolation}
\straight(\conf_0, \conf_1) :
\begin{array}{cl}
  [0, 1] & \to \mathcal{CS} \\
    s    & \mapsto \conf_0 + s \, (\conf_1 - \conf_0)
\end{array}
\end{equation}
$$

#### Contraintes

Les contraintes sont utilisées pour spécifier les règles de manipulations.
Par exemple, quand un robot manipule un objet,
l'objet se trouve toujours à une position stable ou dans la main du robot.
De plus, soit le robot se déplace seul et l'objet est statique, soit le robot déplace l'objet,
celui-ci étant à une position fixe par rapport à la main du robot.
Ces règles peuvent êtres encodées par deux types de contraintes sont définies.

Contrainte de validation
: Contrainte de la forme $$ \func(\conf) = 0 $$ où $$\func \in \funcSpace$$ et $$\conf \in \mathcal{CS}$$.
  $$n$$ est la *dimension* de la contrainte.

Contrainte de paramétrisation
: Contrainte de la forme $ \func (\conf) =  \rhs $
  où $\func \in \funcSpace$, $\conf \in \mathcal{CS}$ et $\rhs \in \real{n}$.
  $\rhs$ est le *paramètre* et $$n$$ est la *dimension*.

Une *contrainte de validation* est une *contrainte de paramétrisation* avec un paramètre $\rhs$ nul.
Dans l'exemple précédent, les deux contraintes de validation correspondent à l'objet en position stable
et à l'objet tenu par le robot.
Les deux contraintes de paramétrisation correspondent à l'objet statique dans un position stable
et à l'objet statique par rapport à la main du robot.

#### Chemin

Un chemin $$\cpath \in \pathSpace$$ est une fonction continue de $$[ 0, 1]$$ vers $$\mathcal{CS}$$.
Il possède un fonction d'interpolation $$\mathbf{interpolate}$$ et un ensemble de contraintes auquel il est soumis.
La configuration $$\cpath (t)$$, évaluée à l'instant $$t$$, correspond à la projection de $$ \mathbf{interpolate}(t) $$
sur l'ensemble satisfaisant les contraintes du chemin.
La méthode d'interpolation utilisé dans le reste de ce manuscrit est une interpolation linéaire par morceaux.
Il est cependant possible d'utiliser d'autres méthodes.

La méthode d'interpolation permet de garder un représentation continue des chemins.
L'évaluation des contraintes à posteriori permet d'assurer que toutes les configurations du chemin satisfont les contraintes.
Cependant, l'étape de projection n'est pas toujours continue. Ce problème est traité dans la section suivante.

### Chemin continue sur des variétés

Cette section traite de la continuité des chemins contraints.
Deux algorithmes basés sur l'algorithme de Newton-Raphson sont proposés.
L'image ci-dessous montre un cas où l'algorithme de Newton-Raphson génère un chemin contraint discontinu.

{% include img/with_cap_b.html
 id="projection_polynome"
 src="/img/thesis/pathprojection/easy_example.jpg"
 alt="2D illustration of discontinuous path projection"
 class="img-responsive center-block"
 style="width: 90%;"%}
Cet exemple en 2 dimensions, où $(x,y)$ sont les paramètres de configuration, montre le graphe de $\func\left( (x,y) \right) = y^2 - 1$.
Les 2 lignes horizontales en pointillées sont les solutions de $\func\left( (x,y) \right) = 0$.
Les 2 points rouges sont 2 configurations satisfaisant $\func(\conf) = 0$.
À gauche, la ligne bleue est l'interpolation linéaire entre les points rouges.
À droite, les lignes noires sont sa projection point par point.
La discontinuité est représentée par les points noirs et la ligne rouge en pointillée.
{% include img/with_cap_e.html %}

#### Continuité de l'algorithme de Newton-Raphson

Cet algorithme améliore itérativement la configuration courante afin de diminuer la norme de la valeur de la contrainte $$ \func(\conf) $$.
La fonction d'itération $$P_{\alpha} \in \mathcal{F} \left( \mathcal{CS}, \mathcal{CS} \right)$$, avec $$ \alpha \gt 0 $$ est:

$$
\begin{equation}
  P_{\alpha}(\conf) = \conf - \alpha \, \pseudoInv{\Jac(\conf)} \, \func (\conf)
  \label{eqn:projection_iteration}
\end{equation}
$$

où $\pseudoInv{A}$ est l'inverse généralisé de $A$
et $\Jac(\conf)$ est la matrice Jacobienne de $\func$ en $\conf$.
$P_\alpha(\conf)$ est la configuration obtenue après une itération, à partir de $\conf$.

{% include theorem/b.html
  id="continuity_nr_iteration_function"
  title="Continuité de $P_{\alpha}$" %}

Soit $\func \in \mathcal{C}^1 \left( \mathcal{CS}, \mathbb{R}^m \right)$, $\Jac(\conf)$ sa jacobienne
et $\sigma(\conf)$ la plus petite valeur singulière non nulle de $\Jac(\conf)$.
Finalement, soit $r = \max\limits_{\conf \in \mathcal{CS}} \left( rank(\Jac(\conf)) \right)$.

Si $\Jac$ est une fonction $K$-Lipschitzienne alors, $\forall \conf \in \mathcal{CS}$

$$ rank(\Jac(\conf)) = r         \Rightarrow        P_\alpha \text{ est continue sur } \ballContinuityF        $$

{% include theorem/e.html %}

La démonstration se trouve dans le [manuscrit]({{ site.data.thesis.pdf }}#page=26).

#### Algorithmes

Le lemme précédent fournit un critère simple.
Les algorithmes ci-dessous assurent qu'une itération de l'algorithme de Newton Raphson sera continue tout au long du chemin.

##### Projection progressive

Démarrant de la configuration de départ du chemin, l'algorithme génère séquentiellement une série de configuration
en s'assurant que

- chaque configuration se trouve dans l'intervalle de continuité de la configuration précédente,
- chaque configuration satisfait les contraintes.

{% include img/with_cap_b.html
 id="pathprojection_progressive"
 src="/img/thesis/pathprojection/progressive.png"
 alt="Progressive path projection algorithm"
 class="img-responsive center-block"
 style="width: 80%;"%}
Méthode de projection progressive.
{% include img/with_cap_e.html %}

L'image ci-dessus schématise son fonctionnement.
La surface verte est $\func(\conf) = 0$.
(a) montre le chemin initial.
(b) et (c) montrent deux itérations réussies.
Les deux premiers points d'interpolation sont ajoutés sans raffinement
car ils sont suffisamment proche du précédent.
(d) montre un point d'interpolation rejeté
car il est trop loin du précédent.
Il est raffiné en divisant la distance à son voisin par 2.
Cela résulte en (e) et le nouveau point d'interpolation est ajouté.

##### Projection globale

L'algorithme fonctionne en itérant sur les deux étapes ci-dessous jusqu'à ce que tous les points d'interpolation
satisfassent la contrainte et qu'ils soient suffisamment proche.

- Ajout de point d'interpolation au chemin courant quand deux points consécutifs sont trop loin.
- Diminution de l'erreur à chaque point d'interpolation.

{% include img/with_cap_b.html
 id="pathprojection_global"
 src="/img/thesis/pathprojection/global.png"
 alt="Global path projection algorithm"
 class="img-responsive center-block"
 style="width: 90%;"%}
Méthode de projection globale.
{% include img/with_cap_e.html %}
L'image ci-dessus schématise son fonctionnement.
La surface verte est $\func(\conf) = 0$.
(a) montre le chemin initial.
(b) et (d) montrent l'étape de ré-interpolation.
De nouveaux points d'interpolation sont ajoutés quand la distance en séparant deux consécutifs est trop grande.
(c) et (e) montrent l'étape de réduction de la violation de la contrainte.
Chaque point d'interpolation est déplacé afin de diminuer l'erreur.

#### Planification de mouvement continue

Les algorithmes précédents peuvent être intégrés à un algorithme de planification de mouvement entre l'étape de création de chemin
et celle de validation des collisions.
Par example, on peut simplement modifier la fonction d'extension de l'algorithm Constrained-RRT comme suit.

{% highlight python %}
def constrainedExtend(conf_near, conf_proj, tree, constraint):
  p_1 = interpolate(conf_near, conf_proj)
  pathProj = projector(constraint)
  p_2  = pathProj.apply (p_1)
  p_3  = testCollision (p_2)
  conf_new = finalConfiguration (p_3)
  tree.insertConfAndPath (conf_new, p_3)
{% endhighlight %}

### Équilibre quasi-statique

Cette section expose un critère d'équilibre quasi-statique dérivable basé sur de l'optimisation.

{% include img/with_cap_b.html
 id="qp_formulation"
 src="/img/thesis/constraints/qp_formulation.jpg"
 alt="Non-coplanar friction-less multi-contact criterion"
 class="img-responsive"
 style="width: 40%; float: left; margin-right: 1em;"%}
Critère de stabilité sans frottements pour des contacts non-coplanaire.
{% include img/with_cap_e.html %}

Soit un robot soumis à des efforts externes $$f_i \, \vec{n}_i$$
appliqués en $$P_i$$.
$$ G $$ denote le centre de gravité du robot.
L'équilibre quasi-statique du robot s'écrit 

$$
\begin{equation}
\label{eqn:stability_criteria}
\exists \mathbf{f} \in [0, +\infty[^n, \phi \mathbf{f} + m \mathbf{G} = 0_{\real{6}}
\end{equation}
$$

où $$\mathbf{f} = (f_1, \dots, f_n)^T \in \real{+n}$$,
$$\mathbf{G} = (0, 0, -9.81, 0, 0, 0)^T \in \real{6} $$
et 
$$ \phi = \left( \begin{array}{ccc}
        \dots & \vec{n}_i & \dots\\
        \dots & \vec{P_iG} \times \vec{n}_i & \dots
        \end{array} \right) \in \matrices{6}{n} $$.

En notant $$ \mathbf{H} = \phi^T \phi \in \matrices{n}{n}$$
et $$\mathbf{g} = m \phi^T \mathbf{G} \in \real{n} $$,
le problème \eqref{eqn:stability_criteria} est équivalent au *problème quadratique* suivant:

$$
\begin{equation}
\label{eqn:static_stability_qp}
\begin{array}{rl}
\min & C(\mathbf{f}) = \frac{1}{2}\mathbf{f}^T \mathbf{H} \mathbf{f} + \mathbf{f}^T \mathbf{g} \\
s.t.& \mathbf{f} \ge 0
\end{array}
\end{equation}
$$

En notant $$\mathbf{f}^*$$ l'optimum de \eqref{eqn:static_stability_qp},
le critère d'équilibre est alors le coût optimal $$ C(\mathbf{f}^*)$$.
Ce critère vaut zéro en cas d'équilibre quasi-statique.
Quand les conditions de relâchement supplémentaires de \eqref{eqn:static_stability_qp} sont strictement vérifiés,
la dérivé du critère d'équilibre est :

$$
\newcommand{\derive}[2][\conf]{\pd{#2}{#1}}
\begin{equation}
\label{eqn:derivative_optimal_cost}
\derive{C(\mathbf{f}^*)} = \frac{1}{2}\mathbf{f}^{*T} \derive{\mathbf{H}} \mathbf{f}^* + \mathbf{f}^{*T} \derive{\mathbf{g}}
\end{equation}
$$

Ce critère peut être intégré comme une contrainte dans une planificateur de mouvement contraint.
