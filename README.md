# zweihander
A two-handed approach to note-taking.

![zweihander.el](zweihander.png?raw=true "zweihander.el")

Small elisp package to extend org mode for use as a simple zettelkasten.

## Zettelkasten

The zettelkasten represents a note-taking methodology for which there is copious information online.
At its simplest, it is a plain-text note system in which notes are organized in ordered branching structures.
Each note should be atomic (hold a single idea) and have a unique identifer.
It should be written in your own words and ideally you should always be noting from a primary source.
In addition, each note should contain enough information to generate the full reference (I use DOI in most cases).
Tags can be utilized to group related notes in separate branches.
Finally direct links can connect parallel ideas across topics.

Most implementations of this style of notetaking involve the individual management of plain-text files.
There are already a few packages which do this quite nicely:

* [Zetteldeft](https://www.eliasstorms.net/zetteldeft/)
* [Org-roam](https://org-roam.readthedocs.io/en/latest/)

### So why did I bother creating this?

Fundamentally Org mode in Emacs is fully capable of managing a tree-like note structure in a single text file.
I'm sure there will be limitations eventually on file size as the zettelkasten grows larger but for my current purposes, this is much easier to manage and fits my particular workflow.
I am not dictating a particular workflow for the user and org mode's flexibility allows you to extend this system as you please.
You can even add images and inline code!

## Note structure

Example minimal note:

```
* Note title
:PROPERTIES:
:CUSTOM_ID: z2020-03-16-153034
:END:

Here is my note.

Look a related note: [[related note][related note]]
```

Here is the format I use for notes from scientific literature:

```
* Branch of notes on topic
** Note title
:PROPERTIES:
:CUSTOM_ID: z2020-03-16-153034
:KEY: capaldi2018probing
:DOI: 10.1039/c8sm01444b
:END:

Here is my note.

Look a related note: [[related note][related note]]

** A sub-branch with other notes
*** Other note 1
*** Other note 2
*** Other note 3
```

I use the same key from my .bib reference database so I can quickly find all notes from a particular source.

## Added functionality

There are only three functions added through this package currently:

* **zweihander-link** >> create two-way link between headers
* **zweihander-new-note** >> create a new note with its ID
* **zweihander-child-note** >> create a new note which has a unique ID but shared all other properties of its parent

### Built-in org mode functionality

Org mode already has some great functionality including tagging, folding and narrowing subtrees.
It's out of the scope of this documentation right now to go over all its features but I recommend checking out the offical documentation: [org mode documentation](https://org-roam.readthedocs.io/en/latest/)
Perhaps in the future I'll add a terse guide to org mode features particularly relevant to the implementation of a zettelkasten.

## Important considerations

* I am not experienced in elisp at all so this "package" could be quite buggy.
* Org mode allows the use of '-', '+' or '\*' for plain lists. Please avoid using '\*' in your zettelkasten to avoid bugs.
* The **CUSTOM_ID** property is both the unique zettelkasten identifier as well as a header for HTML export [(relevant blog post)](https://writequit.org/articles/emacs-org-mode-generate-ids.html).
* I recommend adding a final **FIN** note at the end of your zettelkasten which can help with some bugs until your collection of notes grows large. As of now there is still a bug for linking with the very last note.

## How to setup

First review my code! This package is quite short and you should be able to skim it quickly and see that it is indeed safe to run in your emacs.

This package requires:

* **org**, obviously
* **counsel** which in turn requires
* **swiper** and
* **ivy**

Download the zweihander.el file.

Load the package by adding it to your load path and requiring it:

```
(add-to-list 'load-path "~/path/to/folder/")
(require 'zweihander)
```

Alternatively, use use-package:

```
(add-to-list 'load-path "~/path/to/folder/")
(use-package zweihander
  :pin manual ;; manually update
  :hook org-mode)
```
