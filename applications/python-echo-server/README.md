# Python Echo Server

A simple echo server built with Flask.

## Requirements
```
1. Python 3
2. see requirements.txt
```

## Example
```sh
❯ python applications/python-echo-server/main.py
INFO:waitress:Serving on http://0.0.0.0:8080
127.0.0.1 - - [19/Jun/2024:17:30:54 -0400] "GET /echo/ HTTP/1.1" 200 265 "-" "curl/8.6.0"
127.0.0.1 - - [19/Jun/2024:17:30:55 -0400] "GET /echo HTTP/1.1" 200 264 "-" "curl/8.6.0"
```

```sh
❯ curl -i http://127.0.0.1:8080/echo
HTTP/1.1 200 OK
Content-Length: 264
Content-Type: text/html; charset=utf-8
Date: Wed, 19 Jun 2024 21:30:55 GMT
Server: waitress

Kubernetes Info:
	Cluster Name: N/A
	Namespace: N/A
	Node Name: N/A
	Pod Name: N/A
	Pod IP: N/A


Request Info:
	Method: GET
	Path: /echo
	Client IP: 127.0.0.1


Request Headers:
	Host: 127.0.0.1:8080
	User-Agent: curl/8.6.0
	Accept: */*


Request Body:
	b''
```
