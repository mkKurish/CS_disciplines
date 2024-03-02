; Switzerland has four official languages: German (D), French (F), Italian (I), and Romance (K)
;
; three native speakers of the same language    -> their language becomes the language of the group
; two are native speakers of the same language  -> the language of the group becomes the language of the third speaker
; native speakers of three different languages  -> the remaining fourth official language becomes the language of the group
;
; Examples:
;   FFF -> F
;   IIK -> K
;   DFK -> I
;

(defun trilingual-democracy (group)
  (let 
   (
    (fullCharSet "DFKI")
    (first (char group 0))
    (second (char group 1))
    (third (char group 2)))
   (if (equalp first second)
       third
       (if (equalp first third)
           second
           (if (equalp second third)
               first
               (char (remove first (remove second (remove third fullCharSet))) 0))))))
