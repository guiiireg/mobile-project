# Réponses — Évaluation Séance 3

## Développement d'applications mobiles — Bachelor 2 Informatique

> **Nom / Prénom :** Naël Guireg
> **Date :** 14 avril 2026

---

## Question 1 — StatefulWidget vs StatelessWidget

> Pourquoi l'écran de la todo list est-il un `StatefulWidget` et non un `StatelessWidget` ?  
> Que se passerait-il concrètement si on avait utilisé un `StatelessWidget` à la place ?

L'écran de la todo list est un `StatefulWidget` car son était change constamment (ajout d'une tâche, suppression, case cochée/décochée et saisie utilisateur).
Avec le `StatefulWidget` on peut appeler setState et directement refaire l'interface avec les nouvelles données.
Mais si on avait utilisé un `StatelessWidget`, l'écran aurait été considéré comme immuable, ce qui fait qu'il n'y a pas de gestion d'état pour le widget.
Concrètement, les actions qui pouvaient modifier la liste ne mettraient pas à jour l'UI correctement.

---

## Question 2 — Le rôle de setState

> Que fait exactement `setState` dans le cycle de vie d'un widget Flutter ?  
> Que se passe-t-il si on modifie la liste de tâches (ajout, suppression, toggle) **sans** appeler `setState` ?

`setState` permet de notifier Flutter que le widget a changé.
Quand on l'appelle, Flutter planifie un rebuild du widget pour remettre les nouvelles données à l'écran.
Si on modifie la liste des tâches `setState`, les données changent en mémoire, mais l'interface ne va pas se mettre à jour directement.
Visuellement, l'utilisateur peut voir une liste qui ne sera pas à jour (pas d'ajout/suppression/toggle) jusqu'à un rebuild déclenché par autre chose.

---

## Question 3 — La pile de navigation

> Expliquez le mécanisme de la pile de navigation Flutter.  
> Quand on navigue vers l'écran Statistiques, puis qu'on revient : que se passe-t-il en mémoire avec les écrans ? L'écran principal est-il reconstruit ?

Flutter utiliser une pile de routes, chaque écran est une route.
Quand on fait `Navigator.push`, l'écran Statistique est empilé au-dessus de l'écran principal qui reste en mémoire en dessous.
Quand on revient avec `Navigator.pop`, la route Statistiques est enlevée et l'écran principal redevient visible.
Donc en général l'écran principal n'est pas recréé depuis 0 à ce retour, il est restauré tel qu'il était.

---

## Question 4 — Bug de déclaration

> Un étudiant déclare son `TextEditingController` **à l'intérieur** de la méthode `build()` au lieu de le déclarer comme variable d'instance dans le `State`. Son champ de texte semble se comporter bizarrement.
>
> Expliquez le problème que cela pose et pourquoi.

IL y'a un problème si on déclare un `TextEditingController` dans `build()` est un problème, car `build()` peut être appelé très souvent (à chaque `setState`, changement de thème, etc).
Du coup, un nouveau controller est fait à chaque rebuild, le text peut se reset, le curseur "saute" et le comportement du champ devient instable.
De plus, on ne maîtrsie pas bien son cycle de vie, c'est impossible de le `dispose()` correctement si on fait plein dans `build()`, ce qui peut provoquer des fuites mémoire.
La meilleure pratique est de déclarer comme variable d'instance dans le `State` puis de l'initialiser une fois et le libérer dans `dispose()`.

---

## Question 5 — Choix de conception

> Votre application gère les tâches avec une simple `List` en mémoire. Quand l'utilisateur ferme l'application, toutes les tâches disparaissent.
>
> — Nommez une approche ou un package Flutter qui permettrait de persister les données entre deux lancements de l'app.  
> — Sans écrire de code, expliquez où dans l'architecture de l'app vous feriez les modifications.

Une approche correcte serait d'utiliser `Hive` ou `shared_preferences` pour un cas basique.
Il faudrait faire une couche séparée du widget UI, par exemple un service/repository `TaskRepository` chargé de lire/écrire les tâches.
Dans l'écran principal, au démarrage (`initState`) on irait charger les tâches depuis ce repo pour initialiser la liste.
Puise à chaque action (ajout, supression, toggle) on met à jour `List` + on sauvegarderait immétidatement dans le stockage afin de retrouver les données directement au prochain lancement.