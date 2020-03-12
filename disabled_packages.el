;;; ~/.doom.d/disabled_packages.el -*- lexical-binding: t; -*-

;;;; Disabled packages
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
(package! hl-line :disable t)
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
