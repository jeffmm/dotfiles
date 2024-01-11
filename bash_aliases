 
#Aliases
if [ "$(uname)" = "Darwin" ]; then
    alias ll="ls -l"
    alias la="ls -la"
else
    alias ls="ls --color"
    alias ll="ls -l --color"
    alias la="ls -la --color"
fi
alias glog="git log --pretty=format:'%C(yellow)%h %Cred%an %Cblue%ad %Cgreen%d %Creset%s' --date=relative --graph"
alias gb="git branch -v --sort=-committerdate"
alias tn="tail nohup.out"
alias vi="/usr/bin/vim"
alias vim="nvim"
alias octave="octave --no-gui-libs"
alias gst="git status"
alias dps='docker ps --format "table {{.Names}}\t{{.Ports}}"'
alias cdp="cd ~/Projects"
alias cdc="cd ~/capsule"
alias icat="kitty +kitten icat"

# Check if pypi-simple-search is installed
if $(command -v pip-pss &> /dev/null); then
    alias pip="pip-pss"
fi

export PYPI_SIMPLE_SEARCH="rg"

#Functions

# Command for setting up vim environment on ubuntu machines
copy_env_setup() {
    echo "apt update && apt install -y git python3-pip && \
        pip install rc4me && \
        rc4me apply jeffmm/dotfiles && \
        source ~/.bash_profile && \
        setup_vimrc" | pbcopy
}

# Open a browser an log in to AWS with SSO
alias sso='open https://manifold.awsapps.com/start#/'

# List running EC2 instances in your region
ec2-list() {
    aws ec2 describe-instances \
    --query "Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}"  \
    --filters "Name=instance-state-name,Values=running" \
    --output table
}

# List stopped EC2 instances in your region
ec2-list-stopped() {
    aws ec2 describe-instances \
    --query "Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}"  \
    --filters "Name=instance-state-name,Values=stopped" \
    --output table
}

# Port forwarding for ec2 instances with Jupyter containers, maps the Jupyter container 
# port to unmapped ports on local machine. Usage: ec2-port [INSTANCE-ID]
ec2-port() {
    PORTS=$(ssh ubuntu@$1 'docker ps --format "table {{.Names}}\t{{.Ports}}"' | awk \
        '/127.0.0.1/{print substr($2,11,5)}')
    echo $PORTS | while read line; do
        port=$line
        if [ ! $line ]; then
            echo "No Jupyter ports found on EC2 instance $1"
            return
        fi
        closed_ports=$(netstat -f inet | grep "localhost" | awk '{print substr($4,11,5)}')
        while [ $(echo $closed_ports | grep $port | tail -n 1) ]; do
            echo "Port $port is taken, trying the next one..."
            let port=$port+1
        done
        echo "Connecting to instance $1 at port $line"
        aws ssm start-session --target $1 \
            --document-name AWS-StartPortForwardingSession \
            --parameters "{\"portNumber\":[\"$line\"],\"localPortNumber\":[\"$port\"]}" &
        open http://localhost:$port
    done
}

# Stop an ec2 instance
ec2-stop() {
    aws ec2 stop-instances --instance-id $1
}

# Start an ec2 instance
ec2-start() {
    aws ec2 start-instances --instance-id $1
}

# Connect your local machine to the same VPC subnet at a remote machine
ec2-sshuttle() {
    sshuttle --remote ubuntu@$1 --auto-nets --dns 0/0
}

# ssh onto an ec2 instance
ec2-ssh() {
    ssh -A ubuntu@$1
}

# Change the default AWS region
aws-region() {
    export AWS_DEFAULT_REGION=$1
}

# After signing in with SSO, opt to get credentials for CLI access and select the second
# option to copy the text, then run this command in any terminal window to set up your 
# aws creds across all terminal instances
aws-cred() {
    export AWS_ACCESS_KEY_ID=
    export AWS_SECRET_ACCESS_KEY=
    export AWS_SESSION_TOKEN=
    echo "[default]" > ~/.aws/credentials
    pbpaste | tail -n 3 >> ~/.aws/credentials
}

make_toc_pdf() {
  pandoc -N --template=/Users/jeff/Notes/work_wiki/latex_template.tex --variable mainfont="Palatino" --variable sansfont="Helvetica" --variable monofont="Menlo" --variable fontsize=12pt --variable version=2.0 $1 --pdf-engine=xelatex --toc -o ${1%%.md}.pdf
}

# todo() {
  # if [ -n "$1" ]; then
    # echo "$* TODO" >> ~/Drive/Notes/todo-list.vnote;
  # fi
  # grep -rh -I --color 'TODO\|XXX' ~/Drive/Notes | awk '{print "  "++c".", "\033[1;31m" $0 "\033[0m"}';
# }

# dun() {
  # lines=`todo | wc -l`;
  # re='^[0-9]+$';
  # if ! [[ $1 =~ $re ]]; then
    # echo "error: todo line number required" >&2;
    # return;
  # fi
  # if ! [ $1 -ge 1 -a $1 -le $lines ]; then
    # echo "error: todo line number non-existent">&2;
    # return;
  # fi
  # line=`grep -rh -I --color 'TODO\|XXX' ~/Drive/Notes | head -n $1 | tail -n 1`;
  # file=`grep -rl -I "$line" ~/Drive/Notes`;
  # n=`grep -rn "$line" ~/Drive/Notes | cut -d : -f 2 | tail -n 1`;
  # if `echo "$line" | grep -q TODO`; then
    # sed -i '' "${n}s/TODO/DONE/" "$file";
  # else
    # sed -i '' "${n}s/XXX/DONE/" "$file";
  # fi
  # grep -rh -I --color 'TODO\|XXX' ~/Drive/Notes | awk '{print "  "++c".", "\033[1;31m" $0 "\033[0m"}'; 
# }

# seed() {
  # if [ -n "$1" ]
  # then
    # file=$1
  # elif [ -f "params.yaml" ]
  # then
    # file="params.yaml"
  # else
    # echo "No yaml file provided."
    # return
  # fi
  # n=`grep -rn seed $file | cut -d : -f 2 | tail -n 1`
  # oldseed=`grep -rn seed $file | cut -d : -f 4 | tail -n 1`
  # sed -i '' "${n}s/${oldseed}/ $RANDOM$RANDOM$RANDOM/" $file
# }

# make_movie FRAMERATE NUM_FRAMES_TO_USE_PER_FRAME RUN_NAME
make_movie() {
  ffmpeg -y -f image2 -framerate $1 -i $3%5d.png -vcodec libx264 -profile baseline -pix_fmt yuv420p -r $2 -q:v 0.8 $3.mov
}
make_movie_mp4_from_jpeg() {
  ffmpeg -y -f image2 -framerate $1 -i $3_%5d.jpg -vcodec h264 -profile baseline -pix_fmt yuv420p -r $2 -q:v 0.8 $3.mp4
}
make_movie_mp4() {
  ffmpeg -y -f image2 -framerate $1 -i $3_%5d.bmp -vcodec libx264 -profile baseline -pix_fmt yuv420p -r $2 -q:v 0.8 $3.mp4
}
make_reload_movie() {
  ffmpeg -y -f image2 -framerate $1 -i $3_reload%*.bmp -vcodec libx264 -profile baseline -pix_fmt yuv420p -r $2 -q:v 0.8 $3.mov

}

edit()
{
    open -a TextEdit $1
}

google() {
    search=""
    echo "Googling: $@"
    for term in $@; do
        search="$search%20$term"
    done
    open http://www.google.com/search?q=$search
}

scholar() {
    search=""
    echo "Schoogling: $@"
    for term in $@; do
	search="$search%20$term"
    done
    open http://scholar.google.com/scholar?q=$search
}


man() {
  env LESS_TERMCAP_mb=$'\E[01;31m' \
  LESS_TERMCAP_md=$'\E[01;38;5;74m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_so=$'\E[38;5;246m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[04;38;5;146m' \
  man "$@"
}

perlpie() {
  perl -pi -e "s/$1/$2/g" $3
}

dm-up() {
  docker-machine start default;
  eval $(docker-machine env default);
}

dm-stop() {
  docker-machine stop default;
}
# syntax: reduce_movie [reduce_factor] [input_file] [output_file]
# reduce_factor is 0 and 50 with 0 being perfectly lossless, 50 being worst quality
# 24 is default, 17 is pretty much lossless, 32 is a sane quality reduction
reduce_movie() {
  ffmpeg -i $2 -c:v libx264 -crf $1 -b:v 1M $3
}

cm() {
  if [ -e build ]
  then
    rm -rf build
  fi
  mkdir build
  cd build
  cmake ..
}

dexec() {
    docker exec -it `docker ps -f "name=executer" --format "{{.ID}}"` bash
}

setup_vimrc() {
    installpip() {
      echo "Installing pip..."
      if [ "$(uname)" = "Darwin" ]; then
          brew install python@3.8 > /dev/null
      elif [ "$(uname -a | grep -c Linux)" -eq 1 ]; then
          apt update > /dev/null
          apt install -y python3-pip > /dev/null
      fi
    }
    installpippackages() {
      echo "Installing pip packages..."
      pip3 install black isort mypy flake8 ranger-fm > /dev/null
    }
    installnode() {
      echo "Installing node..."
      if [ "$(uname)" = "Darwin" ]; then
          brew install lua npm yarn > /dev/null
      elif [  "$(uname -a | grep -c Linux)" -eq 1 ]; then
          apt update > /dev/null
          # Need latest node version
          curl -fsSL https://deb.nodesource.com/setup_current.x | bash - > /dev/null
          apt install -y nodejs > /dev/null
      fi
    }
    installvim() {
      echo "Installing vim version >=8.1..."
      if [ "$(uname)" = "Darwin" ]; then
          brew install vim > /dev/null
      elif [ "$(uname -a | grep -c Linux)" -eq 1 ]; then
          apt update > /dev/null
          apt install -y vim > /dev/null
      fi
      return 0
    }
    installpackages() {
        if [ "$(uname)" = "Darwin" ]; then
            # Don't reinstall curl on Mac
            brew install git ripgrep fzf > /dev/null
        elif [  "$(uname -a | grep -c Linux)" -eq 1 ]; then
            apt update > /dev/null
            apt install -y git curl ripgrep fzf > /dev/null
        fi
    }


    # Welcome
    echo 'Installing vim development environment'

    [ "$(uname)" = "Darwin" ] || [ "$(uname -a | grep -c Linux)" -eq 1 ] || (echo  "Distribution not currently supported." && return 1)

    [ "$(uname)" = "Darwin" ] && ! $(command -v brew &> /dev/null) && echo "macOS requires Homebrew to install dev environment." && return 1

    # install pip
    if $(command -v pip3 &> /dev/null); then
        echo "pip detected, moving on..."
    else
        installpip
    fi

    # Standardize python binary location
    if $(command -v python3 &> /dev/null) && [ ! -f /usr/local/bin/python ]; then
        ln -s $(command -v python3) /usr/local/bin/python
    fi

    if $(command -v git &> /dev/null) && $(command -v curl &> /dev/null) && $(command -v rg &> /dev/null) && $(command -v fzf &> /dev/null); then
        echo "git, curl, ripgrep, and fzf detected, moving on..."
    else
        installpackages
    fi
    installpippackages

    # install node
    if $(command -v node &> /dev/null); then
        if [ $(node --version | grep -cE "v1[3-9]|v2[0-9]") -eq 1 ]; then
            echo "node detected, moving on..."
        elif [ "$(uname -a | grep -c Linux)" -eq 1 ]; then
            apt remove -y nodejs > /dev/null
            installnode
        elif [ "$(uname)" = "Darwin" ]; then
            brew reinstall npm > /dev/null
        fi
    else
        installnode
    fi

    # install vim
    if $(command -v vim &> /dev/null); then
        # Check vim version
        if [ $(vim --version | head -n 1 | grep -cE "IMproved 8.[1-9]") -eq 1 ]; then
            echo "vim version >=8.1 detected, moving on..."
        else
            installvim
        fi
    else
        installvim
    fi

    npm install coc-explorer coc-snippets coc-json \
             --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
    vim -E -s -u ~/.vimrc +PlugInstall +qall
    echo "Environment setup complete."
}

export VENV_HOME="$HOME/.virtualenvs"
[[ -d $VENV_HOME ]] || mkdir $VENV_HOME

# $ lsvenv              # list virtual envs
lsvenv() {
  ls -1 $VENV_HOME
}

# $ venv myvirtualenv   # activates venv
venv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      source "$VENV_HOME/$1/bin/activate"
  fi
}

# $ mkvenv myvirtualenv # creates venv under ~/.virtualenvs/
mkvenv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      python3 -m venv $VENV_HOME/$1
  fi
}

# $ rmvenv myvirtualenv # removes venv
rmvenv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      rm -r $VENV_HOME/$1
  fi
}
