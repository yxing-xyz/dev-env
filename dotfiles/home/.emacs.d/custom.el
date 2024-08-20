;;; custom.el --- user customization file    -*- lexical-binding: t no-byte-compile: t -*-
;;; Code:

;; (setq debug-on-error t)

(setq xx-package-archives 'nju)
;; (setq xx-package-archives 'melpa)
(setq xx-full-name "shawnyyu")
(setq xx-mail-address "yxing.xyz@gmail.com")
(setq xx-server nil)
(setq xx-doom-theme 'doom-dracula)
(setq xx-tree-sitter t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(cursor-type 'box)
 '(custom-safe-themes
   '("aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "2721b06afaf1769ef63f942bf3e977f208f517b187f2526f0e57c1bd4a000350" "691d671429fa6c6d73098fc6ff05d4a14a323ea0a18787daeb93fde0e48ab18b" "e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" "4ade6b630ba8cbab10703b27fd05bb43aaf8a3e5ba8c2dc1ea4a2de5f8d45882" "dccf4a8f1aaf5f24d2ab63af1aa75fd9d535c83377f8e26380162e888be0c6a9" "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19" "014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69" "a9eeab09d61fef94084a95f82557e147d9630fbbb82a837f971f83e66e21e5ad" "8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "944d52450c57b7cbba08f9b3d08095eb7a5541b0ecfb3a0a9ecd4a18f3c28948" default))
 '(desktop-save t)
 '(magit-todos-insert-after '(bottom) nil nil "Changed by setter of obsolete option `magit-todos-insert-at'")
 '(menu-bar-mode nil)
 '(mouse-wheel-mode t)
 '(package-selected-packages
   '(link-hint sideline-flymake yasnippet-capf multi-vterm vterm js2-mode go-mode lsp-mode wgrep xterm-color treemacs ace-window hl-todo prescient company counsel multiple-cursors expand-region avy lsp-treemacs ztree youdao-dictionary yasnippet-snippets which-key web-mode vimrc-mode v-mode undo-tree typescript-mode treemacs-persp treemacs-nerd-icons treemacs-magit tldr symbol-overlay swift-mode sudo-edit solaire-mode smart-region skewer-mode scss-mode scala-mode rustic rust-playground rmsbolt rg restclient rainbow-mode rainbow-delimiters quickrun protobuf-mode pretty-hydra popper pomidor plantuml-mode php-mode paradox pager page-break-lines overseer nerd-icons-ivy-rich nerd-icons-ibuffer nerd-icons-dired mwim mocha mixed-pitch minions mermaid-mode memory-usage magit-todos macrostep lua-mode lsp-ui lsp-sourcekit lsp-pyright lsp-julia lsp-java lsp-ivy list-environment ivy-yasnippet ivy-hydra ivy-dired-history ivy-avy iscroll iedit ibuffer-project ialign hungry-delete highlight-indent-guides highlight-defined hide-mode-line helpful haml-mode groovy-mode goto-line-preview goto-chg goto-char-preview goggles go-translate go-tag go-playground go-impl go-gen-test go-fill-struct go-dlv gnu-elpa-keyring-update git-timemachine git-modes git-messenger gcmh forge flymake-diagnostic-at-point fish-mode fd-dired fanyi fancy-narrow eshell-z eshell-prompt-extras esh-help emacsql-sqlite-builtin editorconfig easy-kill dumb-jump drag-stuff doom-themes doom-modeline disk-usage diredfl dired-rsync dired-quick-sort dired-git-info diminish diff-hl devdocs default-text-scale dart-mode daemons csv-mode counsel-world-clock counsel-tramp company-prescient company-box coffee-mode cmake-mode citre ccls cask-mode cal-china-x browse-kill-ring browse-at-remote bmx-mode beginend avy-zap anzu amx add-node-modules-path ace-pinyin ace-link))
 '(scroll-bar-mode nil)
 '(vc-follow-symlinks t)
 '(warning-suppress-log-types '((magit-todos))))

(defun xx-setup-fonts ()
  "Setup fonts."
  (when (display-graphic-p)
    (cond (sys/macp (progn
                      ;;
                      (setq nerd-icons-font-family "CodeNewRoman Nerd Font Propo")
                      ;;(setq nerd-icons-font-family "Symbols Nerd Font Mono")
                      ;; (setq nerd-icons-scale-factor 0.5)
                      ;; Set default font
                      (cl-loop for font in '("CodeNewRoman Nerd Font Propo")
                               when (font-installed-p font)
                               return (set-face-attribute 'default nil
                                                          :family font
                                                          :weight 'regular
                                                          :height 140))
                      ;; Specify font for Chinese characters
                      (cl-loop for font in '("WenQuanYi Micro Hei")
                               when (font-installed-p font)
                               return (progn
                                        (setq face-font-rescale-alist `((,font . 1.15)))
                                        (set-fontset-font t 'han (font-spec :family font))
                                        ))
                      ))
          (sys/linuxp (progn
                        (setq nerd-icons-font-family "CodeNewRoman Nerd Font")
                        ;; Set default font
                        (cl-loop for font in '("CodeNewRoman Nerd Font")
                                 when (font-installed-p font)
                                 return (set-face-attribute 'default nil
                                                            :family font
                                                            :weight 'regular
                                                            :height 120))
                        ;; Specify font for Chinese characters
                        (cl-loop for font in '("WenQuanYi Micro Hei")
                                 when (font-installed-p font)
                                 return (progn
                                          (setq face-font-rescale-alist `((,font . 1.18)))
                                          (set-fontset-font t 'han (font-spec :family font))
                                          )))))))

(xx-setup-fonts)
(add-hook 'window-setup-hook #'xx-setup-fonts)
(add-hook 'server-after-make-frame-hook #'xx-setup-fonts)

;;你好aaa你ac
;;abcdaaaabad
;; | 一个普通标题     | 一个普通标题 | 一个普通标题     |
;; | ---------------- | ------------ | ---------------- |
;; | 短文本           | 中等文本     | 稍微长一点的文本 |
;; | 稍微长一点的文本 | 短文本       | 中等文本         |

;;; custom.el ends here
