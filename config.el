;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
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

(load! "+func")
(load! "+bindings")
(load! "+looking")
(load! "+lsp")
(load! "+cc")

(setq doom-scratch-buffer-major-mode 'emacs-lisp-mode)

(set-lookup-handlers! 'emacs-lisp-mode :documentation #'helpful-at-point)

;; shell
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

;; comment
(use-package! evil-nerd-commenter
  :commands (evilnc-comment-or-uncomment-lines)
  )

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

;; isearch
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

(use-package! smartparens
  :config
  (setq sp-autoinsert-pair t
        sp-autodelete-pair t
        sp-escape-quotes-after-insert t)
  (setq-default sp-autoskip-closing-pair t)
  )

(set-popup-rules! '(
  ("^\\*helpful" :size 0.4)
  ("^\\*info.*" :size 80 :size right)
  ("^\\*Man.*" :size 80 :side right)
  ))

;; use rg
(use-package! rg)

(use-package! awesome-tab
  :config
  (awesome-tab-mode t)
  ;; show index
  (setq
     awesome-tab-show-tab-index t
        )
  )

;; search engine
(use-package! ivy
  :config
  (setq
   ;; use fuzzy finding
   ivy-re-builders-alist '((swiper . ivy--regex-plus)
                           (swiper-isearch . ivy--regex-plus)
                           (counsel-rg . ivy--regex-plus)
                           (t . ivy--regex-plus))
   )
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
