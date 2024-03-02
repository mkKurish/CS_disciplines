; The list (A (B C) (D E) (K)) is given
;
;	Receive
;	1. Element E
;	2. Element K
;	3. List (KAD)
;	4. List (B A K)
;	5. List (C D K)
;	6. List ((B C) A)
;
;	You must complete the task using only the CAR, CDR, and CONS functions
;

(setq lst '(a (b c) (d e) (k)))

(print (cadr (caddr lst))) ; E
(print (car (cadddr lst))) ; K

(print (cons 
        (car (cadddr lst)) ; K
        (cons 
         (car lst) ; A
         (cons
          (caaddr lst) ; D
          nil
          )
         )
        )
) ; (K A D)

(print (cons
        (caadr lst) ; B
        (cons
         (car lst) ; A
         (cons
          (car (cadddr lst)) ; K
          nil
          )
         )
        )
) ; (B A K)

(print (cons
        (cadadr lst) ; C
        (cons
         (caaddr lst) ; D
         (cons
          (car (cadddr lst)) ; K
          nil
          )
         )
        )
) ; (C D K)

(print (cons
        (cons
         (caadr lst) ; B
         (cons
          (cadadr lst) ; C
          nil
          )
         )
        (cons
         (car lst) ; A
         nil
         )
        )
) ; ((B C) A) 
