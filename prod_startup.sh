sudo ./script/server -d -e production
export PATH=$PATH:$HOME/bin:/var/lib/gems/1.8/bin
sudo ./script/backgroundrb -e production &