#!/bin/bash
#
# Author : Deren Wu. 2013/Oct/31. (deren.g@gmail.com)
#
# Description : This program is collections for useful shell commands
########################################################


# There is a system-default "help" function. So, we choose "help2"
function help2() {
cat <<EOF

Invoke ". <this_script>" or "source <this_script>" from your shell to add the following functions to your environment:

Major functions:
- allgrep:      Greps on all local files.
- cgrep:        Greps on all local C/C++ files.
- jgrep:        Greps on all local Java files.
- mgrep:        Greps on all local Makefiles.
- pygrep:       Greps on all local Python files.
- phpgrep:      Greps on all local PHP files.
- dgrep:        Greps on all local sub-directories.
- godir:        Go to the directory containing a file.
- croot:        Changes directory to the top of the tree.
- gettop:       Get the top folder in current settings.
- settop:       Set the top folder in current settings.
- help2:        Print this menu.

Minor functions:
- search_project_top:   Auto-detect your project root by getting '.git'/'.svn'/'tags'/'cscope.out'.
- get_real_dir:         Convert relative path to absolute one.
- SymbolExport:         A simple wrapper for "export".

DW Old functions:
- dwgrep:       Be equal to "allgrep".
- dwfind:       Find files in sub-directories.
- dwdu:         Show the size of files/directories at current position.
EOF
}
function dwdu()
{
    echo "======== ${FUNCNAME[0]} start ========"
    echo ""
    du --max-depth=1 -hca .
    echo ""
    echo "======= ${FUNCNAME[0]} Finish! ======="
}
function dwgrep()
{
    echo "======== ${FUNCNAME[0]} start ========"
    echo ""
    allgrep $@
    echo ""
    echo "======= ${FUNCNAME[0]} Finish! ======="
}
function dwfind()
{
    echo "======== ${FUNCNAME[0]} start ========"
    echo ""
    find ./ -iname "*$1*" | grep -v "svn-base" | grep --color -i "$1"
    echo ""
    echo "======= ${FUNCNAME[0]} Finish! ======="
}
function SymbolExport()
{
	export $1="$2"
}

function allgrep()
{
	grep --color -n -i -r --exclude="*svn-base*" --exclude="*.d" --exclude="filelist" --exclude="tags" --exclude="cscope.*" --exclude-dir=".svn" "$1" * 2>/dev/null
}

function _GetDeaultGrepTemplate()
{
    local default1="find . -not \( -path */.git -prune \) -and -not \( -path */.svn -prune \) -and -not \( -path */.repo -prune \) -and -type f -not \( -name tags -o -name 'cscope.*' -o -name '*.diff' -o -name filelist  -o -name '*.d' \) -and "
    local default2=' -print0 | xargs -0 grep --color -n -i '
    echo $default1 $@ $default2
}
function pygrep()
{
    local target=" -type f \( -name '*.py' \)"
    local cmd=$(_GetDeaultGrepTemplate $target)
    eval $cmd \"$@\"
}
function phpgrep()
{
    local target=" -type f \( -name '*.php' \)"
    local cmd=$(_GetDeaultGrepTemplate $target)
    eval $cmd \"$@\"
}


function jgrep()
{
    local target=" -type f \( -name '*.java' \)"
    local cmd=$(_GetDeaultGrepTemplate $target)
    eval $cmd \"$@\"
}
function cgrep()
{
    local target=" -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' -and -name -not '*.d' \)"
    local cmd=$(_GetDeaultGrepTemplate $target)
    eval $cmd \"$@\"
}
function mgrep()
{
    local target=" -type f \( -iname makefile -o -iname 'makefile.*' -o -iname '*.mk' -o -iname '*.Kconfig' \)"
    local cmd=$(_GetDeaultGrepTemplate $target)
    eval $cmd \"$@\"
}
function dgrep()
{
	find . -name .repo -prune -o -name .git -prune -o -name .svn ! -prune -o -type d -iname *$@* | grep --color -n -i "$@"
}
function get_real_dir()
{
    return $(cd -P -- "$@" && pwd)
}
function search_project_top()
{
    dir_now=$PWD
    while :
    do
        if [ -e $dir_now'/.git' ] || [ -e $dir_now'/.svn' ] || [ -e $dir_now'/cscope.out' ] || [ -e $dir_now'/tags' ]; then
            #echo "$dir_now Found"
            echo "$dir_now"
            return
        fi
        dir_now=$dir_now'/..'
        dir_now=$(cd -P -- "$dir_now" && pwd)
        if [ "$dir_now" == "/" ];then
            #echo 'NotFound'
            return
        fi
    done
}
function gettop()
{
	if [ -n "$DW_PROJ_TOP_DIR" ]; then
		echo $DW_PROJ_TOP_DIR
	else
        local top=$(search_project_top)
        read -p "Is root at $top [Y/n]: " selection
        if [ "$selection" == "N" ] || [ "$selection" == "n" ]; then
            echo 'No root direcotory(You should "settop" first)'
        else
            SymbolExport DW_PROJ_TOP_DIR "$top"
            echo $top
        fi
	fi
}
function settop()
{
	if [[ -z "$1" ]]; then
		echo "Format : ${FUNCNAME[0]} <path>"
		return
	fi
	SymbolExport DW_PROJ_TOP_DIR "$1"
	echo "Top dir ==> $DW_PROJ_TOP_DIR"
}
function croot()
{
	cd $(gettop)
}


function godir () {
	if [[ -z "$1" ]]; then
		echo "Usage: godir <regex>"
		return
	fi
	T=$(gettop)
	if [[ ! -f $T/filelist ]]; then
		echo -n "Creating index..."
		(cd $T; find . -wholename ./out -prune -o -wholename ./.repo -prune -o -type f > filelist)
		echo " Done"
		echo ""
	fi
	local lines
	lines=($(grep "$1" $T/filelist | sed -e 's/\/[^/]*$//' | sort | uniq))
	if [[ ${#lines[@]} = 0 ]]; then
		echo "Not found"
		return
	fi
	local pathname
	local choice
	if [[ ${#lines[@]} > 1 ]]; then
		while [[ -z "$pathname" ]]; do
			local index=1
			local line
			for line in ${lines[@]}; do
				printf "%6s %s\n" "[$index]" $line
				index=$(($index + 1))
			done
			echo
			echo -n "Select one: "
			unset choice
			read choice
			if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
				echo "Invalid choice"
				continue
			fi
			pathname=${lines[$(($choice-1))]}
		done
	else
		pathname=${lines[0]}
	fi
	cd $T/$pathname
}