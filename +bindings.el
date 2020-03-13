;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

(define-inline +my/prefix-M-x (prefix)
  (inline-quote
   (lambda () (interactive)
     (setq unread-command-events (string-to-list ,prefix))
     (call-interactively #'execute-extended-command))))

(define-inline +my/simulate-key (key)
  (inline-quote
   (lambda () (interactive)
     (setq prefix-arg current-prefix-arg)
     (setq unread-command-events (listify-key-sequence (read-kbd-macro ,key))))))

(general-define-key :states '(normal visual motion) "x" nil)

(map!
 ;; localleader
 :m ","    nil

 ;; (:map prog-mode-map
 ;;   :n "H"  #'lsp-ui-peek-jump-backward
 ;;   :n "L"  #'lsp-ui-peek-jump-forward
 ;;   :m "C-H"  #'+my/xref-jump-backward-file
 ;;   :m "C-L"  #'+my/xref-jump-forward-file
 ;;   )

 ;; :n "M-u" (+my/simulate-key "[")
 ;; :n "M-i" (+my/simulate-key "]")
 ;; :n "M-;"  #'eval-expression
 ;; :n "M-f"  #'swiper
 ;; :n "M-j"  #'+my/find-definitions
 :n "M-."  #'+lookup/definition
 :n "/"  #'swiper
 :n "f" #'avy-goto-char

 ;; :n [tab]  #'evil-window-next
 :n "C-1" #'+popup/raise
 :n "C-c a" #'org-agenda
 ;; all symbols
 ;; :n ";"    (λ! (if lsp-mode
 ;;                    (progn (+my/avy-document-symbol t)
 ;;                           (+my/find-definitions))
 ;;                  (avy-goto-word-0 nil)))
 ;; outline
 :n "z;"   (λ! (+my/avy-document-symbol nil))
 :n "M-,"  (λ! (+my/find-references (+my//folder-param t)))
 :n "ga"   #'+my/workspace-symbol
 :n "C-,"  #'+my/find-references
 :n "gf"   #'+my/ffap

 :n "gA"   (λ! (setq current-prefix-arg t) (call-interactively #'+my/workspace-symbol))
 :n "gc"   #'evilnc-comment-or-uncomment-lines
 :n "go"   (λ! (message "%S" (text-properties-at (point))))
 :n "Q" #'kill-current-buffer

 (:prefix "x"
   :n ";" (λ! (+my/avy-document-symbol t) (+my/find-references))

   ;; $ccls/inheritance
   :n "b" (λ! (ccls/base 1))
   :n "B" (λ! (ccls/base 3))
   :n "d" (λ! (ccls/derived 1))
   :n "D" (λ! (ccls/derived 3))
   :n "i" #'ccls-inheritance-hierarchy         ; base hierarchy
   :n "I" (λ! (ccls-inheritance-hierarchy t)) ; derived hierarchy

   :n "r" #'ccls/references-read
   :n "w" #'ccls/references-write
   ;; $ccls/call
   :n "c" #'ccls/caller
   :n "C" #'ccls/callee
   ;; caller hierarchy
   :n "e" #'ccls-call-hierarchy
   ;; callee hierarchy
   :n "E" (λ! (ccls-call-hierarchy t))

   ;; $ccls/member
   :n "s" (λ! (ccls/member 2))   ; 2 (Type) => nested classes/namespace members
   :n "f" (λ! (ccls/member 3))   ; 3 (Func) => member functions
   :n "m" (λ! (ccls/member 0))   ; other => member variables
   :n "M" #'ccls-member-hierarchy

   :n "l" #'julia-repl-send-region-or-line

   :n "L" #'ccls-code-lens-mode
   :n "t" #'lsp-goto-type-definition
   ;; https://github.com/maskray/ccls/blob/master/src/messages/ccls_vars.cc#L15
   :n "v" (λ! (ccls/vars 3))           ; field or local variable
   :n "V" (λ! (ccls/vars 1))           ; field
   :n "C-v" (λ! (ccls/vars 7))         ; any
   :n "x" #'evil-delete-char)

 (:prefix "C-x"
   :n "e"  #'pp-eval-last-sexp
   :n "u" #'link-hint-open-link
   )
 )

(map! :leader
   "SPC" #'+ivy/switch-workspace-buffer
   ;; :n "M-u" (+my/simulate-key "SPC [")
   ;; :n "M-i" (+my/simulate-key "SPC ]")
   (:prefix "g"
     "*" (+my/prefix-M-x "magit-")
     :desc "Magit blame"               "b"   #'magit-blame-addition
     :desc "Magit switch branch"       "B"   #'magit-branch-checkout
     "q" #'git-link
     )
   (:prefix "h"
     "C" #'helpful-command
     )
   (:prefix ("l" . "lsp")
     "=" #'lsp-format-buffer
     "a" #'lsp-execute-code-action
     "l" #'lsp-ui-sideline-mode
     "d" #'lsp-ui-doc-mode
     "e" #'flymake-show-diagnostics-buffer
     "i" #'lsp-ui-imenu
     "r" #'lsp-rename
     "R" #'lsp-restart-workspace
     "w" #'lsp-ui-peek-find-workspace-symbol
     )
   ;; Rebind to "S"
   (:prefix ("S" . "snippets")
     :desc "New snippet"            "n" #'yas-new-snippet
     :desc "Insert snippet"         "i" #'yas-insert-snippet
     :desc "Find snippet for mode"  "s" #'yas-visit-snippet-file
     :desc "Find snippet"           "S" #'+default/find-in-snippets)

   (:prefix ("s" . "search")
     "b" #'swiper-all
     :desc "Directory"              "d" #'+ivy/project-search-from-cwd
     :desc "Project"                "/" #'+ivy/project-search
     "s" (λ! (minibuffer-with-setup-hook
                  (lambda () (insert ivy--default)) (+ivy/project-search)))
     :desc "Symbols"                "i" #'imenu
     :desc "Symbols across buffers" "I" #'imenu-anywhere
     :desc "Online providers"       "o" #'+lookup/online-select
     )
   )

(map! :localleader
   :m "b" #'+ivy/switch-workspace-buffer
   :m "f" #'+default/find-file-under-here
   :m "1" (λ! (awesome-tab-select-visible-nth-tab 1))
   :m "2" (λ! (awesome-tab-select-visible-nth-tab 2))
   :m "3" (λ! (awesome-tab-select-visible-nth-tab 3))
   :m "4" (λ! (awesome-tab-select-visible-nth-tab 4))
   :m "5" (λ! (awesome-tab-select-visible-nth-tab 5))
   :m "6" (λ! (awesome-tab-select-visible-nth-tab 6))
   :m "7" (λ! (awesome-tab-select-visible-nth-tab 7))
   :m "8" (λ! (awesome-tab-select-visible-nth-tab 8))
   :m "9" (λ! (awesome-tab-select-visible-nth-tab 9))
   :m "0" (λ! (awesome-tab-select-visible-nth-tab 0))
   :m "h" #'symbol-overlay-put
   :m "cc" #'evilnc-comment-or-uncomment-lines
   :m "w" #'counsel-rg-thing-at-point
   :m "s" #'yas-insert-snippet
   :m "t" #'imenu
   :m "T" #'counsel-etags-list-tag
   ;; xref style, more general
   :n "r" #'xref-find-references
   :n "d" #'xref-find-definitions
   ;; :n "r" #'lsp-ui-peek-find-references
   ;; :n "r" #'lsp-find-references
   ;; :n "d" #'lsp-ui-peek-find-definitions
   )
