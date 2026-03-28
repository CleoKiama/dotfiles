;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

(defvar my/org-root "/data/org"
  "Root directory for all org files.")

;; Derived paths — no need to touch these
(defvar my/org-gtd      (concat my/org-root "/GTD/"))
(defvar my/org-notes    (concat my/org-root "/roam/"))
(defvar my/org-archive  (concat my/org-root "/archive/"))
(defvar my/org-templates (concat my/org-root "/templates/"))
(defvar my/org-attachments (concat my/org-root "/attachments/")) 

(setq org-directory (concat my/org-root "/"))

(setq org-agenda-files (list my/org-gtd))

(setq org-attach-id-dir my/org-attachments) 

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

 ;; Remap Esc to 'jj' in Evil insert mode using evil-escape (built-in to Doom)
     (after! evil-escape
       (setq evil-escape-key-sequence "jj"  ; Your preferred sequence
             evil-escape-delay 0.2          ; Slightly longer delay for same-key sequences like 'jj' (adjust if too sensitive)
             evil-escape-unordered-key-sequence t)  ; Allow 'jj' or 'j j' in any order (optional)
       (evil-escape-mode 1))                ; Re-enable the mode (disabled by default in recent Doom)


;; 1. Standard Org & GTD Configuration (SPC X)
(after! org
  (setq org-agenda-files (list my/org-gtd (concat my/org-notes "journal/")))
  (setq org-capture-templates
      '(("t" "Personal Todo" entry
         (file+headline (concat my/org-gtd "inbox.org") "Tasks")
         "* TODO %?\n  %i\n  %a" :prepend t)
        ("m" "Meeting" entry
         (file+headline (concat my/org-gtd "inbox.org") "Meetings")
         "* MEETING with %? :MEETING:\n  %U" :prepend t)
        ("c" "Contact" entry                                      ;; add this
         (file (concat my/org-gtd "contacts.org"))
            "* %^{Name}
            :PROPERTIES:
            :EMAIL:    %^{Email}
            :PHONE:    %^{Phone}
            :BIRTHDAY: %^{Birthday (YYYY-MM-DD)}
            :NOTE:     %^{Note}
            :END:" :prepend t)
            ))

   (setq org-archive-location (concat my/org-archive "%s_archive::"))
     ;; This tells Org: "When I archive something in 'projects.org', 
     ;; move it to '/data/org/GTD/archives/projects.org_archive'"


      ;;TODO states
     (setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)")))

    ;; LOG when a TODO is moved to the NEXT actionable state 
    (defun log-todo-next-creation-date (&rest ignore)
            "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
                (when (and (string= (org-get-todo-state) "NEXT")
                    (not (org-entry-get nil "ACTIVATED")))
                        (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))
            (add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)

      ;; Set to `time` to automatically record a timestamp when a TODO item is marked as done.
      (setq org-log-done 'time)

     (setq org-tag-alist '(
       (:startgroup . nil)
       ("@home"     . ?h)
       ("@work"     . ?w)
       ("@computer" . ?c)
       ("@phone"    . ?p)
       ("@errands"  . ?e)
       ("@email"    . ?m)
       (:endgroup   . nil)
       ("@waiting"  . ?W)
       ("#deep"     . ?d)
       ("#quick"    . ?q)
       ("#low"      . ?l)
    ))



)

;; 2. Org-Roam & Zettelkasten Configuration (SPC n r)
(after! org-roam
  (setq org-roam-directory my/org-notes)
  (setq org-roam-dailies-directory "journal/")
  ;; Node Templates: This includes your new Buckets
  (setq org-roam-capture-templates
        '(("d" "default/fleeting" plain "%?"
           :target (file+head "fleeting/%<%Y%m%d%H%M%S>-${slug}.org" 
                              "#+title: ${title}\n#+filetags: :fleeting:\n:PROPERTIES:\n:CREATED:  %U\n:END:")
           :unnarrowed t)
          ("m" "media" plain "%?"
           :target (file+head "media/%<%Y%m%d%H%M%S>-${slug}.org" 
                              "#+title: ${title}\n#+filetags: :media:\n:PROPERTIES:\n:CREATED:  %U\n:END:")
           :unnarrowed t)
          ("a" "atlas" plain "%?"
           :target (file+head "atlas/%<%Y%m%d%H%M%S>-${slug}.org" 
                              "#+title: ${title}\n#+filetags: :atlas:MOC:\n:PROPERTIES:\n:CREATED:  %U\n:END:")
           :unnarrowed t)
          ("s" "permanent/slipbox" plain "%?"
           :target (file+head "permanent/%<%Y%m%d%H%M%S>-${slug}.org" 
                              "#+title: ${title}\n#+filetags: :permanent:\n:PROPERTIES:\n:CREATED:  %U\n:END:")
           :unnarrowed t)
          ("p" "people" plain "%?"
           :target (file+head "people/${slug}.org" 
            "#+title: ${title}\n#+filetags: :people:\n:PROPERTIES:\n:CREATED:  %U\n:EMAIL:    \n:ROLE:     \n:MET:      \n:END:\n\n* Notes\n\n* Conversations\n\n* Ideas & Connections")
           :unnarrowed t)))

      
  
     (setq org-roam-dailies-capture-templates
        '(("d" "default" entry
           "* %U %?"
              :target (file+head "%<%Y-%m-%d>.org"
                            ":PROPERTIES:\n:CREATED: %U\n:END:\n#+title: %<%Y-%m-%d>\n#+filetags: :journal:"))
        ("w" "weekly review" plain
           (file (concat my/org-templates "weekly_review.org"))
             :target (file+head "reviews/%<%Y-W%W>-weekly-review.org"
                            ":PROPERTIES:\n:CREATED: %U\n:END:\n#+title: Weekly Review %<%Y-W%W>\n#+filetags: :journal:review:")
              :unnarrowed t)))

)


(after! org-contacts
  (setq org-contacts-files (list (concat my/org-gtd "contacts.org")))
  (setq org-contacts-files (list (concat my/org-gtd "contacts.org")))
  (setq org-agenda-include-diary t)
  (setq org-contacts-birthday-property "BIRTHDAY")
)


