;M-x `describe-key`: and type the key combination then Emacs will then show the command that key press is bound to.
;M-x `describe-bindings`: to see a list of ALL keybindings that's active for your current buffer
;; (setq package-enable-at-startup nil)
;; (package-initialize)

(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

;; garbage collector
(setq gc-cons-threshold 100000000)
(setq inhibit-startup-message t)

(defalias 'yes-or-no-p 'y-or-n-p)

(add-to-list 'load-path "~/.emacs.d/custom")
(add-to-list 'load-path "~/.emacs.d/functions")

(require 'setup-helm)
(require 'setup-editing)
(require 'setup-faces-and-ui)
(require 'setup-files)

(windmove-default-keybindings)

;; exec-path-from-shell package:
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; Package: projejctile
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)

(require 'helm-projectile)
(helm-projectile-on)
(setq projectile-completion-system 'helm)
(setq projectile-indexing-method 'native)

;; Org-mode configure
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

; C-c a t to enter the global todo list
(setq org-agenda-files (list "~/org/work.org"
                             "~/org/school.org"
                             "~/org/home.org"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; --- NEW PYTHON CONFIG --- ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'company)
add-hook 'afer-init-hook 'global-company-mode)

(defun my-python-mode-hook()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my-python-mode-hook)

(elpy-enable)
(setq elpy-rpc-backend "jedi")

(defun setup-keys-elpy:pop-tag-mark ()
  (global-set-key (kbd "M-,") 'pop-tag-mark)
  (global-unset-key (kbd "M-*"))
  )

(add-hook 'python-mode-hook 'setup-keys-elpy:pop-tag-mark)


(defun goto-def-or-rgrep ()
  "Go to definition of thing at point or do an rgrep in project if that fails"
  (interactive)
  (condition-case nil (elpy-goto-definition)
    (error (elpy-rgrep-symbol (thing-at-point 'symbol)))))

(define-key elpy-mode-map (kbd "M-.") 'goto-def-or-rgrep)

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
