
;(map!
 ;;; localleader

 ;(:map prog-mode-map
   ;:m "RET" #'+ivy/switch-workspace-buffer
   ;;; Override default :n < > ( )
   ;;; :nm "<" #'lispyville-previous-opening
   ;;; :nm ">" #'lispyville-next-closing

   ;:n "C-h" #'lispyville-backward-up-list
   ;:n "C-j" #'lispyville-forward-sexp
   ;:n "C-k" #'lispyville-backward-sexp
   ;:n "C-l" #'lispyville-up-list
   ;)
 ;:n "[ M-u" #'symbol-overlay-switch-backward
 ;:n "] M-i" #'symbol-overlay-switch-forward
 ;)
;; (map!
;;  (:after evil-collection-info
;;    :map Info-mode-map
;;    "/" #'Info-search
;;    "?" #'Info-search-backward
;;    )

;;  ;; ivy
;;  (:after ivy
;;    :map ivy-minibuffer-map
;;    "<tab>" #'ivy-call-and-recenter
;;    "C-;"   #'ivy-posframe-avy
;;    "C-b"   #'backward-char
;;    "C-f"   #'forward-char
;;    )

;;  (:after company
;;    (:map company-active-map
;;      ;; Don't interfere with `evil-delete-backward-word' in insert mode
;;      "C-v"        #'company-next-page
;;      "M-v"        #'company-previous-page
;;      "C-i"        #'company-complete-selection
;;      [tab]        #'company-complete-selection
;;      "RET"        nil
;;      [return]     nil
;;      "SPC"        nil))

;;  (:after magit
;;    (:map magit-revision-mode-map
;;      "gq"        #'+my/open-issue-in-browser))

;;  (:after realgud
;;    (:map realgud-track-mode-map
;;      :in ";" #'realgud-window-src-undisturb-cmd
;;      :in "C-j" (λ! (realgud:cmd-repeat-last) (realgud-window-src-undisturb-cmd)))
;;    (:map realgud:shortkey-mode-map
;;      ;; :n "e" (λ! (realgud:cmd-run-command (thing-at-point 'symbol) "eval"))
;;      :n "i" #'realgud-window-cmd-undisturb-src
;;      :n "t" #'realgud:cmd-tbreak
;;      :n "U" #'realgud:cmd-until
;;      :n "1" (λ! (+my/realgud-eval-nth-name-forward 1))
;;      :n "2" (λ! (+my/realgud-eval-nth-name-forward 2))
;;      :n "3" (λ! (+my/realgud-eval-nth-name-forward 3))
;;      :n "4" (λ! (+my/realgud-eval-nth-name-forward 4))
;;      :n "5" (λ! (+my/realgud-eval-nth-name-forward 5))
;;      :n "6" (λ! (+my/realgud-eval-nth-name-forward 6))
;;      :n "7" (λ! (+my/realgud-eval-nth-name-forward 7))
;;      :n "8" (λ! (+my/realgud-eval-nth-name-forward 8))
;;      :n "9" (λ! (+my/realgud-eval-nth-name-forward 9))
;;      :n "M-1" (λ! (+my/realgud-eval-nth-name-backward 1))
;;      :n "M-2" (λ! (+my/realgud-eval-nth-name-backward 2))
;;      :n "M-3" (λ! (+my/realgud-eval-nth-name-backward 3))
;;      :n "M-4" (λ! (+my/realgud-eval-nth-name-backward 4))
;;      :n "M-5" (λ! (+my/realgud-eval-nth-name-backward 5))
;;      :n "M-6" (λ! (+my/realgud-eval-nth-name-backward 6))
;;      :n "M-7" (λ! (+my/realgud-eval-nth-name-backward 7))
;;      :n "M-8" (λ! (+my/realgud-eval-nth-name-backward 8))
;;      :n "M-9" (λ! (+my/realgud-eval-nth-name-backward 9))
;;      )
;;    )
;;  )

;; (map! :leader
;;    "SPC" #'+ivy/switch-workspace-buffer
;;    ;; :n "M-u" (+my/simulate-key "SPC [")
;;    ;; :n "M-i" (+my/simulate-key "SPC ]")
;;    (:prefix ("a" . "app")
;;      :desc "genhdr" :n "g"
;;      (λ! (shell-command-on-region (point-min) (point-max) "genhdr" t t))
;;      :desc "genhdr windows" :n "G"
;;      (λ! (shell-command-on-region (point-min) (point-max) "genhdr windows" t t))
;;      )
;;    (:prefix "b"
;;      :desc "Last buffer" :n "b" #'evil-switch-to-windows-last-buffer
;;      "l" #'ivy-switch-buffer
;;      )
;;    (:prefix ("e" . "error")
;;      "n" #'flycheck-next-error
;;      "p" #'flycheck-previous-error
;;      )
;;    :desc "lispyville" :n "L" (+my/prefix-M-x "lispyville ")
;;    (:prefix "o"
;;      "d" #'+debugger:start
;;      "o" #'symbol-overlay-put
;;      "q" #'symbol-overlay-remove-all
;;      )
;;    (:prefix "p"
;;      "e" #'projectile-run-eshell
;;      "f" #'counsel-projectile-find-file
;;      "*" (+my/prefix-M-x "projectile-")
;;      )
;;    (:prefix "r"
;;      "l" #'ivy-resume
;;      )
;;    (:prefix ("t" . "toggle")
;;      "d" #'toggle-debug-on-error
;;      "D" #'+my/realtime-elisp-doc
;;      )
;;    )
