# bash_scripts4URLhaus

This is my toolset of Bash scripts for collecting and sending Gafgyt/Mirai samples/URLs to the site URLhas.abuse.ch
I hope you Won't use it (:

# Don't forget add YOUR-API-KEY in urlhaus.py file

Find your key -> https://urlhaus.abuse.ch/api/

Also, for logging, specify the path to the directory with log files in this section:
```
#Logs path
log_path="...urlhaus_logs..." <- EDIT THIS 
```

![example](https://i.ibb.co/QbDPT51/carbon2.png)
![urlhaus](https://i.ibb.co/2vNzW8C/Screenshot-2021-12-25-URLhaus-Tag-gafgyt.png)

```console
$ ./get_fls_ftp.sh

================================================================
Usage: ./get_fls_ftp.sh [ -h | --help ]
       ./get_fls_ftp.sh <address>:<port> -- Specify the HTTP-server port: <address>:8080

================================================================

$ ./get_fls_http.sh

================================================================
Usage: ./get_fls_http.sh [ -h | --help ]
       ./get_fls_http.sh <address>:<port> -- Specify the HTTP-server port: <address>:8080

================================================================

$ ./send_ftp_v0.4.sh

================================================================
Usage: ./send_ftp_v0.4.sh [ -h | --help ]
       ./send_ftp_v0.4.sh <address>/shellscript_name.sh -- Enter address HTTP-server : 144.233.0.1 AND shellscript path - e.g bins.sh
       ./send_ftp_v0.4.sh <address>:<port> -- Specify the HTTP-server port: <address>:8080
       ./send_ftp_v0.4.sh <address> -t tag -- Default tag: 'gafgyt'
       ./send_ftp_v0.4.sh <address> -t tag -- Default tag: 'gafgyt'  -p path

================================================================

$ ./send_http_v0.4.sh

================================================================
Usage: ./send_http_v0.4.sh [ -h | --help ]
       ./send_http_v0.4.sh <address>/shellscript_name.sh -- Enter address HTTP-server : 144.233.0.1 AND shellscript path - e.g bins.sh
       ./send_http_v0.4.sh <address>:<port> -- Specify the HTTP-server port: <address>:8080
       ./send_http_v0.4.sh <address> -t tag -- Default tag: 'mirai'

================================================================

$ ./send_gafgyt_v0.4.sh

================================================================
Usage: ./send_gafgyt_v0.4.sh [ -h | --help ]
       ./send_gafgyt_v0.4.sh <address>/shellscript_name.sh -- Enter address HTTP-server : 144.233.0.1 AND shellscript path - e.g bins.sh
       ./send_gafgyt_v0.4.sh <address>:<port>-- Specify the HTTP-server port: <address>:8080
       ./send_gafgyt_v0.4.sh <address> -t tag -- Default tag: 'gafgyt'
       ./send_gafgyt_v0.4.sh <address> -w  -- Set http type for shellscript

================================================================

$ ./send_hajime.sh

================================================================
Send URL to URLhaus. Hajime & Mozi Edition
Usage: ./send_hajime.sh <address> [ -h | --help ] -- Specify the HTTP-server address: http://192.168.10.16/
       ./send_hajime.sh <address>/[:<port>/] -- Specify the HTTP-server <address>:port:  http://192.168.10.16:8080/
       ./send_hajime.sh <address>/ -t tag -- Specify the Tag: http://192.168.10.16/ -t Hajime
       ./send_hajime.sh <address>/ -n filename -- Specify the name for URLhaus: http://192.168.10.16/ -n Hajime

================================================================

$ ./get_fls_shellscript_v0.1.sh

================================================================
Usage: ./get_fls_shellscript_v0.1.sh [ -h | --help ]
       Download all the samples using the URL-links from the shellscript file
       ./get_fls_shellscript_v0.1.sh <address>/shellscript_name.sh -- Enter address HTTP-server : 144.233.0.1 AND shellscript path - e.g bins.sh
       ./get_fls_shellscript_v0.1.sh <address>:<port>-- Specify the HTTP-server port: <address>:8080
       ./get_fls_shellscript_v0.1.sh <address> -w  -- Set http type for shellscript

================================================================
```

# Inspired by
This toolset uses a script **urlhaus.py** by @cocaman -- https://github.com/cocaman/urlhaus
