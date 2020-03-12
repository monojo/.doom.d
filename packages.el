;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el
;; To install a package with Doom you must declare them here, run 'doom sync' on
;; the command line, then restart Emacs for the changes to take effect.
;; Alternatively, use M-x doom/reload.
;;

;; ==== Motion ====
;; char jump motion
(package! avy)

;; ==== LSP ====
;; set :tools spi will install lsp-ui, lsp-mode, company-lsp, lsp-ivy
;; set :lang (cc +lsp) install ccls, irony*(disabled), modern-cpp-font-lock
;;
;; installed through doom init.el lsp config
;; (package! lsp-mode :ignore t)
;; (package! lsp-treemacs :ignore t)
;; (package! lsp-ui :ignore t)
;; (package! company-lsp :ignore t)
;; cc client
;; (package! ccls :ignore t)
;; (package! modern-cpp-font-lock)
;;
(package! spinner)                      ; required by lsp-mode

;; ==== Finder ====
;; e-ctags using counsel, symbol search
(package! rg)
(package! counsel-etags)

;;==== Lang ===
;; formater based on clang-format
(package! clang-format)

;; ==== MISC ====
;; comment
(package! evil-nerd-commenter)
;; gen git linkage
(package! git-link)
;; symbol highlighting and more
(package! symbol-overlay)
;; Buffer tab, and num selection
(package! awesome-tab :recipe (:host github :repo "manateelazycat/awesome-tab"))
;; z jump to common
(package! eshell-autojump)
;; more complete evil binding
(package! evil-collection)
