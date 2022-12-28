;;; -*- Mode: Emacs-Lisp -*-
;;;
;;; 19-next.el --- Emacs 19 for NeXTSTEP hacks.
;;;
;;; Time-stamp: <22/12/28 19:37:56 asmodai>
;;; Revision:   185
;;;
;;; Copyright (c) 2011-2022 Paul Ward <asmodai@gmail.com>
;;;
;;; Author:     Paul Ward <asmodai@gmail.com>
;;; Maintainer: Paul Ward <asmodai@gmail.com>
;;; Created:    16 Feb 2011 07:24:29
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

(setq ns-convert-font-trait-alist
      '(("Ohlfs" "Courier-Bold" "Courier-Oblique"
         "Courier-BoldOblique")))

(defun rgb-to-hex (r g b)
  (if (next-mach-p)
      (format "RGB%02x%02x%02xff" r g b)   ; NeXT colour resource.
      (format "#%02x%02x%02x"     r g b))) ; X11 colour resource.

;; For the default colours to work as expected, the following commands
;; will probably be required:
;;
;;  NEXTSTEP and OPENSTEP:
;;      dwrite Emacs Foreground RGBdbbcffff
;;      dwrite Emacs Background RGB0f0017ff
;;
;;  Unix:
;;      Hack your .Xdefaults:
;;      
;;
;; You can also save preferences once done.
(defun configure-emacs-graphics ()
  (when (not (terminal-p))
    (require 'font-lock)
    (global-font-lock-mode 1)

    (let ((fg-default   (rgb-to-hex 219 188 255))
          (bg-default   (rgb-to-hex  15   0  23))
          ;;
          ;; Attributes.
          (fg-bold      (rgb-to-hex 250 247 255))
          ;;
          ;; Cursor
          (cursor-color (rgb-to-hex 217 111 255))
          ;;
          ;; Modeline.
          (fg-modeline  (rgb-to-hex 226 209 255))
          (bg-modeline  (rgb-to-hex  40  21  50))
          ;;
          ;; Primary selection.
          (fg-highlight (rgb-to-hex 222 155 255))
          (bg-highlight (rgb-to-hex  44   1  65))
          ;;
          ;; Secondary selection.
          (fg-secondary (rgb-to-hex 155 255 194))
          (bg-secondary (rgb-to-hex   1  64  25))
          ;;
          ;; Region.
          (fg-region    (rgb-to-hex 255 156 232))
          (bg-region    (rgb-to-hex  64   1  49))
          ;;
          ;; Syntax
          (fg-comment   (rgb-to-hex 189 255 188))
          (fg-function  (rgb-to-hex 255 188 188))
          (fg-keyword   (rgb-to-hex 255 218 188))
          (fg-reference (rgb-to-hex 188 255 250))
          (fg-string    (rgb-to-hex 188 208 255))
          (fg-type      (rgb-to-hex 213 255 188))
          (fg-variable  (rgb-to-hex 255 188 254)))
      ;;
      ;; Now we set 'em!
      (set-face-foreground 'default                      fg-default)
      (set-face-background 'default                      bg-default)
      ;;
      (set-face-foreground 'bold                         fg-bold)
      (set-face-background 'bold                         bg-default)
      ;;
      (set-face-foreground 'italic                       fg-bold)
      (set-face-background 'italic                       bg-default)
      ;;
      (set-face-foreground 'bold-italic                  fg-bold)
      (set-face-background 'bold-italic                  bg-default)
      ;;
      (set-face-foreground 'underline                    fg-bold)
      (set-face-background 'underline                    bg-default)
      ;;
      (set-cursor-color                                  cursor-color)
      ;;
      (set-face-foreground 'modeline                     fg-modeline)
      (set-face-background 'modeline                     bg-modeline)
      ;;
      (set-face-foreground 'highlight                    fg-highlight)
      (set-face-background 'highlight                    bg-highlight)
      ;;
      (set-face-foreground 'secondary-selection          fg-secondary)
      (set-face-background 'secondary-selection          bg-secondary)
      ;;
      (set-face-foreground 'region                       fg-region)
      (set-face-background 'region                       bg-region)
      ;;
      (set-face-foreground 'font-lock-comment-face       fg-comment)
      (set-face-background 'font-lock-comment-face       bg-default)
      ;;
      (set-face-foreground 'font-lock-function-name-face fg-function)
      (set-face-background 'font-lock-function-name-face bg-default)
      ;;
      (set-face-foreground 'font-lock-keyword-face       fg-keyword)
      (set-face-background 'font-lock-keyword-face       bg-default)
      ;;
      (set-face-foreground 'font-lock-reference-face     fg-reference)
      (set-face-background 'font-lock-reference-face     bg-default)
      ;;
      (set-face-foreground 'font-lock-string-face        fg-string)
      (set-face-background 'font-lock-string-face        bg-default)
      ;;
      (set-face-foreground 'font-lock-type-face          fg-type)
      (set-face-background 'font-lock-type-face          bg-default)
      ;;
      (set-face-foreground 'font-lock-variable-name-face fg-variable)
      (set-face-background 'font-lock-variable-name-face bg-default)))
  nil)
