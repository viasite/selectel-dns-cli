FROM ubuntu:16.10

RUN apt-get update -y && apt-get full-upgrade -y
RUN apt-get install -y bash-completion zsh curl cowsay git vim bsdmainutils

ADD selectel-dns /usr/bin/selectel-dns
ADD _selectel-dns /usr/local/share/zsh/site-functions/_selectel-dns
ADD selectel-dns.bash-completion /etc/bash-completion.d/selectel-dns


#
# Install oh-my-zsh
#
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true

#
# Enable bash completion
#
RUN echo '\n\
. /etc/bash_completion\n\
source /etc/bash-completion.d/selectel-dns\n\
' >> ~/.bashrc

#
# Setup prompt
#
RUN echo 'export PS1="[Selectel DNS API] \$ "' >> ~/.bashrc
RUN echo 'export PROMPT="[Selectel DNS API] \$ "' >> ~/.zshrc

#
# Setup a welcome message with basic instruction
#
RUN echo 'cat << EOF\n\
\n\
This Docker provides preconfigured environment for running the command\n\
line REST client for $(tput setaf 6)Selectel DNS API$(tput sgr0).\n\
\n\
For convenience, you can export the following environment variables:\n\
\n\
$(tput setaf 3)SELECTEL_API_URL$(tput sgr0) - server URL, e.g. https://example.com:8080\n\
$(tput setaf 3)SELECTEL_API_KEY$(tput sgr0) - access token, e.g. "ASDASHJDG63456asdASSD"\n\
\n\
$(tput setaf 7)Basic usage:$(tput sgr0)\n\
\n\
$(tput setaf 3)Print the list of operations available on the service$(tput sgr0)\n\
$ selectel-dns -h\n\
\n\
$(tput setaf 3)Print the service description$(tput sgr0)\n\
$ selectel-dns --about\n\
\n\
$(tput setaf 3)Print detailed information about specific operation$(tput sgr0)\n\
$ selectel-dns <operationId> -h\n\
\n\
By default you are logged into Zsh with full autocompletion for your REST API,\n\
but you can switch to Bash, where basic autocompletion is also supported.\n\
\n\
EOF\n\
' | tee -a ~/.bashrc ~/.zshrc

ENTRYPOINT ["zsh"]
