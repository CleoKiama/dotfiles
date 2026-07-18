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

;; --- 2. Pull in the newer Org *before* anything else can touch Org --
;; org-babel-load-file (below) uses ob-tangle, which requires 'org.
;; If we let that be satisfied by Emacs's built-in Org, and only ask
;; straight for the newer Org later (inside emacs.org), Emacs ends up
;; with two Org versions loaded in the same session -> the mismatch
;; warning. Pulling this specific recipe forward, ahead of everything
;; else, means only one Org ever loads. Keep this recipe in sync with
;; the `:straight` spec on the `org` use-package block in emacs.org.
(straight-use-package '(org :branch "bugfix"))

;; --- 3. use-package via straight -----------------------------------
(setq straight-use-package-by-default t)
(straight-use-package 'use-package)

;; --- 4. Hand off to the literate config -----------------------------
;; org-babel-load-file tangles emacs.org -> emacs.el (only if emacs.org
;; is newer than the last tangle) and then loads the result. Pass `t`
;; as a second arg later if you want it byte-compiled for a faster
;; startup once the config has settled down.
(org-babel-load-file (expand-file-name "emacs.org" user-emacs-directory))
