# $NetBSD: varname-dot-newline.mk,v 1.6 2023/01/26 20:48:18 sjg Exp $
#
# Tests for the special .newline variable, which contains a single newline
# character (U+000A).


# https://austingroupbugs.net/view.php?id=1549 proposes:
# > After all macro expansion is complete, when an escaped <newline> is
# > found in a command line in a makefile, the command line that is executed
# > shall contain the <backslash>, the <newline>, and the next line, except
# > that the first character of the next line shall not be included if it is
# > a <tab>.
#
# The above quote assumes that each resulting <newline> character has a "next
# line", but that's not how the .newline variable works.
BACKSLASH_NEWLINE:=	\${.newline}


# Check that .newline is read-only

NEWLINE:=	${.newline}

.newline=	overwritten

.if ${.newline} != ${NEWLINE}
.  error The .newline variable can be overwritten.  It should be read-only.
.endif

all:
	@echo 'first${.newline}second'
	@echo 'backslash newline: <${BACKSLASH_NEWLINE}>'
