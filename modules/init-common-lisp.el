;;;-----------------------------------------------------------------------------
;;; common lisp
;;;-----------------------------------------------------------------------------
(require-package 'slime)
(require 'slime-autoloads)

;; set lisp interpreter
(setq inferior-lisp-program "/usr/bin/sbcl")

;; slime contribs
(setq slime-contribs '(slime-fancy))


;; Package manager:
;; Initialise package and add Melpa repository
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t) ;; Добавляем ресурс Melpa
(package-initialize) ;; Инициализируем пакетный менеджер

;; Package list
(defvar required-packages
  '(slime ;; Slime - IDE для Common Lisp, интегрированная с Emacs
    projectile ;; Удобный менеджер проектов
    auto-complete)) ;; Автодополнение

;; Require Common Lisp extensions
(require 'cl)

;; Функция реализет проверку факта установки перечисленных выше пакетов:
;; slime, projectile, auto-complete
(defun packages-installed-p ()
    "Packages availability checking."
    (interactive)
    (loop for package in required-packages
          unless (package-installed-p package)
            do (return nil)
          finally (return t)))

;; Автоматическая установка пакетов slime, projectile, auto-complete
;; при первом запуске Emacs
;; Auto-install packages
(unless (packages-installed-p)
    (message "%s" "Emacs is now refreshing it's package database...")
    (package-refresh-contents)
    (message "%s" " done.")
    (dolist (package required-packages)
        (unless (package-installed-p package)
            (package-install package))))


(when (packages-installed-p)

    ;; Auto-complete
    (require 'auto-complete)
    (require 'auto-complete-config)
    (ac-config-default)
    (setq ac-auto-start        t)
    (setq ac-auto-show-manu    t)
    (global-auto-complete-mode t)
    (add-to-list 'ac-modes 'lisp-mode)

    ;; SLIME
    (require 'slime)
    (require 'slime-autoloads)
    (setq slime-net-coding-system 'utf-8-unix)
    (slime-setup '(slime-fancy slime-asdf slime-indentation))
    (if (or (file-exists-p unix-sbcl-bin) (file-exists-p windows-sbcl-bin))
        (if (system-is-windows)
            (setq inferior-lisp-program windows-sbcl-bin)
            (setq inferior-lisp-program unix-sbcl-bin))
        (message "%s" "SBCL not found..."))
    (add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))

    ;; Projectile
    (require 'projectile)
    (projectile-global-mode))

;; hyperspec setup - use shift+F1 to open Hyperspec documentation
(global-set-key [(shift f1)]
  '(lambda ()
     (interactive)
     (let (;; (browse-url-browser-function 'browse-url-w3)
	     (common-lisp-hyperspec-root            
             "file:///home/amon/.emacs.d/HyperSpec/"))
	 (slime-hyperspec-lookup (thing-at-point 'symbol)))))

;; set Hyperspec location
(setq common-lisp-hyperspec-root            
      "file:/home/amon/.emacs.d/HyperSpec/") 


(provide 'init-common-lisp)
