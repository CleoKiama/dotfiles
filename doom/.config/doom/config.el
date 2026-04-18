;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(defvar my/org-root "/data/org"
  "Root directory for all org files.")

(defvar my/org-gtd      (concat my/org-root "/GTD/"))
(defvar my/org-notes    (concat my/org-root "/roam/"))
(defvar my/org-archive  (concat my/org-root "/archive/"))
(defvar my/org-templates (concat my/org-root "/templates/"))
(defvar my/org-attachments (concat my/org-root "/attachments/"))
(defvar my/org-habits   (concat my/org-gtd "habits.org"))

(setq org-directory (concat my/org-root "/"))
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

;; Fix: org-agenda 'j' should go to next line, not open calendar
;; This is a known issue with evil-collection overriding org-agenda keys
(after! org-agenda
  (define-key org-agenda-mode-map (kbd "j") #'org-agenda-next-line)
  (define-key org-agenda-mode-map (kbd "k") #'org-agenda-previous-line))

(after! org
  (setq org-agenda-files (list my/org-gtd my/org-habits (concat my/org-notes "journal/")))
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
            :END:" :prepend t)
          ("H" "Habit" entry
           (file+headline my/org-habits "Habits")
           "* TODO %^{Habit name}
            :PROPERTIES:
            :STYLE:    habit
            :CREATED:  %U
            :END:
            :LOGBOOK:
            - State \"DONE\" from \"TODO\" %U
            :END:" :prepend t)))

(setq org-archive-location (concat my/org-archive "%s_archive::"))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "SOMEDAY(s)" "CANCELLED(c)" "|" "DONE(d)")))

(defun log-todo-state-change (&rest args)
  "Log timestamps for various todo states."
  (let ((state (org-get-todo-state)))
    (cond
     ;; When moving to NEXT, log ACTIVATED
     ((and (string= state "NEXT")
           (not (org-entry-get nil "ACTIVATED")))
      (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]")))
     ;; When moving to WAITING, log WAITING_SINCE
     ((and (string= state "WAITING")
           (not (org-entry-get nil "WAITING_SINCE")))
      (org-entry-put nil "WAITING_SINCE" (format-time-string "[%Y-%m-%d]")))
     ;; When moving FROM WAITING, clear WAITING_SINCE
     ((and (org-entry-get nil "WAITING_SINCE")
           (not (string= state "WAITING")))
      (org-entry-put nil "WAITING_SINCE" nil)))))

(add-hook 'org-after-todo-state-change-hook #'log-todo-state-change)

;; Auto-add CREATED property on capture (via template handles this)
;; But also ensure any new TODO gets a CREATED timestamp
(defun log-task-creation-time ()
  "Log CREATED timestamp when a new TODO is created."
  (when (and (string= (org-get-todo-state) "TODO")
             (not (org-entry-get nil "CREATED")))
    (org-entry-put nil "CREATED" (format-time-string "[%Y-%m-%d]"))))

(add-hook 'org-after-todo-state-change-hook #'log-task-creation-time)

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
  ("#someday"  . ?S)
  ;; effort required
  ("#deep"     . ?d) ; deep work
  ("#quick"    . ?q)
   ("#low"      . ?l))) ; low effort

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

(setq ispell-program-name "aspell")

(use-package! org-super-agenda
  :after org-agenda
  :config
  (org-super-agenda-mode)

  (setq org-super-agenda-groups
        '((:name "⚡ NEXT (Active)"
           :todo "NEXT"
           :order 0)

          (:name "🏠 @home"
           :tag "@home"
           :order 1)

          (:name "💼 @work"
           :tag "@work"
           :order 2)

          (:name "📱 @phone/@email"
           :tag ("@phone" "@email")
           :order 3)

          (:name "🚗 @errands"
           :tag "@errands"
           :order 4)

          (:name "⏳ WAITING"
           :todo "WAITING"
           :order 8)

          (:name "📥 TODO (Later)"
            :todo "TODO"
            :order 9)

          (:name "❌ CANCELLED"
            :todo "CANCELLED"
            :order 10)

          (:name "🌙 SOMEDAY"
            :todo "SOMEDAY"
            :order 11)
          ))
  )

(use-package! org-modern
  :after org
  :config
  (global-org-modern-mode)

  ;; Custom bullet style
  (setq org-modern-star '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶"))

  (setq org-modern-tag t) ; Use built-in modern tags

  ;; Keep default timestamps
  (setq org-modern-timestamp nil)

  ;; Optional: Other nice settings
  (setq org-modern-table-vertical 1      ; Vertical table lines
        org-modern-table-horizontal 0.2  ; Subtle horizontal lines
        org-modern-list '((?+ . "➤") (?- . "–") (?* . "•"))  ; Pretty list bullets
        org-modern-block-fringe nil))    ; No block fringe

(use-package! org-roam-ui
  :after org-roam
  :config
   (setq org-roam-ui-sync-theme t         ; Match Emacs theme
         org-roam-ui-follow t              ; Follow current note
         org-roam-ui-update-on-save t      ; Update graph on save
         org-roam-ui-open-on-start nil))   ; Don't auto-open browser

  ;; Quick access keybinding
  (map! :leader
         :prefix ("n g" . "knowledge graph")
         :desc "Toggle graph mode" "e" #'org-roam-ui-mode
         :desc "Open in browser" "o" #'org-roam-ui-open))

(use-package! org-wild-notifier
  :after org
  :config
  (org-wild-notifier-mode)
  
  ;; Alert timing: 30, 15, 5, 1 minutes before
  (setq org-wild-notifier-alert-time '(30 15 5 1))
  
  ;; Only notify about MEETING and tasks with deadlines
  (setq org-wild-notifier-keyword-whitelist nil)
  (setq org-wild-notifier-keyword-blacklist '("DONE"))
  
  ;; Use libnotify for desktop notifications
  (setq alert-default-style 'libnotify))

(use-package! org-contacts
  :after org
  :config
  (setq org-contacts-files (list (concat my/org-gtd "contacts.org")))
  (setq org-agenda-include-diary t)
  (setq org-contacts-birthday-property "BIRTHDAY"))

(use-package! org-download
  :after org
  :config
  ;; uses org attach under the hood
  (setq org-download-method 'attach)
  ;; Screenshot method for wl-clipboard (Wayland)
  (setq org-download-screenshot-method "wl-paste > %s")

  ;; Customize the heading for images
  (setq org-download-heading-lvl nil)

  ;; Display inline images after download
  (setq org-download-display-inline-images t)

  ;; Annotate images with timestamps
  (setq org-download-timestamp "_%Y%m%d_%H%M%S")

  ;; Optional: Edit screenshot after pasting
  (setq org-download-edit-cmd "swappy -f %s")

  ;; Key bindings under SPC n i (notes insert/image)
  (map! :leader
        :prefix ("n i" . "insert image")
        :desc "Paste clipboard image" "p" #'org-download-clipboard
        :desc "Download from URL" "u" #'org-download-yank
        :desc "Delete image at point" "d" #'org-download-delete))
