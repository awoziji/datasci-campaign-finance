## Dev Environment

Install pyenv virtual env
```
$ brew install pyenv-virtualenv
```

Add the following lines to your `~/.bash_profile` file
```
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi                                       
 if which pyenv-virtualenv-init > /dev/null; then
     eval "$(pyenv virtualenv-init -)";
fi
```

Install python
```
$ pyenv install 3.6.5
```

Create a new virtual environment and activate
```
pyenv virtualenv 3.6.5 campaign-finance
pyenv activate campaign-finance
```

Install python packages
```
pip install -r requirements.txt
```

Start jupyter notebook server
```
python3 -m jupyter notebook
```
