;;; build-site.el -*- lexical-binding: t; -*-
(require 'ox-publish)


(setq org-publish-project-alist
      `(("pages"
         :base-directory "./content/"
         :base-extension "org"
         :recursive t
         :publishing-directory "./html/"
         :publishing-function org-html-publish-to-html)

        ("static"
         :base-directory "./content/"
         :base-extension "css\\|txt\\|jpg\\|gif\\|png"
         :recursive t
         :publishing-directory  "./html/"
         :publishing-function org-publish-attachment)

        ("musings" :components ("pages" "static"))))

(org-publish "musings")

(message "Build complete")
