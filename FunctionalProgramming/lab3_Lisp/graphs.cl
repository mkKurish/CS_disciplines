;----------------------------------->>>-TASK-<<<-----------------------------------;
; For a given digraph, determine the minimum set of nodes,
; the removal of which (along with incoming or outgoing edges)
; will lead to the division of the original graph into a given number of subgraphs.
; It is necessary to provide all solutions with a minimum set of nodes, or
; to report that there are no such solutions.
;
; It is not allowed to use operators
; the loop and the PROG operator.

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
;                                          BASIC  UTILITY  FUNCTIONS                                                ;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

; removes the external nesting level of the list
(defun unflatOneLayer (lst)
    (cond
        ((null lst) nil)
        (T (append (car lst) (unflatOneLayer (cdr lst))))
        ))

; removes element from list - no mutations, returns new list
(defun rm (l elem)
    (if l
        (if (equal elem (car l)) 
            (rm (cdr l) elem)
            (cons (car l) (rm (cdr l) elem)))
        nil))

; compares two lists of atoms or nested lists
; (nested lists should be the same only in terms of the content of the elements)
(defun notStrictEqual (lst1 lst2)
    (cond 
        ((null lst1) T)
        ((null (member (car lst1) lst2)) nil)
        (T (notStrictEqual (cdr lst1) lst2))
        ))

; checks whether an atom or a list is part of another list
(defun memb (el list)
    (if (null list)
        nil
        (if (atom el)
            (if (equal el (car list))
                T
                (memb el (cdr list)))
            (if (notStrictEqual el (car list))
                T
                (memb el (cdr list)))
            )))

; creates a set of elements from the argument list
(defun setof (lstOfLists)
    (if (null lstOfLists)
        nil
        (let 
             ((nextRes (setof (cdr lstOfLists))))
              (if (null (memb (car lstOfLists) nextRes))
                  (cons (car lstOfLists) nextRes)
                  nextRes))
         ))

; pushes each of the elements on the stack if:
; 1) the element is not in the stack
; 2) the element is not visited
(defun appendNotMembElems (visited newElems stack)
    (if (null newElems)
        (return-from appendNotMembElems stack))
    (if (and (null (memb (car newElems) visited)) (null (memb (car newElems) stack)))
        (if (null stack)
            (setq stack (cons (car newElems) nil))
            (nconc stack (cons (car newElems) nil))))
    (if (null (memb (car newElems) visited))
        (appendNotMembElems (append visited (cons (car newElems) nil)) (cdr newElems) stack)
        (appendNotMembElems visited (cdr newElems) stack)))

; selects all items from the list "b" that are missing from the list "a"
(defun selectNotMembers (a b)
    (cond
        ((null b) nil)
        ((null a) nil)
        ((memb (car b) a) (selectNotMembers a (cdr b)))
        (T (cons (car b) (selectNotMembers a (cdr b))))
        ))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
;                                          GRAPH  UTILITY  FUNCTIONS                                                ;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

; removes a node from the graph
(defun rmNode (graph elem)
    (cond
        ((null graph) nil)
        ((equal (caar graph) elem)  (rmNode (cdr graph) elem))
        (T (cons (cons (caar graph) (cons (rm (cadar graph) elem) nil)) (rmNode (cdr graph) elem)))
        ))

; works like 'assoc', but returns only value, not the entire pair
(defun getGraphNodesList (graph nodeName)
    (if (null graph)
        nil
        (if (equal (caar graph) nodeName)
            (cadar graph)
            (getGraphNodesList (cdr graph) nodeName))))

; returns list of nodes, reachable from 'startElement'
(defun goThroughGraph (graph startElement nodesStack visited)
    (if (null graph)
        (return-from goThroughGraph nil))
    (if (null startElement)
        (return-from goThroughGraph visited))
    (if (null (memb startElement visited)) ;; if elem has not been visited, add to the visited
        (if (null visited)
            (setq visited (cons startElement nil))
            (nconc visited (cons startElement nil))))
    (setq nodesStack (appendNotMembElems visited (getGraphNodesList graph startElement) nodesStack)) ;; add every not-visited child to the stack
    (goThroughGraph graph (car (last nodesStack)) (remove (car (last nodesStack)) nodesStack) visited))

; returns all nodes of the graph
(defun getAllGraphNodes (graph)
    (mapcar 'car graph))

; adds an elem element to each node from the list "nodes"
(defun addELemForEveryNode (graph elem nodes)
    (cond
        ((null graph) nil)
        ((memb (caar graph) nodes) (cons (cons (caar graph) (cons (appendNotMembElems nil (cons elem nil) (cadar graph)) nil)) (addELemForEveryNode (cdr graph) elem nodes)))
        (T (cons (car graph) (addELemForEveryNode (cdr graph) elem nodes)))
        ))

; returns a list of subgraphs formed by removing each node from the nodes of the original graph
(defun deleteOneNodeFromEveryPosition (graph nodes)
    (cond
        ((null nodes) nil)
        (T (cons (rmNode graph (car nodes)) (deleteOneNodeFromEveryPosition graph (cdr nodes))))
        ))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
;                                            GRAPH  MAIN  FUNCTIONS                                                 ;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

; makes the graph undirected
(defun makeGraphNotOriented (graph nodes)
    (cond ((null nodes) graph)
        (T 
         (makeGraphNotOriented (addELemForEveryNode graph (car nodes) (getGraphNodesList graph (car nodes))) (cdr nodes)))
        ))

; counts the number of connected subgraphs in an (un)related graph
(defun calcSubgraphsCount (subgraphs nodes)
    (if (null nodes)
        nil
        (setof (cons (goThroughGraph subgraphs (car nodes) nil nil) (calcSubgraphsCount subgraphs (cdr nodes))))
        ))

; checks the number of subgraphs to match the required number
(defun checkModifiedGraphs (g expectedSubgraphs)
    (cond
        ((null g) nil)
        ((equal (length (calcSubgraphsCount (car g) (getAllGraphNodes (car g)))) expectedSubgraphs) (cons (car g) (checkModifiedGraphs (cdr g) expectedSubgraphs)))
        (T (checkModifiedGraphs (cdr g) expectedSubgraphs))
        ))

; removes node combinations from the graph
(defun deleteCombsN (g expectedSubgraphs cN)
    (cond
        ((equal cN 0) nil)
        (T
         (let* ((modifiedG (deleteOneNodeFromEveryPosition g (getAllGraphNodes g)))
                (results (checkModifiedGraphs modifiedG expectedSubgraphs)))
               (cond
                   ((null results) (if (equal (- cN 1) 0) nil (unflatOneLayer (mapcar (lambda (x) (deleteCombsN x expectedSubgraphs (- cN 1))) modifiedG))))
                   (T results))))
        ))

; returns nodes whose deletion resulted in the resulting subgraphs
(defun getDeletedNodes (resGraphs initGraphNodes)
    (mapcar (lambda (x) (selectNotMembers (getAllGraphNodes x) initGraphNodes)) resGraphs))

; finds the minimum number of nodes
; (all possible combinations of them)
; that must be removed to get the required number of subgraphs
(defun deleteDiffCounts (g expectedSubgraphs &optional (curN 1))
    (setq res (deleteCombsN g expectedSubgraphs curN))
    (cond
        ((equal (length res) 0) (if (equal (+ curN 1) (length g))
                                     nil
                                     (deleteDiffCounts g expectedSubgraphs (+ curN 1))
                                    ))
        (T (getDeletedNodes res (getAllGraphNodes g)))
        ))

;------------------------->>>-ENTRY-POINT-<<<-------------------------;
(defun splitGraphIntoN (graph num) ; splits the graph into N subgraphs
    (setq graph (makeGraphNotOriented graph (getAllGraphNodes graph)))
    (cond
        ((or (< num 2) (>= num (length graph))) "Wrong input data: num must be in [2, countOfNodes - 1]")
        (T
         (setq res (setof (deleteDiffCounts graph num))) ;;;; TODO
         (if (or (equal (length res) 0) (null (car res)))
             "The answer cannot be received"
             res))
        ))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
;                                                USAGE  EXAMPLES                                                    ;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(setq g1 '((a (b d e))
           (b ())
           (c (b))
           (d (c))
           (e (a d))))
;(print g1)                             ; ((A (B D E)) (B NIL) (C (B)) (D (C)) (E (A D))) 

(setq g2 (makeGraphNotOriented g1 (getAllGraphNodes g1)))
;(print g2)                             ; ((A (B D E)) (B (A C)) (C (B D)) (D (C A E)) (E (A D))) 

;(print (rmNode g1 'd))                ; ((A (B E)) (B NIL) (C (B)) (E (A))) 
;(print (getGraphNodesList g1 'a))      ; (B D E) 
;(print (goThroughGraph g1 'a nil nil)) ; (A E D C B) 
;(print (getAllGraphNodes g1))          ; (A B C D E) 
;(print (addELemForEveryNode g1 'y '(a b e))) ; ((A (B D E Y)) (B (Y)) (C (B)) (D (C)) (E (A D Y))) 
;(print (makeGraphNotOriented g1 (getAllGraphNodes g1))) ; ((A (B D E Y)) (B (A C)) (C (B D)) (D (C A E)) (E (A D Y))) ------ g1 has been modified by (appendNotMembElems) function

(setq g1 '((a (b d e)) ; set g1 again
           (b ())
           (c (b))
           (d (c))
           (e (a d))))
(print g1)                                               ; ((A (B D E)) (B NIL) (C (B)) (D (C)) (E (A D))) 
;(setq g3 (rmNode (rmNode g1 'd) 'a))
;(print g3)                                               ; ((B NIL) (C (B)) (E NIL))
;(setq g4 (makeGraphNotOriented g3 (getAllGraphNodes g3)))
;(print g4)                                               ; ((B (C)) (C (B)) (E NIL)) 
;(print (goThroughGraph g4 'a nil nil))                   ; (A) 
;(print (calcSubgraphsCount g4 (getAllGraphNodes g4)))    ; ((C B) (E))
    
;(print (deleteOneNodeFromEveryPosition g2 (getAllGraphNodes g2))) 
;(((B (C)) (C (B D)) (D (C E)) (E (D)))
 ;((A (D E)) (C (D)) (D (C A E)) (E (A D)))
 ;((A (B D E)) (B (A)) (D (A E)) (E (A D)))
 ;((A (B E)) (B (A C)) (C (B)) (E (A)))
 ;((A (B D)) (B (A C)) (C (B D)) (D (C A))))

;(print (unflatOneLayer (deleteCombsN g2 2 2)))
;(((B NIL) (D (E)) (E (D))) ((B (C)) (C (B)) (E NIL)) ((A (E)) (C NIL) (E (A)))
 ;((B NIL) (D (E)) (E (D))) ((B (C)) (C (B)) (E NIL)) ((A (E)) (C NIL) (E (A)))) 

;(print (setof (getDeletedNodes (unflatOneLayer (deleteCombsN g2 2 2)) (getAllGraphNodes g2))))     ; ((A C) (A D) (B D))

(print (splitGraphIntoN g1 1))         ; "Wrong input data: num must be in [2, countOfNodes - 1]"
(print (splitGraphIntoN g1 2))         ; ((A C) (A D) (B D)) 
(print (splitGraphIntoN g1 3))         ; "The answer cannot be received" 
(print (splitGraphIntoN g1 4))         ; "The answer cannot be received" 
(print (splitGraphIntoN g1 5))         ; "Wrong input data: num must be in [2, countOfNodes - 1]"

(setq tc1 '((a (b d e)) ; set g1 again
           (b (a))
           (c (a))
           (d ())
           (e (e))
           (f (c))))
(print tc1)                                                    ; ((A (B D E)) (B (A)) (C (A)) (D NIL) (E (E)) (F (C))) 

(print (splitGraphIntoN tc1 1))        ; "Wrong input data: num must be in [2, countOfNodes - 1]" 
(print (splitGraphIntoN tc1 2))        ; ((C))
(print (splitGraphIntoN tc1 3))        ; ((A B) (A D) (A E)) 
(print (splitGraphIntoN tc1 4))        ; ((A)) 
(print (splitGraphIntoN tc1 5))        ; "The answer cannot be received" 
(print (splitGraphIntoN tc1 6))        ; "Wrong input data: num must be in [2, countOfNodes - 1]"