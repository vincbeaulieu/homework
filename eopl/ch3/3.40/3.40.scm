#lang eopl
;;; support pack and unpack from exercise 3.18.

(require eopl/tests/private/utils)
(require racket/pretty)

(require "data-structures.rkt")  ; for expval constructors
(require "lang.rkt")             ; for scan&parse
(require "interp.rkt")           ; for value-of-program
(require "translator.rkt")       ; for translation-of-program

(define run
  (lambda (string)
    (value-of-translation
     (translation-of-program
      (scan&parse string)))))

(define equal-answer?
  (lambda (ans correct-ans)
    (equal? ans (sloppy->expval correct-ans))))

(define sloppy->expval
  (lambda (sloppy-val)
    (cond
      ((number? sloppy-val) (num-val sloppy-val))
      ((boolean? sloppy-val) (bool-val sloppy-val))
      (else
       (eopl:error 'sloppy->expval
                   "Can't convert sloppy value to expval: ~s"
                   sloppy-val)))))

(define-syntax-rule (check-run (name str res) ...)
  (begin
    (cond [(eqv? 'res 'error)
           (check-exn always? (lambda () (run str)))]
          [else
           (check equal-answer? (run str) 'res (symbol->string 'name))])
    ...))

;;;;;;;;;;;;;;;; tests ;;;;;;;;;;;;;;;;

(pretty-print
 (run
  "letrec f(x) = if zero?(x) then 0 else -((f -(x, 1)), x) in (f 10)")
 )
