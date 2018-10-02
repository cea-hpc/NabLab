# MEMO POUR LA DEMO NABLAB SLE 2018

## Environnement

Machine virtuelle Ubuntu comprenant :
* git, git gui, gitk
* Nabla avec compilateur gcc, CMake, Flex, Bison
* Eclipse avec Xtext, Sirius, CDT (pout montrer les fichiers C++) et les projets NabLab compilés.

Les projets Nabla et NabLab sont des clones git. Il est donc possible de pusher des modifications.

## Préparation de la démonstration

Le lancement de Eclipse s'effectue avec une icone placée sur le bureau. Les différents projets sont alors disponibles. Il faut ouvrir le fichier fr.cea.nabla/plugin.xml et cliquer sur la flèche verte en haut à droite pour lancer un runtime.
**Attention** : bien vérifier que la vue Latex est ouverte avant de commencer sinon l'ouvrir Window>Show View>Other>Nabla>Latex View.

Dans le runtime, un projet a été créé pour la démonstration. Il ne contient que le code du schéma numérique Glace2d (code hydrodynamique).

## A.1 NabLab Runtime Environment

### A.1.1 Model Explorer

* src : le source Glace2D.nabla avec son icone specifique et les fonctions utilitaires associées en Xtend.
* xtend-gen : les fonctions associées générées en Java par le compilateur Xtend
* src-gen contient notre génération sur laquelle nous reviendrons durant la démonstration.

### A.1.2 Textual Editor

Il faut double/cliquer sur le fichier src/Glace2d.nabla pour que le fichier s'ouvre dans l'éditeur Xtext. Il est alors possible de voir :
* La completion: se positionner ligne 67 après la dernière variable déclarée et faire CTRL/espace. On voit alors les types possibles de variables qui sont des caractères UTF-8 ce qui permet de mesurer l'intérêt de la complétion !
* Les erreurs et quick fixes : ligne 72, remplacer j par k dans center{j}. k est alors souligné et un quic fix propose de le remplacer par j.
* Le typage : ligne 72, placer le curseur sans cliquer au dessus de center{j} pour voir apparaitre le type de l'expression dans un tooltip.
* Montrer, en bas à gauche, l'outline personnalisée avec les formules "Latex light". Sélectionner un job dans l'outline permet de se positionner dans l'éditeur.
* Montrer en même temps qu'au changement de sélection la vue Latex se met à jour.

### A.1.3 IR Metamodel

Dans le répertoire src-gen on peut voir les fichiers .nablair générés lorsque le fichier nabla est enregistré. On constate qu'il y en a un pour le Java et un pour le Nabla (.n) car les passes effectuées sur l'IR sont différentes. Le résultat final est donc différent et c'est lui qui persiste dans le fichier .nablair. 

Il est possible d'ouvrir les ir avec l'éditeur de modèle EMF (Sample Generic EMF Editor normalement configuré par défaut sur ce type de fichiers). Si on ouvre les fichiers Glace2d.nabla.ir et Glace2d.java.ir, qu'on se positionner sur la 'Scalar Variable t', on constate qu'il y a une valeur par défaut en Java et pas en Nabla. En effet, elles ne sont pas autorisées en Nabla et sont remplacées par des jobs d'initialisation.

### A.1.4 Data Flow Graph

Le projet a été configuré un 'Modeling Project' (sinon clic drit sur le projet > 'Convert to Modeling Project) avec le point de vue adapté (sinon clic droit sur le project > Viewpoints Selection > Instruction Viewpoint).

Dans le répertoire src-gen, déplier l'onglet du fichier Glace2d.java.nablair et celui de l'objet de plus au niveau 'Ir Module Glace2d'. Double cliquer sur Glace2d Ir Graph pour voir apparaitre le graphe d'appel (il est possible de créer le graphe et de montrer le filtrage mais peut-être un peu long... à voir avec Benoît).

### A.1.5 Java Code Generator

Dans le répertoire src-gen on peut voir le fichier Glace2d.java généré lorsque le fichier nabla est enregistré. On peut l'ouvrir pour voir les boucles java multithreads, par exemple ligne 178.

Il est possible d'exécuter le Java avec un clic droit sur le fichier Run As > Java Application. Un répertoire output est alors créé à la racine du projet. Lancer Paraview en cliquant sur l'icone de la barre de gauche (avec les 3 bandes) > File > Open > /home/nablab/eclipse-workspace/DemoSLE/output > Glace2d.vtk. Cliquer ensuite sur Apply et sélectionner 'Surface with Edges' dans le menu déroulant en haut puis cliquer sur la fléche pour jouer le film.

### A.1.6 Nabla Code Generator

De la même manière, on peut voir le fichier Nabla généré (.n) et même le compiler avec le makefile 
fourni. Par contre, il est conseillé de ne pas l'exécuter car il n'a pas été recalé !!!

## A.2 NabLab Develoment Environment Architecture

Le mieux est alors de quitter le Eclipse de Runtime pour observer les projets dans le Eclipse hôte. 

* Projet fr.cea.nabla
** fr.cea.nabla/Nabla.xtext qui contient la grammaire qui génère le fichier model/generated/nabla.ecore.
** package fr.cea.nabla.typing qui contient tout le système de typage calqué sur celui du livre Implementing DSL with Xtext and Xtend de Lorenzo Bettini. Idem pour le Scope Provider du package fr.cea.nabla.scoping.
** le répertoire fr.cea.nabla.generator.ir qui montre bien que le code n'est pas généré depuis le nabla et qu'il y a bien un passage par l'IR.
** le répertoire nablalib contient la bibliothèque de base du langage nabla.

* Projets fr.cea.nabla.edit, fr.cea.nabla.editor, fr.cea.nabla.ide. RAS
* Projets fr.cea.nabla.javalib et cpplib contiennent des classes de base pour le code généré : typage et maillage. Ils implémentent notamment la bibliothèque nablalib pour les différents langages.

* Projet fr.cea.nabla.ir
** le répertoire model contient le fichier ecore (Pas généré mais écrit. Pas de Xtext ici).
** les différents packages montrent les générations java, nabla et kokkos (en cours - on revient dessus en conclusion).
** package fr.cea.nabla.transformers contient toutes les passes de transformation d'IR qui implémentent l'interface IrTransformationStep. Il est alors intéressant d'ouvrir le fichier fr.cea.nabla.ir.generator.java/Ir2Java.xtend et de se positionner en ligne 33 pour voir les passes de transformation utiles au Java (c'est la même chose sur le nabla et le kokkos).

* Projet fr.cea.nabla.sirius contient toutes les classes utiles au graphe d'appel et le fichier Sirius dans le répertoire description (.odesign)

* Projet fr.cea.nabla.ui contient toutes les fonctionnalités de l'éditeur (omplétion, tooltip, outline...) et la vue Latex (package fr.cea.nabla.ui.views).

