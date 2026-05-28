;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq shell-file-name (executable-find "bash")) ; using fish shell

(defvar my/org-root "/data/org"
  "Root directory for all org files.")

(defvar my/org-gtd (concat my/org-root "/GTD/"))
(defvar my/org-notes (concat my/org-root "/roam/"))
(defvar my/org-archive (concat my/org-root "/archive/"))
(defvar my/org-templates (concat my/org-root "/templates/"))
(defvar my/org-attachments (concat my/org-root "/attachments/"))
(defvar my/org-habits (concat my/org-gtd "habits.org"))

(setq org-directory (concat my/org-root "/"))
(setq org-attach-id-dir my/org-attachments)

;; UI defaults
(setq catppuccin-flavor 'mocha)
(setq doom-theme 'catppuccin)
(setq doom-font (font-spec :family "Hasklug Nerd Font Mono Med" :size 15)
      doom-variable-pitch-font (font-spec :family "CaskaydiaCove Nerd Font" :size 15)
      display-line-numbers-type t)

;; Spell checker backend
(setq ispell-program-name "aspell")

;; Better org-agenda navigation in evil
(after! org-agenda
  (define-key org-agenda-mode-map (kbd "j") #'org-agenda-next-line)
  (define-key org-agenda-mode-map (kbd "k") #'org-agenda-previous-line))

(require 'org)

(defun my/load-org-module (name)
  "Tangle and load config module NAME from $DOOMDIR/config/."
  (let* ((org-file (expand-file-name (format "config/%s.org" name) doom-user-dir))
         (el-file (expand-file-name (format "config/%s.el" name) doom-user-dir)))
    (when (file-exists-p org-file)
      (when (or (not (file-exists-p el-file))
                (file-newer-than-file-p org-file el-file))
        (org-babel-tangle-file org-file el-file "emacs-lisp"))
      (load el-file nil 'nomessage))))

(my/load-org-module "gtd")
(my/load-org-module "roam")
(my/load-org-module "org-ui")
(my/load-org-module "integrations")
