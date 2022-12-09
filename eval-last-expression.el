
;;; import from sly
(defun slime-eval-print (string)
  "Eval STRING in Lisp; insert any output and the result at point. from sly"
  (slime-eval-async `(swank:eval-and-grab-output ,string)
    (lambda (result)
      (cl-destructuring-bind (output value) result
        (push-mark)
        (let* ((start (point))
               (ppss (syntax-ppss))
               (string-or-comment-p (or (nth 3 ppss) (nth 4 ppss))))
          (insert output (if string-or-comment-p
                             ""
                           " => ") value)
          (unless string-or-comment-p
            (comment-region start (point) 1)))))))

(defun slime-eval-last-expression-in-repl2 (prefix)
  "Evaluates last expression in the Slime REPL and continue edit."
  (interactive "P")
  (let ((expr (slime-last-expression))
        (buffer-name (or (buffer-file-name (current-buffer))
                         (buffer-name (current-buffer))))
        (new-package (slime-current-package))
        (old-package (slime-lisp-package))
        (slime-repl-suppress-prompt t)
        (yank-back nil)
        (cur-line (line-number-at-pos))
        (cur-point (point)))
    (save-excursion
      (backward-char (length expr))
      (let ((beg-line (line-number-at-pos))
            (beg-point (point)))
        (with-current-buffer (slime-output-buffer)
          ;;      (unless (eq (current-buffer) (window-buffer))
          ;;        (pop-to-buffer (current-buffer) t))
          (goto-char (point-max))
          ;; Kill pending input in the REPL
          (when (< (marker-position slime-repl-input-start-mark) (point))
            (kill-region slime-repl-input-start-mark (point))
            (setq yank-back t))
          (unwind-protect
              (progn
                (insert-before-markers (format "\n;;; from %s : line %d-%d, (%d-%d)\n"
                                               buffer-name
                                               beg-line cur-line
                                               beg-point cur-point))
                (when new-package
                  (slime-repl-set-package new-package))
                (let ((slime-repl-suppress-prompt nil))
                  (slime-repl-insert-prompt))
                (insert expr)
                (slime-repl-return))
            (unless (or prefix (equal (slime-lisp-package) old-package))
              ;; Switch back.
              (slime-repl-set-package old-package)
              (let ((slime-repl-suppress-prompt nil))
                (slime-repl-insert-prompt))))
          ;; Put pending input back.
          (when yank-back
            (yank)))))))


;;;
;;
;; (add-hook 'lisp-mode-hook
;;           '(lambda ()
;;              (slime-mode 1)
;;              (local-set-key (kbd "C-j") 'slime-eval-print-last-expression)
;;              (local-set-key (kbd "<C-return>") 'slime-eval-last-expression-in-repl2)) )
;; 
;;;
