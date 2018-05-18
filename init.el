;; raise garbage collection threshold for quick startup
(let ((gc-cons-threshold most-positive-fixnum))
  ;; disable mouse interface
  (when window-system
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (scroll-bar-mode -1)
    (tooltip-mode -1))

  ;; no startup message
  (setq inhibit-startup-message t)
  ;; blank scratch
  (setq initial-scratch-message "")

  ;; set up package
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
  (when (boundp 'package-pinned-packages)
    (setq package-pinned-packages '((org-plus-contrib . "org"))))
  (package-initialize)
  (package-refresh-contents)

  ;; install use-package
  (unless (package-installed-p 'use-package)
    (package-install 'use-package))

  ;; install diminish
  (unless (package-installed-p 'diminish)
    (package-install 'diminish))

  ;; from use-package README
  (eval-when-compile (require 'use-package))
  (require 'diminish)                ;; if you use :diminish
  (require 'bind-key)                ;; if you use any :bind variant
  (require 'misc)

  ;; load config
  (org-babel-load-file (concat user-emacs-directory "config.org"))

  ;; set up minibuffer hooks for garbage collection management
  (defun aj/minibuffer-setup-hook ()
    (setq gc-cons-threshold most-positive-fixnum))

  (defun aj/minibuffer-exit-hook ()
    (setq gc-cons-threshold 800000))

  (add-hook 'minibuffer-setup-hook #'aj/minibuffer-setup-hook)
  (add-hook 'minibuffer-exit-hook  #'aj/minibuffer-exit-hook))
