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
           (file (concat my/org-templates "weekly-review.org"))
           :target (file+head "reviews/%<%Y-W%W>-weekly-review.org"
                              ":PROPERTIES:\n:CREATED: %U\n:END:\n#+title: Weekly Review %<%Y-W%W>\n#+filetags: :journal:review:")
           :unnarrowed t))))

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil)

  (map! :leader
        :prefix ("n g" . "knowledge graph")
        :desc "Toggle graph mode" "e" #'org-roam-ui-mode
        :desc "Open in browser" "o" #'org-roam-ui-open))
