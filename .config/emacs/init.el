;; -*- lexical-binding: t; -*-


(setq inhibit-startup-message t)

;; Only disable these elements if Emacs is running as a graphical application
(when (display-graphic-p)
  (scroll-bar-mode -1)        ; Disable visible scrollbar
  (tool-bar-mode -1)          ; Disable the toolbar
  (tooltip-mode -1)           ; Disable tooltips
  (set-fringe-mode 10))       ; Give some breathing room left/right

(menu-bar-mode -1)            ; Hides the top menu bar
(setq visible-bell t)         ; Flashes the screen instead of an audible beep


;; Set the default font family, size, and weight
(set-face-attribute 'default nil
                    :font "Hasklug Nerd Font Mono"
                    :height 130
                    :weight 'medium)

; Enable line numbers globally 
(global-display-line-numbers-mode t)
(column-number-mode t) 

;; Disable line numbers in Org mode
(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)))

(load-theme 'tango-dark)

;; intialize straight.el 

;; 1. Bootstrap straight.el (Standard installation snippet)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; 2. Set the variable so straight is the default installer for use-package
(setq straight-use-package-by-default t)

;; 3. Install use-package using straight
(straight-use-package 'use-package)


(use-package vertico
  :custom
   (vertico-scroll-margin 0) ;; Different scroll margin
   (vertico-count 20) ;; Show more candidates
   (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))


; ;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

; ;; Emacs minibuffer configurations.
(use-package emacs
  :custom
   ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
   (context-menu-mode t)
   ;; Support opening new minibuffers from inside existing minibuffers.
   (enable-recursive-minibuffers t)
   ;; Hide commands in M-x which do not work in the current mode.  Vertico
   ;; commands are hidden in normal buffers. This setting is useful beyond
   ;; Vertico.
   (read-extended-command-predicate #'command-completion-default-include-p)
   ;; Do not allow the cursor in the minibuffer prompt
   (minibuffer-prompt-properties
    '(read-only t cursor-intangible t face minibuffer-prompt)))


 ;; Example configuration for Consult
 (use-package consult
   ;; Replace bindings. Lazily loaded by `use-package'.
   :bind (;; C-c bindings in `mode-specific-map'
          ([remap Info-search] . consult-info)
          ;; C-x bindings in `ctl-x-map'
          ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
          ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
          ;; M-g bindings in `goto-map'
          ("M-g e" . consult-compile-error)
          ("M-g r" . consult-grep-match)
          ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
          ("M-g m" . consult-mark)
          ;; M-s bindings in `search-map'
          ("M-s d" . consult-find)                  ;; Alternative: consult-fd
          ("M-s g" . consult-grep)
          ("M-s G" . consult-git-grep)
          ("M-s r" . consult-ripgrep)
          )

   ;; The :init configuration is always executed (Not lazy)
   :init

   ;; Tweak the register preview for `consult-register-load',
   ;; `consult-register-store' and the built-in commands.  This improves the
   ;; register formatting, adds thin separator lines, register sorting and hides
   ;; the window mode line.
   (advice-add #'register-preview :override #'consult-register-window)
   (setq register-preview-delay 0.5)

   ;; Use Consult to select xref locations with preview
   (setq xref-show-xrefs-function #'consult-xref
         xref-show-definitions-function #'consult-xref)

   ;; Configure other variables and modes in the :config section,
   ;; after lazily loading the package.
   :config

   ;; Optionally configure preview. The default value
   ;; is 'any, such that any key triggers the preview.
   ;; (setq consult-preview-key 'any)
   ;; (setq consult-preview-key "M-.")
   ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
   ;; For some commands and buffer sources it is useful to configure the
   ;; :preview-key on a per-command basis using the `consult-customize' macro.
   (consult-customize
    consult-theme :preview-key '(:debounce 0.2 any)
    consult-ripgrep consult-git-grep consult-grep consult-man
    consult-bookmark consult-recent-file consult-xref
    consult-source-bookmark consult-source-file-register
    consult-source-recent-file consult-source-project-recent-file
    ;; :preview-key "M-."
    :preview-key '(:debounce 0.4 any))

   ;; Optionally configure the narrowing key.
   ;; Both < and C-+ work reasonably well.
   (setq consult-narrow-key "<") ;; "C-+"

   ;; Optionally make narrowing help available in the minibuffer.
   ;; You may want to use `embark-prefix-help-command' or which-key instead.
   ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
 )


 ;; Optionally use the `orderless' completion style.
 (use-package orderless
   :custom
   ;; Configure a custom style dispatcher (see the Consult wiki)
   ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
   ;; (orderless-component-separator #'orderless-escapable-split-on-space)
   (completion-styles '(orderless basic))
   (completion-category-overrides '((file (styles partial-completion))))
   (completion-category-defaults nil) ;; Disable defaults, use our settings
   (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring
   (custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  '(package-selected-packages nil))
 (custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  )

 (use-package doom-modeline
   :ensure t
   :init (doom-modeline-mode 1))


(setq my-var nil)
