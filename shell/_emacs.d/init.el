;; VERSION: 0.9.0
;; BUILD:    141
;; TODO:
;; - Dependencies:
;;     - Haskell: ghc-mod; hlint
;;     - Python: jedi (pip install jedi epc)
;;     - Arch: aspell-de
;;       - org-mode
;;         - imagemagick
;;         - Latex-preview: texlive-core

;; TODO: eldoc for C looks awesome
;; company for autocompletion?
;;;; comments
;; Fix custom-set-variables
;; need a redo solution
;; align-regexp
;; need to fix color schemes
;; fix evil state in list-packages buffer
;; fix smooth scrolling (no jumps pls)
;; fix jedi
;; checkout evil-exchange https://github.com/Dewdrops/evil-exchange
;; Learn how the minibuffer works

;; Turn off mouse interface early to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No welcome screen
(setq inhibit-startup-message t)

;;;; autoloads
(add-to-list 'load-path (concat user-emacs-directory "/site-lisp/"))
(require 'site-lisp-autoloads)

;;;; general settings
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (blink-cursor-mode -1))

(setq visible-bell t
      ;; color-theme-is-global t
      ;; shift-select-mode nil
      ;; mouse-yank-at-point t
      backup-directory-alist `((".".,(concat user-emacs-directory "backups"))))

(defalias 'yes-or-no-p 'y-or-n-p)

;; much better scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; Increase memory for tables
(setq max-lisp-eval-depth '40000)
(setq max-specpdl-size '100000)

(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(refresh-proxy-settings)
(when (not package-archive-contents)
  (package-refresh-contents))

(require 'with-package)

(with-package (ace-jump-buffer haskell-mode python-mode htmlize
  multiple-cursors column-marker
  ;; ess ;; statistic
  ;; key-chord ;; combination of keys for commands
  ;; no-easy-keys
  ;; pretty-symbols-mode ;; mode for pretty symbols
  ;; auto-complete
  ;; auto-complete-clang-async
  ;; auto-complete-c-headers
  ;; autopair
  ;; column-marker
  ;; fuzzy ;; better matching
  ;; jedi
  ;; maxframe
  ;; nav
  ;; yasnippet
  notmuch
  midnight
  org-plus-contrib
))

(with-package* (evil evil-nerd-commenter evil-numbers)
  (evil-mode t)
  (define-key evil-normal-state-map "m" 'tabbar-forward-tab)
  (define-key evil-normal-state-map "M" 'tabbar-backward-tab)
  (define-key evil-normal-state-map " " 'ace-jump-buffer)
  (define-key evil-normal-state-map (kbd ",ci")
    'evilnc-comment-or-uncomment-lines)
  (define-key evil-normal-state-map (kbd ",cl")
    'evilnc-comment-or-uncomment-to-the-line))

(define-key evil-normal-state-map (kbd "RET") nil)
(define-key evil-motion-state-map (kbd "RET") nil)

;; TODO: test this more
(with-package* key-chord
  (key-chord-mode t)
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state))

;; Evil surround mode. See https://github.com/timcharper/evil-surround
(with-package* surround
  (global-surround-mode 1))

(with-package* anzu
  (global-anzu-mode))

(with-package* solarized-theme
  (message "Solarized theme loaded!")
  (load-theme 'solarized-dark t))

;; loading zenburn retriggers this with-package call, so only call it once
;; (with-package* zenburn-theme
;;   (unless (symbolp 'zenburn-loaded)
;;     (setq 'zenburn-loaded t)
;;     (load-theme 'zenburn)))

(with-package* (ido ido-ubiquitous smex)
  (ido-mode t)
  (ido-everywhere t)
  (setq ido-enable-flex-matching t)
  (ido-ubiquitous-mode)
  (setq ido-enable-last-directory-history nil
	ido-record-commands nil
	ido-max-work-directory-list 0
	ido-max-work-file-list 0)
  (setq smex-save-file (concat user-emacs-directory ".smex-items"))
  (global-set-key (kbd "M-x") 'smex))

(with-package* diminish
  (diminish 'undo-tree-mode))

(show-paren-mode 1)
(global-linum-mode 1)

;; chmod +x on save if shell script
;; (add-hook 'after-save-hook
;;          'executable-make-buffer-file-executable-if-script-p)

;; see https://github.com/flycheck/flycheck
;; for all the additional dependencies.
(with-package* (flycheck flycheck-color-mode-line)
  (setq flycheck-check-syntax-automatically (quote (save mode-enabled)))
  ;; in case cabal isn't in path add path manually
  ;; FIXME: don't do this always use -^
  (setq flycheck-haskell-hlint-executable "~/.cabal/bin/hlint")
  (global-flycheck-mode t)
  (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))

(with-package magit
  (define-key magit-status-mode-map (kbd "j") 'magit-goto-next-section)
  (define-key magit-status-mode-map (kbd "k") 'magit-goto-previous-section)
  (define-key magit-status-mode-map (kbd "n") 'magit-discard-item))

;;;; general
(setq tab-width 4)

;;;; python
;; dependencies: pip install jedi epc
(with-package* jedi
  (setq jedi:setup-keys t)
  (setq jedi:complete-on-dot t)
  (add-hook 'python-mode-hook 'jedi:setup))

;;;; C
(setq-default c-basic-offset 4)

(add-hook 'prog-mode-hook
  (lambda ()
    (font-lock-add-keywords nil
      '(("\\<\\(FIX\\(ME\\)?\\|TODO\\|\ HACK\\|REFACTOR\\|NOCOMMIT\\):"
	 1 font-lock-warning-face t)))))

;; highlight with-package*
;; TODO: add-hook to emacs-lisp?
(font-lock-add-keywords
 'emacs-lisp-mode
 '(("(\\(with-package\\*?\\)\\(?:\\s-+(?\\([^()]+\\))?\\)?"
    (1 'font-lock-keyword-face)
    (2 'font-lock-constant-face nil t))))

;; eval-and-replace
(global-set-key (kbd "C-c C-e") 'eval-and-replace)

;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; Show trailing spaces, set whitespace tabs to dim grey and delete trailing
;; whitespaces on save.
;; Note: this will break hard line breaks for markdown.
;; TODO: Add exception for markdown-mode
;; TODO: whitespace cleanup?
;; (setq whitespace-style '(face tabs newline tab-mark)
;;       whitespace-line-column 80
;;       whitespace-tab '(:foreground "dim gray" :weight bold))
;; (global-whitespace-mode t)
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Marks the 81st column in a line.
;; (column-marker-1 80)

(setq custom-file (concat user-emacs-directory "custom-var.el"))
(load custom-file)
