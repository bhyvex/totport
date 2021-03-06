#!/usr/bin/env tsh

plan 58

# setup

echo $TOTPORT_TEST
    /y/ or die "please see t/README.mkd"

touch ~/.ssh/authorized_keys ~/totport.log ~/totport.rc
    ok

mkdir -p ~/keydir ~/validated_keys
    ok

rm -rf ~/.ssh/authorized_keys ~/totport.log ~/totport.rc ~/keydir ~/validated_keys
    ok

./totport
    !ok
    /rc file missing or doesn.t have what I want/

cp t/totport.rc.sample ~/totport.rc
    ok

./totport
    !ok
    /need command or user name/

tail -2 ~/totport.log
    ok
    /20..-..-..\...:..:.. \d+ FATAL: rc file missing or doesn.t have what I want/
    /20..-..-..\...:..:.. \d+ FATAL: need command or user name/

SSH_CONNECTION="1.2.3.4 4444 2.3.4.5 22" ./totport
    !ok
    /need command or user name/

tail -2 ~/totport.log
    ok
    /20..-..-..\...:..:.. \d+ SSH_CONNECTION 1.2.3.4 4444 2.3.4.5 22/
    /20..-..-..\...:..:.. \d+ FATAL: need command or user name/

SSH_ORIGINAL_COMMAND="1.2.3.4 4444 2.3.4.5 22" ./totport
    !ok
    /need command or user name/

tail -2 ~/totport.log
    ok
    /20..-..-..\...:..:.. \d+ SSH_ORIGINAL_COMMAND 1.2.3.4 4444 2.3.4.5 22/
    /20..-..-..\...:..:.. \d+ FATAL: need command or user name/

rm ~/totport.log
    ok

./totport rebuild
    ok

tail -1 ~/totport.log
    ok
    !/./

wc -c ~/.ssh/authorized_keys
    ok
    /0 /home/\w+/.ssh/authorized_keys/

cp t/keys/u?.pub ~/keydir
    ok

./totport rebuild
    ok

wc ~/.ssh/authorized_keys
    ok
    /   4   20 \d+ /home/\w+/.ssh/authorized_keys/

cut -c1-120 ~/.ssh/authorized_keys
    ok
    /command="/home/\w+/bin/totport u1",no-X11-forwarding,no-agent-forwarding,no-pty,permitopen="127.0.0.1:3536" ssh-rsa /
    /command="/home/\w+/bin/totport u2",no-X11-forwarding,no-agent-forwarding,no-pty,permitopen="127.0.0.1:3536" ssh-rsa /
    /command="/home/\w+/bin/totport u3",no-X11-forwarding,no-agent-forwarding,no-pty,permitopen="127.0.0.1:3536" ssh-rsa /
    /command="/home/\w+/bin/totport u4",no-X11-forwarding,no-agent-forwarding,no-pty,permitopen="127.0.0.1:3536" ssh-rsa /

./totport sita0
    ok
    /hello sita0,.*IP is not validated/

tail -5 ~/totport.log
    ok
    /20..-..-..\...:..:.. \d+ == ARGV ==: sita0/

./totport sita0 123
    !ok
    /hi sita0, you may use.../
    /user 'sita0' does not exist/
    /totp database out of sync with authkeys/

tail -5 ~/totport.log
    ok
    /20..-..-..\...:..:.. \d+ == ARGV ==: sita0 123/
    /20..-..-..\...:..:.. \d+ valid access user=sita0 validated-ip=123 from=/
    /20..-..-..\...:..:.. \d+ FATAL: totp database out of sync with authkeys/

./totport sita1
    ok
    /hello sita1,.*IP is not validated/

tail -5 ~/totport.log
    ok
    /20..-..-..\...:..:.. \d+ == ARGV ==: sita1/

./totport sita1 123
    ok
    /hi sita1, you may use.../

tail -5 ~/totport.log
    ok
    /20..-..-..\...:..:.. \d+ == ARGV ==: sita1 123/
    /20..-..-..\...:..:.. \d+ valid access user=sita1 validated-ip=123 from=/

