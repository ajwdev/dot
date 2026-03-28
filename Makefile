# Delegates to Rakefile
RAKE_WARN = @echo "WARNING: Makefile is deprecated, use rake directly" >&2

switch:
	$(RAKE_WARN)
	rake switch

test:
	$(RAKE_WARN)
	rake test

build-live:
	$(RAKE_WARN)
	rake build_live

fmt:
	$(RAKE_WARN)
	rake fmt

check:
	$(RAKE_WARN)
	rake check
