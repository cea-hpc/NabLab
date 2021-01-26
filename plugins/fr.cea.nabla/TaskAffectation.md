# Présentation du problème

**Introduction**

NabLab possède l'instruction Affectation composée d'une ArgOrVarRef à gauche du égal et d'une Expression à droite du égal.
Lors de la génération, on fait simplement quelque chose du type :

	left.generate = right.generate.

Les validateurs garantissent que les parties droite et gauche sont du même type.
Néanmoins, dans le cas de tableaux, la génération entraine de l'aliasing puisqu'il n'y a pas de recopie du contenu des tableaux 
mais une affectation directe (et pas de surcharge de l'opérateur =).

Même si l'aliasing peut dans certains cas offrir un gain de performance, il est préférable qu'il soit fait sur une passe supplémentaire
avec une heuristique d'optimisation maitrisée. De base, il serait souhaitable qu'une recopie soit effectuée.

**Algèbre linéaire et ConnectivityVariable**

L'affectation sur des ConnectivityVariable n'a pas été interdite afin de pouvoir faire des instructions du type :

	X^{n+1} = solveLinearSystem(...)

Dans ce cas, l'affectation traite une ConnectivityVariable de type Vector (LinearAlgebra).

Le problème est que le code Eucclhyd possède des affectations directes de ConnectivityVariable avec une des deux variables de type Vector/Matrix et l'autre non. 
Le validateur ne lève pas d'erreur car les deux côtés de l'affectation ont bien le même type de ConnectivityVariable. Mais une des deux est de type LinearAlgebra
ce qui crée une erreur à la génération puisque les types sont différents.

# Tâches à réaliser

Ces tâches sont présentées dans leur ordre de réalisation.

**Validateur**

Interdire l'affectation d'une ConnectivityVariable sauf si elle est LinearAlgebra et que l'expression à droite de l'affectation est LinearAlgebra.
Cela permettra de laisser passer le solve mais pas le reste. Dans ce cas particulier, il n'y aura pas d'aliasing car le vecteur est réallouée par le solve.
Si une affectation directe de deux ConnectivityVariable de type LinearAlgebra est faite par l'utilisateur il y aura aliasing mais ce cas n'a pas été rencontré
et il semble rare.

Q : que veut dire "l'expression à droite de l'affectation est LinearAlgebra". Jai testé que l'expression est un appel de fonction de type LinearAlgebra. Problème, que se passe-t'il si l'utilisateur veur définir son propre solveur ou tout autre méthode qui renvoit un tableau type connectivity ?

**Copie lors de l'affectation**

Dans le cas où la variable affectée (partie gauche de l'affectation) a un type avec une liste BaseType.sizes non vide (tableau),
il faut insérer n boucles dans le modèle IR avant l'affectation, n étant la taille de la liste BaseType.sizes.
Ainsi, les affectations se feront toujours sur des scalaires. La génération sera triviale puisque le travail aura été fait lors
de la construction de l'IR.
Notons que l'insertion des boucles se fait quelque soit le type de la variable, ConnectivityVariable ou SimpleVariable.
Si l'affectation a lieu à l'intérieur d'une boucle sur les mailles sur une ConnectivityVariable aux mailles, les boucles
seront naturellement insérées à l'intérieur.

**Marquage des variables**

Actuellement, lors de la génération, des fonctions permettent de savoir si les variables sont LinearAlgebra.
Il serait souhaitable de modifier l'IR pour mettre un attribut de type LinearAlgebra sur les ConnectivityVariable.
Ce travail a déjà été réalisé par MP sur son fork. Il permet, de plus, d'uniformiser les variables LinearAlgebra.
Par exemple, si une variable Un+1 est LinearAlgebra, toutes les autres variables Un (Un, Un=0, Un+1,k...) seront LinearAlgebra.

*Note:* la fonction fr.cea.nabla.ir.ArgOrVarExtensions.isLinearAlgebra(Function it) semble inutile. 
Elle peut probablement être remplacée lors de l'appel par la même sur isLinearAlgebra(ArgOrVar)

**Généralisation aux jobs de boucle en temps**

A l'heure actuelle, tous les TimeLoopJob (SetUp, Execute et TearDown) possèdent un ensemble de copies.
Ces copies sont des formes d'affectation simplifiées où les parties gauches et droites sont des variables.
Il faudrait généraliser le problème en remplaçant les copies par des affectations (souhaitable aussi pour Truffle).
Le travail réalisé au point précédent garantira que les variables de 2 côtés de l'affectation seront ou non LinearAlgebra.
Dans le cas du Execute, les copies sont optimisées par des switch de variables Un<-->Un+1. Il sera toujours possible de 
le faire en n'appelant pas la génération de l'affectation.

