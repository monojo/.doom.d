;;; ~/.doom.d/disabled_config.el -*- lexical-binding: t; -*-

;; xref-find-apropos (workspace/symbol)
;;
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

  ;; (dolist (lang org-babel-lsp-lang-list)
  ;;   (eval `(lsp-org-babel-enbale ,lang))))

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

;; (setq evil-move-beyond-eol t)

;; (add-hook 'post-command-hook #'flymake-posframe-set-timer)
;; (add-hook! (doom-exit-buffer doom-exit-window) #'flymake-posframe-hide)

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

;; ;; If you use `org' and don't want your org files in the default location below,
;; ;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")

;; (after! evil-snipe
;;   (setq evil-snipe-scope 'buffer)
;;   )

;; (use-package! frog-jump-buffer)

;; (use-package! avy
;;   :commands (avy-goto-char-timer)
;;   :init
;;   (setq avy-timeout-seconds 0.2)
;;   (setq avy-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?q ?w ?e ?r ?u ?i ?o ?p))
;;   )

;; (use-package! eglot)

 ;; Support LSP in Org Babel with header argument `:file'.
  ;; https://github.com/emacs-lsp/lsp-mode/issues/377
  ;; (defvar org-babel-lsp-explicit-lang-list
  ;;   '("java")
  ;;   "Org Mode Babel languages which need explicitly specify header argument :file.")
  ;; (cl-defmacro lsp-org-babel-enbale (lang)
  ;;   "Support LANG in org source code block."
  ;;   ;; (cl-check-type lang symbolp)
  ;;   (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
  ;;          (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
  ;;     `(progn
  ;;        (defun ,intern-pre (info)
  ;;          (let ((lsp-file (or (->> info caddr (alist-get :file))
  ;;                              buffer-file-name
  ;;                              (unless (member ,lang org-babel-lsp-explicit-lang-list)
  ;;                                (concat (org-babel-temp-file (format "lsp-%s-" ,lang))
  ;;                                        (cdr (assoc ,lang org-babel-tangle-lang-exts)))))))
  ;;            (setq-local buffer-file-name lsp-file)
  ;;            (setq-local lsp-buffer-uri (lsp--path-to-uri lsp-file))
  ;;            (lsp)))
  ;;        (if (fboundp ',edit-pre)
  ;;            (advice-add ',edit-pre :after ',intern-pre)
  ;;          (progn
  ;;            (defun ,edit-pre (info)
  ;;              (,intern-pre info))
  ;;            (put ',edit-pre 'function-documentation
  ;;                 (format "Add LSP info to Org source block dedicated buffer (%s)."
  ;;                         (upcase ,lang))))))))
  ;;                     
   ;; (defvar org-babel-lsp-lang-list
    ;; '("shell"
    ;;   "python"
    ;;   "ein"
    ;;   ;; "ruby"
    ;;   "js" "css"
    ;;   ;; "C" "C++"

    ;;   "rust" "go" "java"))

;; (after! lsp-clients
;;   ;; (remhash 'clangd lsp-clients)
;;   )
