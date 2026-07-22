;; -*- lexical-binding: t; -*-
;;
;; This file is intentionally tiny and should rarely change.
;; Everything else lives in emacs.org (the literate config) —
;; edit that file, not this one.

;; --- 1. Bootstrap straight.el ------------------------------------
;; This has to stay here in plain elisp: it must run before Org
;; itself is guaranteed to be fully set up, so it can't live inside
;; the literate file that Org is about to load.
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

(straight-use-package '(org :branch "bugfix"))

(straight-use-package 'project)
(require 'project)

(setq straight-use-package-by-default t)

(straight-use-package 'use-package)

;; (dolist (pkg '(xref eldoc flymake seq jsonrpc external-completion compat))
  ;; (straight-use-package `(,pkg :type built-in)))

(org-babel-load-file (expand-file-name "emacs.org" user-emacs-directory))
