echo "Checking if tools are installed correctly..."
if [[ -z $(find /usr/local/bin/ -name "pmd.sh") ]]
then
	echo "pmd.sh is either is not in /usr/local/bin/ or is not named pmd.sh."
	exit -1
fi

if [[ -z $(find /usr/local/lib/ -name "pmd") ]]
then
	echo "PMD libraries not saved in /usr/local/lib/ in a directory called 'pmd'"
	exit -1
fi

if [[ -z $(find /usr/local/bin/ -name "cloc") ]]
then
	echo "Cloc is not installed in /usr/local/bin/"
	exit -1
fi

echo "Tools installed correctly."

echo "Installing Executable..."
cp project-analyzer.sh /usr/local/bin/project-analyzer.sh

if [[ -z $(find /usr/local/bin/ -name "project-analyzer.sh") ]]
then
	echo "Failed to save executable to /usr/local/bin/"
	exit -1
fi

echo "Executable Successfully Installed."

echo "Installing Resources..."

mkdir /usr/local/var/project-analyzer

if [[ -z $(find /usr/local/var/ -name "project-analyzer") ]]
then
	echo "Failed to create project-analyzer directory in /usr/local/var"
	exit -1
fi

mkdir /usr/local/var/project-analyzer/tmp

if [[ -z $(find /usr/local/var/project-analyzer -name "tmp") ]]
then
	echo "Failed to create tmp directory in /usr/local/var/project-analyzer"
	exit -1
fi

cp -a ./resources/. /usr/local/var/project-analyzer/resources/

if [[ -z $(find /usr/local/var/project-analyzer -name "resources") ]]
then
	echo "Failed to save resources to /usr/local/var/project-analyzer/"
	exit -1
fi

echo "Resources Successfully Installed."

echo "Done."


