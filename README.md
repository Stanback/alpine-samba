# Samba 4 + Alpine Linux Docker Image

This repository contains a basic Dockerfile for installing Samba 4
on Alpine Linux.

This is a solution for network filesharing. I use it on my self-built,
zfs-based NAS server and connect up OSX, Linux, and Windows clients.

I was previously running Netatalk for Apple AFP support, however
I've found that Samba works reasonably well for me and it appears
that [Apple may start prefering Samba over AFP](http://appleinsider.com/articles/13/06/11/apple-shifts-from-afp-file-sharing-to-smb2-in-os-x-109-mavericks).

## Building

```
docker build \
  --rm=true \
  --tag=samba \
  .
```

## Create Samba Configuration

Create the `smb.conf` configuration file. The following is an example:

```
[global]
workgroup = WORKGROUP
server string = %h server (Samba, Alpine)
security = user
encrypt passwords = yes
printing = bsd
printcap name = /dev/null

[Dozer]
path = /dozer
comment = ZFS
browseable = yes
writable = yes
valid users = carol

[Shared]
path = /share
comment = Shared Folder
browseable = yes
read only = yes
write list = carol
guest ok = yes
```

## Running

Add/update the `-v` volumes below to match the shares defiend in your
`smb.conf` file and run:

```
docker run -dt \
  -v $PWD/smb.conf:/etc/samba/smb.conf \
  -v $PWD/dozer:/dozer \
  -v $PWD/share:/share \
  -p 137:137/udp \
  -p 138:138/udp \
  -p 139:139 \
  -p 445:445 \
  --name samba \
  --restart=always \
  samba
```

If you would like more debugging output, append `--debuglevel=5` to
the above command.

You can use `--net=host` instead of the `-p` port mappings if you want
to bypass Docker's proxy, however it's not necessary.

## Add Users

Once the server is running, you can add your users using the following:

```
docker exec -it samba adduser -s /sbin/nologin -h /home/samba -H -D carol
docker exec -it samba smbpasswd -a carol
```

