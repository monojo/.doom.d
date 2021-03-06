;;; ~/.doom.d/+looking.el -*- lexical-binding: t; -*-


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

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
