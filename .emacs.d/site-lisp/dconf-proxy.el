(defun refresh-proxy-settings ()
  (interactive)
  (if (string= (shell-command-to-string "dconf read /system/proxy/http/enabled") "true\n")
      (setq url-proxy-services
	    `(("http" .
	       ,(concat
		 (car (split-string-and-unquote ;; split string to remove single quotes and newline
		       (shell-command-to-string "dconf read /system/proxy/http/host") '"'"))
		 ":"
		 (car (split-string-and-unquote ;; split string to remove newline
		       (shell-command-to-string "dconf read /system/proxy/http/port") '"\n"))))))
    (setq url-proxy-services nil)))

(provide 'dconf-proxy)
