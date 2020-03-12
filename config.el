;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(load! "+bindings")

(setq doom-scratch-buffer-major-mode 'emacs-lisp-mode)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 17)
      doom-variable-pitch-font (font-spec :family "Monospace")
       doom-unicode-font (font-spec :family "Monospace")
)
(setq doom-big-font (font-spec :family "Monospace" :size 27))
(remove-hook 'doom-init-ui-hook #'blink-cursor-mode)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)
(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
(use-package! lsp-mode
  :commands lsp
  :config
 ;; Support LSP in Org Babel with header argument `:file'.
  ;; https://github.com/emacs-lsp/lsp-mode/issues/377
  (defvar org-babel-lsp-explicit-lang-list
    '("java")
    "Org Mode Babel languages which need explicitly specify header argument :file.")
  (cl-defmacro lsp-org-babel-enbale (lang)
    "Support LANG in org source code block."
    ;; (cl-check-type lang symbolp)
    (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
           (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
      `(progn
         (defun ,intern-pre (info)
           (let ((lsp-file (or (->> info caddr (alist-get :file))
                               buffer-file-name
                               (unless (member ,lang org-babel-lsp-explicit-lang-list)
                                 (concat (org-babel-temp-file (format "lsp-%s-" ,lang))
                                         (cdr (assoc ,lang org-babel-tangle-lang-exts)))))))
             (setq-local buffer-file-name lsp-file)
             (setq-local lsp-buffer-uri (lsp--path-to-uri lsp-file))
             (lsp)))
         (if (fboundp ',edit-pre)
             (advice-add ',edit-pre :after ',intern-pre)
           (progn
             (defun ,edit-pre (info)
               (,intern-pre info))
             (put ',edit-pre 'function-documentation
                  (format "Add LSP info to Org source block dedicated buffer (%s)."
                          (upcase ,lang))))))))
   (defvar org-babel-lsp-lang-list
    '("shell"
      "python"
      "ein"
      ;; "ruby"
      "js" "css"
      ;; "C" "C++"

      "rust" "go" "java"))

  (dolist (lang org-babel-lsp-lang-list)
    (eval `(lsp-org-babel-enbale ,lang))))
(after! lsp-clients
  ;; (remhash 'clangd lsp-clients)
  )
(use-package! lsp-ui
  ;;load-path "~/Dev/Emacs/lsp-ui"
  :commands lsp-ui-mode
  :config
  (setq
   lsp-ui-sideline-enable nil
   lsp-ui-sideline-ignore-duplicate t
   lsp-ui-doc-header nil
   lsp-ui-doc-include-signature nil
   lsp-ui-doc-background (doom-color 'base4)
   lsp-ui-doc-border (doom-color 'fg)

   lsp-ui-peek-force-fontify nil
   lsp-ui-peek-expand-function (lambda (xs) (mapcar #'car xs)))

  (custom-set-faces
   '(ccls-sem-global-variable-face ((t (:underline t :weight extra-bold))))
   '(lsp-face-highlight-read ((t (:background "sea green"))))
   '(lsp-face-highlight-write ((t (:background "brown4"))))
   '(lsp-ui-sideline-current-symbol ((t (:foreground "grey38" :box nil))))
   '(lsp-ui-sideline-symbol ((t (:foreground "grey30" :box nil)))))

  (map! :after lsp-ui-peek
        :map lsp-ui-peek-mode-map
        "h" #'lsp-ui-peek--select-prev-file
        "j" #'lsp-ui-peek--select-next
        "k" #'lsp-ui-peek--select-prev
        "l" #'lsp-ui-peek--select-next-file
        )

  ;; (defhydra hydra/ref (evil-normal-state-map "x")
  ;;   "reference"
  ;;   ("p" (-let [(i . n) (lsp-ui-find-prev-reference)]
  ;;          (if (> n 0) (message "%d/%d" i n))) "prev")
  ;;   ("n" (-let [(i . n) (lsp-ui-find-next-reference)]
  ;;          (if (> n 0) (message "%d/%d" i n))) "next")
  ;;   ("R" (-let [(i . n) (lsp-ui-find-prev-reference '(:role 8))]
  ;;          (if (> n 0) (message "read %d/%d" i n))) "prev read" :bind nil)
  ;;   ("r" (-let [(i . n) (lsp-ui-find-next-reference '(:role 8))]
  ;;          (if (> n 0) (message "read %d/%d" i n))) "next read" :bind nil)
  ;;   ("W" (-let [(i . n) (lsp-ui-find-prev-reference '(:role 16))]
  ;;          (if (> n 0) (message "write %d/%d" i n))) "prev write" :bind nil)
  ;;   ("w" (-let [(i . n) (lsp-ui-find-next-reference '(:role 16))]
  ;;          (if (> n 0) (message "write %d/%d" i n))) "next write" :bind nil)
  ;;   )
  )

;; (setq magit-repository-directories '(("~/Dev" . 2)))

;; (use-package! atomic-chrome
;;   :defer 5                              ; since the entry of this
;;                                         ; package is from Chrome
;;   :config
;;   (setq atomic-chrome-url-major-mode-alist
;;         '(("github\\.com"        . gfm-mode)
;;           ("emacs-china\\.org"   . gfm-mode)
;;           ("stackexchange\\.com" . gfm-mode)
;;           ("stackoverflow\\.com" . gfm-mode)))

;;   (defun +my/atomic-chrome-mode-setup ()
;;     (setq header-line-format
;;           (substitute-command-keys
;;            "Edit Chrome text area.  Finish \
;; `\\[atomic-chrome-close-current-buffer]'.")))

;;   (add-hook 'atomic-chrome-edit-mode-hook #'+my/atomic-chrome-mode-setup)

;;   (atomic-chrome-start-server))

(use-package! avy
  :commands (avy-goto-char-timer)
  :init
  (setq avy-timeout-seconds 0.2)
  (setq avy-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?q ?w ?e ?r ?u ?i ?o ?p))
  )

(after! company
  (setq company-minimum-prefix-length 2
        company-quickhelp-delay nil
        company-show-numbers t
        company-global-modes '(not comint-mode erc-mode message-mode help-mode gud-mode)
        ))

(use-package! company-lsp
  ;;:load-path "~/Dev/Emacs/company-lsp"
  :after lsp-mode
  :config
  (setq company-transformers nil company-lsp-cache-candidates nil)
  (set-company-backend! 'lsp-mode 'company-lsp)
  )

;; (after! d-mode
;;   (require 'lsp)
;;   (lsp-register-client
;;    (make-lsp-client
;;     :new-connection (lsp-stdio-connection "dls")
;;     :major-modes '(d-mode)
;;     :priority -1
;;     :server-id 'ddls))
;;   (add-hook 'd-mode-hook #'lsp)
;;   )

(set-lookup-handlers! 'emacs-lisp-mode :documentation #'helpful-at-point)

(use-package! eglot)
(after! eshell
  (defun eshell/l (&rest args) (eshell/ls "-l" args))
  (defun eshell/e (file) (find-file file))
  (defun eshell/md (dir) (eshell/mkdir dir) (eshell/cd dir))
  (defun eshell/ft (&optional arg) (treemacs arg))

  (defun eshell/up (&optional pattern)
    (eshell-up pattern))

  (defun +my/ivy-eshell-history ()
    (interactive)
    (require 'em-hist)
    (let* ((start-pos (save-excursion (eshell-bol) (point)))
           (end-pos (point))
           (input (buffer-substring-no-properties start-pos end-pos))
           (command (ivy-read "Command: "
                              (delete-dups
                               (when (> (ring-size eshell-history-ring) 0)
                                 (ring-elements eshell-history-ring)))
                              :initial-input input)))
      (setf (buffer-substring start-pos end-pos) command)
      (end-of-line)))

  (defun +my/eshell-init-keymap ()
    (evil-define-key 'insert eshell-mode-map
      (kbd "C-r") #'+my/ivy-eshell-history))
  (add-hook 'eshell-first-time-mode-hook #'+my/eshell-init-keymap))

;; (setq evil-move-beyond-eol t)

(use-package! evil-nerd-commenter
  :commands (evilnc-comment-or-uncomment-lines)
  )

(after! evil-snipe
  (setq evil-snipe-scope 'buffer)
  )

(after! flycheck
  ;; (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  (global-flycheck-mode -1)
  )

(after! flymake-proc
  ;; disable flymake-proc
  (setq-default flymake-diagnostic-functions nil)
  )
(defvar flymake-posframe-delay 0.5)
(defvar flymake-posframe-buffer "*flymake-posframe*")
(defvar flymake-posframe--last-diag nil)
(defvar flymake-posframe--timer nil)

(defun flymake-posframe-hide ()
  (posframe-hide flymake-posframe-buffer))

(defun flymake-posframe-display ()
  (when flymake-mode
    (if-let (diag (and flymake-mode
                       (get-char-property (point) 'flymake-diagnostic)))
        (unless (and (eq diag flymake-posframe--last-diag)
                     (frame-visible-p (buffer-local-value 'posframe--frame (get-buffer flymake-posframe-buffer))))
          (setq flymake-posframe--last-diag diag)
          (posframe-show
           flymake-posframe-buffer
           :string (propertize (concat "➤ " (flymake--diag-text diag))
                               'face
                               (case (flymake--diag-type diag)
                                 (:error 'error)
                                 (:warning 'warning)
                                 (:note 'info)))))
      (flymake-posframe-hide))))

(defun flymake-posframe-set-timer ()
  (when flymake-posframe--timer
    (cancel-timer flymake-posframe--timer))
  (setq flymake-posframe-timer
        (run-with-idle-timer flymake-posframe-delay nil #'flymake-posframe-display)))

(use-package! frog-jump-buffer)

;; (add-hook 'post-command-hook #'flymake-posframe-set-timer)
;; (add-hook! (doom-exit-buffer doom-exit-window) #'flymake-posframe-hide)
(after! git-link
  (defun git-link-llvm (hostname dirname filename branch commit start end)
      (format "https://github.com/llvm-mirror/%s/tree/%s/%s"
              (file-name-base dirname)
              (or branch commit)
              (concat filename
                      (when start
                        (concat "#"
                                (if end
                                    (format "L%s-%s" start end)
                                  (format "L%s" start)))))))
  (defun git-link-musl (hostname dirname filename branch commit start end)
      (format "http://git.musl-libc.org/cgit/%s/tree/%s%s%s"
              (file-name-base dirname)
              filename
              (if branch "" (format "?id=%s" commit))
              (if start (concat "#" (format "n%s" start)) "")))
  (defun git-link-sourceware (hostname dirname filename branch commit start end)
    (format "https://sourceware.org/git/?p=%s.git;a=blob;hb=%s;f=%s"
            (file-name-base dirname)
            commit
            (concat filename
                    (when start
                      (concat "#" (format "l%s" start))))))
  (add-to-list 'git-link-remote-alist '("git.llvm.org" git-link-llvm))
  (add-to-list 'git-link-remote-alist '("git.musl-libc.org" git-link-musl))
  (add-to-list 'git-link-remote-alist '("sourceware.org" git-link-sourceware))
  )

(setq isearch-lax-whitespace t)
(setq search-whitespace-regexp ".*")
(define-key isearch-mode-map (kbd "DEL") #'isearch-del-char)
(defadvice isearch-search (after isearch-no-fail activate)
  (unless isearch-success
    (ad-disable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search)
    (isearch-repeat (if isearch-forward 'forward))
    (ad-enable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search)))

(use-package! link-hint
  :commands link-hint-open-link link-hint-open-all-links)

;; (after! lispy
;;   (setq lispy-outline "^;; \\(?:;[^#]\\|\\*+\\)"
;;         lispy-outline-header ";; "
;;         lispy-ignore-whitespace t)
;;   (map! :map lispy-mode-map
;;         :i "C-c (" #'lispy-wrap-round
;;         :i "_" #'special-lispy-different
;;         "d" nil
;;         :i [remap delete-backward-char] #'lispy-delete-backward))

;(remove-hook 'emacs-lisp-mode-hook #'lispy-mode)

;; ;; Also use lispyville in prog-mode for [ ] < >
;; (after! lispyville
;;   ;; (lispyville-set-key-theme
;;   ;;  '(operators
;;   ;;    c-w
;;   ;;    (escape insert)
;;   ;;    (slurp/barf-lispy)
;;   ;;    additional-movement))
;;   (map! :map lispyville-mode-map
;;        :i "C-w" #'backward-delete-char
;;        :n "M-j" nil
;;        :n "H" #'sp-backward-sexp
;;        :n "L" #'sp-forward-sexp
;;        )
;;   )
;; (map! :after elisp-mode
;;       :map emacs-lisp-mode-map
;;       :n "gh" #'helpful-at-point
;;       :n "gl" (λ! (let (lispy-ignore-whitespace) (call-interactively #'lispyville-right)))
;;       :n "C-<left>" #'lispy-forward-barf-sexp
;;       :n "C-<right>" #'lispy-forward-slurp-sexp
;;       :n "C-M-<left>" #'lispy-backward-slurp-sexp
;;       :n "C-M-<right>" #'lispy-backward-barf-sexp
;;       :i "C-w" #'delete-backward-char
;;       :n "<tab>" #'lispyville-prettify
;;       :localleader
;;       :n "x" (λ! (save-excursion (forward-sexp) (eval-last-sexp nil))))

(use-package! smartparens
  :config
  (setq sp-autoinsert-pair t
        sp-autodelete-pair t
        sp-escape-quotes-after-insert t)
  (setq-default sp-autoskip-closing-pair t)
  )


;; (use-package! tldr
;;   :commands (tldr)
;;   :config
;;   (setq tldr-directory-path (concat doom-etc-dir "tldr/"))
;;   (set-popup-rule! "^\\*tldr\\*" :side 'right :select t :quit t)
;;   )

;; (after! nav-flash
;;   ;; (defun nav-flash-show (&optional pos end-pos face delay)
;;   ;; ...
;;   ;; (let ((inhibit-point-motion-hooks t))
;;   ;; (goto-char pos)
;;   ;; (beginning-of-visual-line) ; work around args-out-of-range error when the target file is not opened
;;   (defun +advice/nav-flash-show (orig-fn &rest args)
;;     (ignore-errors (apply orig-fn args)))
;;   (advice-add 'nav-flash-show :around #'+advice/nav-flash-show))

(setq which-key-idle-delay 0)

(set-popup-rules! '(
  ("^\\*helpful" :size 0.4)
  ("^\\*info.*" :size 80 :size right)
  ("^\\*Man.*" :size 80 :side right)
  ))
(use-package! rg)
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
     ;; :n "f" #'ccls/references-not-call
     :n "lp" #'ccls-preprocess-file
     :n "lf" #'ccls-reload
     :n "m" #'ccls/references-macro
     :n "r" #'ccls/references-read
     :n "w" #'ccls/references-write
     :desc "breakpoint"
     :n "db" (lambda ()
               (interactive)
               (evil-open-above 1)
               (insert "volatile static int z=0;while(!z)asm(\"pause\");")
               (evil-normal-state))
     :n "dd" #'realgud:gdb
     ))
  )

(use-package! clang-format
  :commands (clang-format-region)
  )

(use-package! ccls
  ;;:load-path "~/Dev/Emacs/emacs-ccls"
  :hook ((c-mode-local-vars c++-mode-local-vars objc-mode-local-vars) . +ccls|enable)
  :config
  ;; overlay is slow
  ;; Use https://github.com/emacs-mirror/emacs/commits/feature/noverlay
  (setq ccls-sem-highlight-method 'font-lock)
  (add-hook 'lsp-after-open-hook #'ccls-code-lens-mode)
  (ccls-use-default-rainbow-sem-highlight)
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

(use-package! modern-cpp-font-lock
  :hook (c++-mode . modern-c++-font-lock-mode))

(use-package! awesome-tab
  :config
  (awesome-tab-mode t)
  (setq
     awesome-tab-show-tab-index t
        )
  )
(use-package! ivy
  :config
  (setq
   ;; use fuzzy finding
   ivy-re-builders-alist '((swiper . ivy--regex-plus)
                           (swiper-isearch . ivy--regex-plus)
                           (counsel-rg . ivy--regex-plus)
                           (t . ivy--regex-fuzzy))
   )
  )
;;; private/my-cc/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defvar +ccls-path-mappings [])

;;;###autoload
(defvar +ccls-initial-blacklist [])

;;;###autoload
(defvar +lsp-blacklist nil)

;;;###autoload
(defun +ccls|enable ()
  (when (and buffer-file-name (--all? (not (string-match-p it buffer-file-name)) +lsp-blacklist))
    (require 'ccls)
    (setq-local lsp-ui-sideline-show-symbol nil)
    (when (string-match-p "/llvm" buffer-file-name)
      (setq-local lsp-enable-file-watchers nil))
    (if +my-use-eglot (call-interactively #'eglot) (lsp))))

(defun ccls/callee ()
  (interactive)
  (lsp-ui-peek-find-custom "$ccls/call" '(:callee t)))
(defun ccls/caller ()
  (interactive)
  (lsp-ui-peek-find-custom "$ccls/call"))
(defun ccls/vars (kind)
  (lsp-ui-peek-find-custom "$ccls/vars" `(:kind ,kind)))
(defun ccls/base (levels)
  (lsp-ui-peek-find-custom "$ccls/inheritance" `(:levels ,levels)))
(defun ccls/derived (levels)
  (lsp-ui-peek-find-custom "$ccls/inheritance" `(:levels ,levels :derived t)))
(defun ccls/member (kind)
  (lsp-ui-peek-find-custom "$ccls/member" `(:kind ,kind)))

;; The meaning of :role corresponds to https://github.com/maskray/ccls/blob/master/src/symbol.h

;; References w/ Role::Address bit (e.g. variables explicitly being taken addresses)
(defun ccls/references-address ()
  (interactive)
  (lsp-ui-peek-find-custom "textDocument/references"
   (plist-put (lsp--text-document-position-params) :role 128)))

;; References w/ Role::Dynamic bit (macro expansions)
(defun ccls/references-macro ()
  (interactive)
  (lsp-ui-peek-find-custom "textDocument/references"
   (plist-put (lsp--text-document-position-params) :role 64)))

;; References w/o Role::Call bit (e.g. where functions are taken addresses)
(defun ccls/references-not-call ()
  (interactive)
  (lsp-ui-peek-find-custom "textDocument/references"
   (plist-put (lsp--text-document-position-params) :excludeRole 32)))

;; References w/ Role::Read
(defun ccls/references-read ()
  (interactive)
  (lsp-ui-peek-find-custom "textDocument/references"
   (plist-put (lsp--text-document-position-params) :role 8)))

;; References w/ Role::Write
(defun ccls/references-write ()
  (interactive)
  (lsp-ui-peek-find-custom "textDocument/references"
   (plist-put (lsp--text-document-position-params) :role 16)))

;; xref-find-apropos (workspace/symbol)

;; (defun my/highlight-pattern-in-text (pattern line)
;;   (when (> (length pattern) 0)
;;     (let ((i 0))
;;      (while (string-match pattern line i)
;;        (setq i (match-end 0))
;;        (add-face-text-property (match-beginning 0) (match-end 0) 'isearch t line)
;;        )
;;      line)))

;; (with-eval-after-load 'lsp-methods
;;   ;;; Override
;;   ;; This deviated from the original in that it highlights pattern appeared in symbol
;;   (defun lsp--symbol-information-to-xref (pattern symbol)
;;    "Return a `xref-item' from SYMBOL information."
;;    (let* ((location (gethash "location" symbol))
;;           (uri (gethash "uri" location))
;;           (range (gethash "range" location))
;;           (start (gethash "start" range))
;;           (name (gethash "name" symbol)))
;;      (xref-make (format "[%s] %s"
;;                         (alist-get (gethash "kind" symbol) lsp--symbol-kind)
;;                         (my/highlight-pattern-in-text (regexp-quote pattern) name))
;;                 (xref-make-file-location (string-remove-prefix "file://" uri)
;;                                          (1+ (gethash "line" start))
;;                                          (gethash "character" start)))))

;;   (cl-defmethod xref-backend-apropos ((_backend (eql xref-lsp)) pattern)
;;     (let ((symbols (lsp--send-request (lsp--make-request
;;                                        "workspace/symbol"
;;                                        `(:query ,pattern)))))
;;       (mapcar (lambda (x) (lsp--symbol-information-to-xref pattern x)) symbols)))
;;   )
(defun ivy-with-thing-at-point (cmd)
  (let ((ivy-initial-inputs-alist
             (list
              (cons cmd (thing-at-point 'symbol)))))
        (funcall cmd)))
(defun counsel-rg-thing-at-point ()
      (interactive)
      (ivy-with-thing-at-point 'counsel-rg))
