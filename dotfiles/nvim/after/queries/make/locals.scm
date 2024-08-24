;; extends

;; prepend x. to avoid duplicating bundled queries

; Match targets in Makefile, excluding builtints that start with a dot (e.g. .PHONY, etc)
(rule
  (targets . (word) @x.realtarget (#match? @x.realtarget "^[a-zA-Z]+")))
