;;; build-site.el -*- lexical-binding: t; -*-
;;
;;
;;
;;
;;

(setq org-publish-project-alist

      `(("pages"
         :base-directory "./content/"
         :base-extension "org"
         :recursive t
         :publishing-directory "./html/"
         :publishing-function org-html-publish-to-html
         :html-head "<link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\"/>")



        ("static"
         :base-directory "./content/"
         :base-extension "css\\|txt\\|jpg\\|gif\\|png"
         :recursive t
         :html-head "<link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\"/>"
         :publishing-directory  "./html/"
         :publishing-function org-publish-attachment

         :html-doctype "html5"
         :html-html5-fancy t

         :html-head-include-scripts nil
         :html-head-include-default-style nil

         :author "M.")



        ("blog"
         :base-directory "./content/blog/"
         :base-extension "org"
         :publishing-directory "./html/blog/"
         :publishing-function org-html-publish-to-html
         :html-head "<link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\"/>"

         :html-doctype "html5"
         :html-html5-fancy t

         :html-head-include-scripts nil
         :html-head-include-default-style nil

         :auto-sitemap t
         :sitemap-title "Blog Posts"
         :sitemap-filename "index.org"
         :sitemap-sort-files anti-chronologically

         :html-preamble "<nav> <a href=\"/\">&lt; Home</a> </nav> <div id=\"updated\">Updated: %C</div>"
         :html-postamble "<hr/>
<footer>
  <div class=\"copyright-container\">
    <div class=\"copyright\">
      Copyright &copy; 2017-2020 Thomas Ingram some rights reserved<br/>
      Content is available under
      <a rel=\"license\" href=\"http://creativecommons.org/licenses/by-sa/4.0/\">
        CC-BY-SA 4.0
      </a> unless otherwise noted
    </div>
    <div class=\"cc-badge\">
      <a rel=\"license\" href=\"http://creativecommons.org/licenses/by-sa/4.0/\">
        <img alt=\"Creative Commons License\"
             src=\"https://i.creativecommons.org/l/by-sa/4.0/88x31.png\" />
      </a>
    </div>
  </div>

  <div class=\"generated\">
    Created with %c on <a href=\"https://www.gnu.org\">GNU</a>/<a href=\"https://www.kernel.org/\">Linux</a>
  </div>
</footer>"
         :author "M.")


        ("musings" :components ("pages" "blog" "static"))))

(org-publish "musings" t)

(message "Build complete")
