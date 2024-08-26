;; extends

(call_expression
  function: (selector_expression) @_id (#contains? @_id "Query")
  arguments: (argument_list 
			   (raw_string_literal) @sql (#offset! @sql 0 1 0 -1)))
