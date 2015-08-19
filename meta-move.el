;;; meta-move.el --- Smartly move next and previous commands

;;-------------------------------------------------------------------
;;
;; Copyright (C) 2015 Yuuki Arisawa
;;
;; This file is NOT part of Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA
;;
;;-------------------------------------------------------------------

;; Author: Yuuki Arisawa <yuuki.ari@gmail.com>
;; URL: https://github/uk-ar/meta-move
;; Smartly move next and previous commands
;; Created: 1 April 2015
;; Version: 1.0
;; Keywords: move
;;; Compatibility: GNU Emacs 24.4

;;; Commentary:

;;; Code:
(defcustom meta-move-last-command 'previous-error
  "Initial value for meta move command."
  :group 'meta-move)

(defun meta-move-record ()
  (when (and
         (not (memq this-command '(next-line previous-line helm-next-line helm-previous-line)))
         (string-match-p "previous-\\|next-"
                           (symbol-name this-command)
                           ))
    (setq meta-move-last-command this-command)))

;; todo: point move hook exist?
(add-hook 'post-command-hook 'meta-move-record)

(defun meta-move-previous (arg)
  (interactive "P")
  (let ((command
         (intern (replace-regexp-in-string
           "next-" "previous-"
           (symbol-name meta-move-last-command)))
         ))
    (when command
      (setq this-command command)
      (call-interactively command)
    )))

(defun meta-move-next (arg)
  (interactive "P")
  (let ((command
         (intern (replace-regexp-in-string
                  "previous-" "next-"
                  (symbol-name meta-move-last-command)))
         ))
    (when command
      (setq this-command command)
      (call-interactively command)
      )))

(global-set-key (kbd "M-p") 'meta-move-previous)
(global-set-key (kbd "M-n") 'meta-move-next)

(provide 'meta-move)
;;; meta-move.el ends here
