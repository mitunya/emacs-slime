# a little useful last-eval-expression for emacs slime

Execute lisp expressions without moving buffers.

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

# output example : slime-eval-print-last-expression

edit in *slime-scratch* buffer. or lisp-mode buffer.

```lisp
(defparameter *test-string* "Hello World") [CTRL-j]
 ; => *TEST-STRING*

(subseq *test-string* 6) [CTRL-j]
 ; => "World"


(loop for i to 10
      collect i
      do (print i)) [CTRL-j]

; 0
; 1
; 2
; 3
; 4
; 5
; 6
; 7
; 8
; 9
; 10  => (0 1 2 3 4 5 6 7 8 9 10)
```

# output example : slime-eval-last-expression-in-repl2

Press C-Return instead of C-j in the above example.

In the repl buffer, the code is executed as if it had been typed, and code editing can continue.

```
CL-USER>
;;; from *slime-scratch* : line 1-1, (1-43)
CL-USER> (defparameter *test-string* "Hello World")
*TEST-STRING*
CL-USER>
;;; from *slime-scratch* : line 4-4, (65-89)
CL-USER> (subseq *test-string* 6)
"World"
CL-USER>
;;; from *slime-scratch* : line 8-10, (106-159)
CL-USER> (loop for i to 10
      collect i
      do (print i))

0
1
2
3
4
5
6
7
8
9
10
(0 1 2 3 4 5 6 7 8 9 10)
CL-USER>
```

# Version - my using environment

slime-sersion - 2.27

emacs - 27.2
