---
layout: thesis_chapter
chapter: 5
title: Results
page: 91
id: thesis
options: [ "use-toc", "mathjax" ]
---

* Will be replaced with the ToC, excluding the "Contents" header
{:toc}

Le grand intérêt de cette thèse est l'approche abstraite du problème qui
permet de couvrir un grande variété de cas.
Ceci est mis en avant dans ce chapitre au travers d'exemples variés.

### Humanoid Path Planner

Les exemples ci-après utilisent la librairie open-source [*Humanoid Path Planner*](https://humanoid-path-planner.github.io/hpp-doc/index.html).
Les algorithmes présentés dans cette thèse, ainsi que les travaux de recherche d'autres membres de l'équipe [Gepetto](http://projects.laas.fr/gepetto),
y ont été intégrés.

Cette librairie traite le problème de planification de mouvement.
Les principales caractéristiques sont les suivantes:

- Espace des configurations :
  - les rotations 3D sont représentées par $$SO(3)$$,[^quaternion]
  - les rotations non bornées sont représentées par $$SO(2)$$,
- Contraintes :
  - une abstraction des fonctions différentiables permet d'intégrer simplement de nouvelles contraintes, telles que définies au [chapitre 2](chap2.html#contraintes).
  - elles sont résolues par une implémentation de l'algorithme de Newton-Raphson.
- Chemins :
  - ils sont implémentés comme une fonction du temps, de manière abstraite.
  - les contraintes sont appliquées à l'évaluation du chemin à une abscisse curviligne donnée. Cela assure que les contraintes sont satisfaites partout.
    La continuité des chemins contraints est vérifiables par les algorithmes détaillés au [chapitre 2](chap2.html#chemin-continue-sur-des-varits)

#### Comparison with OMPL

Le tableau suivant compare HPP avec OMPL, une librairie de planification de mouvement couramment utilisée.
La vidéo suivante montre les benchmarks utilisés pour la comparaison.

{% youtube 01K_nmax9E0?start=237 class="center-block" poster=/img/thesis/posters/ompl_bench.jpg %}

<br/>

<style type="text/css">
.tg {}
.tg td{padding:10px 5px;border-style:solid;border-color:white;border-width:1px;overflow:hidden;word-break:normal;}
.tg th{padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
.tg .tg-baqh{text-align:center;}
.tg .green{color:green;}
.tg .red{color:red;}
</style>
<table class="table tg">
  <tr>
    <th class="tg-baqh">scenario</th>
    <th class="tg-baqh" colspan="4">min time (s)</th>
    <th class="tg-baqh" colspan="4">avg time (s)</th>
  </tr>
  <tr>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">HPP-D</td>
    <td class="tg-baqh">HPP-C</td>
    <td class="tg-baqh">OMPL</td>
    <td class="tg-baqh">OMPL-NR</td>
    <td class="tg-baqh">HPP-D</td>
    <td class="tg-baqh">HPP-C</td>
    <td class="tg-baqh">OMPL</td>
    <td class="tg-baqh">OMPL-NR</td>
  </tr>
  <tr>
    <td class="tg-baqh">Pipedream-Ring</td>
    <td class="tg-baqh green">0.065</td>
    <td class="tg-baqh green">0.043</td>
    <td class="tg-baqh">0.458</td>
    <td class="tg-baqh">0.618</td>
    <td class="tg-baqh green">1.24</td>
    <td class="tg-baqh green">2.05</td>
    <td class="tg-baqh">3.00</td>
    <td class="tg-baqh">4.23</td>
  </tr>
  <tr>
    <td class="tg-baqh">Abstract      </td>
    <td class="tg-baqh green">0.159</td>
    <td class="tg-baqh green">0.408</td>
    <td class="tg-baqh">23.5 </td>
    <td class="tg-baqh">14.3 </td>
    <td class="tg-baqh green">47.6 </td>
    <td class="tg-baqh green">34.4 </td>
    <td class="tg-baqh">107  </td>
    <td class="tg-baqh">107  </td>
  </tr>
  <tr>
    <td class="tg-baqh">Cubicles      </td>
    <td class="tg-baqh green">0.049</td>
    <td class="tg-baqh green">0.024</td>
    <td class="tg-baqh">0.096</td>
    <td class="tg-baqh">0.118</td>
    <td class="tg-baqh green">0.271</td>
    <td class="tg-baqh green">0.130</td>
    <td class="tg-baqh">0.277</td>
    <td class="tg-baqh">0.329</td>
  </tr>
</table>

<table class="table tg">
  <tr>
    <th class="tg-baqh">scenario</th>
    <th class="tg-baqh" colspan="4">max time (s)</th>
    <th class="tg-baqh" colspan="4">success rate (%)</th>
  </tr>
  <tr>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">HPP-D</td>
    <td class="tg-baqh">HPP-C</td>
    <td class="tg-baqh">OMPL</td>
    <td class="tg-baqh">OMPL-NR</td>
    <td class="tg-baqh">HPP-D</td>
    <td class="tg-baqh">HPP-C</td>
    <td class="tg-baqh">OMPL</td>
    <td class="tg-baqh">OMPL-NR</td>
  </tr>
  <tr>
    <td class="tg-baqh">Pipedream-Ring</td>
    <td class="tg-baqh green">6.52 </td>
    <td class="tg-baqh green">7.35 </td>
    <td class="tg-baqh">10.4 </td>
    <td class="tg-baqh">14.1</td>
    <td class="tg-baqh">100</td>
    <td class="tg-baqh">100</td>
    <td class="tg-baqh">100</td>
    <td class="tg-baqh">100</td>
  </tr>
  <tr>
    <td class="tg-baqh">Abstract      </td>
    <td class="tg-baqh green">258  </td>
    <td class="tg-baqh green">178  </td>
    <td class="tg-baqh">297  </td>
    <td class="tg-baqh">270 </td>
    <td class="tg-baqh red">94 </td>
    <td class="tg-baqh red">94 </td>
    <td class="tg-baqh">96 </td>
    <td class="tg-baqh">98 </td>
  </tr>
  <tr>
    <td class="tg-baqh">Cubicles      </td>
    <td class="tg-baqh red">0.902</td>
    <td class="tg-baqh red">0.946</td>
    <td class="tg-baqh">0.665</td>
    <td class="tg-baqh">1.06</td>
    <td class="tg-baqh">100</td>
    <td class="tg-baqh">100</td>
    <td class="tg-baqh">100</td>
    <td class="tg-baqh">100</td>
  </tr>
</table>

<table class="table tg">
  <tr>
    <th class="tg-baqh">scenario</th>
    <th class="tg-baqh" colspan="4">avg number of nodes</th>
    <th class="tg-baqh">time-out (s)</th>
  </tr>
  <tr>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">HPP-D</td>
    <td class="tg-baqh">HPP-C</td>
    <td class="tg-baqh">OMPL</td>
    <td class="tg-baqh">OMPL-NR</td>
    <td class="tg-baqh"></td>
  </tr>
  <tr>
    <td class="tg-baqh">Pipedream-Ring</td>
    <td class="tg-baqh green">2283 </td>
    <td class="tg-baqh green">2452 </td>
    <td class="tg-baqh">16100 </td>
    <td class="tg-baqh">22681 </td>
    <td class="tg-baqh">20 </td>
  </tr>
  <tr>
    <td class="tg-baqh">Abstract      </td>
    <td class="tg-baqh green">11927</td>
    <td class="tg-baqh green">10807</td>
    <td class="tg-baqh">177914</td>
    <td class="tg-baqh">181427</td>
    <td class="tg-baqh">300</td>
  </tr>
  <tr>
    <td class="tg-baqh">Cubicles      </td>
    <td class="tg-baqh red">495  </td>
    <td class="tg-baqh red">302  </td>
    <td class="tg-baqh">261   </td>
    <td class="tg-baqh">307   </td>
    <td class="tg-baqh">20 </td>
  </tr>
</table>

#### Programmation de robot

Un prototype d'interface de programmation de robot a été développé.
La vidéo suivante a été réalisée avec HPP en suivant la méthode [détaillé ici](https://humanoid-path-planner.github.io/hpp-doc//2016/10/06/Factory-In-A-Day-usecase.html)

{% video http://projects.laas.fr/gepetto/uploads/Members/fiad-full-sequence.mp4 560px 315px center-block %}

### Bras manipulateurs

#### Planification de réarrangement

Le robot Baxter intervertit la position de boîtes, avec un puis deux bras.
Ces problèmes ne sont pas monotones, c'est-à-dire qu'il n'existe pas de solution où chaque objet est manipulé au plus une fois, les uns après les autres.
Cet exemple montre la capacité du planificateur à trouver des positions de boîtes intermédiaires
ainsi qu'à considérer des manipulations simultanées.

{% youtube kptp-zZw634?start=4&end=34 class="center-block" poster=/img/thesis/posters/baxter_3box.jpg %}

#### Inférence

Le robot PR2 doit prendre un objet à l'intérieur d'un tiroir.
La contrainte de stabilité assure que l'objet se déplace quand le tiroir est déplacé.
Elle à l'avantage d'être complètement indépendante des objets considérés.

La séquence de tâche n'est pas donné.
Le planificateur découvre une solution où le robot ouvre le tiroir.
Cet exemple montre la capacité d'exploration du planificateur.
Il est capable de considérer des objets à la même position au début et à la fin.

{% youtube iRJtmt7RzDM                class="center-block" %}

### Robots humanoïdes

#### Mouvement de marche quasi-statique

Le problème de locomotion peut être modélisé comme un problème de manipulation, comme le montre cet exemple.
La position des pieds au sol représente un feuilletage.
Ce problème est donc sujet au problème de feuillates croisés.
La première vidéo utilise un critère de statibilité simple reposant sur le fait que les pieds sont à hauteur constante.
La second vidéo utilise le critère de stabilité détaillé [plus tôt](chap2.html#quilibre-quasi-statique).

<div class="text-center">

{% video http://homepages.laas.fr/jmirabel/raw/videos/hrp2_step_over.mp4 560px 315px %}
{% video http://homepages.laas.fr/jmirabel/raw/videos/hrp2_stairs.mp4 300px 315px %}

</div>

#### Romeo tenant une bannière

Cet exemple illustre également un cas avec feuilletages croisés.

{% youtube kptp-zZw634?start=53 class="center-block" poster=/img/thesis/posters/romeo_placard.jpg %}

#### Saisie derrière une porte

Dans cet exemple, le planificateur infère qu'il doit ouvrir la porte du placard pour attraper l'objet.
L'équilibre du robot est géré en deux étapes.
Tout d'abord, on calcule un chemin pour le robot glissant, comme sur la vidéo ci-dessous.
Ensuite, le chemin peut être transformé en un chemin faisable dynamiquement en utilisant la [méthode détaillé ici](https://youtu.be/X5bYGF1slcI).

{% youtube kptp-zZw634?start=34&end=50 class="center-block" poster=/img/thesis/posters/romeo_fridge.jpg %}

---

*[HPP]: Humanoid Path Planner
*[OMPL]: Open Motion Planning Library
*[OMPL-NR]: OMPL with "no range"
*[HPP-D]: HPP with discrete collision detection
*[HPP-C]: HPP with continuous collision detection
[^quaternion]: $$SO(3)$$ est représenté par des quaternions, avec les opérateurs différence et addition comme définis dans le [chapitre 2](chap2.html#notations-et-dfinitions).
               Les opérations de différence entre deux quaternions et d'addition d'une vitesse à un quaternion 
