; Inventory of university laboratories: classrooms, installed equipment

; _____ UTILITY FUNCTIONS _____

; removes the external nesting level of the list
(defun unflatOneLayer (lst)
    (cond
        ((null lst) nil)
        (T (append (car lst) (unflatOneLayer (cdr lst))))
        ))

; removes element from list - no mutations, returns new list
(defun rmOne (l elem)
    (if l
        (if (equal elem (car l))
            (cdr l) 
            (cons (car l) (rmOne (cdr l) elem)))
        nil))

; checks if the atom is part of the list
(defun memb (el list)
    (if (null list)
        nil
        (if (equal el (car list))
            T
            (memb el (cdr list)))
        ))

; checks whether the first list contains elements of the second
(defun contains (list1 list2)
    (cond
        ((null list1) (null list2))
        ((null list2) T)
        ((memb (car list2) list1) (setf list1 (rmOne list1 (car list2))) (contains list1 (cdr list2)))
        (T nil)))

; _____ MAIN SOURCE CODE _____

(defstruct auditorium number subject manager equipment)

(defvar *laboratory* '())

(defun add_auditorium (number subject manager equipment)
    (if (get_audit_by_number number)
        (format T "You cannot create an auditorium with the number ~s, because it belongs to another audience~%" number)
        (push (make-auditorium :number number :subject subject :manager manager :equipment equipment)
              *laboratory*)))

(defun delete_auditorium (number)
    (setq *laboratory* 
          (remove-if 
           (lambda (audit) (equal (auditorium-number audit) number))
           *laboratory*)))

(defun modify_auditorium (number subject manager equipment)
    (let ((audit (get_audit_by_number number)))
         (if (not audit)
             (format T "The audience with the number ~s was not found~%" number)
             (setf (auditorium-subject audit) subject
                   (auditorium-manager audit) manager
                   (auditorium-equipment audit) equipment))))

(defun add_equipment_to_auditorium (audit_number newEquipmentElement)
    (let ((audit (get_audit_by_number audit_number)))
         (if (not audit)
             (format T "The audience with the number ~s was not found~%" lab_number)
             (setf (auditorium-equipment audit) (cons newEquipmentElement (auditorium-equipment audit))))))

(defun get_audit_by_number (number)
    (find-if (lambda (audit) (equal (auditorium-number audit) number)) *laboratory*))

(defun get_audit_by_manager (manager)
    (remove-if-not (lambda (audit) (equal (auditorium-manager audit) manager)) *laboratory*))

(defun get_audit_by_subject (subject)
        (remove-if-not (lambda (audit) (equal (auditorium-subject audit) subject)) *laboratory*))

(defun check_audit_equipment (autidorium required_equipment)
    (let ((audit_eq (auditorium-equipment autidorium)))
         (cond
             ((contains audit_eq required_equipment) T)
             (T nil))))

(defun get_audit_numbers_by_custom_requirement (req_func params)
    (setq intermediate_res (unflatOneLayer (funcall req_func params)))
    (mapcar 'auditorium-number intermediate_res))

; _____ USAGE EXAMPLES _____

(format T "~10TGetting started~%~4TSetting the initial audience:~%---------------------------------------------")
(add_auditorium "1" "Math" "Ivanov I.I." '("projector" "blackboard")) (print *laboratory*)
(print "^^^^^^^^^^ The first one was added ^^^^^^^^^^")
(format T "~%Error when adding ---> ")
(add_auditorium "1" "Foreign languages" "Andreeva E.G." '("blackboard"))
(format T "vvvvvvvvvvvvv The final laboratory vvvvvvvvvvvvv")
(add_auditorium "2" "Computer science" "Svetov V.V." '("PC" "marker board"))
(add_auditorium "3" "Graphics" "Shustov P.K." '("PC"))
(add_auditorium "4" "Physics" "Sokolov N.V." '("electronic installation No. 1" "hydra. Installation No. 112" "amplifier"))
(add_auditorium "5" "Physics" "Petrov I.G." '("hydra. Installation No. 10" "amplifier" "air tube"))
(add_auditorium "6" "Computer science" "Sidorova A.M." '("PC" "projector" "marker board" "presentation board"))
(print *laboratory*)

(format T "~%---------------------------------------------~%~4TDeleting the audience 3~%---------------------------------------------")
(delete_auditorium "3")
(print *laboratory*)

(format T "~%---------------------------------------------~%~4TChanging the audience 1~%---------------------------------------------")
(modify_auditorium "1" "Philosophy" "Vilova A.D." '("blackboard"))
(print *laboratory*)

(format T "~%---------------------------------------------~%~4TAdding equipment to the classroom 2~%---------------------------------------------")
(add_equipment_to_auditorium "2" "laptop")
(add_equipment_to_auditorium "2" "graphic tablet")
(add_equipment_to_auditorium "2" "programmable calculator")
(add_equipment_to_auditorium "2" "microcontroller")
(print *laboratory*)

(format T "~%---------------------------------------------~%~4TLet's check if auditorium 4 is suitable for working with an amplifier and an air tube~%---------------------------------------------")
(print (check_audit_equipment (get_audit_by_number "4") '("amplifier" "air tube")))

(format T "~%---------------------------------------------~%~4TLet's check if auditorium 5 is suitable for working with an amplifier and an air tube~%---------------------------------------------")
(print (check_audit_equipment (get_audit_by_number "5") '("amplifier" "air tube")))

(format T "~%---------------------------------------------~%~4TFinding an audience 2~%---------------------------------------------")
(print (get_audit_by_number "2"))

(format T "~%---------------------------------------------~%~4TFinding the audience, which is headed by Sidorova A.M.~%---------------------------------------------")
(print (get_audit_by_manager "Sidorova A.M."))

(format T "~%---------------------------------------------~%~4TFinding the physics audience~%---------------------------------------------")
(print (get_audit_by_subject "Physics"))

(format T "~%---------------------------------------------~%~4TFinding an audience 100 (which does not exist)~%---------------------------------------------")
(print (get_audit_by_number "100"))

(format T "~%---------------------------------------------~%~4TFinding all the numbers of physics and philosophy classrooms~%---------------------------------------------")
(print (get_audit_numbers_by_custom_requirement 
        (lambda (x) (mapcar 
                     (lambda (x_el) (remove-if-not (lambda (audit) (equal (auditorium-subject audit) x_el)) *laboratory*))
                              x))
        '("Physics" "Philosophy")))