;;; early-init.el --- Early Init -*- lexical-binding: t; -*-

;;; Code:

(defvar cl/emacs-load-start-time (current-time))

;; Disable package.el — straight.el handles everything
(setq package-enable-at-startup nil)

;;; GC — disable during startup, restore after
;; Default 800KB threshold causes dozens of GC pauses during init.
;; Maximizing it eliminates all of them (30-50% startup speedup).
(if noninteractive
    (setq gc-cons-threshold 268435456)  ; 256 MB for batch
  (setq gc-cons-threshold most-positive-fixnum))
(setq gc-cons-percentage 1.0)

;;; Native-comp — max optimization, suppress noisy warnings
(setq native-comp-speed 3
      native-comp-async-report-warnings-errors nil)

;;; Load newer files over stale .elc
(setq load-prefer-newer t)

;;; Frame — pixelwise resize, no implied resize, no font cache compaction
(setq frame-resize-pixelwise t
      frame-inhibit-implied-resize 'force
      inhibit-compacting-font-caches t)

;;; Bidirectional text — skip BPA for faster display (LTR code only)
(setq bidi-inhibit-bpa t)

;;; UI — small QoL defaults
(setq use-short-answers t
      ring-bell-function 'ignore
      inhibit-startup-echo-area-message user-login-name
      inhibit-startup-buffer-menu t)

;;; File-name-handler-alist — strip during startup, restore after
(defvar cl/early-init--file-name-handler-alist file-name-handler-alist)

(defun cl/early-init--respect-file-handlers (fn args-left)
  "Restore file handlers when processing command-line args (TRAMP safety)."
  (let ((file-name-handler-alist (if args-left
                                     cl/early-init--file-name-handler-alist
                                   file-name-handler-alist)))
    (funcall fn args-left)))

(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist
                  (delete-dups (append file-name-handler-alist
                                       cl/early-init--file-name-handler-alist)))))

(advice-add 'command-line-1 :around #'cl/early-init--respect-file-handlers)

;;; Emacs server — start for emacsclient
(load "server")
(unless (server-running-p) (server-start))

;;; Startup benchmark
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %.2fs (%d GCs)"
                     (float-time (time-subtract after-init-time
                                                 cl/emacs-load-start-time))
                     gcs-done)))

;;; UI — already handled by use-package/straight in init.el
;;; (menu-bar, tool-bar, scroll-bar, fringe, fonts)

;;; Local Variables:
;;; byte-compile-warnings: (not obsolete free-vars)
;;; End:

;;; early-init.el ends here
