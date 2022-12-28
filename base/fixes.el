;;; -*- Mode: Emacs-Lisp; byte-compile-dynamic-docstrings: t; byte-compile-dynamic: t -*-
;;;
;;; fixes.el --- Various fixes.
;;;
;;; Time-stamp: <22/12/28 19:40:47 asmodai>
;;; Revision:   3
;;;
;;; Copyright (c) 2015-2022 Paul Ward <asmodai@gmail.com>
;;;
;;; Author:     Paul Ward <asmodai@gmail.com>
;;; Maintainer: Paul Ward <asmodai@gmail.com>
;;; Created:    31 Jan 2015 14:15:08
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

;;; If we are on GNU Emacs 20.x then we need to deal with the fact
;;; that `font-lock-unfontify-buffer' might be missing.  This symbol
;;; seems present in GNU Emacs 20.6 however, so assume that any
;;; version lesser than 20.6 will require the fix.
(when (and (emacs-p)
           (= emacs-major-version 20)
           (< emacs-minor-version 6)
           (not (fboundp 'font-lock-unfontify-buffer)))
  (defalias 'font-lock-unfontify-buffer 'ignore)
  (require 'font-lock))

;;; Emacs 19 on NeXT lacks `custom-set-variables' sadly.
(when (and (emacs-p)
           (= emacs-major-version 19)
           (not (fboundp 'custom-set-variables)))
  (defalias 'custom-set-variables 'ignore))

;;; fixes.el ends here
