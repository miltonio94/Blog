;;; build-site.el -*- lexical-binding: t; -*-
;;
;; This was heavilly inpired by Thomas Igram's blog
;; located in his github https://github.com/taingra/blog
;; Thomas, if you ever see this, thank you for your blog post and for making your code available to see
;;

(require 'package)
;; Set package dir
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

(require 'org)
(require 'ox-publish)
(require 'htmlize)



(file-name-directory
 (or load-file-name
     default-directory))


(setq org-export-with-section-numbers nil
      org-export-with-toc t

      ;; Date formate
      org-export-date-timestamp-format "%d-%m-%Y"
      org-html-metadata-timestamp-format "%d-%m-%Y"

      ;; HTML5
      org-html-html5-fancy t
      org-html-doctype "html5"

      ;; Disable some defaults
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil

      org-html-htmlize-output-type 'css)

(setq org-export-global-macros
      '(("timestamp" . "@@html:<span class='timestamp'>[$1]</span>@@")))

(add-to-list 'org-html-text-markup-alist '(code . "<kbd>%s<kbd>"))

(defvar m--head
  "<link rel='stylesheet' href='style.css' type='text/css'/>")

(defvar m--preamble
  "<div id='updated-on'>Updated: %C</div>")

(defvar m--footer
  "<footer><div class='generated'> Created with %c on <a href='https://www.gnu.org'>GNU</a>/<a href='https://www.kernel.org/'>Linux</a>
</div>
</footer>")

(defvar m--base-dir
  (concat
   (if (null load-file-name)
       (expand-file-name default-directory)
     (file-name-directory load-file-name))
   "content/")
  "The `:base-directory' for m")

(defvar m--publish-dir
  (concat
   (if (null load-file-name)
       (expand-file-name default-directory)
     (file-name-directory load-file-name))
   "html/")
  "The `:publishing-directory' for m-preview")

(defvar m--preview-dir
  (concat
   (if (null load-file-name)
       (expand-file-name default-directory)
     (file-name-directory load-file-name))
   "html/")
  "The `:publishing-directory' for m-preview")

(defun m--sitemap-dated-entry-format (entry style project)
  "Sitemap entry stule format"
  (let ((fileman (org-publish-find-title entry project)))
    (if (= (length fileman) 0)
        (format "*%s*" entry)
      (format "{{{timestamp(%s}}} [[file:%s][%s]]"
              (format-time-string "%d-%m-%Y"
                                  (org-publish-find-date entry project))
              entry
              filename))))



(setq org-publish-project-alist

      `(("index"
         :base-directory ,m--base-dir
         :base-extension "org"
         :exclude "."
         :include ("index.org")
         :publishing-directory ,m--publish-dir
         :publishing-function org-html-publish-to-html

         :html-head ,m--head
         :html-preamble ,m--preamble
         :html-postamble ,m--footer)

        ("pages"
         :base-directory ,m--base-dir
         :base-extension "org"
         :exclude ,(regexp-opt '("index.org" ".*-draft\.org" "drafts/" "blog/"))

         :html-link-home ""
         :html-link-up ""
         :html-home/up-format "<div id='org-div-home-and-up'><a href='%s'>Home</a></div>"

         :recursive t
         :publishing-directory ,m--publish-dir
         :publishing-function org-html-publish-to-html

         :html-head ,m--head
         :html-preamble ,m--preamble
         :html-postamble ,m--footer)

        ("static"
         :base-directory ,m--base-dir
         :base-extension "css\\|txt\\|jpg\\|gif\\|png"
         :recursive nil
         :publishing-directory ,m--publish-dir
         :publishing-function org-publish-attachment

         :html-doctype "html5"
         :html-html5-fancy t

         :html-head-include-scripts nil
         :html-head-include-default-style nil

         :author "M.")

        ("blog"
         :base-directory ,(concat m--base-dir "blog/")

         :base-extension "org"
         :exclude ".*-draft\.org"
         :publishing-directory ,(concat m--publish-dir "blog/")
         :publishing-function org-html-publish-to-html

         :html-link-home ""
         :html-link-up ""
         :html-home/up-format "<div id='org-div-home-and-up'><a href='%s'>Home</a></div>"


         :html-doctype "html5"
         :html-html5-fancy t

         :html-head-include-scripts nil
         :html-head-include-default-style nil

         :auto-sitemap t
         :sitemap-title "Blog Posts"
         :sitemap-filename "index.org"
         :sitemap-sort-files anti-chronologically
         :sitemap-format-entry m--sitemap-dated-entry-format

         :html-head ,m--head
         :html-preamble ,m--preamble
         :html-postamble ,m--footer
         :author "M.")

        ("blog-files"
         :base-directory ,(concat m--base-dir "blog/files/")
         :base-extension "jpg\\|gif\\|png\\|jpeg"
         :recurse nil
         :publishing-directory ,(concat m--publish-dir "blog/files/")
         :publishing-function org-publish-attachment)

        ("musings" :components ("index" "pages" "blog" "blog-files" "static"))))

(org-publish "musings" t)

(message "Build complete")
