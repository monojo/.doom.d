;;; ~/.doom.d/+lsp.el -*- lexical-binding: t; -*-

;; linting via flycheck, completion via company-lsp
;; hovers via lsp-ui, outline via imenu
;; navigation via xref, lsp-treemacs or lsp-ui
;; Debugger - dap-mode
;; helm
;; ivy
;; treemacs
;; semantic highlighting
;; which-key

;; sugestions from lsp-mode
;; set 100mb
(setq gc-cons-threshold 200000000)
(setq read-process-output-max (* 2048 1024)) ;; 2mb
;; (setq lsp-prefer-capf t)
(setq lsp-idle-delay 0.500)

(use-package! lsp-mode
  :commands lsp
  :hook
  ;; start in prog-mode
    (prog-mode . lsp)
  )

(use-package! lsp-ui
  ;;load-path "~/Dev/Emacs/lsp-ui"
  :commands lsp-ui-mode
  :config
  (setq
   lsp-ui-sideline-enable t
   lsp-ui-sideline-ignore-duplicate t
   lsp-ui-doc-header nil
   lsp-ui-doc-include-signature nil
   lsp-ui-doc-background (doom-color 'base4)
   lsp-ui-doc-border (doom-color 'fg)

   lsp-ui-peek-force-fontify nil
   lsp-ui-peek-expand-function (lambda (xs) (mapcar #'car xs)))
  ;; (custom-set-faces
  ;;  '(ccls-sem-global-variable-face ((t (:underline t :weight extra-bold))))
  ;;  '(lsp-face-highlight-read ((t (:background "sea green"))))
  ;;  '(lsp-face-highlight-write ((t (:background "brown4"))))
  ;;  '(lsp-ui-sideline-current-symbol ((t (:foreground "grey38" :box nil))))
  ;;  '(lsp-ui-sideline-symbol ((t (:foreground "grey30" :box nil)))))

  (map! :after lsp-ui-peek
        :map lsp-ui-peek-mode-map
        "h" #'lsp-ui-peek--select-prev-file
        "j" #'lsp-ui-peek--select-next
        "k" #'lsp-ui-peek--select-prev
        "l" #'lsp-ui-peek--select-next-file
        )
  )

(after! company
  (setq company-minimum-prefix-length 1
        company-quickhelp-delay nil
        company-show-numbers t
        company-global-modes '(not comint-mode erc-mode message-mode help-mode gud-mode)
        company-idle-delay 0.0
        ))

;; company backend for lsp-mode
(use-package! company-lsp
  :after lsp-mode
  :config
  (setq company-transformers nil
        company-lsp-cache-candidates 'auto
        company-lsp-enalbe-snippet t)
  (set-company-backend! 'lsp-mode 'company-lsp)
  )

(setq which-key-idle-delay 0)
