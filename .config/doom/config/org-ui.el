(after! org
  (setq org-src-fontify-natively t))

(after! evil-escape
  (setq evil-escape-key-sequence "jj"
        evil-escape-delay 0.2
        evil-escape-unordered-key-sequence t)
  (evil-escape-mode 1))

(setq org-agenda-custom-commands
      '(("h" "@home Context"
         ((tags-todo "+@home/!-WAIT-CNCL"
                      ((org-agenda-overriding-header "🏠 Home Actions")))))

        ("W" "Work Dashboard"
         ((tags-todo "+@work/!-WAIT-CNCL"
                      ((org-agenda-overriding-header "💼 Work Actions")))
           (tags "+MEETING"
                 ((org-agenda-overriding-header "📅 Meetings")))))))

(use-package! org-modern
  :after org
  :config
  (global-org-modern-mode)
  (setq org-modern-star '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
        org-modern-tag t
        org-modern-timestamp nil
        org-modern-table-vertical 1
        org-modern-table-horizontal 0.2
        org-modern-list '((?+ . "➤") (?- . "–") (?* . "•"))
        org-modern-block-fringe nil))

(use-package! org-wild-notifier
  :after org
  :config
  (org-wild-notifier-mode)
  (setq org-wild-notifier-alert-time '(30 15 5 1)
        org-wild-notifier-keyword-whitelist nil
        org-wild-notifier-keyword-blacklist '("DONE")
        alert-default-style 'libnotify))

(use-package! org-contacts
  :after org
  :config
  (setq org-contacts-files (list (concat my/org-gtd "contacts.org"))
        org-agenda-include-diary t
        org-contacts-birthday-property "BIRTHDAY"))

(use-package! org-download
  :after org
  :config
  (setq org-download-method 'attach
        org-download-screenshot-method "wl-paste > %s"
        org-download-heading-lvl nil
        org-download-display-inline-images t
        org-download-timestamp "_%Y%m%d_%H%M%S"
        org-download-edit-cmd "swappy -f %s")

  (map! :leader
        :prefix ("n i" . "insert image")
        :desc "Paste clipboard image" "p" #'org-download-clipboard
        :desc "Download from URL" "u" #'org-download-yank
        :desc "Delete image at point" "d" #'org-download-delete))
