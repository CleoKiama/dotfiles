;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(defvar my/org-root "/data/org"
  "Root directory for all org files.")

(defvar my/org-gtd      (concat my/org-root "/GTD/"))
(defvar my/org-notes    (concat my/org-root "/roam/"))
(defvar my/org-archive  (concat my/org-root "/archive/"))
(defvar my/org-templates (concat my/org-root "/templates/"))
(defvar my/org-attachments (concat my/org-root "/attachments/"))

(setq org-directory (concat my/org-root "/"))
(setq org-agenda-files (list my/org-gtd))
(setq org-attach-id-dir my/org-attachments)

(setq doom-theme 'doom-one)

(setq doom-font (font-spec :family "Hasklug Nerd Font Mono Med" :size 15)
      doom-variable-pitch-font (font-spec :family "CaskaydiaCove Nerd Font" :size 15))

(setq display-line-numbers-type t)

(after! evil-escape
  (setq evil-escape-key-sequence "jj"
        evil-escape-delay 0.2
        evil-escape-unordered-key-sequence t)
  (evil-escape-mode 1))

(after! org
  (setq org-agenda-files (list my/org-gtd (concat my/org-notes "journal/")))
  (setq org-capture-templates
        '(("t" "Personal Todo" entry
           (file+headline (concat my/org-gtd "inbox.org") "Tasks")
           "* TODO %?\n  %i\n  %a" :prepend t)
          ("m" "Meeting" entry
           (file+headline (concat my/org-gtd "inbox.org") "Meetings")
           "* MEETING with %? :MEETING:\n  %U" :prepend t)
          ("c" "Contact" entry
           (file (concat my/org-gtd "contacts.org"))
           "* %^{Name}
:PROPERTIES:
:EMAIL:    %^{Email}
:PHONE:    %^{Phone}
:BIRTHDAY: %^{Birthday (YYYY-MM-DD)}
:NOTE:     %^{Note}
:END:" :prepend t)))

(setq org-archive-location (concat my/org-archive "%s_archive::"))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)")))

(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key ACTIVATED."
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))
(add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)

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
    ("#low"      . ?l)))
)

(setq org-log-into-drawer t)      ; State changes go into LOGBOOK
(setq org-clock-into-drawer t)    ; Clock entries go into LOGBOOK

(after! org-roam
  (setq org-roam-directory my/org-notes)
  (setq org-roam-dailies-directory "journal/")
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
  (setq org-agenda-include-diary t)
  (setq org-contacts-birthday-property "BIRTHDAY"))

(after! org-download
  (setq org-download-method 'attach))

(setq ispell-program-name "aspell")
