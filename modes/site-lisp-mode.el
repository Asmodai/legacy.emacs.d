;;; -*- Mode: Emacs-Lisp -*-
;;;
;;; site-lisp-mode.el --- Lisp mode hacks.
;;;
;;; Time-stamp: <22/12/28 19:44:26 asmodai>
;;; Revision:   43
;;;
;;; Copyright (c) 2011-2022 Paul Ward <asmodai@gmail.com>
;;;
;;; Author:     Paul Ward <asmodai@gmail.com>
;;; Maintainer: Paul Ward <asmodai@gmail.com>
;;; Created:    Mon Jun 06 02:48:09 2005
;;; Keywords:   
;;; URL:        not distributed yet
;;;
;;;{{{ License:
;;;
;;; This program is free software: you can redistribute it
;;; and/or modify it under the terms of the GNU General Public
;;; Licenseas published by the Free Software Foundation,
;;; either version 3 of the License, or (at your option) any
;;; later version.
;;;
;;; This program isdistributed in the hope that it will be
;;; useful, but WITHOUT ANY  WARRANTY; without even the implied
;;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;;; PURPOSE.  See the GNU General Public License for more
;;; details.
;;;
;;; You should have received a copy of the GNU General Public
;;; License along with this program.  If not, see
;;; <http://www.gnu.org/licenses/>.
;;;
;;;}}}
;;;{{{ Commentary:
;;;
;;;}}}

;;;
;;; There are two inferior Lisp systems that could be used here:
;;; Franz' ELI/XELI and Slime.  You can choose which one to use by
;;; setting the following variable to one of `allegro', `slime', or
;;; `nil' if there is no special inferior Lisp (or you are using an
;;; older Lisp that does not support either.)
;;;
(defvar *interactive-lisp-mode*
  (cond ((running-on-paradox-p) 'slime)
        ((running-on-magellan-p) 'slime)
        ((running-on-voyager-p) 'slime)
        ((running-on-challenger-p) 'slime)
        ((running-on-yorktown-p) 'slime)
        (t nil))
  "Current Interactive Lisp mode.

Can be one of:

`slime'     - Connect to a Lisp using SLIME.
`nil'       - Unsupported or old Lisp.")

;;; ==================================================================
;;;{{{ Utilities and predicates:

(defsubst slime-p ()
  "T if we are using SLIME."
  (eq *interactive-lisp-mode* 'slime))

(defsubst interactive-lisp-p ()
  "T if we are using a Lisp interactive mode."
  (not (null *interactive-lisp-mode*)))

;;;
;;; Sanity.  Slime will not load on older Emacsen.  ELI might if one
;;; has an old-enough copy of Allegro Common Lisp.
(when (and (or (emacs=18-p)
               (emacs=19-p)
               (emacs=20-p))
           (slime-p))
  (setq *interactive-lisp-mode* nil))

;;;}}}
;;; ==================================================================

;;; ==================================================================
;;;{{{ SLIME:

(when (slime-p)
  ;;
  ;; Set the inferior Lisp program.
  (setq inferior-lisp-program
        (cond ((unix-p)
               "sbcl --no-inform --no-linedit")
              ((windows-nt-p)
               "c:/ccl/wx86cl.exe")
              (t
               "lisp")))

  ;;
  ;; Load in SLIME.
  (compile-load "slime")
  (require 'slime)

  ;;
  ;; `slime-autodoc' does not work on XEmacs.
  (when (emacs-p)
    (compile-load "slime-fancy")
    (require 'slime-fancy))

  ;;
  ;; Configure which SLIME packages we want to load.
  (let ((slime-packages
         (if (emacs-p)
             '(slime-fancy slime-asdf slime-repl slime-autodoc)
             '(slime slime-asdf slime-repl))))
    (slime-setup slime-packages)))

;;;}}}
;;; ==================================================================

;;; ==================================================================
;;;{{{ Neat comments which should really be else-where:

(defun my-comment-region (start end)
  "Comment the region defined by `start' and `end' with a \"correct\"
number of comment characters depending on the major mode of the
buffer.  Has been known to get things horribly wrong."
  (interactive "*")
  (let* ((tmode (downcase mode-name))
         (chars (cond ((string= tmode "lisp") 3)
                      ((string= tmode "lisp interaction") 3)
                      ((string= tmode "scheme") 3)
                      ((string= tmode "emacs-lisp") 3)
                      (t 1))))
    (comment-region start end chars)))

(defun my-insert-comment (name &optional chars)
  "Insert a comment at the current point.  The comment will look
similar to:

<comment> <chars>
<comment> {{{ <name>

<comment> }}}
<comment> <chars>

To see an example of the output, look at site-lisp-mode.el."
  (interactive "*")
  (let ((start (point)))
    (insert (concat chars
                    "{{{ " name ":\n\n"
                    "}}}\n"
                    chars "\n"))
    (let ((end (point))
          (comment-padding ""))
      (my-comment-region start end))))

(defun make-group-lisp-comment (&rest args)
  "Insert a comment delimited by the = character."
  (interactive "*")
  (my-insert-comment
   "Group"
   "==================================================================\n"))

(defun make-major-lisp-comment (&rest args)
  "Insert a comment delimited by the - character."
  (interactive "*")
  (my-insert-comment
   "Major"
   "------------------------------------------------------------------\n"))

(defun make-minor-lisp-comment (&rest args)
  "Insert a comment delimited by the . character."
  (interactive "*")
  (my-insert-comment
   "Minor"
   "..................................................................\n"))

(defun make-plain-lisp-comment (&rest args)
  "Insert a comment with no delimitor character."
  (interactive "*")
  (my-insert-comment "Comment"))

;;;}}}
;;; ==================================================================

;;; ==================================================================
;;;{{{ Key bindings:

;;;
;;; Bindings for an Emacs that doesn't use a Symbolics keyboard
(unless (featurep 'symbolics)  
  ;;
  ;; Bindings for SLIME.
  (when (slime-p)
    (global-set-key [(control f9)] 'slime)
    (global-set-key [(control f10)] 'slime-connect)
    (global-set-key (kbd "<backtab>") 'slime-complete-symbol)
    (global-set-key [(meta r)] 'slime-reindent-region))
  
  ;;
  ;; Bindings for our custom comments.
  (when (emacs>=19-p)
    (global-set-key [(f6)] 'make-group-lisp-comment)
    (global-set-key [(f7)] 'make-major-lisp-comment)
    (global-set-key [(f8)] 'make-minor-lisp-comment)
    (global-set-key [(f9)] 'make-plain-lisp-comment)))

;;;
;;; Bindings for an Emacs that uses a Symbolics keyboard.
(when (and (featurep 'symbolics)
           (fboundp 'define-select-key)
           (fboundp 'define-function-key))
  ;;
  ;; Bindings for SLIME.
  (when (slime-p)
    (define-select-key "s" 'slime)
    (define-select-key "l" 'slime-connect)
    (global-set-key (kbd "<backtab>") 'slime-complete-symbol)
    (global-set-key [(control complete)] 'slime-complete-symbol)
    (global-set-key [(meta r)] 'slime-reindent-retion))
  
  ;;
  ;; Bindings for custom comments.
  (when (emacs>=19-p)
    (define-function-key "1" 'make-group-lisp-comment)
    (define-function-key "2" 'make-major-lisp-comment)
    (define-function-key "3" 'make-minor-lisp-comment)
    (define-function-key "4" 'make-plain-lisp-comment)))
                  
;;;}}}
;;; ==================================================================

;;; ==================================================================
;;;{{{ Other mode hacks:

;;; ------------------------------------------------------------------
;;;{{{ Common Lisp indentation:

(when (emacs>=19-p)
  ;;
  ;; Load in indentation hacks for Common Lisp.
  (compile-load "cl-indent-patches")
 
  ;;
  ;; Patch the indenting function for XEmacs.
  (if (xemacs-p)
      (setq lisp-indent-function
            (function common-lisp-indent-function))))

;;;}}}
;;; ------------------------------------------------------------------

;;; ------------------------------------------------------------------
;;;{{{ ParEdit mode:

;;;
;;; Configure the ParEdit sexpr editor
(when (featurep 'paredit)
  (defvar electrify-return-match "[\]}\)\"]")

  (defun electrify-return-if-match (arg)
    "If the text after the cursor matches `electrify-return-match'
then open and indent an empty line between the cursor and the
text.  Move the cursor to the new line."
    (interactive "P")
    (let ((case-fold-search nil))
        (if (looking-at electrify-return-match)
            (save-excursion
              (newline-and-indent)))
        (newline arg)
        (indent-according-to-mode)))

  (global-set-key (kbd "RET") 'electrify-return-if-match))

;;;}}}
;;; ------------------------------------------------------------------

;;; ------------------------------------------------------------------
;;;{{{ Parenthesis highlighting:

;;;
;;; Configure parenthesis highlighting.
(when (featurep 'highlight-parentheses)
  ;;
  ;; We want `highlight-parentheses' to work with autopair.
  (defun hi-parens-autopair ()
    (highlight-parentheses-mode t)
    (setq autopair-handle-action-fns
          (list 'autopair-default-handle-action
                '(lambda (action pair pos-before)
                  (hl-paren-color-update))))))

;;;}}}
;;; ------------------------------------------------------------------

;;; ------------------------------------------------------------------
;;;{{{ Other mode hooks:

;;;
;;; Hooks for auto-fill, font-lock, and SLIME.
(when (emacs>=19-p)
  ;;
  ;; I know these could be represented better, but I'd rather they
  ;; have fewer calls.
  ;;
  
  ;;
  ;; For interactive lisp, e.g. *scratch* buffer.
  (defun my-interactive-lisp-mode-hooks ()
    (when (or (emacs=20-p)
              (emacs=21-p))
      (turn-on-font-lock))
    (when (featurep 'paredit)
      (paredit-mode -1))
    (when (featurep 'company)
      (company-mode 1))
    (when (featurep 'highlight-parentheses)
      (hi-parens-autopair))
    (when (featurep 'semantic)
      (ede-minor-mode -1)
      (semantic-decoration-mode -1)
      (semantic-highlight-edits-mode -1)
      (semantic-highlight-func-mode -1)
      (semantic-show-unmatched-syntax-mode -1)
      (semantic-stickyfunc-mode -1))
    (when (emacs>=21-p)
      (eldoc-mode 1))
    (maybe-font-lock-mode 1)
    (show-paren-mode 1)
    (auto-fill-mode 1))
  
  ;;
  ;; For non-SLIME inferior lisp modes.
  (defun my-inferior-lisp-mode-hooks ()
    (when (or (emacs=20-p)
              (emacs=21-p))
      (turn-on-font-lock))
    (when (featurep 'paredit)
      (paredit-mode -1))
    (when (featurep 'company)
      (company-mode 1))
    (when (featurep 'highlight-parentheses)
      (hi-parens-autopair))
    (when (featurep 'semantic)
      (ede-minor-mode -1)
      (semantic-decoration-mode -1)
      (semantic-highlight-edits-mode -1)
      (semantic-highlight-func-mode -1)
      (semantic-show-unmatched-syntax-mode -1)
      (semantic-stickyfunc-mode -1))
    (when (emacs>=21-p)
      (eldoc-mode 1))
    (maybe-font-lock-mode 1)
    (show-paren-mode 1))
  
  ;;
  ;; For SLIME lisp modes.
  (defun my-slime-lisp-mode-hooks ()
    (when (or (emacs=20-p)
              (emacs=21-p))
      (turn-in-font-lock))
    (when slime-p
      (slime-mode 1))
    (when (featurep 'paredit)
      (paredit-mode 1))
    (when (featurep 'company)
      (company-mode 1))
    (when (and (slime-p)
               (featurep 'company))
      (require 'slime-company))
    (when (featurep 'highlight-parentheses)
      (hi-parens-autopair))
    (when (featurep 'semantic)
      (ede-minor-mode -1)
      (semantic-decoration-mode -1)
      (semantic-highlight-edits-mode -1)
      (semantic-highlight-func-mode -1)
      (semantic-show-unmatched-syntax-mode -1)
      (semantic-stickyfunc-mode -1))
    (auto-fill-mode 1)
    (when (emacs>=21-p)
      (eldoc-mode 1))
    (maybe-font-lock-mode 1)
    (show-paren-mode 1))
  
  ;;
  ;; For SLIME-repl mode.
  (defun my-slime-repl-mode-hooks ()
    (when (or (emacs=20-p)
              (emacs=21-p))
      (turn-in-font-lock)
      (maybe-font-lock-mode 1))
    (when (slime-p)
      (slime-mode 1))
    (when (featurep 'company)
      (company-mode 1))
    (when (and (slime-p)
               (featurep 'company))
      (require 'slime-company))
    (when (featurep 'highlight-parentheses)
      (hi-parens-autopair))
    (when (featurep 'semantic)
      (ede-minor-mode -1)
      (semantic-decoration-mode -1)
      (semantic-highlight-edits-mode -1)
      (semantic-highlight-func-mode -1)
      (semantic-show-unmatched-syntax-mode -1)
      (semantic-stickyfunc-mode -1))
    (when (emacs>=21-p)
      (eldoc-mode 1))
    (show-paren-mode 1))

  ;;
  ;; For non-SLIME lisp modes.
  (defun my-lisp-mode-hooks ()
    (when (or (emacs=20-p)
              (emacs=21-p))
      (turn-on-font-lock))
    (when (featurep 'paredit)
      (paredit-mode 1))
    (when (featurep 'company)
      (company-mode 1))
    (when (featurep 'highlight-parentheses)
      (hi-parens-autopair))
    (when (and (emacs>=21-p)
               (eq major-mode 'emacs-lisp-mode))
      (eldoc-mode 1))
    (when (featurep 'semantic)
      (ede-minor-mode -1)
      (semantic-decoration-mode -1)
      (semantic-highlight-edits-mode -1)
      (semantic-highlight-func-mode -1)
      (semantic-show-unmatched-syntax-mode -1)
      (semantic-stickyfunc-mode -1))
    (column-number-mode 1)
    (auto-fill-mode 1)
    (maybe-font-lock-mode 1)
    (show-paren-mode 1))
  
  ;;
  ;; Hooks for modes derived from emacs-lisp-mode
  (add-hook 'lisp-interaction-mode-hook 'my-interactive-lisp-mode-hooks)
  (add-hook 'inferior-lisp-mode-hook 'my-inferior-lisp-mode-hooks)
  (add-hook 'ielm-mode-hook 'my-interactive-lisp-mode-hooks)
  (add-hook 'emacs-lisp-mode-hook 'my-lisp-mode-hooks)
  (add-hook 'lisp-mode-hook 'my-slime-lisp-mode-hooks)
  (add-hook 'slime-repl-mode-hook 'my-slime-repl-mode-hooks)
  (add-hook 'scheme-mode-hook 'my-lisp-mode-hooks))

;;;}}}
;;; ------------------------------------------------------------------

;;;}}}
;;; ==================================================================

;;; site-lisp-mode.el ends here
