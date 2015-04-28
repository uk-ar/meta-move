(defvar meta-move-last-command git-gutter:previous-hunk)
 
(setq meta-move-commands
      '((git-gutter:previous-hunk . git-gutter:next-hunk)
        (flycheck-previous-error . flycheck-next-error)
        ))
 
(defun meta-move-record (arg)
  (setq meta-move-last-command this-command))
 
;;meta-move-last-command
(mapc
 (lambda (elem)
   (advice-add (car elem) :after #'meta-move-record)
   (advice-add (cdr elem) :after #'meta-move-record)
   )
 meta-move-commands)
 
(defun meta-move-previous (arg)
  (interactive "P")
  (let ((command
         (or (assq meta-move-last-command meta-move-commands)
             (rassq meta-move-last-command meta-move-commands))))
    (when command
      (setq this-command (car command))
      (call-interactively (car command)))
    ))
 
(defun meta-move-next (arg)
  (interactive "P")
  (let ((command
         (or (assq meta-move-last-command meta-move-commands)
             (rassq meta-move-last-command meta-move-commands))))
    (when command
      (setq this-command (cdr command))
      (call-interactively (cdr command)))
    ))
 
(global-set-key (kbd "M-p") 'meta-move-previous)
(global-set-key (kbd "M-n") 'meta-move-next)
