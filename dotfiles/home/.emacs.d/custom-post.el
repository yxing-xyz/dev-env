;; 关闭自动换行
(set-default 'truncate-lines t)
;; hide line-truncation symbols in terminal
(set-display-table-slot standard-display-table 0 ?\ )
;; 禁止闪烁光标
(blink-cursor-mode nil)
;; 光标实心
(setq-default cursor-type 'box)

;; 设置mode-line显示路径风格
(setq doom-modeline-buffer-file-name-style 'relative-from-project)
;; key重定向
;; (define-key key-translation-map (kbd "M-\\") (kbd "M-g w"))
;; (define-key prog-mode-map (kbd "M-RET") (key-binding (kbd "M-g w")))
(add-hook 'ace-pinyin-mode-hook (lambda () (progn
                                        (local-set-key (kbd "M-RET") (key-binding (kbd "C-:")))
                                        )))
(add-hook 'prog-mode-hook (lambda () (progn
                                  (local-set-key (kbd "C-c @ `") 'hideshow-hydra/body)
                                  )))

;; 恢复会话
(desktop-read)
