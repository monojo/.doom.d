;;; ~/.doom.d/+cc.el -*- lexical-binding: t; -*-


(after! cc-mode
  ;; https://github.com/radare/radare2
  (c-add-style
   "radare2"
   '((c-basic-offset . 4)
     (indent-tabs-mode . t)
     (c-auto-align-backslashes . nil)
     (c-offsets-alist
      (arglist-intro . ++)
      (arglist-cont . ++)
      (arglist-cont-nonempty . ++)
      (statement-cont . ++)
      )))
  (c-add-style
   "my-cc" '("user"
             (c-basic-offset . 2)
             (c-offsets-alist
              . ((innamespace . 0)
                 (access-label . -)
                 (case-label . 0)
                 (member-init-intro . +)
                 (topmost-intro . 0)
                 (arglist-cont-nonempty . +)))))
  ;; cc code style
  (setq c-default-style "my-cc")
  (add-hook 'c-mode-common-hook
            (lambda ()
              ;; TODO work around https://github.com/hlissner/doom-emacs/issues/1006
              ;; (when (and buffer-file-name (string-match-p "binutils\\|glibc" buffer-file-name))
              ;;   (setq tab-width 8)
              ;;   (c-set-style "gnu"))
              (setq flymake-diagnostic-functions '(lsp--flymake-backend t))
              (modify-syntax-entry ?_ "w")
              ))

  (add-to-list 'auto-mode-alist '("\\.inc\\'" . +cc-c-c++-objc-mode))

  (map!
   :map (c-mode-map c++-mode-map)
   :n "C-h" (λ! (ccls-navigate "U"))
   :n "C-j" (λ! (ccls-navigate "R"))
   :n "C-k" (λ! (ccls-navigate "L"))
   :n "C-l" (λ! (ccls-navigate "D"))
   (:leader
     :n "=" #'clang-format-region
     )
   (:localleader
     :n "a" #'ccls/references-address
     :n "lp" #'ccls-preprocess-file
     :n "lf" #'ccls-reload
     :n "m" #'ccls/references-macro
     ;; :n "f" #'ccls/references-not-call
     ;; :n "r" #'ccls/references-read
     ;; :n "w" #'ccls/references-write
     ;; :desc "breakpoint"
     ;; :n "db" (lambda ()
     ;;           (interactive)
     ;;           (evil-open-above 1)
     ;;           (insert "volatile static int z=0;while(!z)asm(\"pause\");")
     ;;           (evil-normal-state))
     ;; :n "dd" #'realgud:gdb
     ))
  )

(use-package! ccls
  :hook ((c-mode-local-vars c++-mode-local-vars objc-mode-local-vars) . +ccls|enable)
  :config
  ;; overlay is slow
  ;; Use https://github.com/emacs-mirror/emacs/commits/feature/noverlay
  ;; (setq ccls-sem-highlight-method 'overlay)
  (setq ccls-sem-highlight-method 'font-lock)
  (add-hook 'lsp-after-open-hook #'ccls-code-lens-mode)
  ;; rainbow highlight, will override your theme
  ;; (ccls-use-default-rainbow-sem-highlight)
  ;; https://github.com/maskray/ccls/blob/master/src/config.h
  (setq
   ccls-initialization-options
   `(:clang
     (:excludeArgs
      ;; Linux's gcc options. See ccls/wiki
      ["-falign-jumps=1" "-falign-loops=1" "-fconserve-stack" "-fmerge-constants" "-fno-code-hoisting" "-fno-schedule-insns" "-fno-var-tracking-assignments" "-fsched-pressure"
       "-mhard-float" "-mindirect-branch-register" "-mindirect-branch=thunk-inline" "-mpreferred-stack-boundary=2" "-mpreferred-stack-boundary=3" "-mpreferred-stack-boundary=4" "-mrecord-mcount" "-mindirect-branch=thunk-extern" "-mno-fp-ret-in-387" "-mskip-rax-setup"
       "--param=allow-store-data-races=0" "-Wa arch/x86/kernel/macros.s" "-Wa -"]
      :extraArgs []
      :pathMappings ,+ccls-path-mappings)
     :completion
     (:include
      (:blacklist
       ["^/usr/(local/)?include/c\\+\\+/[0-9\\.]+/(bits|tr1|tr2|profile|ext|debug)/"
        "^/usr/(local/)?include/c\\+\\+/v1/"
        ]))
     :index (:initialBlacklist ,+ccls-initial-blacklist :parametersInDeclarations :json-false :trackDependency 1)))

  (after! projectile
   (add-to-list 'projectile-globally-ignored-directories ".ccls-cache"))

  (evil-set-initial-state 'ccls-tree-mode 'emacs)
  )

;; modern c++ highlight
(use-package! modern-cpp-font-lock
  :hook (c++-mode . modern-c++-font-lock-mode))

;; format c++ code
;; only work if there' a .clang-format file
(use-package! clang-format
  :commands (clang-format-region)
  )

;;;###autoload
(defvar +ccls-path-mappings [])

;;;###autoload
(defvar +ccls-initial-blacklist [])

;;;###autoload
(defvar +lsp-blacklist nil)
