(after! org
  ;; Existing non-GTD captures remain available
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

  ;; Single unified org-gtd workflow.
  ;; Linear keeps its own file-local TODO states in /data/org/GTD/linear.org.
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "CNCL(c)")))

  (setq org-use-tag-inheritance t)

  ;; WAIT/CNCL are states now, not tags
  (setq org-tag-alist
        '((:startgroup . nil)
          ("@home" . ?h)
          ("@work" . ?w)
          ("@computer" . ?c)
          ("@phone" . ?p)
          ("@errands" . ?r)
          ("@email" . ?e)
          (:endgroup . nil)
          ("#deep" . ?d)
          ("#quick" . ?q)
          ("#low" . ?l)))

  (setq org-log-done 'time
        org-log-into-drawer t
        org-clock-into-drawer t)

  (defun log-todo-state-change (&rest _)
    "Log timestamps for important TODO state transitions."
    (let ((state (org-get-todo-state)))
      (cond
       ((and (string= state "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
        (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]")))
       ((and (string= state "WAIT")
             (not (org-entry-get nil "WAITING_SINCE")))
        (org-entry-put nil "WAITING_SINCE" (format-time-string "[%Y-%m-%d]")))
       ((and (not (string= state "WAIT"))
             (org-entry-get nil "WAITING_SINCE"))
        (org-entry-put nil "WAITING_SINCE" nil)))))

  (defun log-task-creation-time ()
    "Log CREATED timestamp when a new TODO is created."
    (when (and (string= (org-get-todo-state) "TODO")
               (not (org-entry-get nil "CREATED")))
      (org-entry-put nil "CREATED" (format-time-string "[%Y-%m-%d]"))))

  (add-hook 'org-after-todo-state-change-hook #'log-todo-state-change)
  (add-hook 'org-after-todo-state-change-hook #'log-task-creation-time))

(use-package! org-gtd
  :after org
  :init
  ;; Required for org-gtd v4 startup acknowledgement
  (setq org-gtd-update-ack "4.0.0")
  :config
  (setq org-gtd-directory my/org-gtd
        org-gtd-keyword-mapping
        '((todo . "TODO")
          (next . "NEXT")
          (wait . "WAIT")
          (done . "DONE")
          (canceled . "CNCL")))

  ;; Keep GTD + habits + journal in agenda via org-gtd integration block
  (setq org-agenda-files
        (append (list org-gtd-directory)
                (list my/org-habits)
                (list (concat my/org-notes "journal/"))))

  ;; Project dependency management
  (org-edna-mode 1)

  ;; Clarify buffer organize action
  (define-key org-gtd-clarify-mode-map (kbd "C-c c") #'org-gtd-organize)

  ;; Agenda transient in agenda buffers
  (after! org-agenda
    (define-key org-agenda-mode-map (kbd "C-c .") #'org-gtd-agenda-transient)))

(map! :leader
      (:prefix-map ("d" . "GTD")
       :desc "Capture to inbox" "c" #'org-gtd-capture
       :desc "Process inbox" "p" #'org-gtd-process-inbox
       :desc "Engage (action list)" "e" #'org-gtd-engage
       :desc "Show all NEXT" "n" #'org-gtd-show-all-next
       :desc "Stuck projects" "s" #'org-gtd-reflect-stuck-projects
       :desc "Reflect missed items" "m" #'org-gtd-reflect-missed-items
       :desc "Reflect someday/maybe" "y" #'org-gtd-reflect-someday-review
       :desc "Reflect completed items" "R" #'org-gtd-reflect-completed-items
       :desc "Archive completed" "a" #'org-gtd-archive-completed-items
       :desc "Reflect areas of focus" "r" #'org-gtd-reflect-area-of-focus))

(map! :g
      :desc "GTD: Capture" "C-d c" #'org-gtd-capture
      :desc "GTD: Process inbox" "C-d p" #'org-gtd-process-inbox
      :desc "GTD: Engage" "C-d e" #'org-gtd-engage
      :desc "GTD: Show all NEXT" "C-d n" #'org-gtd-show-all-next
      :desc "GTD: Stuck projects" "C-d s" #'org-gtd-reflect-stuck-projects
      :desc "GTD: Reflect missed items" "C-d m" #'org-gtd-reflect-missed-items
      :desc "GTD: Reflect someday" "C-d y" #'org-gtd-reflect-someday-review
      :desc "GTD: Reflect completed" "C-d R" #'org-gtd-reflect-completed-items
      :desc "GTD: Archive completed" "C-d a" #'org-gtd-archive-completed-items
      :desc "GTD: Reflect areas" "C-d r" #'org-gtd-reflect-area-of-focus)
