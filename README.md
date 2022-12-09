# useful last-eval-expression for emacs slime

slime-eval-print - Eval STRING in Lisp; insert any output and the result at point. from sly.

slime-eval-last-expression-in-repl2 - Evaluates last expression in the Slime REPL and continue edit.

# add your emacs init (.emacs or .emacs.d/init.el)

```emacs-lisp
(load "eval-last-expression.el")
(add-hook 'lisp-mode-hook
          '(lambda ()
             (slime-mode 1)
             (local-set-key (kbd "C-j") 'slime-eval-print-last-expression)
             (local-set-key (kbd "<C-return>") 'slime-eval-last-expression-in-repl2) ) )
```



# Version - my using environment

slime-sersion - 2.27

emacs - 27.2
