(require 'cl)

;; will be available at emacs 24.4
(unless (fboundp 'with-eval-after-load)
  "Do magic from the future"
  (defmacro with-eval-after-load (file &rest body)
    `(eval-after-load ,file
       `(funcall (function ,(lambda () ,@body))))))

(defmacro with-package (packages &rest body)
  "After pkg macro"
  (declare (indent defun))
  (when (symbolp packages) ;; make a list if necessary
    (setf packages (list packages)))
  `(progn
     (dolist (p ',packages)
       (when (not (package-installed-p p))
         (package-install p))
       (with-eval-after-load p ,@body))))

(defmacro with-package* (packages &rest body)
  "After pkg macro*"
  (declare (indent defun))
  (when (symbolp packages) ;; make a list if necessary
    (setf packages (list packages)))
  `(prog1
       (with-package ,packages ,@body)
     (dolist (p ',packages)
       (require p))))

(provide 'with-package)
