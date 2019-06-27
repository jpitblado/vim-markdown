#!/bin/bash
# m2h.sh

self=`basename $0`

usage () {
	cat <<EOF
usage: $self <file>[.markdown]

Use pandoc to convert <file>.markdown to <file>.html

EOF
	exit 1
}

if ! which pandoc >& /dev/null
then
	echo "$self requires pandoc, but pandoc not found"
	exit 1
fi

if [ $# -eq 0 ]
then
	usage
fi

unset style
style=`	find . -maxdepth 1 -name "*.css" |
	xargs --no-run-if-empty -L 1 basename |
	xargs -I FILE echo "-css=FILE" |
	xargs echo`
if [ -z "$style" ]
then
	homedir=`dirname $0`
	if [ -f "$homedir/style.html" ]
	then
		style="--include-in-header=\"${homedir}/style.html\""
	fi
fi

EchoRun () {
	echo "==> ${*}"
	eval "${*}"
}

for f in "${@}"
do
	base=${f%%.*}
	if [ -f "${base}.markdown" ]
	then
		infile="${base}.markdown"
	elif [ -f "${base}.md" ]
	then
		infile="${base}.md"
	else
		infile="${f}"
	fi
	outfile="${base}.html"
	if head -n1 "${infile}" | grep --quiet "^#"
	then
		pagetitle="`head -n1 "${infile}" | sed -e 's/^# //'`"
	else
		pagetitle="${base}"
	fi
	if [ -f ${infile} ]
	then
		EchoRun						\
		pandoc	--standalone				\
			--metadata pagetitle="${pagetitle}"	\
			"${style}"				\
			--from markdown				\
			--to html				\
			--output="${outfile}"			\
			"${infile}"
	fi
done

# end: m2h.sh
