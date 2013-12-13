codebox
======

## Useful shell tool-set for developer

### Support shell commands


**Major functions:**

<table>
    <tr>
        <td>allgrep</td>
        <td>Greps on all local files.</td>
    </tr>
    <tr>
        <td>cgrep</td>
        <td>Greps on all local C/C++ files.</td>
    </tr>
    <tr>
        <td>jgrep</td>
        <td>Greps on all local Java files.</td>
    </tr>
    <tr>
        <td>mgrep</td>
        <td>Greps on all local Makefiles.</td>
    </tr>
    <tr>
        <td>pygrep</td>
        <td>Greps on all local Python files.</td>
    </tr>
    <tr>
        <td>phpgrep</td>
        <td>Greps on all local PHP files.</td>
    </tr>
    <tr>
        <td>dgrep</td>
        <td>Greps on all local sub-directories.</td>
    </tr>
    <tr>
        <td>godir</td>
        <td>Go to the directory containing a file.</td>
    </tr>
    <tr>
        <td>croot</td>
        <td>Changes directory to the top of the tree.</td>
    </tr>
    <tr>
        <td>gettop</td>
        <td>Get the top folder in current settings.</td>
    </tr>
    <tr>
        <td>settop</td>
        <td>Set the top folder in current settings.</td>
    </tr>
    <tr>
        <td>cscopeGen</td>
        <td>Create cscope related files for your whole project. Please run this command at the top folder of project.</td>
    </tr>
    <tr>
        <td>help2</td>
        <td>Print this help menu.</td>
    </tr>
</table>

### How to use?

1. Add following command at the end of your ~/.bash_aliases or ~/.bashrc.

		source $your_dir/codebox.sh
2. If there is no ~/.bash_aliases in your environment, you may make a simple link directly.

		ln -sf $your_dir/codebox.sh ~/.bash_aliases
3. Include this tool manually. (Almost the same as method 1)

		source $your_dir/codebox.sh

### Git clone
git clone https://github.com/deren/codebox.git

### ZIP download
<https://github.com/deren/codebox/archive/master.zip>


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/deren/codebox/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

