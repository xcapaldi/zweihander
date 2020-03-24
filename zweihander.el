;;; zetteldeft.el --- Two-fisted approach to note-taking

;; Copyright (C) 2020 Xavier Capaldi

;; Author: Xavier Capaldi
;; URL: https://github.com/xcapaldi/zweihander
;; Keywords: org zettelkasten
;; Package-Requires: ((emacs "24.5") (org "9.1.9") (ivy "0.13.0") (swiper "0.13.0") (counsel "0.20.0"))

;; This file is not part of Emacs

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Zweihander is a small extension of the org mode package for Emacs.
;; It facilitates the use of org mode as a single-file zettelkasten note-taking system.
;; There are only three functions added through this package currently:
;; zweihander-link >> create two-way link between headers
;; zweihander-new-note >> create a new note with its ID
;; zweihander-child-note >> create a new note which has a unique ID but shared all other properties of its parent
;; For more information, see https://github.com/xcapaldi/zweihander

;;; Code:

(require 'swiper)

(defgroup zweihander nil
  "Minor mode for implementing zettelkasten in org-mode"
  :prefix "zweihander-"
  :group 'text
  :link '(url-link "https://github.com/xcapaldi/zweihander"))

(defun zweihander-link ()
  "Add two-way links between two notes in zettelkasten."
  (interactive)
  (save-excursion ; save current location
    (call-interactively 'org-store-link)
    (counsel-org-goto)
    (end-of-line)
    (if (eq (search-forward "* " nil t) nil) ; if there isn't another header past this point
	(progn
	  (goto-char (point-max))
	  (newline))
      (org-next-visible-heading 1)
      (previous-line))
    (org-insert-last-stored-link 1)
    (call-interactively 'org-store-link))
  (org-insert-last-stored-link 1) ; go back to original location and insert link
  )

(defun zweihander-new-note()
  "Insert a new note with a unique title."
  (interactive) ; allow user to call function
  (setq note_title (read-string "Enter note title:")) ; prompt for a new note title
  ;(push-mark) ; record our current position
  ;(goto-line 1) ; jump to the first line of the document
  ;(search-forward (concat "* " note_title) nil t) 
  ;(if (not (eq (search-forward (concat "* " note_title) nil t) nil)) ; if that note title is found in the body
      ;(progn ; allow the evaluation of more than one sexp for the true case
	;(message "That note title already exists!")
	;(pop-to-mark-command)) ; return to starting position
	;(pop-to-mark-command) ; else, return to starting position
  (org-next-visible-heading 1)
  (newline)
  (previous-line)
  (org-insert-heading)
  (insert note_title) ; and insert the new note title
  (newline)
  (insert ":PROPERTIES:")
  (newline)
  (insert ":CUSTOM_ID: ")
  (insert (concat "z" (replace-regexp-in-string ":" "" (format-time-string "%Y-%m-%d-%T"))))
  ;(org-time-stamp '(16) t) ; we need two universal prefix arguments for the convenient date-time
  (newline)
  (insert ":END:")
  (newline)
  )

(defun zweihander-child-note()
  "Insert a new note with a unique title.
   Pull all the same properties from the previous note except the ID."
  (interactive) ; allow user to call function
  (setq note_title (read-string "Enter note title:")) ; prompt for a new note title
  ;(push-mark) ; record our current position
  ;(goto-line 1) ; jump to the first line of the document
  ;(search-forward (concat "* " note_title) nil t) 
  ;(if (not (eq (search-forward (concat "* " note_title) nil t) nil)) ; if that note title is found in the body
      ;(progn ; allow the evaluation of more than one sexp for the true case
	;(message "That note title already exists!")
	;(pop-to-mark-command)) ; return to starting position
	;(pop-to-mark-command) ; else, return to starting position
  ;; we need to decide if we are inside a note or at the head
  ;; first let's take the current line and narrow it
  (beginning-of-line)
  (push-mark)
  (end-of-line)
  (narrow-to-region (region-beginning) (region-end))
  (if (eq (search-backward "* " nil t) nil) ; if * not found
      (progn
	(widen)
	(org-previous-visible-heading 1)) ; go the previous header which should be the header for the current note
    (widen)) ; otherwise just widen the region
  (next-line)
  (next-line)
  (next-line)
  (beginning-of-line)
  (push-mark)
  (search-forward ":END:")
  (copy-region-as-kill (region-beginning) (region-end))
  (org-next-visible-heading 1)
  (newline)
  (previous-line)
  (org-insert-heading)
  (insert note_title) ; and insert the new note title
  (newline)
  (insert ":PROPERTIES:")
  (newline)
  (insert ":CUSTOM_ID: ")
  (insert (concat "z" (replace-regexp-in-string ":" "" (format-time-string "%Y-%m-%d-%T"))))
  ;(org-time-stamp '(16) t) ; we need two universal prefix arguments for the convenient date-time
  (newline)
  (yank)
  (newline)
  )

(provide 'zweihander)
