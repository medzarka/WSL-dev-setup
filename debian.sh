
TIME_ZONE=Asia/Riyadh
USER_NAME=abc
USER_PASSWORD=abc
GID=1000
UID=1000

PYENV_PYTHON_VERSION=3.11
JAVA_VERSION=21-graal

###########################################################
# install required packages
sudo apt update
sudo apt upgrade -y
sudo apt install -y --no-install-recommends   \
  htop wget ca-certificates curl llvm net-tools iputils-ping nano openssh-server less sudo gpg \
  make git build-essential locales locales-all kmod file bash-completion tzdata gettext clang \
  postgresql-client postgresql-common libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
  libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev mecab-ipadic-utf8 \
  jq libatomic1 python3-dev python3-setuptools libtiff5-dev libjpeg-dev libopenjp2-7-dev zlib1g-dev \
  libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python3-tk \
  libharfbuzz-dev libfribidi-dev libxcb1-dev default-libmysqlclient-dev 


###########################################################
# create the user
if id -u "$USER_NAME" >/dev/null 2>&1; then
  echo "user exists"
else
  echo "Create the user $USER_NAME ..."
  groupadd -f -g $GID $USER_NAME
  useradd -m -u $UID -g $GID -s /bin/bash $USER_NAME
fi
echo "Add the user $USER_NAME to the sudo group..."
usermod -aG sudo $USER_NAME
echo "Update the user password..."
echo "$USER_NAME:$USER_PASSWORD" | chpasswd
#su "$USER_NAME"

###########################################################
# install C/C++ compilers
sudo apt install -y --no-install-recommends g++ gdb gcc

###########################################################
# install octave environment
sudo apt install -y --no-install-recommends octave octave-image octave-signal octave-audio octave-common

###########################################################
# install rust compiler
sudo apt install -y --no-install-recommends rustc

###########################################################
# install Java JDK using sdkman
sudo apt install zip curl
curl -s "https://get.sdkman.io" | bash
source "/home/$USER_NAME/.sdkman/bin/sdkman-init.sh"
sdk version
sdk list
sdk list java
sdk install java $JAVA_VERSION
sdk use java $JAVA_VERSION
sdk default java $JAVA_VERSION
#sdk uninstall java $JAVA_VERSION

###########################################################
# install Python using pyenv
curl https://pyenv.run | bash 

# configure pyenv
echo "Update .bashrc file for $USER_NAME user (pyenv section)"
export PYENV_ROOT=/home/$USER_NAME/.pyenv
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
bashrc_file="/home/$USER_NAME/.bashrc"
grep -qF -- "export PYENV_ROOT=/home/$USER_NAME/.pyenv" $bashrc_file || echo "export PYENV_ROOT=/home/$USER_NAME/.pyenv" >> $bashrc_file
grep -qF -- "export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH" $bashrc_file || echo "PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH" >> $bashrc_file
grep -qF -- 'eval "$(pyenv init -)"' $bashrc_file || echo 'eval "$(pyenv init -)"' >> $bashrc_file
grep -qF -- 'eval "$(pyenv virtualenv-init -)"' $bashrc_file || echo 'eval "$(pyenv virtualenv-init -)"' >> $bashrc_file

# install python versions
pyenv update 
pyenv install 3.12
pyenv global 3.12
pyenv rehash
pip install --upgrade pip
pip install --upgrade wheel
### create machine learning virtual env
#pyenv virtualenv 3.11 ml
#pyenv activate ml
#pip install -r ml_requirements.txt 
#pyenv virtualenv-delete <name>
#pip cache purge


