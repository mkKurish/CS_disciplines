; A coloured triangle is created from a row of colours, each of which is red, green or blue.
; Successive rows, each containing one fewer colour than the last, are generated by considering
; the two touching colours in the previous row. If these colours are identical, the same colour
; is used in the new row. If they are different, the missing colour is used in the new row.
; This is continued until the final row, with only a single colour, is generated.
;
; Colour here:            G G        B G        R G        B R
; Becomes colour here:     G          R          B          G
;
;   R R G B R G B B
;    R B R G B R B
;     G G B R G G
;      G R G B G
;       B B R R
;        B G R
;         R B
;          G
;
; (equal (triangle "B") #\B)
; (equal (triangle "GB") #\R)
; (equal (triangle "RRR") #\R)
; (equal (triangle "RGBG") #\B)
; (equal (triangle "RBRGBRB") #\G)
; (equal (triangle "RBRGBRBGGRRRBGBBBGG") #\G)
;

;;;;; first version ;;;;;

(defun mix-2-colors (group)
  (let 
   (
    (fullCharSet "RGB")
    (first (char group 0))
    (second (char group 1)))
   (if (equal first second)
        (make-string 1 :initial-element first)
        (remove first (remove second fullCharSet)))))

(defun triangle (colors)
    (if (equal colors (subseq colors 0 1)) ;; common case R->R G->G B->B
        (return-from triangle (char colors 0)))
    (if (equal colors (subseq colors 0 2)) ;; common case RG->B RB->G GB->R
        (return-from triangle (char (mix-2-colors colors) 0)))
    (do
        ((i_start 0) (res_string ""))
        ((equal (length colors) (+ i_start 1)) (triangle res_string))
        (setq res_string (concatenate 'string res_string (mix-2-colors (subseq colors i_start (+ i_start 2)))))
        (setq i_start (+ i_start 1))))

;;;;; second version ;;;;;

(defun mix-2-colors (group)
  (let 
   ((first (char group 0))      ;; little changes
    (second (char group 1)))
   (if (equal first second)
        (subseq group 0 1)
        (remove first (remove second "RGB")))))

(defun triangle (colors)
    (if (equal colors (subseq colors 0 1)) ;; common case R->R G->G B->B
        (return-from triangle (char colors 0)))
    (if (equal colors (subseq colors 0 2)) ;; common case RG->B RB->G GB->R
        (return-from triangle (char (mix-2-colors colors) 0)))
    (do
        ()
        ((equal (length colors) 1) (char colors 0))     ;; another changes
        (do
            ((l (length colors)) (i_start 0) (res_string ""))
            ((equal l (+ i_start 1)) (setq colors res_string))
            (setq res_string (concatenate 'string res_string (mix-2-colors (subseq colors i_start (+ i_start 2)))))
            (setq i_start (+ i_start 1)))))