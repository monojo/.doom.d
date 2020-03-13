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
;; installed through doom init.el :tools lsp
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

;;;; ==== Disabled packages ====
;; cmake-mode provides hl for CMakeLists.txt and .cmake
;; irony is libclang based cc helper
;; flycheck is syntax checking tool
;; rtags is clang based indexer
;; demangle-mode help demangle cc symbols
;; disaster disamble code under cursor
;; glsl-mode for opengl shading language
;; These packages will be installed automatically by setting :lang cc
(disable-packages! cmake-mode company-irony company-irony-c-headers flycheck-irony
                   irony irony-eldoc ivy-rtags rtags cuda-mode
                   demangle-mode disaster opencl-mode glsl-mode company-glsl
                   helm-rtags company-prescient)
;; edit chrome text in emacs
(package! atomic-chrome :disable t)
;; highlight current line, but does not work well with hl-symbol
;;(package! hl-line :disable t)
;; a lsp client
(package! eglot :disable t)
;; lisp evil plug
(package! lispyville :disable t)
;; another man
(package! tldr :disable t)
;; d lang
(package! d-mode :disable t)
;; buffer selection tool
(package! frog-jump-buffer :disable)
;; open link avy
(package! link-hint :disable t)
;; convert buffer content to html
(package! htmlize :disable t)
;; motion based on syntax
(package! smart-forward :disable t)
;; hl current word through buffer
(package! highlight-symbol :disable t)
;; try a package
(package! try :disable t)
;; llvm source code support
(package! llvm-mode :disable t)
(package! tablegen-mode :disable t)
