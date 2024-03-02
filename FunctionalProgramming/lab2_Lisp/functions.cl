; Develop a function whose argument is a list that returns
; a list of pairs: (<element of the original list> <the number of its occurrences in
; the original list>)
;
; For example:
; Input: (1 2 1 1 3 5 2 5)
; Output: ((1 3) (2 2) (3 1) (5 2))
;

(defun concatLists (a b res)
    (if (null a)
        (if (null b)
            res
            (concatLists a (cdr b) (cons (car b) res)))
        (concatLists (cdr a) b (cons (car a) res))))

(defun preArray (arr initArr res)
    (if (eq (car arr) (car initArr))
        res
        (preArray arr (cdr initArr) (cons (car initArr) res))))

(defun incAndReturn (arr initArr)
    (concatLists (cons (cons (caar arr) (cons (+ (cadar arr) 1) nil)) (preArray arr initArr nil)) (cdr arr) nil))

(defun incrementSymbol (symbol arr initArr)
    (if (null arr)
        (cons (cons symbol (cons 1 nil)) initArr)
        ;else
        (if (equal (caar arr) symbol)
            (incAndReturn arr initArr)
            ;else
            (incrementSymbol symbol (cdr arr) initArr))))

(defun calculate (arr &optional countArr) ; countArr -> ((element count) (e c) (e c) (e c) ...)
    (if (null arr)
        countArr
        ;else
        (calculate (cdr arr) (incrementSymbol (car arr) countArr countArr))))


(setq initial '(1 2 1 1 3 5 2 5))
(print (calculate initial)) 
