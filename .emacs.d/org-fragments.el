
** org-mode settings

*** Increase front size of latex previews

#+BEGIN_SRC emacs-lisp
(setq org-format-latex-options (plist-put 'org-format-latex-options :scale 2.0))
#+END_SRC

*** Other customizations
TODO: create subgroups

#+BEGIN_SRC emacs-lisp
;; org-mode
;; active Babel languages
;; TODO: load on demand
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((R . t)
	 (python . t)
	 ))

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)
(setq org-confirm-babel-evaluate nil)
(setq org-export-html-validation-link nil)
(setq org-export-allow-BIND t)
(setq org-support-shift-select t)
(setq org-src-fontify-natively t)


;; iimage (show images inline)
;; (when window-system
;;   (defun iimage-fix-underlining ()
;;   ;;   (set-face-underline-p 'org-link nil) ;; deactivate underlining
;;     ) ;; TODO: needing something better aka unclickable links

;;   (defun iimage-refresh-iimages ()
;;     "Hacked refresh"
;;     (clear-image-cache nil)
;;     (iimage-mode nil)
;;     (iimage-mode t))

;;   (add-hook 'org-mode-hook 'iimage-mode)
;;   (add-hook 'after-save-hook 'iimage-refresh-iimages)
;;   (add-hook 'iimage-mode-hook 'iimage-fix-underlining)
;;   (iimage-mode nil)
;;   (add-to-list 'iimage-mode-image-regex-alist
;;                (cons (concat "\\[\\[file:\\(~?" iimage-mode-image-filename-regex
;;                            "\\)\\]")  1))
;;   )
#+END_SRC

** increase memory for tables

#+BEGIN_SRC emacs-lisp
;; Increase memory for tables
(setq max-lisp-eval-depth '40000)
(setq max-specpdl-size '100000)
#+END_SRC
