#!/usr/bin/python3

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
from os import getenv
from urllib.parse import urlparse, parse_qs

class CustomHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        req_content_type = self.headers.get('Content-Type')
        if req_content_type != 'application/json':
            self.send_response(400)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            error_string = """{
    "error": {
        "message": "Unsupported content type.",
        "code": "UNSUPPORTED_CONTENT_TYPE",
        "hint": "Only \'application/json\' is supported."
    }
}"""
            self.wfile.write(error_string.encode('UTF-8'))
            return

        req_parsed_path = urlparse(self.path)

        req_path         = req_parsed_path.path
        req_query_string = req_parsed_path.query

        req_content_length = int(self.headers.get('Content-Length'))
        req_body_bytes = self.rfile.read(req_content_length)
        req_body_str = req_body_bytes.decode('UTF-8')
        req_body_json = json.loads(req_body_str)

        resp_body_json = {
            'path':  req_path,
            'query': parse_qs(req_query_string),
            'body':  req_body_json
        }

        self.send_response(200)
        self.end_headers()

        resp_body_str = json.dumps(resp_body_json, indent=2)
        self.wfile.write(resp_body_str.encode('UTF-8'))

port = int(getenv('PORT', 8080))
bind_address = getenv('BIND_ADDR', '0.0.0.0')

httpd = HTTPServer((bind_address, port), CustomHandler)
httpd.serve_forever()
