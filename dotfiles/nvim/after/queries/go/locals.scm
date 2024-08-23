;; extends

;; prepend x. to avoid duplicating bundled queries

(import_declaration 
  (import_spec_list 
	. (import_spec) @x.import.first (_) (import_spec) @x.import.last .) 
  @x.import.inner)

(function_declaration 
  result: (_) @x.returnargs)

(return_statement) @x.return
