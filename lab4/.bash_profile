# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
unset USERNAME

export SPARK=/data/spark15
export SPARK_HOME=$SPARK
export PATH=$SPARK/bin:$PATH

